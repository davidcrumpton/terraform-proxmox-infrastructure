<!-- SPDX-License-Identifier: MIT -->

# Terraform Proxmox Infrastructure

This repository automates provisioning and configuration of **LXC containers** and **virtual machines** in **Proxmox** using **Terraform** for infrastructure definition and **Ansible** for configuration management.
Terraform state is stored in **GitLab**, allowing you to run the pipeline directly in GitLab CI/CD or from your local CLI.

If a tag name matches a role name, Ansible automatically applies that role.
Roles run in alphabetical order—so prefix tags to control sequencing (e.g., `1.zabbix` ensures the Zabbix role runs first).

---

## 🧰 Requirements

You need a ProxMox token with admin permissions and a root level token if you wish to make priveleged containers or features other than nesting.

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
| `ANSIBLE_VAULT_PASSWORD`    | Enable encrypted storage during run            |
| `ANSIBLE_HOST_KEY_CHECKING` | Enable/disable SSH host key checking           |
| `GITEA_EMAIL`               | gitea known email for check in                 |
| `GITEA_MYNAME`              | gitea display name for check in                |
| `GITEA_TOKEN`               | gitea push token                               |
| `GITHUB_EMAIL`              | github known email for check in                |
| `GITHUB_MYNAME`             | github display name for check in               |
| `GITHUB_TOKEN`              | github push token                              |
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

## 📝 Pipeline Summary

This pipeline is designed to manage the infrastructure as code (IaC) using **Terraform** and configure the deployed resources using **Ansible**. It includes stages for validation, synchronization to external repositories, planning, applying, configuration management, and destruction.

### Pipeline Stages

The pipeline defines the following stages, executed in this order:

1. **`validate`**: Runs checks on the code quality and licensing.
2. **`sync_internal`**: Synchronizes the repository to an internal Gitea instance.
3. **`plan`**: Generates an execution plan for Terraform changes.
4. **`apply`**: Executes the Terraform plan to make infrastructure changes.
5. **`ansible`**: Runs Ansible playbooks for post-provisioning configuration.
6. **`sync_external`**: Synchronizes the repository to an external GitHub instance.
7. **`destroy`**: Runs a Terraform destroy to tear down the infrastructure.

---

### Key Jobs and Their Logic

| Job Name | Stage | Description & Trigger Logic |
| :--- | :--- | :--- |
| **`license_check`** | `validate` | Checks for the required `LICENSE` file and ensures all `.tf`, `.sh`, `.yml`, `.yaml`, and `.md` files contain the **`SPDX-License-Identifier: MIT`** header. **Runs on merge requests and `*-stable` branches.** |
| **`validate`** | `validate` | Runs `terraform validate` and `terraform fmt -check=true`. **Runs only on merge requests.** |
| **`sync_to_gitea`** | `sync_internal` | Cleans the repository and forces a push to a private **Gitea** instance. **Runs only when a tag matching `v.X.X.X` is pushed.** |
| **`plan`** | `plan` | Generates the Terraform execution plan (`tfplan.cache`). **Runs on merge requests and `*-stable` branches.** |
| **`apply`** | `apply` | Applies the cached plan. **Manual job that runs only on `*-stable` branches.** |
| **`ansible_deploy`** | `ansible` | Runs Ansible playbooks to configure the provisioned infrastructure. It needs artifacts from the **`apply`** job. **Runs automatically on success of `apply`, only on `*-stable` branches.** |
| **`sync_to_github`** | `sync_external` | Cleans the repository and pushes to a public **GitHub** instance. **Manual job that runs only when a tag matching `v.X.X.X` is pushed.** |
| **`destroy`** | `destroy` | Runs `terraform destroy`. **Manual job that runs only on `*-stable` branches.** |

### Key Details

* **Default Image**: The pipeline uses the **`hashicorp/terraform:latest`** image for most Terraform-related jobs.
* **Ansible Image**: The **`ansible_deploy`** job uses a separate **`demisto/ansible-runner:1.0.0.5807676`** image.
* **Terraform Backend**: The state is managed remotely using the **GitLab Terraform HTTP Backend** for the state named **`proxmox-homelab`**.
* **Artifacts/Cache**: Terraform plugins and state are cached. The `plan` and `apply` jobs generate artifacts like the `tfplan.cache` and the Ansible inventory.

---

© 2025 David Crumpton • ProxMox Automation with Terraform + Ansible
