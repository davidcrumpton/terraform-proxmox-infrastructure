#!/usr/bin/env sh
# SPDX-License-Identifier: MIT
set -e

# 1. Read the JSON input from Terraform's 'query' map (stdin)
JSON_INPUT=$(cat /dev/stdin)

# 2. Extract the complete, rendered YAML content using 'jq'
# The script no longer cares what secrets are inside this string.
PLAINTEXT_VAULT=$(echo "$JSON_INPUT" | jq -r '.plaintext_yaml')

# 3. Encrypt the plaintext YAML content using Ansible Vault and pipe it to stdout.
# The 'ansible-vault encrypt /dev/stdin' reads the pipe, encrypts it, 
# and the entire encrypted result is printed to stdout.


ENCRYPTED_CONTENT=$(echo "$PLAINTEXT_VAULT" | ansible-vault encrypt /dev/stdin --output - --vault-password-file <(echo "$ANSIBLE_VAULT_PASSWORD"))

# 4. Output the result in the expected Terraform JSON format
jq -n --arg content "$ENCRYPTED_CONTENT" '{"encrypted_content": $content}'