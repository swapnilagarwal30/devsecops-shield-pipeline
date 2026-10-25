#!/usr/bin/env bash
# ==============================================================================
# Script: drift-detector.sh
# Purpose: Detects unauthorized out-of-band infrastructure changes (Console Drift)
# Exit Codes:
#   0: No drift detected (Desired state matches live Azure state)
#   1: Error executing plan
#   2: Drift detected! (Infrastructure has drifted from git code)
# ==============================================================================

set -uo pipefail

WORKLOAD_DIR="${1:-sample-workload}"
ALERT_WEBHOOK="${ALERT_WEBHOOK_URL:-}"

echo "=================================================="
echo "🔍 Starting Automated Infrastructure Drift Audit"
echo "📂 Target Directory: ${WORKLOAD_DIR}"
echo "=================================================="

cd "${WORKLOAD_DIR}" || exit 1

terraform init -input=false > /dev/null 2>&1

echo "Executing: terraform plan -detailed-exitcode..."
set +e
terraform plan -detailed-exitcode -no-color > /tmp/tf_drift_plan.log 2>&1
EXIT_CODE=$?
set -e

if [ ${EXIT_CODE} -eq 0 ]; then
  echo "✅ SUCCESS: Infrastructure is in 100% sync with Git repository. No drift detected."
  exit 0
elif [ ${EXIT_CODE} -eq 2 ]; then
  echo "⚠️ WARNING: DRIFT DETECTED! Manual changes were made outside Terraform!"
  cat /tmp/tf_drift_plan.log | grep -E "([~+-])" | head -n 30

  if [ -n "${ALERT_WEBHOOK}" ]; then
    echo "Sending alert notification to SRE Action Group..."
    curl -s -X POST -H 'Content-Type: application/json' \
      -d '{"text": "🚨 CRITICAL: Terraform Drift Detected in Production Environment!"}' \
      "${ALERT_WEBHOOK}" > /dev/null || true
  fi
  exit 2
else
  echo "❌ ERROR: Terraform plan execution failed."
  cat /tmp/tf_drift_plan.log
  exit 1
fi
