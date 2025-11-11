# Terraform ProxMox PVE02 Files

## Tools and Scripts

Are available in the scripts/ folder

## Terraform init command

This requires more init options to keep state synced in the cloud.

### Personal
```sh
terraform init -reconfigure -backend-config="address=${TF_ADDRESS}" \
-backend-config="lock_address=${TF_ADDRESS}/lock"  -backend-config="unlock_address=${TF_ADDRESS}/lock" \
-backend-config="username=oauth2" -backend-config="password=${GITLAB_TF_API_TOKEN}" \
-backend-config="lock_method=POST"  -backend-config="unlock_method=DELETE"  -backend-config="retry_max=10"
```
### Formal

```sh
export GITLAB_ACCESS_TOKEN=<YOUR-ACCESS-TOKEN>
export TF_STATE_NAME=proxmox-homelab
terraform init \
    -backend-config="address=https://gitlab.crumpton.org/api/v4/projects/20/terraform/state/$TF_STATE_NAME" \
    -backend-config="lock_address=https://gitlab.crumpton.org/api/v4/projects/20/terraform/state/$TF_STATE_NAME/lock" \
    -backend-config="unlock_address=https://gitlab.crumpton.org/api/v4/projects/20/terraform/state/$TF_STATE_NAME/lock" \
    -backend-config="username=bear" \
    -backend-config="password=$GITLAB_ACCESS_TOKEN" \
    -backend-config="lock_method=POST" \
    -backend-config="unlock_method=DELETE" \
    -backend-config="retry_wait_min=5"
```

## TFVARS File terraform.tfvars 

```text
pm_api_url = "https://pve02.crumpton.org:8006/api2/json"
pm_user = "root@pam"

# Use token-based auth where possible

pm_api_token_id = "root@pam!terraform"
pm_api_token_secret = "8B154087-D17A-4311-9D9B-ED3D651DA1CA"   #  Looks like a GUID in lowercase
node = "pve02"
storage = "local-lvm"
```

## Shell Variables for terraform

Source the variables below after proper setup.  Your token should be created in your personal account config.

```sh
export PM_API_URL="https://pve02.crumpton.org:8006/api2/json"
export PM_API_TOKEN_ID="root@pam!terraform"
export PM_API_TOKEN_SECRET="f0fb7021-0f0f-45ad-97b3-c7f6b589d84a"
export CI_API_V4_URL="https://gitlab.crumpton.org/api/v4"
export CI_PROJECT_ID=20
export TF_ADDRESS="${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/terraform/state/proxmox-homelab"
# export GITLAB_TOKEN=glpat-a3...
```
