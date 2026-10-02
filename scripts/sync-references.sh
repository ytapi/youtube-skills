#!/usr/bin/env bash
# Each skill is installed on its own, so each carries a copy of the shared
# reference files. Edit shared/, then run this.
set -euo pipefail
cd "$(dirname "$0")/.."
for dir in skills/*/; do
  mkdir -p "${dir}references"
  cp shared/auth-setup.md "${dir}references/auth-setup.md"
done
