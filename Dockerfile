# syntax=docker/dockerfile:1.3
###############################################################
###    STAGE 1: Build LogTo runner with customisations      ###
###############################################################

FROM ghcr.io/logto-io/logto:edge as runner

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
ARG ADMIN_ENDPOINT
ARG ENDPOINT
ARG CA_CERT
ARG NODE_EXTRA_CA_CERTS ${NODE_EXTRA_CA_CERTS}

# Run-time environment variables
ENV NODE_ENV ${NODE_ENV}
ENV NPM_CONFIG_LOGLEVEL ${NPM_CONFIG_LOGLEVEL}
ENV PORT ${PORT}
ENV ADMIN_PORT ${ADMIN_PORT}
ENV ADMIN_DISABLE_LOCALHOST ${ADMIN_DISABLE_LOCALHOST}
ENV TRUST_PROXY_HEADER ${TRUST_PROXY_HEADER}
ENV ADMIN_ENDPOINT ${ADMIN_ENDPOINT}
ENV ENDPOINT ${ENDPOINT}
ENV CA_CERT ${CA_CERT}
ENV NODE_EXTRA_CA_CERTS /usr/local/share/ca-certificates/do-cert.crt
ENV DOCKER_BUILDKIT 1

# Change ownership of working directory
RUN --mount=type=secret,id=CA_CERT chown -R node:node /etc/logto && \
    touch /usr/local/share/ca-certificates/do-cert.crt && \
    echo "$CA_CERT" > /usr/local/share/ca-certificates/do-cert.crt && \
    update-ca-certificates

# Specify default port
EXPOSE ${PORT} ${ADMIN_PORT}

# Set user and shell
USER node
SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

# Run the application
CMD [ "npm start" ]
