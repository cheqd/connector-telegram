#!/bin/bash

set -euo pipefail

# Create blank custom CA certificate file
sudo touch /usr/local/share/ca-certificates/do-cert.crt

# Insert custom CA certificate contents from environment variable into file
echo "$DO_CA_CERT" | sudo tee /usr/local/share/ca-certificates/do-cert.crt > /dev/null

# Update CA certificates
sudo update-ca-certificates

# Remove node user from sudoers group
sudo sed -i '$ d' /etc/sudoers

if [[ $# -eq 0 ]]; then
  # No flags passed, execute actions for no flag
  echo "npm start"
else
  while getopts "a:" opt; do
    case "$opt" in
      a)
        # Flag -a or --alter-db was passed, execute actions for alter-db
        version_number=${OPTARG}
        echo "Executing actions for --alter-db for version $version_number"
        npx @logto/cli db seed all --swe
        npx @logto/cli db alteration deploy "$version_number"
        # Add your code for actions related to --alter-db here
        ;;
      *)
        echo "Invalid option. Pass the -a flag and version number to execute DB alteration script."
      ;;
    esac
  done
fi
