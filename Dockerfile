###############################################################
###    STAGE 1: Build LogTo runner with customisations      ###
###############################################################

FROM registry.digitalocean.com/cheqd/logto:1.0.3 as runner

# Set working directory
WORKDIR /etc/logto

# Install pre-requisites
RUN apk update && \
    apk add --no-cache bash ca-certificates

# Copy source files
COPY . /custom-connectors

# Build-time arguments
ARG NPM_CONFIG_LOGLEVEL=warn
ARG PORT=3001
ARG ADMIN_PORT=3002
ARG ADMIN_DISABLE_LOCALHOST=false
ARG TRUST_PROXY_HEADER=true
ARG ADMIN_ENDPOINT
ARG ENDPOINT
ARG NODE_EXTRA_CA_CERTS="/usr/local/share/ca-certificates/do-cert.crt"
ARG DOCKER_BUILDKIT=1

# Run-time environment variables
ENV NPM_CONFIG_LOGLEVEL ${NPM_CONFIG_LOGLEVEL}
ENV PORT ${PORT}
ENV ADMIN_PORT ${ADMIN_PORT}
ENV ADMIN_DISABLE_LOCALHOST ${ADMIN_DISABLE_LOCALHOST}
ENV TRUST_PROXY_HEADER ${TRUST_PROXY_HEADER}
ENV ADMIN_ENDPOINT ${ADMIN_ENDPOINT}
ENV ENDPOINT ${ENDPOINT}
ENV NODE_EXTRA_CA_CERTS ${NODE_EXTRA_CA_CERTS}

# Set working directory
WORKDIR /custom-connectors

# Install dependencies and built the npm package
RUN pnpm install --frozen-lockfile \
    && pnpm build

# Copy the build output
RUN mv /custom-connectors/packages/* /etc/logto/packages/core/connectors/

# Change ownership of working directory and update CA certificates
RUN --mount=type=secret,id=CA_CERT chown -R node:node /etc/logto && \
    touch /usr/local/share/ca-certificates/do-cert.crt && \
    cat /run/secrets/CA_CERT > /usr/local/share/ca-certificates/do-cert.crt && \
    update-ca-certificates

# Specify default port
EXPOSE ${PORT} ${ADMIN_PORT}

# Set the working directory
WORKDIR /etc/logto

# Set user and shell
USER node
SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

# Run the application
CMD [ "npm start" ]
