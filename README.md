# Terraform vCenter 3 VMs

This project uses Terraform to create three virtual machines (VMs) in a vCenter environment using a specified Ubuntu template. Each VM will have one network interface card (NIC) and will be configured according to the provided specifications.

## Project Structure

```
terraform-vcenter-3vms
├── main.tf            # Main configuration for creating VMs
├── variables.tf       # Input variables for the configuration
├── outputs.tf         # Outputs of the Terraform configuration
├── provider.tf        # vCenter provider configuration
├── versions.tf        # Required Terraform and provider versions
├── template
│   └── cloud_init.tpl # Cloud-Init template for VM customization
└── README.md          # Project documentation
```

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