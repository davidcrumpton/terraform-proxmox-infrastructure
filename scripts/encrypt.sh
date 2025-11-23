#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
set -e

# External providers receive JSON via stdin
INPUT_JSON=$(cat)

PASSWORD_FILE="${PATH_MODULE}/.vault-pass"

# Write the vault password file
echo "$ANSIBLE_VAULT_PASSWORD" > "$PASSWORD_FILE"

# Convert JSON → YAML (using Python)
YAML_CONTENT=$(python3 - <<EOF
import sys, json, yaml
data=json.loads("""$INPUT_JSON""")
print(yaml.safe_dump(data, default_flow_style=False))
EOF
)

# Write temporary plain YAML
PLAIN_FILE=$(mktemp)
echo "$YAML_CONTENT" > "$PLAIN_FILE"

# Encrypt YAML → encrypted_vault.yml
ansible-vault encrypt \
  --vault-password-file "$PASSWORD_FILE" \
  --encrypt-vault-id default \
  --output "${PATH_MODULE}/encrypted_vault.yml" \
  "$PLAIN_FILE"


# Cleanup
rm "$PLAIN_FILE"

# Terraform expects valid JSON on stdout
echo '{"status":"ok"}'
