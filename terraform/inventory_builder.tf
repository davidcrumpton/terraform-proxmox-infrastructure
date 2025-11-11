locals {
  # Collect ansible data from all LXC modules in the repo
  lxc_inventory = [
    module.lxc_atom5g.ansible_data,
    # Add more here, e.g.:
    # module.lxc_gitlab_runner.ansible_data,
    # module.lxc_keycloak.ansible_data
  ]

  # Build a map of groups → hosts
  groups = {
    all = [for h in local.lxc_inventory : h.hostname]

    # Group by node (pve_x)
    for node in distinct([for h in local.lxc_inventory : h.node]) :
    "pve_${node}" => [for h in local.lxc_inventory : h.hostname if h.node == node]

    # Group by tags (role_x)
    ...
  }

  # Add roles (from tags)
  group_roles = merge(
    { for h in local.lxc_inventory : h.hostname => [for t in h.tags_list : "role_${t}"] },
    {}
  )

  # Add networks (from bridge)
  group_networks = merge(
    { for h in local.lxc_inventory :
      h.hostname => [for n in h.networks : "net_${replace(n.bridge, "-", "_")}"]
    },
    {}
  )

  # Merge all group sources
  all_groups = merge(
    local.groups,
    # dynamically flatten tags and networks into inventory groups
    {
      for g in flatten(distinct(concat(
        flatten(values(local.group_roles)),
        flatten(values(local.group_networks))
      ))) :
      g => [for h in local.lxc_inventory : h.hostname if contains(flatten(concat(
        local.group_roles[h.hostname],
        local.group_networks[h.hostname]
      )), g)]
    }
  )

  inventory_content = join("\n",
    concat(
      ["[all]"],
      [for h in local.groups["all"] : "${h} ansible_host=${join("", h.ip_addrs)}"],
      flatten([
        for group_name, hosts in local.all_groups : [
          "",
          "[${group_name}]",
          for host in hosts : host
        ]
      ])
    )
  )
}

resource "local_file" "ansible_inventory" {
  content  = local.inventory_content
  filename = "${path.root}/ansible/inventory/hosts"
}
