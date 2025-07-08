# Environment Configuration Guide

This document provides detailed information about each environment configuration and their intended use cases.

## 🌍 Environment Overview

| Environment | Purpose | VM Count | Resources | Domain | IP Range |
|------------|---------|----------|-----------|---------|----------|
| **Production** | Live workloads | 3 VMs | 4 CPU, 8GB RAM | `dellpc.in` | `192.168.1.141-145` |
| **Development** | Testing & dev | 2 VMs | 2 CPU, 4GB RAM | `dev.dellpc.in` | `192.168.1.151-152` |
| **Staging** | Pre-production | 2 VMs | 2 CPU, 4GB RAM | `staging.dellpc.in` | `192.168.1.151-152` |

## 🏭 Production Environment

**Location**: `environments/prod/`

### Configuration
```hcl
# VM Configuration
vm_count = 3
vm_name_prefix = "k8s"
vm_cpus = 4
vm_memory = 8192  # 8GB
vm_disk_size = 60 # 60GB

# Network Configuration
domain_name = "dellpc.in"
vm_ips = [
  "192.168.1.141",  # k8s-master-1
  "192.168.1.142",  # k8s-worker-1  
  "192.168.1.145"   # k8s-worker-2
]
```

### Use Cases
- Production Kubernetes clusters
- Live applications and services
- Customer-facing workloads
- Critical business applications

### VM Roles
- **k8s-1**: Kubernetes master node
- **k8s-2**: Kubernetes worker node 1
- **k8s-3**: Kubernetes worker node 2

### Security Considerations
- Production-grade security policies
- Regular security updates
- Monitoring and alerting enabled
- Backup and disaster recovery

## 🔬 Development Environment

**Location**: `environments/dev/`

### Configuration
```hcl
# VM Configuration
vm_count = 2
vm_name_prefix = "dev-k8s"
vm_cpus = 2
vm_memory = 4096  # 4GB
vm_disk_size = 40 # 40GB

# Network Configuration
domain_name = "dev.dellpc.in"
vm_ips = [
  "192.168.1.151",  # dev-k8s-1
  "192.168.1.152"   # dev-k8s-2
]
```

### Use Cases
- Feature development and testing
- Experimental configurations
- Learning and training
- Breaking changes testing

### VM Roles
- **dev-k8s-1**: Development master/worker
- **dev-k8s-2**: Development worker

### Development Features
- Relaxed security policies for debugging
- Easy VM recreation/destruction
- Snapshot capabilities for quick rollbacks
- Direct access for troubleshooting

## 🎭 Staging Environment

**Location**: `environments/staging/`

### Configuration
```hcl
# VM Configuration
vm_count = 2
vm_name_prefix = "staging-k8s"
vm_cpus = 2
vm_memory = 4096  # 4GB
vm_disk_size = 40 # 40GB

# Network Configuration
domain_name = "staging.dellpc.in"
vm_ips = [
  "192.168.1.151",  # staging-k8s-1
  "192.168.1.152"   # staging-k8s-2
]
```

### Use Cases
- Pre-production testing
- User acceptance testing (UAT)
- Performance testing
- Release candidate validation

### VM Roles
- **staging-k8s-1**: Staging master/worker
- **staging-k8s-2**: Staging worker

### Staging Features
- Production-like configuration
- Performance monitoring
- Load testing capabilities
- Integration testing

## 🔧 Environment-Specific Variables

### Production Variables
```hcl
# High-performance configuration
vm_cpus = 4
vm_memory = 8192
vm_disk_size = 60

# Production network settings
gateway = "192.168.1.1"
dns_servers = ["192.168.1.225", "8.8.4.4"]

# Production security
vm_folder = "production"
```

### Development Variables
```hcl
# Resource-efficient configuration
vm_cpus = 2
vm_memory = 4096
vm_disk_size = 40

# Development network settings
gateway = "192.168.1.1"
dns_servers = ["192.168.1.225", "8.8.4.4"]

# Development settings
vm_folder = "development"
```

### Staging Variables
```hcl
# Production-like but smaller
vm_cpus = 2
vm_memory = 4096
vm_disk_size = 40

# Staging network settings
gateway = "192.168.1.1"
dns_servers = ["192.168.1.225", "8.8.4.4"]

# Staging settings
vm_folder = "staging"
```

## 🚀 Deployment Workflows

### Development Workflow
```bash
cd environments/dev
terraform plan    # Review changes
terraform apply   # Deploy to dev
# Test features
terraform destroy # Clean up when done
```

### Staging Workflow
```bash
cd environments/staging
terraform plan    # Review changes
terraform apply   # Deploy to staging
# Run UAT and performance tests
# Keep running for extended testing
```

### Production Workflow
```bash
cd environments/prod
terraform plan    # Careful review
terraform apply   # Deploy to production
# Monitor and validate
# Never destroy without backup
```

## 🔄 Environment Promotion

### Code Promotion Path
```
Developer → Development → Staging → Production
```

### Configuration Validation
1. **Development**: Feature validation
2. **Staging**: Integration and performance testing
3. **Production**: Live deployment

### Checklist for Promotion
- [ ] All tests pass in current environment
- [ ] Performance benchmarks met
- [ ] Security scan completed
- [ ] Documentation updated
- [ ] Rollback plan prepared

## 📊 Resource Allocation

### Production Resources
- **Total CPUs**: 12 (4 × 3 VMs)
- **Total Memory**: 24GB (8GB × 3 VMs)
- **Total Storage**: 180GB (60GB × 3 VMs)

### Development Resources
- **Total CPUs**: 4 (2 × 2 VMs)
- **Total Memory**: 8GB (4GB × 2 VMs)
- **Total Storage**: 80GB (40GB × 2 VMs)

### Staging Resources
- **Total CPUs**: 4 (2 × 2 VMs)
- **Total Memory**: 8GB (4GB × 2 VMs)
- **Total Storage**: 80GB (40GB × 2 VMs)

## 🔒 Security Configurations

### Production Security
- SELinux disabled for development workloads
- Firewalld disabled for simplified networking
- SSH key authentication
- Regular security updates
- Audit logging enabled

### Development Security
- Relaxed security for debugging
- Root access available
- Development tools installed
- Debug logging enabled

### Staging Security
- Production-like security
- Limited access
- Testing-specific configurations
- Performance monitoring

## 📈 Scaling Considerations

### Horizontal Scaling
Add more VMs by increasing `vm_count` and adding IP addresses:

```hcl
vm_count = 4
vm_ips = [
  "192.168.10.141",
  "192.168.10.142", 
  "192.168.10.145",
  "192.168.10.146"  # New VM
]
```

### Vertical Scaling
Increase resources per VM:

```hcl
vm_cpus = 6      # Increase from 4
vm_memory = 16384 # Increase from 8192
vm_disk_size = 100 # Increase from 60
```

## 🎯 Best Practices

### Environment Isolation
- Use separate IP ranges
- Different domain names
- Isolated VM folders
- Separate resource pools

### Resource Management
- Right-size resources for use case
- Monitor resource utilization
- Plan for growth
- Regular cleanup of unused resources

### Configuration Management
- Keep environment configs in sync
- Use variables for differences
- Document all customizations
- Version control all changes

---

**📝 Notes:**
- All environments use the same modules for consistency
- Only variables change between environments
- This ensures testing in dev/staging reflects production
- Resource requirements can be adjusted based on workload needs
