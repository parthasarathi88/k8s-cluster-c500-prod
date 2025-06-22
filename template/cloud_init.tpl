#cloud-config
hostname: ${hostname}
fqdn: ${hostname}.localdomain
manage_etc_hosts: true

users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh-authorized-keys:
      - ${ssh_key}

package_update: true
package_upgrade: true
packages:
  - git
  - curl
  - vim
  - net-tools

write_files:
  - path: /etc/motd
    content: |
      Welcome to ${hostname}!
      This system was provisioned by Terraform
    owner: root:root
    permissions: '0644'

runcmd:
  - systemctl enable --now ssh
  - ufw allow ssh
  - sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
  - systemctl restart sshd

network:
  version: 2
  ethernets:
    ${interface}:
      dhcp4: false
      addresses: ["${ip_addresses}/24"]
      gateway4: ${gateway}
      nameservers:
        addresses: ${yamlencode(nameservers)}
      optional: true

power_state:
  mode: reboot
  message: Rebooting after cloud-init
  timeout: 30