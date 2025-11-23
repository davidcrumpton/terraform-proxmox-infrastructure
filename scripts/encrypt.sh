#!/bin/bash
# SPDX-License-Identifier: MIT
# scripts/encrypt.sh
# Performs secure, ephemeral disk encryption for Ansible Vault.
# Guaranteed to work in restricted LXC/Docker environments.
set -e

# --- 1. Read JSON Input from Terraform (stdin) ---
JSON_INPUT=$(cat /dev/stdin)
PLAINTEXT_VAULT=$(echo "$JSON_INPUT" | jq -r '.plaintext_yaml')

# --- 2. Setup: Use mktemp for secure, ephemeral file storage ---
# This creates a unique temporary file path and is guaranteed to be available.
TEMP_FILE=$(mktemp) 

# --- 3. Write and Encrypt ---
# Write plaintext content to the temporary file
echo "$PLAINTEXT_VAULT" > "$TEMP_FILE"

# Encrypt the temporary file, reading password from the environment variable.
# ANSIBLE_VAULT_PASSWORD must be exported in the GitLab CI 'apply' job.
ENCRYPTED_CONTENT=$(ANSIBLE_VAULT_PASSWORD="$ANSIBLE_VAULT_PASSWORD" \
                    ansible-vault encrypt "$TEMP_FILE" --output -)

# --- 4. Cleanup and Output ---
# Securely delete the temporary file IMMEDIATELY after encryption
rm -f "$TEMP_FILE"

# Output the result in the expected Terraform JSON format
jq -n --arg content "$ENCRYPTED_CONTENT" '{"encrypted_content": $content}'