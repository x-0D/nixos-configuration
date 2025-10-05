#!/bin/env bash
set -e

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Download the package
wget https://registry.npmjs.org/n8n-nodes-datastore/-/n8n-nodes-datastore-0.1.18.tgz
tar -xzf n8n-nodes-datastore-0.1.18.tgz
cd package

# Generate the package-lock.json file
npm install --package-lock-only

# Copy the lock file to your overlay directory
cp package-lock.json /etc/nixos/services/n8n/overlays/npm-pkg-locks/package-lock.json.n8n-nodes-datastore

# Clean up
cd / && rm -rf "$TEMP_DIR"

echo "package-lock.json has been generated and copied to /etc/nixos/overlays/package-lock.json.n8n-nodes-datastore"