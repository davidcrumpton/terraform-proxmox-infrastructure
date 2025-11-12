# Terraform ProxMox Files

## Description

This repository sets up LXCs and VMs in ProxMox using Terraform for provisioning and Ansible for configuration. 
The state is stored in GitLab so it can be run in either GitLab or your CLI.  If a tag name corresponds to a role
name, then ansible will run the role for it.  Roles are run in sorted order so order is done by ensuring the
name comes in the order you wish.  So, your tag name might need to be *1.zabbix*, if you need that role configured
first.

## Requirements

- Ansible
- terraform
- git 


## Usage

### Enable or Disable

Terraform runs all .tf files in the base directory.  To remove a VM or LXC, use its name only.
The script below will disable openbsd.  It can determine if you have an LXC or VM but you can't
have them both with the same name.

```sh
./scripts/enable openbsd
```

## TFVARS Example File terraform.tfvars

You must set the values for your environment.

```text
pm_api_url = "https://pve02.localdomain:8006/api2/json"
pm_user = "root@pam"

# Use token-based auth where possible

pm_api_token_id = "proxmox@pam!terraform"
pm_api_token_secret = "8B154087-D17A-4311-9D9B-ED3D651DA1CA"   #  Looks like a GUID in lowercase
node = "pve02"

# override other non login related variables below

storage = "local-lvm"

```

## GitLab CI/CD Variables


| Variable | Description |
|-----------|-------------|
| `ANSIBLE_HOST_KEY_CHECKING` | Ignore host keys or not |
| `GITLAB_ACCESS_TOKEN` | Your personal access token |
| `PM_API_TOKEN_ID` | `proxmox@pam.terraform` |
| `PM_API_TOKEN_SECRET` | Token generated within ProxMox |
| `PM_API_URL` | `https://proxbox:8006/api2/json` |
| `PM_USER` | `proxmox@pam` |
| `SSH_PRIVATE_KEY_BASE_64` | Base64-encoded SSH private key used by Ansible |

SSH_PRIVATE_KEY_BASE_64   - `base64 -w 0 ~/.ssh/terraform.ssh.private.key`

## Shell Variables for terraform

Source the variables below after proper setup.  Your token should be created in your personal account config.  
There is no script file for this at this writing but these should be in a file you source into your shell
environment.

```sh
export PM_API_URL="https://pve02.localdomain:8006/api2/json"
export PM_API_TOKEN_ID="proxmox@pam!terraform"
export PM_API_TOKEN_SECRET="f0fb7021-0f0f-45ad-97b3-c7f6b589d84a"
export CI_API_V4_URL="https://gitlab.localdomain/api/v4"
export CI_PROJECT_ID=20
export TF_ADDRESS="${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/terraform/state/proxmox-homelab"
# export GITLAB_ACCESS_TOKEN=glpat-a3...
```
## Template Setup
### LXC

Copy the lxc_docker02.tf file to a new name like *lxc_ansible.tf*.
Edit the file and change all occurrences of *docker* to *ansible*.

Your taget_node name will be different from *pve02* so change this.

Set sizing as needed.  You can change the pre-defined sizes in
var.lxc.sizing to exactly what you desire.

Replace all **debian_12** with **ubuntu_2022** if you want Ubuntu 22.04.

Set your description to the markdown you desire.

Set your tags to what you desire.  Some tag names are mapped to roles
and will cause ansible to make role based changes.

Set networks as you wish.

Add your lxc to *inventory_builder.tf* so it can make the ansible inventory.

```
  lxc_inventory = [
    # Add more here, e.g.:
    module.lxc_gl_runner.ansible_data,
# new one below can be anywhere in this list
    module.lxc_ansible.ansible_data,

    module.lxc_docker02.ansible_data,
    # module.lxc_keycloak.ansible_data,
  ]
```

### Virtual Machines

Use the vm_openbsd.tf template as a starting point and make change
similar to what you did above.

## Example Run

Use the following commands to build out your ProxMox instances.

```sh
export GITLAB_ACCESS_TOKEN=gl-pat-a3...
./scripts/tf-init
terraform plan -out plan.out
terraform apply plan.out
terraform output    # Lists all output values
terraform output   <an_output_from_list>
```

## Issues

- Only LXCs are automated.  Ansible doesn't run for VMs.
- root is hard coded for the Ansible user.
- Expects the chosen host name to register with DNS or fails
- lxc_hostname.tf file should grab the SSH key from the environment so it doesn't need to be set twice.

