#!/bin/bash

set -euo pipefail

# Create blank custom CA certificate file
touch /usr/local/share/ca-certificates/do-cert.crt

# Insert custom CA certificate contents from environment variable into file
echo "$DO_CA_CERT" > /usr/local/share/ca-certificates/do-cert.crt

# Set file permissions
chmod 644 /usr/local/share/ca-certificates/do-cert.crt

# Update CA certificates
update-ca-certificates

# Run the application
npm start
