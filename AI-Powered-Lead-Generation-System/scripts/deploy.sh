#!/usr/bin/env bash
# Deploys the AI Powered Lead Generation System to a Salesforce Developer Org.
# Prerequisite: Salesforce CLI (sf) installed -> https://developer.salesforce.com/tools/salesforcecli
set -euo pipefail

ALIAS="${1:-leadgen}"

echo ">> Logging in to your Developer Org (alias: $ALIAS)"
sf org login web --alias "$ALIAS"

echo ">> Deploying metadata (fields, validation rule, flow, app, permission set)"
sf project deploy start --source-dir force-app --target-org "$ALIAS"

echo ">> Assigning the permission set to the logged-in user"
sf org assign permset --name AI_Lead_Gen_Access --target-org "$ALIAS"

echo ">> Importing sample leads"
sf data import bulk --sobject Lead --file data/sample_leads_valid.csv --wait 10 --target-org "$ALIAS"

echo ">> Done. Now follow docs/manual_setup_steps.md for Einstein, Prompt Builder and the Lightning page."
