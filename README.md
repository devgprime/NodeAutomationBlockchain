# Azure VM and container provisioning experiment

Historical Terraform configuration for an Azure VM, networking and remote container setup. Existing resource names, SSH-key paths and provisioner settings are environment-specific; review them before deployment.

## Workflow

With Terraform, Azure credentials and the referenced Azure resources configured:

```bash
bash terraform/apply.sh
# After reviewing the destroy plan and confirming resource ownership:
bash terraform/destroy.sh
```

Both scripts resolve their own directory, initialize Terraform and preserve Terraform's interactive approval. Additional Terraform arguments are passed through unchanged. A failed command stops the script and does not print a success message. The destroy script runs `terraform destroy`, not apply.

No cloud deployment was performed as part of repository maintenance. The configuration needs provider/version validation before reuse; a clean-machine installation script is not included.

## Offline regression checks

```bash
python3 -m unittest discover -s tests -v
```

Tests use a fake Terraform executable to verify command selection, working-directory handling, argument forwarding and failure propagation. They never contact Azure.
