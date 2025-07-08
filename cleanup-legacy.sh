#!/bin/bash

# Cleanup Script: Remove Old Non-Modular Terraform Files
# This script removes the legacy monolithic Terraform configuration
# after successful migration to modular structure

set -e

echo "=========================================="
echo "🧹 Terraform Modular Migration Cleanup"
echo "=========================================="
echo

# Check if we're in the right directory
if [ ! -d "environments" ] || [ ! -d "modules" ]; then
    echo "❌ Error: This doesn't appear to be the correct directory."
    echo "   Please run this script from the terraform project root."
    exit 1
fi

# Check if staging environment was successfully deployed
if [ ! -f "environments/staging/terraform.tfstate" ]; then
    echo "⚠️  Warning: Staging environment doesn't appear to be deployed."
    echo "   Are you sure you want to proceed with cleanup?"
    read -p "   Continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Cleanup cancelled."
        exit 1
    fi
fi

echo "🔍 Files to be removed (old non-modular structure):"
echo "=================================================="

# List files that will be removed
OLD_FILES=(
    "main.tf"
    "variables.tf" 
    "outputs.tf"
    "data.tf"
    "provider.tf"
    "versions.tf"
    "terraform.tfvars"
    "terraform.tfstate"
    "terraform.tfstate.backup"
    "original.plan"
    ".terraform"
    ".terraform.lock.hcl"
)

for file in "${OLD_FILES[@]}"; do
    if [ -e "$file" ]; then
        echo "   📄 $file"
    fi
done

echo
echo "🛡️  Files/directories to be preserved:"
echo "======================================"
echo "   📁 environments/"
echo "   📁 modules/"
echo "   📁 scripts/"
echo "   📁 packer/"
echo "   📁 template/"
echo "   📄 README-MODULAR.md"
echo "   📄 MIGRATION.md"
echo "   📄 ENVIRONMENTS.md"
echo "   📄 VM_CONFIGURATION.md"
echo "   📄 DOMAIN_SETUP.md"
echo "   📄 TROUBLESHOOTING.md"
echo "   📄 check-project-status.sh"
echo

# Confirm deletion
echo "⚠️  This will permanently delete the old non-modular Terraform files."
echo "   The modular structure in environments/ and modules/ will be preserved."
echo
read -p "🤔 Are you sure you want to proceed? (y/N): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cleanup cancelled. No files were removed."
    exit 0
fi

echo
echo "🗑️  Removing old non-modular files..."
echo "===================================="

# Create a backup directory first
BACKUP_DIR="legacy-backup-$(date +%Y%m%d-%H%M%S)"
echo "📦 Creating backup in $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"

# Move files to backup instead of deleting
for file in "${OLD_FILES[@]}"; do
    if [ -e "$file" ]; then
        echo "   🔄 Backing up $file..."
        mv "$file" "$BACKUP_DIR/"
    fi
done

echo
echo "✅ Cleanup completed successfully!"
echo "================================="
echo
echo "📊 Summary:"
echo "• Old files backed up to: $BACKUP_DIR/"
echo "• Modular structure preserved in environments/ and modules/"
echo "• Documentation files preserved"
echo "• Scripts and templates preserved"
echo
echo "🚀 Your modular Terraform infrastructure is now clean and ready!"
echo
echo "🎯 Next steps:"
echo "1. Test dev and prod environments: cd environments/dev && terraform init"
echo "2. Update CI/CD pipelines to use modular structure"
echo "3. Remove backup directory after confirming everything works"
echo
echo "📖 For usage guidance, see: README-MODULAR.md"
