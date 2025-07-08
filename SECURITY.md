# Security and Sensitive Files Guide

This document outlines the sensitive files in this Terraform project and security best practices.

## 🔒 Sensitive Files Protected by .gitignore

### **Critical - Never Commit These Files**

#### **Terraform State Files**
- `*.tfstate` - Contains complete infrastructure state including IPs, IDs, and metadata
- `*.tfstate.backup` - Backup of state files
- **Risk**: Exposes entire infrastructure layout, resource IDs, and potentially sensitive outputs

#### **Variable Files**
- `terraform.tfvars` - Contains vCenter credentials, VM passwords, SSH keys
- `*.auto.tfvars` - Auto-loaded variable files with sensitive configuration
- `*.tfvars.json` - JSON format variable files with sensitive data
- **Risk**: Exposes vCenter admin credentials, VM root passwords, API keys

#### **Plan Files**
- `*.tfplan` - Contains planned changes and may include sensitive values
- `*.plan` - Terraform execution plans
- **Risk**: May contain sensitive variable values in planned changes

#### **Terraform Cache**
- `.terraform/` - Local provider cache and module cache
- `.terraform.lock.hcl` - Provider version locks (optional to commit)
- **Risk**: May contain cached credentials or sensitive module data

### **Moderate to High Sensitivity**

#### **Log Files**
- `*.log` - Terraform and script execution logs
- `crash.log` - Terraform crash logs
- `cloud-init-*.log` - Cloud-init provisioning logs
- `provisioning-*.log` - VM provisioning logs
- **Risk**: May contain sensitive output or error messages with credentials

#### **SSH Keys and Certificates**
- `*.pem`, `*.key`, `*.pub` - SSH keys and certificates
- `id_rsa*` - SSH identity files
- **Risk**: Provides access to VMs and infrastructure

#### **Configuration and Credential Files**
- `vcenter_credentials.json` - vCenter authentication details
- `infraconfig.json` - Infrastructure configuration
- `config.json`, `secrets.json`, `credentials.json` - General configuration files
- `passwords.txt`, `secrets.txt` - Plain text sensitive data
- **Risk**: Direct access to infrastructure and services

#### **Script Outputs and Artifacts**
- `vm_passwords.txt` - Generated VM passwords
- `infrastructure_details.txt` - Infrastructure metadata
- `deployment_notes.txt` - Deployment-specific information
- `script_output.txt` - Script execution results
- `vm_details.txt` - VM configuration details
- `ip_mappings.txt` - Network configuration
- **Risk**: May contain passwords, IPs, or configuration details

#### **Environment Files**
- `.env`, `.env.local`, `.env.*.local` - Environment-specific variables
- **Risk**: May contain API keys, passwords, and configuration secrets

#### **Override Files**
- `override.tf`, `*_override.tf` - Local configuration overrides
- **Risk**: May contain sensitive local modifications

#### **Packer Artifacts**
- `*.pkrvars.hcl` - Packer variable files
- `packer_cache/` - Packer build cache
- `output-*/` - Packer build outputs
- `*.box`, `*.iso`, `*.vmdk` - Large build artifacts
- **Risk**: May contain build credentials and consume significant storage

### **Additional Sensitive Patterns**
- `*.secret`, `*.private` - Files explicitly marked as sensitive
- `*_secret.*`, `*_private.*` - Sensitive file variations
- `sensitive_*`, `confidential_*` - Confidential file patterns
- `ansible_vault_password` - Ansible vault credentials
- `kubeconfig`, `*.kubeconfig` - Kubernetes cluster access
- `prometheus.yml`, `grafana.ini` - Monitoring configuration

## 🛡️ Security Best Practices

### **1. Credential Management**
- **Never hardcode credentials** in `.tf` files
- Use **environment variables** for sensitive values:
  ```bash
  export TF_VAR_vcenter_password="your-password"
  export TF_VAR_vm_password="your-vm-password"
  ```
- Consider using **HashiCorp Vault** or **AWS Secrets Manager** for production

### **2. State File Security**
- **Never commit state files** to version control
- Use **remote state** (S3, Azure Storage, Terraform Cloud) with encryption
- Enable **state locking** to prevent concurrent modifications
- **Backup state files** securely and separately

### **3. Access Control**
- **Limit vCenter access** to necessary personnel only
- Use **service accounts** with minimal required permissions
- **Rotate passwords** regularly
- **Enable MFA** where possible

### **4. Network Security**
- **VPN/Private network** access for vCenter management
- **Firewall rules** to restrict access to infrastructure
- **Network segmentation** between environments

### **5. Version Control Security**
- **Review .gitignore** regularly to ensure all sensitive files are excluded
- **Scan commits** before pushing to detect accidentally committed secrets
- Use **git hooks** to prevent sensitive data commits
- **Never force push** over commits that might contain secrets

## 🔧 Setting Up Secure Terraform Workflow

### **1. Environment Variables Setup**
```bash
# Set these in your shell profile or CI/CD environment
export TF_VAR_vcenter_user="your-vcenter-user"
export TF_VAR_vcenter_password="your-secure-password"
export TF_VAR_vcenter_server="your-vcenter-server"
export TF_VAR_vm_user="vm-admin-user"
export TF_VAR_vm_password="secure-vm-password"
```

### **2. Remote State Configuration**
```hcl
terraform {
  backend "s3" {
    bucket = "your-terraform-state-bucket"
    key    = "environments/prod/terraform.tfstate"
    region = "us-west-2"
    encrypt = true
    dynamodb_table = "terraform-lock-table"
  }
}
```

### **3. Terraform Cloud/Enterprise**
- Use **Terraform Cloud** for managed state and secure variable storage
- **Workspace-level variables** for environment-specific configuration
- **API-driven workflows** for CI/CD integration

## ⚠️ What to Do If Sensitive Data Is Accidentally Committed

### **1. Immediate Actions**
1. **Revoke/rotate** any exposed credentials immediately
2. **Remove sensitive data** from git history using `git filter-branch` or BFG Repo-Cleaner
3. **Force push** the cleaned history (coordinate with team)
4. **Update .gitignore** to prevent future occurrences

### **2. Git History Cleanup**
```bash
# Remove a file from all git history
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch terraform.tfvars' \
  --prune-empty --tag-name-filter cat -- --all

# Force push to all remotes
git push origin --force --all
git push origin --force --tags
```

### **3. Credential Rotation**
- **vCenter passwords** - Change immediately in vCenter
- **VM passwords** - Update on all deployed VMs
- **SSH keys** - Generate new keys and update authorized_keys
- **API tokens** - Revoke and create new tokens

## 📋 Security Checklist

### **Before Each Commit**
- [ ] Review changed files for sensitive data
- [ ] Check that `.gitignore` is working correctly
- [ ] Verify no state files are being committed
- [ ] Ensure variable files are excluded

### **Before Each Deployment**
- [ ] Verify secure connection to vCenter
- [ ] Check that credentials are not hardcoded
- [ ] Confirm remote state backend is configured
- [ ] Validate network access controls

### **Regular Security Tasks**
- [ ] Rotate vCenter credentials monthly
- [ ] Update VM passwords quarterly
- [ ] Review access logs and audit trails
- [ ] Update .gitignore as project evolves
- [ ] Scan for exposed secrets in git history

## 🆘 Emergency Contacts

In case of security incidents:
1. **Infrastructure Team**: [Contact Info]
2. **Security Team**: [Contact Info]
3. **vCenter Admins**: [Contact Info]

---

**Remember**: Security is everyone's responsibility. When in doubt, ask before committing!
