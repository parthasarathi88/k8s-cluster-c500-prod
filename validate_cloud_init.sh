#!/bin/bash

# Test cloud-init template validation
echo "Testing cloud-init template..."

# Create a temporary file with the rendered template
cat > /tmp/test_cloud_init.yml << 'EOF'
#cloud-config

# Basic system setup
hostname: test-vm
manage_etc_hosts: true

# Network configuration - static IP setup
network:
  version: 2
  ethernets:
    ens160:
      dhcp4: false
      addresses:
        - 192.168.1.100/24
      gateway4: 192.168.1.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4

# User configuration
users:
  - name: partha
    plain_text_passwd: Kukapilla@1269
    lock_passwd: false
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: [sudo, adm, dialout, cdrom, floppy, audio, dip, video, plugdev, netdev]
    shell: /bin/bash
    chpasswd: {expire: false}
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDuLJKA2/sLxSI2izFAroofhGbPaV9WHnt4w6cfmj2gquMmbe0+CfjxVR/2CMqHeQns4UtZcs7ctFsxrPz59caRsl2ZLR+66AVL4T0Hg2YYMcRJI7jaAVoSkjBgVGSMkp0ObktxZso/JHrcbGHMU7NplJ3rIDpRvuKfZ82VmzAAbSkr2lyA9spxHBNPQHcz889Oym57j/K/b/fMlJLYjgFetlczEQcFQKO2T28upfzD56EE+7ZYcmW3Sh/Qhb1bBG+1ca1r47tochVONiczZly2qS2hcfKmi4PYU4w3MrfRRfh2R2zqgIGPrQ6u0fVDKpfOb5PVyuk7JCEn9v/nCnOj partha@mgmt01

# Enable password authentication
ssh_pwauth: true
disable_root: false

# Basic packages
packages:
  - openssh-server
  - curl
  - wget
  - net-tools
  - htop
  - vim
  - git
  - unzip

# System configuration
package_update: true
package_upgrade: false

# Commands to run after boot
runcmd:
  - echo "Cloud-init setup started for partha" >> /var/log/cloud-init-custom.log
  - systemctl enable ssh
  - systemctl restart ssh
  - systemctl enable systemd-networkd
  - systemctl restart systemd-networkd
  - netplan apply
  - echo "Network configuration applied" >> /var/log/cloud-init-custom.log
  - echo "Cloud-init setup completed for partha" >> /var/log/cloud-init-custom.log
  - ip addr show >> /var/log/cloud-init-custom.log

# Write additional configuration files
write_files:
  - path: /etc/ssh/sshd_config.d/99-custom.conf
    content: |
      PasswordAuthentication yes
      PubkeyAuthentication yes
      PermitRootLogin no
    owner: root:root
    permissions: '0644'

# Final message
final_message: "System setup completed successfully for test-vm"
EOF

# Check if cloud-init is available for validation
if command -v cloud-init &> /dev/null; then
    echo "Validating cloud-init template..."
    cloud-init schema --config-file /tmp/test_cloud_init.yml
    if [ $? -eq 0 ]; then
        echo "✅ Cloud-init template is valid!"
    else
        echo "❌ Cloud-init template has errors!"
        exit 1
    fi
else
    echo "⚠️  cloud-init not available for validation, but template syntax looks correct"
fi

# Validate YAML syntax using Python
python3 -c "
import yaml
try:
    with open('/tmp/test_cloud_init.yml', 'r') as f:
        yaml.safe_load(f)
    print('✅ YAML syntax is valid!')
except yaml.YAMLError as e:
    print(f'❌ YAML syntax error: {e}')
    exit(1)
"

echo "Cloud-init template validation completed!"
