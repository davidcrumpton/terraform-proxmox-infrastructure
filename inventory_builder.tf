# SPDX-License-Identifier: MIT

locals {
  # Collect ansible data from all LXC modules
  lxc_inventory = [
   # module.lxc_atom5g.ansible_data,

    # Add more here, e.g.:
#    module.lxc_gl_runner.ansible_data,
    module.lxc_nextsuite.ansible_data,
    module.lxc_docker02.ansible_data,
    # module.lxc_keycloak.ansible_data,
  ]

  # Build base groups
  base_groups = {
    all = [for h in local.lxc_inventory : h.hostname]
  }

  # Group by Proxmox node (pve_x)
  node_groups = {
    for node in distinct([for h in local.lxc_inventory : h.node]) :
    "pve_${node}" => [for h in local.lxc_inventory : h.hostname if h.node == node]
  }

  # Group by tags (role_x)
  tag_groups = merge([
    for h in local.lxc_inventory : {
      for t in h.tags_list : "role_${t}" => [h.hostname]
    }
  ]...)

  # Optionally, group by bridges (net_x)
  bridge_groups = merge([
    for h in local.lxc_inventory : {
      for n in h.networks : "net_${n.bridge}" => [h.hostname]
    }
  ]...)

  # Merge everything into one map
  all_groups = merge(
    local.base_groups,
    local.node_groups,
    local.tag_groups,
    local.bridge_groups,
  )

  # Flatten map into Ansible INI inventory text
  inventory_text = join(
    "\n",
    flatten([
      for group_name, hosts in local.all_groups : concat(
        ["[${group_name}]"],
        hosts,
        [""]
      )
    ])
  )
}

resource "local_file" "ansible_inventory" {
  content  = local.inventory_text
  filename = "${path.cwd}/ansible/inventory/hosts"
}
