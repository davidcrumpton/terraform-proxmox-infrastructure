
tags:
%{ for tag in tags_list ~}
  - ${tag}
%{ endfor ~}
docker: ${docker}
ldap_login: ${ldap_login}
