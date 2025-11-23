# templates/vault.yml.tpl
# This template is generic and accepts any number of key/value pairs.
# SPDX-License-Identifier: MIT
%{ for key, value in secrets ~}
${key}: ${value}
%{ endfor ~}