import { createHash, createHmac } from 'node:crypto';

import {
  type GetAuthorizationUri,
  type GetUserInfo,
  type SocialConnector,
  type CreateConnector,
  type GetConnectorConfig,
  parseJson,
  ConnectorError,
  ConnectorErrorCodes,
  validateConfig,
  ConnectorType,
} from '@logto/connector-kit';

import { authorizationEndpoint, scope, defaultMetadata } from './constant.js';
import {
  type TelegramConfig,
  userInfoResponseGuard,
  telegramConfigGuard,
  authResponseGuard,
} from './types.js';

const getAuthorizationUri =
  (getConfig: GetConnectorConfig): GetAuthorizationUri =>
  async ({ state, redirectUri }) => {
    const config = await getConfig(defaultMetadata.id);
    validateConfig<TelegramConfig>(config, telegramConfigGuard);
    const tokenParts = config.botToken.split(':');
    const botId = tokenParts[0];
    if (!botId) {
      throw new ConnectorError(ConnectorErrorCodes.InvalidConfig, {
        error: 'Invalid telegram bot token',
      });
    }

    // Reconstruct the return_to url

    // const returnTo = '';
    // if (!config.replaceCallbackDomain) {
    // }

    let returnTo = new URL(redirectUri);
    if (config.replaceCallbackURIDomain) {
      // eslint-disable-next-line @silverhand/fp/no-mutation
      returnTo = new URL(returnTo.pathname, config.origin);
    }

    // Append state to return_to url
    returnTo.searchParams.set('state', state);

    const queryParameters = new URLSearchParams({
      bot_id: botId,
      origin: config.origin,
      embed: '1',
      request_access: scope,
      return_to: returnTo.toString(),
    });
    return `${authorizationEndpoint}?${queryParameters.toString()}`;
  };

const authorizationCallbackHandler = async (parameterObject: unknown) => {
  const result = authResponseGuard.safeParse(parameterObject);

  if (!result.success) {
    throw new ConnectorError(ConnectorErrorCodes.General, JSON.stringify(parameterObject));
  }

  return result.data;
};

const performTelegramIntegrityCheck = (
  telegramResponse: Record<string, unknown>,
  botToken: string
): boolean => {
  const fields: string[] = [];
  for (const key of Object.keys(telegramResponse)) {
    if (key === 'hash') {
      continue;
    }
    const value = String(telegramResponse[key]);
    const field = key + '=' + value;
    fields.push(field);
  }
  const data = fields.sort().join('\n');

  const botSecretKey = createHash('sha256').update(Buffer.from(botToken)).digest();
  const dataHash = createHmac('sha256', botSecretKey).update(data).digest('hex');
  return dataHash === telegramResponse.hash;
};

const getUserInfo =
  (getConfig: GetConnectorConfig): GetUserInfo =>
  async (data) => {
    // Get tgAuthResult from parameterObject
    const { tgAuthResult } = await authorizationCallbackHandler(data);

    // Get config
    const config = await getConfig(defaultMetadata.id);

    // Validate config
    validateConfig<TelegramConfig>(config, telegramConfigGuard);

    // Decode tgAuthResult from base64 to utf-8 JSON string
    const decoded = Buffer.from(tgAuthResult, 'base64').toString('utf-8');

    // Parse JSON string to object
    const parsed = userInfoResponseGuard.safeParse(parseJson(decoded));

    // Validate parsed object
    if (!parsed.success) {
      throw new ConnectorError(ConnectorErrorCodes.InvalidResponse, parsed.error);
    }
    const ok = performTelegramIntegrityCheck(parsed.data, config.botToken);
    if (!ok) {
      throw new ConnectorError(ConnectorErrorCodes.AuthorizationFailed, {
        error: 'Telegram data integrity check failed',
      });
    }

    return {
      id: String(parsed.data.id),
      avatar: parsed.data.photo_url || '',
      username: parsed.data.username || '',
      name: `${parsed.data.first_name} ${parsed.data.last_name}`.trim() || '',
    };
  };

const createTelegramConnector: CreateConnector<SocialConnector> = async ({ getConfig }) => {
  return {
    metadata: defaultMetadata,
    type: ConnectorType.Social,
    configGuard: telegramConfigGuard,
    getAuthorizationUri: getAuthorizationUri(getConfig),
    getUserInfo: getUserInfo(getConfig),
  };
};

export default createTelegramConnector;
