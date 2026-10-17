#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
terraform init
terraform destroy "$@"
printf 'Terraform destroy completed successfully.\n'
