# Modular Terraform vCenter Infrastructure

This project provides a modular, production-ready Terraform infrastructure for deploying Ubuntu/CentOS VMs on vCenter with static IPs, VMware customization, and post-deployment configuration.

## 🏗️ Project Structure

```
k8s-cluster-c500-prod/
├── modules/                    # Reusable Terraform modules
│   ├── compute/               # VM creation and configuration
│   ├── network/               # Network configuration
│   └── storage/               # Storage configuration
├── environments/              # Environment-specific configurations
│   ├── prod/                  # Production environment
│   ├── dev/                   # Development environment
│   └── staging/               # Staging environment
├── scripts/                   # Automation and validation scripts
│   ├── configure-vm.sh        # Post-deployment VM configuration
│   └── validate_vm_config.sh  # Validation script
├── packer/                    # Packer templates for VM images
└── template/                  # Cloud-init templates
```

## 🚀 Quick Start

### 1. Choose Your Environment

Navigate to the environment you want to deploy:

```bash
# For production
cd environments/prod

# For development
cd environments/dev

# For staging
cd environments/staging
```

### 2. Configure Variables

Edit the `terraform.tfvars` file in your chosen environment:

```bash
# Example for production
vi environments/prod/terraform.tfvars
```

### 3. Initialize and Deploy

```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply the configuration
terraform apply
```

## 🔧 Configuration

### Environment-Specific Settings

Each environment has its own configuration:

#### Production (`environments/prod/`)
- **VMs**: 3 instances (k8s-master-1, k8s-worker-1, k8s-worker-2)
- **Resources**: 4 CPUs, 8GB RAM, 60GB disk per VM
- **IPs**: 192.168.10.141, 192.168.10.142, 192.168.10.145
- **Domain**: dellpc.in

#### Development (`environments/dev/`)
- **VMs**: 2 instances (dev-k8s-1, dev-k8s-2)
- **Resources**: 2 CPUs, 4GB RAM, 40GB disk per VM
- **IPs**: 192.168.10.131, 192.168.10.132
- **Domain**: dev.dellpc.in

#### Staging (`environments/staging/`)
- **VMs**: 2 instances (staging-k8s-1, staging-k8s-2)
- **Resources**: 2 CPUs, 4GB RAM, 40GB disk per VM
- **IPs**: 192.168.10.151, 192.168.10.152
- **Domain**: staging.dellpc.in

## 📦 Modules

### Compute Module (`modules/compute/`)
Handles VM creation, customization, and post-deployment configuration:
- VM provisioning with static IPs
- VMware customization (hostname, IP, domain)
- User account creation
- Post-deployment script execution

### Network Module (`modules/network/`)
Manages network configuration:
- Network discovery and validation
- Gateway and DNS configuration
- Network security settings

### Storage Module (`modules/storage/`)
Handles storage configuration:
- Datastore selection and validation
- Disk configuration
- Storage policies

## 🔒 Security & Configuration

### Post-Deployment Configuration
The `scripts/configure-vm.sh` script automatically:
- Disables SELinux and firewalld for development
- Configures eth0 network interface naming
- Installs and configures iSCSI initiator
- Sets up multipath configuration
- Updates system packages

### Validation
Use the validation script to check VM configuration:
```bash
./scripts/validate_vm_config.sh
```

## 🛠️ Advanced Usage

### Custom VM Configuration
Override default settings in your environment's `terraform.tfvars`:

```hcl
# Custom VM specifications
vm_cpus = 4
vm_memory = 8192
vm_disk_size = 100

# Custom IP addresses
vm_ips = [
  "192.168.10.200",
  "192.168.10.201"
]
```

### Adding New Environments
1. Create a new directory under `environments/`
2. Copy files from an existing environment
3. Modify variables and configuration as needed

### Module Customization
Each module can be customized by modifying the variables in the respective `variables.tf` files.

## 📋 Prerequisites

- Terraform >= 1.0
- Access to vCenter server
- SSH access to target VMs
- Ubuntu 22.04 template in vCenter

## 🔍 Troubleshooting

### Common Issues

1. **vCenter Connection Issues**
   - Verify network connectivity to vCenter
   - Check credentials in `terraform.tfvars`
   - Ensure SSL certificate trust

2. **VM Creation Failures**
   - Verify template exists and is accessible
   - Check resource pool and datastore availability
   - Validate network configuration

3. **Post-Deployment Script Failures**
   - Check SSH connectivity to VMs
   - Verify user credentials
   - Review script logs

### Debug Commands

```bash
# Check Terraform state
terraform state list

# View detailed logs
export TF_LOG=DEBUG
terraform apply

# Validate configuration
terraform validate

# Check VM status
./scripts/validate_vm_config.sh
```

## 📚 Documentation

- [VM Configuration Guide](VM_CONFIGURATION.md)
- [Domain Setup Guide](DOMAIN_SETUP.md)
- [Troubleshooting Guide](TROUBLESHOOTING.md)
- [Migration Guide](MIGRATION.md)

## 🤝 Contributing

1. Create feature branches for new functionality
2. Test changes in the `dev` environment first
3. Update documentation for any new features
4. Follow Terraform best practices

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**🎯 Next Steps:**
- Set up remote state management
- Implement CI/CD pipeline
- Add monitoring and alerting
- Extend modules for additional cloud providers
