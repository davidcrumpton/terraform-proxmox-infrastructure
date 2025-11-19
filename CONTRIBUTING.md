<!-- SPDX-License-Identifier: MIT -->
# Contributing to CrumptonOrg Terraform

Thank you for considering contributing to this project! This repository automates provisioning and configuration of LXC containers and virtual machines in Proxmox using **Terraform** for infrastructure definition and **Ansible** for configuration management. Contributions help improve automation, documentation, and reliability.

---

## 🛠 Prerequisites

Before contributing, ensure you have:

- [Terraform](https://www.terraform.io/) installed
- [Ansible](https://www.ansible.com/) installed
- Git installed and configured
- Access to a Proxmox environment with API tokens
- Properly sourced environment variables (`env.sh`)

---

## 📌 How to Contribute

### Reporting Issues

- Use GitLab Issues to report bugs or request features.
- Include logs, environment details, and reproduction steps.

### Feature Requests

- Clearly describe the desired functionality and rationale.
- Suggest possible implementation approaches if known.

### Code Contributions

1. Fork the repository and create a feature branch:

   ```bash
   git checkout -b feature/my-new-module
   ```

2. Make changes and commit with descriptive messages.
3. Run tests locally:

   ```bash
   ./scripts/tf-init
   terraform plan
   ```

4. Submit a Merge Request (MR) with details of your changes.

---

## 🔄 Development Workflow

- Terraform runs all `.tf` files in the root directory.
- Use existing templates (`lxc_docker02.tf`, `vm_openbsd.tf`) as starting points.
- Register new LXC modules in `inventory_builder.tf`.
- Ensure Ansible roles are tagged correctly for sequencing.

---

## 📐 Coding Standards

- Add MIT license headers to new files.
- Run `terraform fmt` before committing.
- Keep commits atomic and descriptive.
- Follow Ansible best practices for role definitions.

---

## 📚 Documentation

- Update the **README.md** when adding new modules or scripts.
- Add entries to the **CHANGELOG.md** for significant changes.
- Expand the **Wiki** for detailed usage examples.

---

## 🚀 CI/CD Guidelines

- Pipelines run Terraform state in GitLab CI/CD.
- Required variables:
  - `PM_API_TOKEN_ID`
  - `PM_API_TOKEN_SECRET`
  - `PM_API_URL`
  - `SSH_PRIVATE_KEY_BASE_64`
- Test pipelines in a fork before merging.

---

## 🤝 Code of Conduct

- Be respectful and collaborative.
- Discuss breaking changes before merging.
- Follow GitLab community standards.

---

## 📜 License

By contributing, you agree that your contributions will be licensed under the **MIT License**.
