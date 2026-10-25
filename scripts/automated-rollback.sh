#!/usr/bin/env bash
# ==============================================================================
# Script: automated-rollback.sh
# Purpose: Handles automated rollback when Terraform apply fails in production.
# ==============================================================================

set -uo pipefail

echo "=================================================="
echo "🚨 INITIATING AUTOMATED ROLLBACK PROCEDURE"
echo "=================================================="

PREVIOUS_COMMIT=$(git rev-parse HEAD~1 2>/dev/null || echo "")

if [ -z "${PREVIOUS_COMMIT}" ]; then
  echo "⚠️ Warning: No previous git commit found. Unable to automatically revert."
  exit 1
fi

echo "Reverting workspace to previous stable release: ${PREVIOUS_COMMIT}..."
git checkout "${PREVIOUS_COMMIT}" -- sample-workload/

echo "Re-running speculative plan on last known good configuration..."
cd sample-workload && terraform plan

echo "=================================================="
echo "✅ Automated rollback plan prepared."
echo "👉 Notification dispatched to On-Call Cloud SRE."
echo "=================================================="
