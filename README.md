# Terraform vCenter Ubuntu 22 VMs

This project uses Terraform to create three Ubuntu 22.04 virtual machines (VMs) in a vCenter environment. Each VM has static IP configuration and cloud-init customization.

## Project Structure

```
k8s-cluster-c500-prod/
├── main.tf            # Main configuration for creating VMs
├── variables.tf       # Input variables for the configuration
├── outputs.tf         # Outputs of the Terraform configuration
├── provider.tf        # vCenter provider configuration
├── data.tf           # Data sources for vCenter resources
├── versions.tf        # Required Terraform and provider versions
├── terraform.tfvars   # Variable values (vCenter credentials)
├── template/
│   └── cloud_init.tpl # Cloud-Init template for VM customization
└── README.md          # Project documentation
```

## Configuration

### VM Specifications
- **Template**: `templates/ubuntu22` (Ubuntu 22.04 cloud-init OVA)
- **Network**: `VM Network`
- **IP Addresses**: 
  - VM1: 192.168.10.141
  - VM2: 192.168.10.142
  - VM3: 192.168.10.145
- **Gateway**: 192.168.10.1
- **DNS**: 192.168.10.1, 8.8.8.8

### User Configuration
- **User**: partha (with sudo privileges)
- **Password**: Kukapilla@1269
- **Default ubuntu user**: SSH key authentication enabled (if SSH key provided)

## Prerequisites

- Terraform installed on your local machine.
- Access to a vCenter server with appropriate permissions to create VMs.
- An existing Ubuntu template in vCenter that will be used for creating the VMs.

## Setup Instructions

1. **Clone the Repository**: 
   Clone this repository to your local machine.

   ```bash
   git clone <repository-url>
   cd terraform-vcenter-3vms
   ```

2. **Configure Variables**: 
   Open the `variables.tf` file and set the necessary variables such as VM names, template name, and network settings.

3. **Initialize Terraform**: 
   Run the following command to initialize the Terraform configuration. This will download the necessary provider plugins.

   ```bash
   terraform init
   ```

4. **Plan the Deployment**: 
   Generate an execution plan to see what resources will be created.

   ```bash
   terraform plan
   ```

5. **Apply the Configuration**: 
   Apply the Terraform configuration to create the VMs.

   ```bash
   terraform apply
   ```

   Confirm the action when prompted.

6. **View Outputs**: 
   After the deployment is complete, you can view the outputs defined in `outputs.tf` to see the details of the created VMs.

## Cleanup

To remove the created VMs and clean up resources, run:

```bash
terraform destroy
```

## License

This project is licensed under the MIT License. See the LICENSE file for details.