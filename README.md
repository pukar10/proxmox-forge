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

## To Do

- [x] ssh keys + password working
- [ ] Configure a second disk for rook-ceph to take over on each VM
- [ ] Make the variables.tf more robust

## Deployment

1. Copy `terraform.tfvars.example` to `terraform.tfvars` and fill it out.
2. `terraform fmt -recursive` - ensure everthing is formated correctly.
3. `terraform plan` - inspect for errors before applying
4. `terraform apply` - build infrastructure

Destroy all VMs
`terraform apply -var='vms={}' -auto-approve`