#!/bin/bash

# Project Status Summary Script
# This script provides an overview of the modular Terraform infrastructure

# Commented out set -e to avoid early exit on validation errors
# set -e

echo "=========================================="
echo "🏗️  Modular Terraform Infrastructure Status"
echo "=========================================="
echo

# Function to check if directory exists and has files
check_environment() {
    local env_name=$1
    local env_path=$2
    
    echo "📁 $env_name Environment ($env_path)"
    if [ -d "$env_path" ]; then
        echo "   ✅ Directory exists"
        
        # Check for required files
        local files=("main.tf" "variables.tf" "outputs.tf" "terraform.tfvars")
        for file in "${files[@]}"; do
            if [ -f "$env_path/$file" ]; then
                echo "   ✅ $file found"
            else
                echo "   ❌ $file missing"
            fi
        done
        
        # Check if initialized
        if [ -d "$env_path/.terraform" ]; then
            echo "   ✅ Terraform initialized"
        else
            echo "   ⚠️  Terraform not initialized"
        fi
        
    else
        echo "   ❌ Directory does not exist"
    fi
    echo
}

# Function to check module
check_module() {
    local module_name=$1
    local module_path=$2
    
    echo "🔧 $module_name Module ($module_path)"
    if [ -d "$module_path" ]; then
        echo "   ✅ Directory exists"
        
        # Check for required files
        local files=("main.tf" "variables.tf" "outputs.tf")
        for file in "${files[@]}"; do
            if [ -f "$module_path/$file" ]; then
                echo "   ✅ $file found"
            else
                echo "   ❌ $file missing"
            fi
        done
    else
        echo "   ❌ Directory does not exist"
    fi
    echo
}

# Check project structure
echo "🔍 Project Structure Check"
echo "----------------------------------------"

# Check environments
check_environment "Production" "environments/prod"
check_environment "Development" "environments/dev"  
check_environment "Staging" "environments/staging"

# Check modules
check_module "Compute" "modules/compute"
check_module "Network" "modules/network"
check_module "Storage" "modules/storage"

# Check scripts
echo "📜 Scripts Directory"
if [ -d "scripts" ]; then
    echo "   ✅ Directory exists"
    
    local scripts=("configure-vm.sh" "validate_vm_config.sh")
    for script in "${scripts[@]}"; do
        if [ -f "scripts/$script" ]; then
            echo "   ✅ $script found"
            if [ -x "scripts/$script" ]; then
                echo "      ✅ Executable"
            else
                echo "      ⚠️  Not executable"
            fi
        else
            echo "   ❌ $script missing"
        fi
    done
else
    echo "   ❌ Directory does not exist"
fi
echo

# Check documentation
echo "📚 Documentation"
echo "----------------------------------------"
local docs=("README-MODULAR.md" "MIGRATION.md" "ENVIRONMENTS.md" "VM_CONFIGURATION.md" "DOMAIN_SETUP.md" "TROUBLESHOOTING.md")
for doc in "${docs[@]}"; do
    if [ -f "$doc" ]; then
        echo "   ✅ $doc found"
    else
        echo "   ❌ $doc missing"
    fi
done
echo

# Check Terraform installation
echo "🛠️  Tool Verification"
echo "----------------------------------------"
if command -v terraform &> /dev/null; then
    echo "   ✅ Terraform installed: $(terraform version | head -n1)"
else
    echo "   ❌ Terraform not installed"
fi

if command -v sshpass &> /dev/null; then
    echo "   ✅ sshpass installed: $(sshpass -V 2>&1 | head -n1)"
else
    echo "   ❌ sshpass not installed"
fi
echo

# Environment readiness check
echo "🚀 Environment Readiness"
echo "----------------------------------------"

for env in "prod" "dev" "staging"; do
    env_path="environments/$env"
    echo "📊 $env Environment:"
    
    if [ -d "$env_path" ] && [ -f "$env_path/main.tf" ]; then
        echo "   ✅ Configuration ready"
        
        # Try to validate if initialized
        if [ -d "$env_path/.terraform" ]; then
            cd "$env_path"
            if terraform validate &> /dev/null; then
                echo "   ✅ Configuration valid"
            else
                echo "   ⚠️  Configuration has validation errors"
            fi
            cd - > /dev/null
        else
            echo "   ⚠️  Not initialized (run: cd $env_path && terraform init)"
        fi
    else
        echo "   ❌ Configuration incomplete"
    fi
    echo
done

# Usage examples
echo "📋 Quick Start Commands"
echo "----------------------------------------"
echo "🔧 Initialize an environment:"
echo "   cd environments/dev && terraform init"
echo
echo "🔍 Plan deployment:"
echo "   cd environments/dev && terraform plan"
echo
echo "🚀 Deploy infrastructure:"
echo "   cd environments/dev && terraform apply"
echo
echo "✅ Validate VM configuration:"
echo "   ./scripts/validate_vm_config.sh"
echo
echo "📖 Read documentation:"
echo "   cat README-MODULAR.md"
echo

# Migration status
echo "🔄 Migration Information"
echo "----------------------------------------"
if [ -f "main.tf" ] && [ -f "variables.tf" ]; then
    echo "   ⚠️  Legacy files still present in root directory"
    echo "   📖 See MIGRATION.md for migration guidance"
else
    echo "   ✅ Project fully migrated to modular structure"
fi
echo

echo "=========================================="
echo "✨ Modular Infrastructure Setup Complete!"
echo "=========================================="
echo
echo "🎯 Next Steps:"
echo "1. Choose your target environment (prod/dev/staging)"
echo "2. Navigate to environments/<env>/ directory"
echo "3. Run 'terraform init' to initialize"
echo "4. Run 'terraform plan' to review changes"
echo "5. Run 'terraform apply' to deploy"
echo
echo "📚 Documentation:"
echo "• README-MODULAR.md - Usage guide"
echo "• ENVIRONMENTS.md - Environment details"
echo "• MIGRATION.md - Migration from legacy"
echo "• TROUBLESHOOTING.md - Common issues"
echo
