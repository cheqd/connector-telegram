###############################################################
###    STAGE 1: Build LogTo runner with customisations      ###
###############################################################

FROM ghcr.io/logto-io/logto:1.0.0-rc.3 as runner

# Set working directory & bash defaults
WORKDIR /etc/logto

# Install pre-requisites
RUN apk update && \
    apk add --no-cache bash ca-certificates

# Copy source files
COPY ./packages ./packages/core/connectors

# Build-time arguments
ARG NODE_ENV=production
ARG NPM_CONFIG_LOGLEVEL=warn
ARG PORT=3001
ARG ADMIN_PORT=3002
ARG ADMIN_DISABLE_LOCALHOST=false
ARG TRUST_PROXY_HEADER=true

# Run-time environment variables
ENV NODE_ENV ${NODE_ENV}
ENV NPM_CONFIG_LOGLEVEL ${NPM_CONFIG_LOGLEVEL}
ENV PORT ${PORT}
ENV ADMIN_PORT ${ADMIN_PORT}
ENV ADMIN_DISABLE_LOCALHOST ${ADMIN_DISABLE_LOCALHOST}
ENV TRUST_PROXY_HEADER ${TRUST_PROXY_HEADER}
ENV CA_CERT ${CA_CERT}

# Change ownership of working directory
RUN chown -R node:node ${WORKDIR}

# Specify default port
EXPOSE ${PORT} ${ADMIN_PORT}

# Set user and shell
USER node
SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

# Run the application
ENTRYPOINT [ "npm run cli db seed -- --swe && npm start" ]
