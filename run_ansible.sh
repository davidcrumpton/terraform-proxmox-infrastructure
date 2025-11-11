#!/usr/bin/env sh
PLAYBOOK="$1"
INVENTORY="./ansible/inventory/hosts"

echo "🔧 Using inventory: $INVENTORY"

# Try to connect until SSH is ready
FIRST_HOST=$(grep -m1 -A1 "^\[all\]" "$INVENTORY" | tail -n1)
echo "⏳ Waiting for $FIRST_HOST to be reachable via SSH..."
for i in {1..10}; do
#    if ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$FIRST_HOST" 'exit' 2>/dev/null; then
    if nc -vw 5 atom5g-ng 22; then
        echo "✅ $FIRST_HOST is reachable."
        break
    fi
    echo "Retrying in 5s..."
    sleep 5
done

echo "🚀 Running playbook: $PLAYBOOK"


# Setup SSH key if provided
if [[ -n "${SSH_PRIVATE_KEY_BASE_64:-}" ]]; then
    echo "Using provided SSH private key..."

    mkdir -p ~/.ssh
    chmod 700 ~/.ssh

    # Decode base64 key to file
    echo "$SSH_PRIVATE_KEY_BASE_64" | base64 --decode > ~/.ssh/terraform
    chmod 600 ~/.ssh/terraform

    # Run ansible with the SSH key
    ansible-playbook -i "$INVENTORY" "./ansible/playbooks/$PLAYBOOK" \
        -u root \
        --private-key ~/.ssh/terraform
else
    echo "No SSH private key provided, using default SSH agent or key."
    ansible-playbook -i "$INVENTORY" "./ansible/playbooks/$PLAYBOOK" -u root
fi