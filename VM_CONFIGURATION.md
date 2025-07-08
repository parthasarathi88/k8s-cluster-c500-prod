# VM Configuration Script

## Overview

This project includes automated VM configuration using Terraform and a post-deployment script that:

1. **Disables SELinux** - Sets SELinux to disabled mode
2. **Disables firewalld** - Stops and disables the firewall service  
3. **Configures GRUB for eth0** - Adds `net.ifnames=0 biosdevname=0` to ensure consistent eth0 interface naming
4. **Installs and configures iSCSI** - Installs iSCSI initiator utils and configures the service
5. **Configures multipath** - Sets up device mapper multipath for storage redundancy
6. **Updates system packages** - Applies security updates

## Files

- `main.tf` - Main Terraform configuration with local-exec provisioner
- `scripts/configure-vm.sh` - Post-deployment configuration script
- `scripts/validate_vm_config.sh` - Validation script to verify configuration

## Usage

### Automatic Execution (via Terraform)

The script runs automatically after VM deployment when you run:

```bash
terraform apply
```

### Manual Execution

You can also run the script manually:

```bash
./scripts/configure-vm.sh <ip_address> <username> <password> <vm_name>
```

Example:
```bash
./scripts/configure-vm.sh 192.168.1.141 partha Kukapilla@1269 c500k8sn1
```

### Validation

To validate the configuration was applied correctly:

```bash
./scripts/validate_vm_config.sh <ip_address> <username> <password>
```

Example:
```bash
./scripts/validate_vm_config.sh 192.168.1.141 partha Kukapilla@1269
```

## Prerequisites

- **sshpass** must be installed on the Terraform host:
  ```bash
  # Ubuntu/Debian
  sudo apt-get install -y sshpass
  
  # CentOS/RHEL
  sudo yum install -y sshpass
  ```

- SSH access to the VMs with sudo privileges
- VMs should be running CentOS/RHEL (script uses yum package manager)

## Configuration Details

### SELinux Disable
- Sets `setenforce 0` immediately
- Modifies `/etc/selinux/config` to set `SELINUX=disabled`

### Firewalld Disable
- Stops firewalld service
- Disables firewalld from starting on boot

### GRUB Configuration
- Adds `net.ifnames=0 biosdevname=0` to `/etc/default/grub`
- Rebuilds GRUB configuration
- **Requires reboot** for changes to take effect

### iSCSI Configuration
- Installs `iscsi-initiator-utils` and `device-mapper-multipath`
- Generates unique initiator name: `iqn.1994-05.com.redhat:<hostname>`
- Enables and starts `iscsid` and `iscsi` services
- Configures multipath for storage redundancy

### Network Interface
- Creates eth0 configuration based on existing interface (if needed)
- Ensures consistent network interface naming

## Post-Configuration

After running the script:

1. **Reboot the VMs** to apply GRUB changes:
   ```bash
   sudo reboot
   ```

2. **Verify configuration** using the validation script

3. **Check network interfaces** after reboot:
   ```bash
   ip addr show
   ```

## Expected Results

After successful configuration:

- SELinux: `Disabled`
- Firewalld: `inactive`
- iSCSI: `active`
- Multipath: `active`
- Network interface: `eth0` available after reboot

## Troubleshooting

### SSH Connection Issues
- Verify VM IP addresses are correct
- Check if VMs are fully booted
- Verify username/password credentials
- Ensure SSH service is running on VMs

### Script Execution Issues
- Check if `sshpass` is installed
- Verify sudo access for the user
- Check network connectivity to VMs

### Package Installation Issues
- Verify internet connectivity from VMs
- Check if package repositories are accessible
- Ensure sufficient disk space on VMs

## Security Notes

- The script uses password-based SSH authentication
- Consider using SSH keys instead of passwords for production
- Review firewall requirements before disabling firewalld
- Test SELinux disable impact on your applications

## Customization

To modify the configuration:

1. Edit `scripts/configure-vm.sh`
2. Add or remove configuration steps as needed
3. Update the validation script accordingly
4. Test changes in a development environment first
