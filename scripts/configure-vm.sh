#!/bin/bash

# VM Post-Deployment Configuration Script
# Parameters: IP_ADDRESS USERNAME PASSWORD VM_NAME

set -e

# Script parameters
IP_ADDRESS="$1"
USERNAME="$2"
PASSWORD="$3"
VM_NAME="$4"

# Configuration
SSH_OPTS="-o ConnectTimeout=10 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
MAX_RETRIES=30
RETRY_DELAY=10

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}" >&2
}

warning() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

# Function to wait for SSH connectivity
wait_for_ssh() {
    log "Waiting for SSH access to $IP_ADDRESS..."
    local retry_count=0
    
    while [ $retry_count -lt $MAX_RETRIES ]; do
        if sshpass -p "$PASSWORD" ssh $SSH_OPTS "$USERNAME@$IP_ADDRESS" "echo 'SSH connection successful'" >/dev/null 2>&1; then
            log "SSH connection established to $IP_ADDRESS"
            return 0
        fi
        
        retry_count=$((retry_count + 1))
        warning "SSH attempt $retry_count/$MAX_RETRIES failed. Retrying in $RETRY_DELAY seconds..."
        sleep $RETRY_DELAY
    done
    
    error "Failed to establish SSH connection to $IP_ADDRESS after $MAX_RETRIES attempts"
    return 1
}

# Function to execute remote commands
execute_remote() {
    local command="$1"
    log "Executing on $VM_NAME ($IP_ADDRESS): $command"
    sshpass -p "$PASSWORD" ssh $SSH_OPTS "$USERNAME@$IP_ADDRESS" "echo '$PASSWORD' | sudo -S bash -c '$command'"
}

# Main configuration function
configure_vm() {
    log "Starting configuration for VM: $VM_NAME ($IP_ADDRESS)"
    
    # Wait for SSH connectivity
    if ! wait_for_ssh; then
        error "Cannot proceed without SSH connectivity"
        exit 1
    fi
    
    log "=== Starting VM Configuration ==="
    
    # 1. Disable SELinux
    log "Disabling SELinux..."
    execute_remote "
        echo 'Disabling SELinux...'
        setenforce 0 2>/dev/null || true
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
        sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config
        echo 'SELinux disabled'
    "
    
    # 2. Disable firewalld
    log "Disabling firewalld..."
    execute_remote "
        echo 'Disabling firewalld...'
        systemctl stop firewalld 2>/dev/null || true
        systemctl disable firewalld 2>/dev/null || true
        echo 'Firewalld disabled'
    "
    
    # 3. Configure GRUB for eth0 interface naming
    log "Configuring GRUB for eth0 interface naming..."
    execute_remote "
        echo 'Updating GRUB configuration...'
        if ! grep -q 'net.ifnames=0' /etc/default/grub; then
            sed -i '/GRUB_CMDLINE_LINUX=/ s/\"$/ net.ifnames=0 biosdevname=0\"/' /etc/default/grub
            grub2-mkconfig -o /boot/grub2/grub.cfg
            echo 'GRUB updated - reboot required for changes to take effect'
        else
            echo 'GRUB already configured for eth0 naming'
        fi
    "
    
    # 4. Install and configure iSCSI
    log "Installing and configuring iSCSI..."
    execute_remote "
        echo 'Installing iSCSI initiator utils...'
        yum install -y iscsi-initiator-utils device-mapper-multipath
        
        echo 'Configuring iSCSI initiator...'
        # Generate unique initiator name if not exists
        if [ ! -f /etc/iscsi/initiatorname.iscsi ] || [ ! -s /etc/iscsi/initiatorname.iscsi ]; then
            echo \"InitiatorName=iqn.1994-05.com.redhat:\$(hostname -s)\" > /etc/iscsi/initiatorname.iscsi
        fi
        
        # Configure iSCSI daemon
        systemctl enable iscsid
        systemctl start iscsid
        systemctl enable iscsi
        
        echo 'iSCSI services configured and started'
        
        # Configure multipath (optional but recommended)
        echo 'Configuring device mapper multipath...'
        if [ ! -f /etc/multipath.conf ]; then
            mpathconf --enable --with_multipathd y
        fi
        systemctl enable multipathd
        systemctl start multipathd || true
        
        echo 'Multipath configured'
    "
    
    # 5. Configure network interface for eth0 (if needed)
    log "Ensuring eth0 network interface configuration..."
    execute_remote "
        echo 'Checking network interface configuration...'
        if [ ! -f /etc/sysconfig/network-scripts/ifcfg-eth0 ] && ls /etc/sysconfig/network-scripts/ifcfg-ens* 2>/dev/null; then
            echo 'Creating eth0 interface configuration...'
            # Find the active interface
            ACTIVE_IF=\$(ls /etc/sysconfig/network-scripts/ifcfg-ens* | head -1)
            cp \"\$ACTIVE_IF\" /etc/sysconfig/network-scripts/ifcfg-eth0
            sed -i 's/NAME=.*/NAME=eth0/' /etc/sysconfig/network-scripts/ifcfg-eth0
            sed -i 's/DEVICE=.*/DEVICE=eth0/' /etc/sysconfig/network-scripts/ifcfg-eth0
            echo 'eth0 interface configuration created'
        else
            echo 'eth0 interface configuration already exists or no template found'
        fi
    "
    
    # 6. Update system packages (optional)
    log "Updating system packages..."
    execute_remote "
        echo 'Updating system packages...'
        yum update -y --security || yum update -y || true
        echo 'System packages updated'
    "
    
    # 7. Display configuration summary
    log "Displaying configuration summary..."
    execute_remote "
        echo '=== Configuration Summary ==='
        echo 'Hostname: '\$(hostname)
        echo 'IP Address: '\$(ip route get 8.8.8.8 | awk '{print \$7}' | head -1)
        echo 'SELinux Status: '\$(getenforce 2>/dev/null || echo 'Not available')
        echo 'Firewalld Status: '\$(systemctl is-active firewalld 2>/dev/null || echo 'inactive')
        echo 'iSCSI Status: '\$(systemctl is-active iscsid 2>/dev/null || echo 'inactive')
        echo 'Multipath Status: '\$(systemctl is-active multipathd 2>/dev/null || echo 'inactive')
        echo 'Network Interfaces:'
        ip addr show | grep -E '^[0-9]+:' | awk '{print \$2}' | tr -d ':'
        echo '============================'
    "
    
    log "Configuration completed successfully for $VM_NAME ($IP_ADDRESS)"
    warning "Note: A reboot is recommended to apply all changes (especially GRUB modifications)"
}

# Main script execution
main() {
    if [ $# -ne 4 ]; then
        error "Usage: $0 <ip_address> <username> <password> <vm_name>"
        exit 1
    fi
    
    # Check if sshpass is available
    if ! command -v sshpass >/dev/null 2>&1; then
        error "sshpass is required but not installed. Please install it first:"
        error "  CentOS/RHEL: yum install -y sshpass"
        error "  Ubuntu/Debian: apt-get install -y sshpass"
        exit 1
    fi
    
    configure_vm
}

# Run main function with all arguments
main "$@"
