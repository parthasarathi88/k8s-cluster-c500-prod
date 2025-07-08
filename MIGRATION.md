# Migration Guide: Legacy to Modular Structure

This guide helps you migrate from the legacy monolithic Terraform configuration to the new modular structure.

## 🔄 Migration Overview

### Legacy Structure (Root Directory)
```
k8s-cluster-c500-prod/
├── main.tf              # All resources in one file
├── variables.tf         # All variables in one file
├── outputs.tf           # All outputs in one file
├── data.tf             # All data sources
├── terraform.tfvars    # Production variables
└── template/
    └── cloud_init.tpl
```

### New Modular Structure
```
k8s-cluster-c500-prod/
├── modules/                    # Reusable modules
│   ├── compute/
│   ├── network/
│   └── storage/
├── environments/               # Environment-specific configs
│   ├── prod/
│   ├── dev/
│   └── staging/
└── scripts/                   # Automation scripts
```

## 📋 Migration Steps

### Step 1: Backup Current Configuration

```bash
# Create a backup of your current configuration
cp -r /home/partha/terraform/k8s-cluster-c500-prod /home/partha/terraform/k8s-cluster-c500-prod-backup

# Backup Terraform state
cp terraform.tfstate terraform.tfstate.backup.migration
```

### Step 2: Choose Your Target Environment

Determine which environment matches your current setup:

- **Production**: Use `environments/prod/` if you're running production workloads
- **Development**: Use `environments/dev/` for development/testing
- **Staging**: Use `environments/staging/` for staging environments

### Step 3: Update State File (If Needed)

If you want to continue using your existing Terraform state:

```bash
# For production environment
cd environments/prod

# Copy your existing state file
cp ../../terraform.tfstate .
cp ../../terraform.tfstate.backup .

# If needed, update state file references
terraform state mv vsphere_virtual_machine.vm module.compute.vsphere_virtual_machine.vm
```

### Step 4: Variable Mapping

Map your legacy variables to the new structure:

#### Legacy `terraform.tfvars` → New Environment Variables

| Legacy Variable | New Location | New Variable Name |
|----------------|--------------|-------------------|
| `vcenter_user` | Same | `vcenter_user` |
| `vcenter_password` | Same | `vcenter_password` |
| `vcenter_server` | Same | `vcenter_server` |
| `vm_count` | Same | `vm_count` |
| `vm_name_prefix` | Environment-specific | Computed from `vm_names` |
| `vm_cpus` | Environment-specific | `vm_cpus` → `num_cpus` |
| `vm_memory` | Environment-specific | `vm_memory` → `memory` |
| `vm_disk_size` | Environment-specific | `vm_disk_size` → `disk_size` |
| `vm_ips` | Environment-specific | `vm_ips` → `ip_addresses` |

### Step 5: Configuration Migration

#### Option A: Fresh Start (Recommended)
Start with a clean environment and migrate settings:

```bash
# Navigate to your chosen environment
cd environments/prod  # or dev/staging

# Edit terraform.tfvars with your settings
vi terraform.tfvars

# Update variables as needed
vm_count = 3
vm_ips = ["192.168.10.141", "192.168.10.142", "192.168.10.145"]
# ... other settings
```

#### Option B: Preserve Existing State
If you want to keep your existing VMs and state:

```bash
# Import existing resources into modules
terraform import module.compute.vsphere_virtual_machine.vm[0] <vm-id-1>
terraform import module.compute.vsphere_virtual_machine.vm[1] <vm-id-2>
terraform import module.compute.vsphere_virtual_machine.vm[2] <vm-id-3>
```

### Step 6: Test Migration

```bash
# Initialize the new configuration
terraform init

# Plan to see what changes will be made
terraform plan

# If plan looks good, apply
terraform apply
```

## 🔧 Key Differences

### Resource Organization
- **Legacy**: All resources in `main.tf`
- **Modular**: Resources split into focused modules

### Variable Scope
- **Legacy**: Global variables for everything
- **Modular**: Module-specific variables with clear interfaces

### Environment Management
- **Legacy**: Single configuration for all environments
- **Modular**: Separate configurations per environment

### Customization Method
- **Legacy**: Cloud-init templates
- **Modular**: VMware customization (more reliable)

## ⚠️ Important Notes

### Breaking Changes
1. **VM Naming**: New structure uses environment-specific prefixes
2. **Customization**: Switched from cloud-init to VMware customization
3. **IP Configuration**: Now handled through VMware tools
4. **Post-deployment**: Uses shell scripts instead of cloud-init

### Resource Addresses
Resource addresses have changed:
- **Legacy**: `vsphere_virtual_machine.vm[0]`
- **Modular**: `module.compute.vsphere_virtual_machine.vm[0]`

### State File Impact
- State file structure changes when using modules
- Consider using `terraform state mv` for migrations
- Fresh deployments are often cleaner

## 🚨 Troubleshooting Migration

### Common Issues

#### 1. State File Conflicts
```bash
# If you get state conflicts
terraform state list
terraform state rm <conflicting-resource>
terraform import <new-resource-address> <resource-id>
```

#### 2. Variable Reference Errors
```bash
# Check variable names match module interfaces
terraform validate
```

#### 3. Network Connectivity Issues
```bash
# Verify vCenter connectivity
./check-domain.sh
```

### Rollback Plan
If migration fails:
```bash
# Restore from backup
cd /home/partha/terraform/k8s-cluster-c500-prod
rm -rf .terraform terraform.tfstate*
cp -r ../k8s-cluster-c500-prod-backup/* .
terraform init
```

## ✅ Validation Steps

After migration, verify everything works:

```bash
# 1. Terraform validation
terraform validate

# 2. Plan check
terraform plan

# 3. VM connectivity
./scripts/validate_vm_config.sh

# 4. SSH access test
ssh partha@192.168.10.141

# 5. Domain resolution test
nslookup k8s-master-1.dellpc.in
```

## 📈 Benefits of Migration

### Modularity
- Reusable components across environments
- Easier maintenance and updates
- Clear separation of concerns

### Environment Management
- Easy environment-specific configurations
- Reduced configuration drift
- Better testing isolation

### Reliability
- VMware customization more reliable than cloud-init
- Better error handling and validation
- Automated post-deployment configuration

### Scalability
- Easy to add new environments
- Module reusability across projects
- Better team collaboration

## 🎯 Next Steps After Migration

1. **Test thoroughly** in your target environment
2. **Update CI/CD pipelines** to use new structure
3. **Train team members** on new workflow
4. **Set up remote state** management
5. **Implement** automated testing
6. **Archive** legacy configuration files

---

**💡 Need Help?**
- Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues
- Review [README-MODULAR.md](README-MODULAR.md) for usage examples
- Test in `dev` environment first before migrating production
