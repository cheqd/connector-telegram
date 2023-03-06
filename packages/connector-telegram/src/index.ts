import {
    GetAuthorizationUri,
    GetUserInfo,
    SocialConnector,
    CreateConnector,
    GetConnectorConfig,
    parseJson,
} from "@logto/connector-kit";
import {
    ConnectorError,
    ConnectorErrorCodes,
    validateConfig,
    ConnectorType,
} from "@logto/connector-kit";
import { conditional } from "@silverhand/essentials";

import {
    authorizationEndpoint,
    scope,
    defaultMetadata,
    defaultTimeout,
} from "./constant.js";
import { TelegramConfig, userInfoResponseGuard } from "./types.js";
import {
    authorizationCallbackErrorGuard,
    telegramConfigGuard,
    authResponseGuard,
} from "./types.js";
import { got } from "got";

const getAuthorizationUri =
    (getConfig: GetConnectorConfig): GetAuthorizationUri =>
    async ({ state, redirectUri }) => {
        const config = await getConfig(defaultMetadata.id);
        validateConfig<TelegramConfig>(config, telegramConfigGuard);
        const tokenParts = config.botToken.split(":");
        const botId = tokenParts[0];
        const queryParameters = new URLSearchParams({
            bot_id: botId!,
            return_to: redirectUri,
            origin: config.origin,
            embed: "1",
            request_access: scope,
        });
        return `${authorizationEndpoint}?${queryParameters.toString()}`;
    };

const authorizationCallbackHandler = async (parameterObject: unknown) => {
    const result = authResponseGuard.safeParse(parameterObject);
    if (result.success) {
        return result.data;
    }

    const parsedError =
        authorizationCallbackErrorGuard.safeParse(parameterObject);

    if (!parsedError.success) {
        throw new ConnectorError(
            ConnectorErrorCodes.General,
            JSON.stringify(parameterObject)
        );
    }

    const { error, error_description, error_uri } = parsedError.data;

    if (error === "access_denied") {
        throw new ConnectorError(
            ConnectorErrorCodes.AuthorizationFailed,
            error_description
        );
    }

    throw new ConnectorError(ConnectorErrorCodes.General, {
        error,
        errorDescription: error_description,
        error_uri,
    });
};

const getUserInfo =
    (getConfig: GetConnectorConfig): GetUserInfo =>
    async (data) => {
        const { hash } = await authorizationCallbackHandler(data);
        const config = await getConfig(defaultMetadata.id);
        validateConfig<TelegramConfig>(config, telegramConfigGuard);
        // no need for access token, bot Token is all we need
        // const { accessToken } = await getAccessToken(config, { code });

        try {
            const uri = new URL("/get", authorizationEndpoint);
            // got.get('https://oauth.telegram.org/auth/get?bot_id=<botid>')
            uri.searchParams.set("bot_id", config.botToken.split(":")[0]!);
            const httpResponse = await got.get(uri.toString(), {
                headers: {},
                timeout: { request: defaultTimeout },
            });

            const result = userInfoResponseGuard.safeParse(
                parseJson(httpResponse.body)
            );
            if (!result.success) {
                throw new ConnectorError(
                    ConnectorErrorCodes.InvalidResponse,
                    result.error
                );
            }

            const {
                id,
                photo_url: avatar,
                first_name,
                last_name,
                username,
            } = result.data;

            return {
                id: String(id),
                avatar: conditional(avatar),
                username: conditional(username),
                name: conditional(first_name) + " " + conditional(last_name),
            };
        } catch (error: unknown) {
            throw error;
        }
    };

const createTelegramConnector: CreateConnector<SocialConnector> = async ({
    getConfig,
}) => {
    return {
        metadata: defaultMetadata,
        type: ConnectorType.Social,
        configGuard: telegramConfigGuard,
        getAuthorizationUri: getAuthorizationUri(getConfig),
        getUserInfo: getUserInfo(getConfig),
    };
};

export default createTelegramConnector;
