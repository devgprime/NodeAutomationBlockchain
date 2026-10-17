#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
terraform init
terraform apply "$@"
printf 'Terraform apply completed successfully.\n'
