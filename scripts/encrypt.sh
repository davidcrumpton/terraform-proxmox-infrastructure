#!/bin/bash
# SPDX-License-Identifier: MIT
# scripts/encrypt.sh
# Performs secure, ephemeral disk encryption using standard Ansible config lookup.
set -e

# --- 1. Read JSON Input and Extract Plaintext ---
# Read the plaintext YAML block that Terraform rendered.
JSON_INPUT=$(cat /dev/stdin)
PLAINTEXT_VAULT=$(echo "$JSON_INPUT" | jq -r '.plaintext_yaml')

# --- 2. Setup: Use mktemp for secure, ephemeral file storage ---
TEMP_FILE=$(mktemp) 

# --- 3. Write and Encrypt ---
# Write plaintext content to the temporary file
echo "$PLAINTEXT_VAULT" > "$TEMP_FILE"

# Encrypt the temporary file. Ansible will automatically look up the 
# password from the vault_password_file defined in the temporary ansible.cfg 
# which is why we don't need --vault-password-file or $ANSIBLE_VAULT_PASSWORD here.
ENCRYPTED_CONTENT=$(ansible-vault encrypt "$TEMP_FILE" --output -)

# --- 4. Cleanup and Output ---
# Securely delete the temporary file immediately after encryption
rm -f "$TEMP_FILE"

# Output the result in the expected Terraform JSON format
jq -n --arg content "$ENCRYPTED_CONTENT" '{"encrypted_content": $content}'