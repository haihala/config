#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
exec "$script_dir/bin/md-convert" "$script_dir/summer-trainee-task.md"
