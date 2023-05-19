###############################################################
###       STAGE 1: Build custom connector for Telegram      ###
###############################################################

FROM node:18-alpine as builder

# Set working directory & bash defaults
WORKDIR /home/node/app

# Copy source files
COPY . .

# Installing dependencies
RUN npm ci

# Build the app
RUN npm run build


###############################################################
###     STAGE 2: Build LogTo image with custom connector    ###
###############################################################

FROM registry.digitalocean.com/cheqd/logto:1.0.3 as runner

# Set working directory
WORKDIR /etc/logto

# Install pre-requisites
RUN apk update && \
    apk add --no-cache bash ca-certificates

# Copy files from builder
COPY --from=builder --chown=node:node /home/node/app /etc/logto/packages/core/connectors/

# Add entrypoint script
COPY --chown=node:node docker/entrypoint.sh /etc/logto/entrypoint.sh

# Make entrypoint script executable
RUN chmod +x entrypoint.sh

# Build-time arguments
ARG NPM_CONFIG_LOGLEVEL=warn
ARG PORT=3001
ARG ADMIN_PORT=3002
ARG ADMIN_DISABLE_LOCALHOST=false
ARG TRUST_PROXY_HEADER=true
ARG ADMIN_ENDPOINT
ARG ENDPOINT
ARG NODE_EXTRA_CA_CERTS="/usr/local/share/ca-certificates/do-cert.crt"

# Run-time environment variables
ENV NPM_CONFIG_LOGLEVEL ${NPM_CONFIG_LOGLEVEL}
ENV PORT ${PORT}
ENV ADMIN_PORT ${ADMIN_PORT}
ENV ADMIN_DISABLE_LOCALHOST ${ADMIN_DISABLE_LOCALHOST}
ENV TRUST_PROXY_HEADER ${TRUST_PROXY_HEADER}
ENV ADMIN_ENDPOINT ${ADMIN_ENDPOINT}
ENV ENDPOINT ${ENDPOINT}
ENV NODE_EXTRA_CA_CERTS ${NODE_EXTRA_CA_CERTS}

# Specify default port
EXPOSE ${PORT} ${ADMIN_PORT}

# Set user and shell
USER node
SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

# Run the application
ENTRYPOINT [ "/etc/logto/entrypoint.sh" ]
