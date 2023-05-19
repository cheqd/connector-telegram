#!/bin/bash

set -euo pipefail

# Define the flags that we want to accept.
flags=("--alter-db")

# Create blank custom CA certificate file
sudo touch /usr/local/share/ca-certificates/do-cert.crt

# Insert custom CA certificate contents from environment variable into file
echo "$DO_CA_CERT" | sudo tee /usr/local/share/ca-certificates/do-cert.crt > /dev/null

# Set file permissions
sudo chmod 644 /usr/local/share/ca-certificates/do-cert.crt

# Update CA certificates
sudo update-ca-certificates

# Use getopts to parse the flags that are passed to the script.
while getopts "${flags[@]}" opt; do
  case "$opt" in
    "-a")
      version_number=${OPTARG}
      npx @logto/cli db seed all --swe
	  npx @logto/cli db alteration deploy "$version_number"
      ;;
    *)
      npm start
      ;;
  esac
done
