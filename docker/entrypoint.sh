#!/bin/bash

set -euo pipefail

# Create blank custom CA certificate file
touch /usr/local/share/ca-certificates/do-cert.crt

# Insert custom CA certificate contents from environment variable into file
echo "$DO_CA_CERT" | tee /usr/local/share/ca-certificates/do-cert.crt > /dev/null

# Update CA certificates
update-ca-certificates

# Default actions
default_start() {
  echo "Executing default start"

  # Start LogTo
  npm start
}

# Alter the database
alter_db() {
  if [[ -z $1 ]]; then
    echo "Please provide a version number after --alter-db."
    exit 1
  fi

  version=$1
  echo "Altering the database for LogTo version number $version."
  
  # Execute LogTo DB alteration scripts
  npx @logto/cli db seed all --swe
  npx @logto/cli db alteration deploy "$version"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    --alter-db)
      alter_db "$2"
      shift
      ;;
    *)
      echo "Unknown option: $key"
      exit 1
      ;;
  esac

  shift
done

# If no arguments are provided, execute default actions
if [[ $# -eq 0 ]]; then
    default_start
fi
