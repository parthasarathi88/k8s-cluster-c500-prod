#!/bin/bash

# Script to verify domain configuration on all VMs
VMs=("192.168.1.141" "192.168.1.142" "192.168.1.145")
VM_NAMES=("c500k8sn1" "c500k8sn2" "c500k8sn3")
USER="partha"  # Replace with your actual username

echo "=== Checking Domain Configuration on All VMs ==="
echo ""

for i in "${!VMs[@]}"; do
    IP="${VMs[$i]}"
    NAME="${VM_NAMES[$i]}"
    
    echo "🔍 Checking VM: $NAME ($IP)"
    echo "----------------------------------------"
    
    # Test SSH connectivity first
    if ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no "$USER@$IP" "echo 'SSH connection successful'" 2>/dev/null; then
        echo "✅ SSH connection successful"
        
        # Check hostname
        echo -n "Hostname: "
        ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no "$USER@$IP" "hostname" 2>/dev/null
        
        # Check FQDN
        echo -n "FQDN: "
        ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no "$USER@$IP" "hostname -f" 2>/dev/null
        
        # Check domain
        echo -n "Domain: "
        ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no "$USER@$IP" "hostname -d" 2>/dev/null
        
        # Check network interface configuration
        echo "Network interface config:"
        ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no "$USER@$IP" "ls -la /etc/sysconfig/network-scripts/ifcfg-* | head -3" 2>/dev/null
        
        # Check for DOMAIN entry in network config
        echo "DOMAIN setting in network config:"
        ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no "$USER@$IP" "grep -H DOMAIN /etc/sysconfig/network-scripts/ifcfg-* 2>/dev/null || echo 'No DOMAIN entry found'"
        
        # Check resolv.conf
        echo "DNS configuration:"
        ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no "$USER@$IP" "grep -E '^(search|domain|nameserver)' /etc/resolv.conf" 2>/dev/null
        
    else
        echo "❌ SSH connection failed - VM may still be booting"
    fi
    
    echo ""
    echo "========================================"
    echo ""
done

echo "Domain verification complete!"
echo ""
echo "To manually fix domain configuration if needed:"
echo "1. SSH to each VM: ssh $USER@<VM_IP>"
echo "2. Check network config: cat /etc/sysconfig/network-scripts/ifcfg-ens*"
echo "3. Add domain if missing: echo 'DOMAIN=dellpc.in' | sudo tee -a /etc/sysconfig/network-scripts/ifcfg-ens160"
echo "4. Restart network: sudo systemctl restart network"
