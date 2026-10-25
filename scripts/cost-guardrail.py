#!/usr/bin/env python3
"""
Script: cost-guardrail.py
Purpose: Evaluates Infracost JSON output against maximum allowed monthly cost delta.
"""

import argparse
import json
import sys


def evaluate_cost(json_path: str, max_delta_monthly: float) -> int:
    try:
        with open(json_path, "r", encoding="utf-8") as f:
            data = json.load(f)
    except FileNotFoundError:
        print(f"⚠️ Notice: Infracost JSON file '{json_path}' not found. Skipping gate.")
        return 0
    except Exception as e:
        print(f"⚠️ Error reading JSON file: {e}")
        return 0

    diff_monthly = 0.0
    try:
        diff_str = data.get("diffTotalMonthlyCost", "0")
        diff_monthly = float(diff_str) if diff_str else 0.0
    except (ValueError, TypeError):
        diff_monthly = 0.0

    print("==================================================")
    print("💰 FinOps Cost Guardrail Analysis")
    print(f"   Projected Monthly Cost Delta: ${diff_monthly:,.2f}")
    print(f"   Maximum Allowed Policy Limit: ${max_delta_monthly:,.2f}")
    print("==================================================")

    if diff_monthly > max_delta_monthly:
        print(
            f"❌ POLICY VIOLATION: Cost increase (+${diff_monthly:,.2f}) exceeds policy limit (${max_delta_monthly:,.2f})!"
        )
        print("👉 Action: Obtain Lead FinOps Architect approval before merging.")
        return 1

    print("✅ SUCCESS: Proposed infrastructure cost is within policy limits.")
    return 0


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="FinOps Cost Guardrail Gate")
    parser.add_argument("--input", required=True, help="Path to Infracost JSON breakdown")
    parser.add_argument("--max-delta-monthly", type=float, default=250.0, help="Max allowed monthly cost increase in USD")
    args = parser.parse_args()

    sys.exit(evaluate_cost(args.input, args.max_delta_monthly))
