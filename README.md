# proxmox-deploy
Declarative Terraform repository to deploy Proxmox VMs for my homelab
Provision Proxmox VMs with Cloud‑Init via the bpg/proxmox providers.

## Getting started

Edit the variables in terraform.tfvars to get the project working.

### Project Structure

* `main.tf` - starting point/logic
* `variables.tf` - initializes variables
* `terraform.tfvars` - defines variables (prompts for any not defined)
* `providers.tf` - defines plugins/modules and version restrictions
* `outputs.tf` - defines output variables which can be passed to other modules
* `terraform.tfstate` - terraforms local cache of your infrastructure's current state

### Useful commands

* `terraform fmt -recursive` - terraform enforces special formatting, this will format all your files recursively
* `terraform plan` - shows a plan of what terraform will create/modify/destroy. Refreshes your state and checks against desired state.
* `terraform apply` - applies the above plan/your desired state

## To Do

- [x] ssh keys + password working
- [ ] Configure a second disk for rook-ceph to take over on each VM
