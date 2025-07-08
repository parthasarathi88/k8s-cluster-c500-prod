# Kubernetes Cluster Infrastructure - Modular Terraform

This project provides a modular Terraform infrastructure for deploying Kubernetes cluster VMs on VMware vSphere with automated post-deployment configuration.

## 🏗️ Project Structure

```
k8s-cluster-c500-prod/
├── environments/           # Environment-specific configurations
│   ├── prod/              # Production environment
│   │   ├── main.tf        # Main configuration
│   │   ├── variables.tf   # Production variables
│   │   ├── outputs.tf     # Production outputs
│   │   └── terraform.tfvars # Production values (sensitive)
│   ├── dev/               # Development environment
│   │   ├── main.tf        # Development configuration
│   │   ├── variables.tf   # Development variables
│   │   └── outputs.tf     # Development outputs
│   └── staging/           # Staging environment (template)
├── modules/               # Reusable Terraform modules
│   ├── compute/           # VM compute resources
│   │   ├── main.tf        # VM definitions and configuration
│   │   ├── variables.tf   # Compute module variables
│   │   └── outputs.tf     # Compute module outputs
│   ├── network/           # Network configuration
│   │   ├── main.tf        # Network data sources
│   │   ├── variables.tf   # Network module variables
│   │   └── outputs.tf     # Network module outputs
│   └── storage/           # Storage configuration
│       ├── main.tf        # Datastore data sources
│       ├── variables.tf   # Storage module variables
│       └── outputs.tf     # Storage module outputs
├── scripts/               # Post-deployment scripts
│   ├── configure-vm.sh    # VM configuration script
│   └── validate_vm_config.sh # Configuration validation
├── packer/                # Packer templates (optional)
└── legacy/                # Original non-modular files
```

## 🚀 Quick Start

### 1. Choose Environment

Navigate to your desired environment:

```bash
# Production environment
cd environments/prod

# Development environment  
cd environments/dev
```

### 2. Configure Variables

Edit `terraform.tfvars` with your environment-specific values:

```hcl
# vCenter Configuration
vcenter_user     = "administrator@vsphere.local"
vcenter_password = "your-password"
vcenter_server   = "192.168.10.252"

# VM Configuration
vm_user     = "your-vm-user"
vm_password = "your-vm-password"
ssh_public_key = "your-ssh-public-key"
```

### 3. Deploy Infrastructure

```bash
# Initialize Terraform
terraform init

# Plan deployment
terraform plan

# Deploy infrastructure
terraform apply
```

## 🏢 Environment Configurations

### Production Environment
- **VM Count**: 3 VMs
- **Resources**: 2 CPU, 4GB RAM, 20GB disk per VM
- **Naming**: c500k8sn1, c500k8sn2, c500k8sn3
- **IPs**: 192.168.1.141-145
- **Domain**: dellpc.in

### Development Environment
- **VM Count**: 2 VMs (resource efficient)
- **Resources**: 1 CPU, 2GB RAM, 15GB disk per VM
- **Naming**: c500k8s-dev1, c500k8s-dev2
- **IPs**: 192.168.1.151-152
- **Domain**: dev.dellpc.in

## ⚙️ Post-Deployment Configuration

Each VM is automatically configured with:

1. **Security Configuration**
   - SELinux disabled
   - Firewalld disabled

2. **Network Configuration**
   - GRUB configured for eth0 interface naming
   - Static IP configuration
   - Domain configuration

3. **Storage Configuration**
   - iSCSI initiator installation and configuration
   - Multipath configuration for redundancy

4. **System Updates**
   - Security package updates
   - Essential package installation

## 🧩 Module Architecture

### Compute Module
Manages VM resources including creation, customization, and post-deployment configuration.

### Network Module
Handles network interface selection, DNS, and gateway configuration.

### Storage Module
Manages datastore allocation and storage policies.

## 📋 Migration from Legacy

The project has been reorganized from a monolithic structure to a modular one. Legacy files are preserved in the root directory.

### Key Changes:
- Separated concerns into modules
- Environment-specific configurations
- Improved reusability and maintainability
- Better separation of production and development settings

## 🔧 Usage Examples

### Deploy Production Environment

```bash
cd environments/prod
terraform init
terraform plan
terraform apply
```

### Validate Configuration

```bash
# From project root
./scripts/validate_vm_config.sh 192.168.1.141 username password
```

## 🔐 Security Best Practices

1. Never commit `terraform.tfvars` to version control
2. Use SSH keys instead of passwords where possible
3. Implement least privilege access for vCenter
4. Regular credential rotation

## 🔍 Troubleshooting

### Common Issues

1. **vCenter Connection Timeout**
   - Verify network connectivity
   - Check firewall rules
   - Validate credentials

2. **Template Not Found**
   - Verify template exists in vCenter
   - Check template naming
   - Ensure proper datacenter path

## 📚 Documentation

- `VM_CONFIGURATION.md` - Detailed VM configuration documentation
- `DOMAIN_SETUP.md` - Domain configuration guide
- `TROUBLESHOOTING.md` - Troubleshooting guide

## 🤝 Contributing

1. Follow the modular structure
2. Test in development environment first
3. Update documentation
4. Submit pull requests for review
