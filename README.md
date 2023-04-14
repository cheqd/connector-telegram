# Telegram OAuth connector for LogTo

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/cheqd/connector-telegram?color=green&label=stable%20release&style=flat-square)](https://github.com/cheqd/connector-telegram/releases/latest) ![GitHub Release Date](https://img.shields.io/github/release-date/cheqd/connector-telegram?color=green&style=flat-square) [![GitHub license](https://img.shields.io/github/license/cheqd/connector-telegram?color=blue&style=flat-square)](https://github.com/cheqd/connector-telegram/blob/main/LICENSE)

[![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/cheqd/connector-telegram?include_prereleases&label=dev%20release&style=flat-square)](https://github.com/cheqd/connector-telegram/releases/) ![GitHub commits since latest release (by date)](https://img.shields.io/github/commits-since/cheqd/connector-telegram/latest?style=flat-square) [![GitHub contributors](https://img.shields.io/github/contributors/cheqd/connector-telegram?label=contributors%20%E2%9D%A4%EF%B8%8F&style=flat-square)](https://github.com/cheqd/connector-telegram/graphs/contributors)

[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/cheqd/connector-telegram/dispatch.yml?label=workflows&style=flat-square)](https://github.com/cheqd/connector-telegram/actions/workflows/dispatch.yml) [![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/cheqd/connector-telegram/codeql.yml?label=CodeQL&style=flat-square)](https://github.com/cheqd/connector-telegram/actions/workflows/codeql.yml) ![GitHub repo size](https://img.shields.io/github/repo-size/cheqd/connector-telegram?style=flat-square)

## ℹ️ Overview

This NPM package is [a custom OAuth connector designed for LogTo](https://docs.logto.io/docs/recipes/create-your-connector/) for use with [Telegram](https://core.telegram.org/api). [LogTo](https://logto.io/) is [an open-source identity management software](https://docs.logto.io/) with out-of-the-box support for many social connectors, and allows custom connectors to be created.

## 🛠️ Configuration

Once you've added this custom connector to LogTo (see *Developer Guide*) below, you need to configure your connector. The steps defined below mirror the [setup guide for the Telegram Login Button widget](https://core.telegram.org/widgets/login).

1. [Register a new Telegram bot](https://core.telegram.org/bots#3-how-do-i-create-a-bot) using the [`@Botfather` Telegram bot](https://t.me/botfather).
2. Send the `/setdomain` message to `@Botfather` to set a public redirect URI for the bot.
   1. Telegram expects this domain to be **publicly-routable**. Therefore, trying to specify this as `localhost` or a non-public domain name doesn't work.
3. Copy the Bot Token and the Bot Domain. These credentials need to be [set in your LogTo admin dashboard](https://docs.logto.io/docs/recipes/configure-connectors/configure-social-connector) to configure and activate the connector.

## 🧑‍💻 Developer Guide

### Use with LogTo

To use this connector with LogTo, copy this source tree into a new folder [under `packages/connectors/connectors-telegram` on a copy of the LogTo repository](https://github.com/logto-io/logto/tree/master/packages/connectors).

You can then use `pnpm` to build the whole project at the top level of the LogTo repo (this will do a recursive build):

```bash
pnpm install
pnpm build
```

Or, build *just* this project as a library using NPM:

```bash
npm install
npm build
```

## 💬 Community

The [**cheqd Community Slack**](http://cheqd.link/join-cheqd-slack) is our primary chat channel for the open-source community, software developers, and node operators.

Please reach out to us there for discussions, help, and feedback on the project.

## 🙋 Find us elsewhere

[![Telegram](https://img.shields.io/badge/Telegram-2CA5E0?style=for-the-badge\&logo=telegram\&logoColor=white)](https://t.me/cheqd) [![Discord](https://img.shields.io/badge/Discord-7289DA?style=for-the-badge\&logo=discord\&logoColor=white)](http://cheqd.link/discord-github) [![Twitter](https://img.shields.io/badge/Twitter-1DA1F2?style=for-the-badge\&logo=twitter\&logoColor=white)](https://twitter.com/intent/follow?screen\_name=cheqd\_io) [![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge\&logo=linkedin\&logoColor=white)](http://cheqd.link/linkedin) [![Slack](https://img.shields.io/badge/Slack-4A154B?style=for-the-badge\&logo=slack\&logoColor=white)](http://cheqd.link/join-cheqd-slack) [![Medium](https://img.shields.io/badge/Medium-12100E?style=for-the-badge\&logo=medium\&logoColor=white)](https://blog.cheqd.io) [![YouTube](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge\&logo=youtube\&logoColor=white)](https://www.youtube.com/channel/UCBUGvvH6t3BAYo5u41hJPzw/)
