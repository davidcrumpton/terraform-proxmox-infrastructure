---
hostname: ${hostname}
vmid: ${vmid}
node: ${node}
storage: ${storage}
tags_list: ${join(", ", tags_list)}
features:
  nesting: ${features.nesting}
networks:
%{ for net in networks ~}
  - name: ${net.name}
    bridge: ${net.bridge}
    ip: ${net.ip}
    ip6: ${net.ip6}
%{ endfor ~}
