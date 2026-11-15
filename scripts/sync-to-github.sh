#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="/Users/nitroi/.gemini/config/plugins/agentic-dev"
COMMIT_MSG="${1:-chore: update agentic development skills and rules}"

cd "$PLUGIN_DIR"

if [ -z "$(git status --porcelain)" ]; then
  echo "No changes to sync in $PLUGIN_DIR."
  exit 0
fi

git add -A
git commit -m "$COMMIT_MSG"
git push origin main
echo "Successfully synced agentic-dev skills and rules to GitHub!"
