#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# scripts/encrypt.sh
# Uses encrypt_string for guaranteed non-interactive, zero-disk-for-secrets encryption.
set -e

# --- 1. Read JSON Input and Extract Plaintext ---
JSON_INPUT=$(cat /dev/stdin)
# We must remove the trailing newline from jq output for clean encryption
PLAINTEXT_VAULT=$(echo "$JSON_INPUT" | jq -r '.plaintext_yaml' | tr -d '\n')

# --- 2. Setup: Use mktemp for secure, ephemeral file storage ---
TEMP_FILE=$(mktemp) 

# --- 3. Write and Encrypt ---
# Write plaintext content to the temporary file
echo "$PLAINTEXT_VAULT" > "$TEMP_FILE"

# Use encrypt_string to encrypt the ENTIRE FILE CONTENT as a single string.
# The 'vault-id' is used to identify the password, which will be found via the environment variable.
ENCRYPTED_CONTENT=$(ANSIBLE_VAULT_PASSWORD="$ANSIBLE_VAULT_PASSWORD" \
                    ansible-vault encrypt_string @$TEMP_FILE \
                    --name 'vault_data' \
                    --encrypt-vault-id 'ci_vault')

# --- 4. Cleanup and Output ---
rm -f "$TEMP_FILE" # Securely delete the temporary file

# Output the result in the expected Terraform JSON format
# The output will be a single, long encrypted YAML string.
jq -n --arg content "$ENCRYPTED_CONTENT" '{"encrypted_content": $content}'
