
tags:
%{ for tag in tags_list ~}
  - ${tag}
%{ endfor ~}
docker: ${ansible_config_docker}
ldap_login: ${ansible_config_ldap}
