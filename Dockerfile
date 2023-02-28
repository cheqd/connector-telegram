FROM node:18-alpine as app
WORKDIR /etc/logto
COPY --from=ghcr.io/logto-io/logto:prerelease /etc/logto .
COPY ./packages ./packages/core/connectors
EXPOSE 3001
ENTRYPOINT ["npm", "start"]