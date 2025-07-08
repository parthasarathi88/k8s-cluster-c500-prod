#!/bin/bash

# Validate that the VM configuration was applied correctly
# Usage: validate_vm_config.sh <ip_address> <username> <password>

IP_ADDRESS="$1"
USERNAME="$2"
PASSWORD="$3"

SSH_OPTS="-o ConnectTimeout=10 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

echo "=== Validating VM Configuration for $IP_ADDRESS ==="

# Function to run remote command and capture output
run_remote() {
    sshpass -p "$PASSWORD" ssh $SSH_OPTS "$USERNAME@$IP_ADDRESS" "$1" 2>/dev/null
}

# Check SELinux status
echo -n "SELinux Status: "
SELINUX_STATUS=$(run_remote "getenforce 2>/dev/null || echo 'Not available'")
echo "$SELINUX_STATUS"

# Check firewalld status
echo -n "Firewalld Status: "
FIREWALL_STATUS=$(run_remote "systemctl is-active firewalld 2>/dev/null || echo 'inactive'")
echo "$FIREWALL_STATUS"

# Check GRUB configuration
echo -n "GRUB eth0 config: "
GRUB_CONFIG=$(run_remote "grep -q 'net.ifnames=0' /etc/default/grub && echo 'Configured' || echo 'Not configured'")
echo "$GRUB_CONFIG"

# Check iSCSI installation and status
echo -n "iSCSI initiator: "
ISCSI_INSTALLED=$(run_remote "rpm -q iscsi-initiator-utils >/dev/null 2>&1 && echo 'Installed' || echo 'Not installed'")
echo "$ISCSI_INSTALLED"

echo -n "iSCSI daemon: "
ISCSI_STATUS=$(run_remote "systemctl is-active iscsid 2>/dev/null || echo 'inactive'")
echo "$ISCSI_STATUS"

# Check multipath
echo -n "Multipath: "
MULTIPATH_STATUS=$(run_remote "systemctl is-active multipathd 2>/dev/null || echo 'inactive'")
echo "$MULTIPATH_STATUS"

# Check network interface
echo "Network interfaces:"
run_remote "ip addr show | grep -E '^[0-9]+:' | awk '{print \$2}' | tr -d ':'"

echo "=== Validation Complete ==="
