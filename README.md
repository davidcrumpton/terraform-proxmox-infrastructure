<!-- SPDX-License-Identifier: MIT -->

# Terraform Proxmox Infrastructure

This repository automates provisioning and configuration of **LXC containers** and **virtual machines** in **Proxmox** using **Terraform** for infrastructure definition and **Ansible** for configuration management.
Terraform state is stored in **GitLab**, allowing you to run the pipeline directly in GitLab CI/CD or from your local CLI.

If a tag name matches a role name, Ansible automatically applies that role.
Roles run in alphabetical order—so prefix tags to control sequencing (e.g., `1.zabbix` ensures the Zabbix role runs first).

---

## 🧰 Requirements

Before using this repository, ensure the following tools are installed:

* [Ansible](https://www.ansible.com/)
* [Terraform](https://www.terraform.io/)
* [Git](https://git-scm.com/)

---
## 📜 License

This project is licensed under the MIT License.

You are free to use, modify, distribute, and sublicense this code for any purpose, including commercial use.  
See the [LICENSE](./LICENSE) file for full details.

SPDX-License-Identifier: MIT

## 🚀 Usage

### Enabling or Disabling Instances

Terraform runs all `.tf` files in the root directory.
To **remove** or **disable** a VM or LXC, use its name only. The included script detects whether it’s an LXC or VM (but you cannot have both with the same name).

```bash
./scripts/enable openbsd
```

---

## ⚙️ TFVARS Example (`terraform.tfvars`)

Set these values to match your environment:

```hcl
pm_api_url          = "https://pve02.localdomain:8006/api2/json"
pm_user             = "root@pam" # Use token-based auth where possible
pm_api_token_id     = "proxmox@pam!terraform"
pm_api_token_secret = "8b154087-d17a-4311-9d9b-ed3d651da1ca" # GUID-style secret
node                = "pve02"
storage             = "local-lvm"
```

---

## 🧩 GitLab CI/CD Variables

Set these variables under your project’s **Settings → CI/CD → Variables**:

| Variable                    | Description                                    |
| --------------------------- | ---------------------------------------------- |
| `ANSIBLE_HOST_KEY_CHECKING` | Enable/disable SSH host key checking           |
| `GITLAB_ACCESS_TOKEN`       | Your personal access token                     |
| `PM_API_TOKEN_ID`           | `proxmox@pam.terraform`                        |
| `PM_API_TOKEN_SECRET`       | Token generated within Proxmox                 |
| `PM_API_URL`                | `https://proxbox:8006/api2/json`               |
| `PM_USER`                   | `proxmox@pam`                                  |
| `SSH_PRIVATE_KEY_BASE_64`   | Base64-encoded SSH private key used by Ansible |

---

## 🐚 Shell Environment Variables

Source these variables locally before running Terraform.
Store them in a script (e.g., `env.sh`) and source it with `source ./env.sh`.

```bash
export PM_API_URL="https://pve02.localdomain:8006/api2/json"
export PM_API_TOKEN_ID="proxmox@pam!terraform"
export PM_API_TOKEN_SECRET="f0fb7021-0f0f-45ad-97b3-c7f6b589d84a"

export CI_API_V4_URL="https://gitlab.localdomain/api/v4"
export CI_PROJECT_ID=20
export TF_ADDRESS="${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/terraform/state/proxmox-homelab"

# Optional: Personal access token for CLI operations
# export GITLAB_ACCESS_TOKEN="glpat-xxxxxx"
```

---

## 🧱 Template Setup

### LXC Containers

Use an existing container definition (e.g., `lxc_docker02.tf`) as a template:

1. Copy it to a new file (e.g., `lxc_ansible.tf`).
2. Replace all occurrences of `docker` with your desired container name.
3. Adjust:

   * `target_node` for your Proxmox host
   * Resource sizing (`var.lxc.sizing`)
   * OS template (`debian_12` → `ubuntu_2022`, if preferred)
   * Description and tags (tags can trigger Ansible roles)
   * Network definitions

Finally, register the new container in **`inventory_builder.tf`**:

```hcl
lxc_inventory = [
  module.lxc_gl_runner.ansible_data,
  module.lxc_ansible.ansible_data,
  module.lxc_docker02.ansible_data,
  # module.lxc_keycloak.ansible_data,
]
```

---

### Virtual Machines

For virtual machines, use the `vm_openbsd.tf` file as a starting point.
Modify it similarly to the LXC template to match your desired OS, node, and resources but *don't*
add it to inventoy builder terraform file.

---

## ▶️ Example Run

Run the following commands to initialize and deploy your infrastructure:

```bash
export GITLAB_ACCESS_TOKEN="glpat-xxxxxx"

./scripts/tf-init
terraform plan -out plan.out
terraform apply plan.out

# List all outputs
terraform output

# Or display a specific output
terraform output <output_name>
```

---

## ⚠️ Known Issues

* Only **LXC containers** are fully automated; **Ansible** takes no action for VMs.
* The Ansible user is currently **hard-coded as `root`**.
* Hostnames must resolve via DNS; otherwise, provisioning will fail.
* The `lxc_hostname.tf` file should eventually fetch the SSH key from the environment to avoid duplication.

---

© 2025 David Crumpton • ProxMox Automation with Terraform + Ansible
