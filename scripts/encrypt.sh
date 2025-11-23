#!/bin/bash
set -e

# 1. Read JSON input from Terraform (stdin)
JSON_INPUT=$(cat /dev/stdin)
PLAINTEXT_VAULT=$(echo "$JSON_INPUT" | jq -r '.plaintext_yaml')

# --- ZERO-DISK FIX: Use a Named Pipe (FIFO) in /tmp ---
# The /tmp directory is guaranteed to be available in any container.
PIPE_FILE="/tmp/ansible_vault_pipe_$$"
mkfifo "$PIPE_FILE"

# 2. Write the vault password to the pipe in the background
# This command is non-blocking and provides the password when needed.
echo "$ANSIBLE_VAULT_PASSWORD" > "$PIPE_FILE" &
PASSWORD_WRITER_PID=$!

# 3. Encrypt the plaintext YAML content
# Pass the content via pipe, and the password via the named pipe file.
ENCRYPTED_CONTENT=$(echo "$PLAINTEXT_VAULT" | \
                    ansible-vault encrypt /dev/stdin --output - --vault-password-file "$PIPE_FILE")

# 4. Cleanup and Error Handling
rm -f "$PIPE_FILE"  # Delete the pipe file immediately
wait $PASSWORD_WRITER_PID 2>/dev/null || true # Kill the background process if it's still running

# 5. Output the result for Terraform
jq -n --arg content "$ENCRYPTED_CONTENT" '{"encrypted_content": $content}'