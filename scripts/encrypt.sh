#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
set -e

PASSWORD_FILE="${PATH_MODULE}/.vault-pass"

# Write the vault password
echo "$ANSIBLE_VAULT_PASSWORD" > "$PASSWORD_FILE"

# Encrypt the JSON input from Terraform external provider
ansible-vault encrypt \
  --vault-password-file "$PASSWORD_FILE" \
  --output "$PATH_MODULE/encrypted_vault.yml" \
  "$PATH_MODULE/plain_vault.yml"

echo '{"status":"ok"}'
