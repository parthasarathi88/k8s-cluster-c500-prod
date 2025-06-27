# Domain Configuration Verification and Fix

## After Terraform Apply

After running `terraform apply`, you should verify that the domain is properly configured on each VM.

### 1. Check Current Domain Configuration

SSH to each VM and check:

```bash
# Check hostname and domain
hostname -f
hostname -d

# Check network configuration
cat /etc/sysconfig/network-scripts/ifcfg-ens160  # or ifcfg-eth0
cat /etc/resolv.conf

# Check system hostname
cat /etc/hostname
```

### 2. Manual Fix if Domain is Missing

If the `DOMAIN=dellpc.in` entry is missing from the network interface configuration, you can add it manually:

```bash
# Backup the original file
sudo cp /etc/sysconfig/network-scripts/ifcfg-ens160 /etc/sysconfig/network-scripts/ifcfg-ens160.backup

# Add the domain entry
echo "DOMAIN=dellpc.in" | sudo tee -a /etc/sysconfig/network-scripts/ifcfg-ens160

# Restart network service
sudo systemctl restart network
# OR
sudo systemctl restart NetworkManager

# Verify the change
cat /etc/resolv.conf
```

### 3. Automated Fix Script

Save this as `fix-domain.sh` and run on each VM:

```bash
#!/bin/bash
DOMAIN="dellpc.in"
INTERFACE_FILE="/etc/sysconfig/network-scripts/ifcfg-ens160"

# Check if interface file exists, try common names
if [ ! -f "$INTERFACE_FILE" ]; then
    INTERFACE_FILE="/etc/sysconfig/network-scripts/ifcfg-eth0"
fi

if [ ! -f "$INTERFACE_FILE" ]; then
    echo "Network interface configuration file not found!"
    exit 1
fi

# Check if DOMAIN is already set
if grep -q "^DOMAIN=" "$INTERFACE_FILE"; then
    echo "DOMAIN is already configured in $INTERFACE_FILE"
    grep "^DOMAIN=" "$INTERFACE_FILE"
else
    echo "Adding DOMAIN=$DOMAIN to $INTERFACE_FILE"
    echo "DOMAIN=$DOMAIN" | sudo tee -a "$INTERFACE_FILE"
    
    # Restart network service
    sudo systemctl restart network 2>/dev/null || sudo systemctl restart NetworkManager
    
    echo "Domain configuration updated. Checking resolv.conf:"
    cat /etc/resolv.conf | grep "^search\|^domain"
fi
```

### 4. Expected Results

After the fix, you should see:

```bash
# In /etc/sysconfig/network-scripts/ifcfg-ens160
DOMAIN=dellpc.in

# In /etc/resolv.conf
search dellpc.in
domain dellpc.in
```

### 5. Terraform Configuration

The current Terraform configuration includes:
- `domain = "dellpc.in"` in linux_options
- `dns_domain = "dellpc.in"` in network_interface  
- `dns_suffix_list = ["dellpc.in"]` for DNS search domains

These settings should automatically configure the domain, but manual verification is recommended.
