#!/bin/bash
# SPDX-License-Identifier: MIT
set -ve

# --- Setup and Input ---
JSON_INPUT=$(cat /dev/stdin)
PLAINTEXT_VAULT=$(echo "$JSON_INPUT" | jq -r '.plaintext_yaml')
TEMP_FILE=$(mktemp) 
ENCRYPTED_FILE=$(mktemp) 

# --- 1. Initial Empty Encryption (Non-Interactive Setup) ---
# Create a temporary, empty vault file using the password from the environment.
# 'create' is interactive; 'rekey' is not. We trick it by creating an empty file 
# and passing it to the non-interactive 'rekey'.

# Create a temporary file with the password
echo "$ANSIBLE_VAULT_PASSWORD" > "$TEMP_FILE"

# Create an empty vault file using the password file mechanism.
# We are creating a placeholder that Ansible Vault now trusts.
ansible-vault create --vault-password-file "$TEMP_FILE" "$ENCRYPTED_FILE" <<< "" > /dev/null

# --- 2. Rekey with Actual Content (The Encryption Step) ---
# Rekey is non-interactive and replaces the content of the vault file.
# The 'new' content is our plaintext secrets.
ENCRYPTED_CONTENT=$(echo "$PLAINTEXT_VAULT" | \
                    ANSIBLE_VAULT_PASSWORD="$ANSIBLE_VAULT_PASSWORD" \
                    ansible-vault rekey --stdin-data @- "$ENCRYPTED_FILE" --output -)

# --- 3. Cleanup and Output ---
rm -f "$TEMP_FILE" "$ENCRYPTED_FILE" # Delete both temporary files
jq -n --arg content "$ENCRYPTED_CONTENT" '{"encrypted_content": $content}'