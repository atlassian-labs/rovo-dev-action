#!/bin/bash
# Create a Pull Request with Rovo Dev changes
# This script commits any changes and creates a PR

set -e

BRANCH_NAME="$1"
BASE_BRANCH="$2"
PR_TITLE="$3"
PR_BODY="$4"

if [ -z "$BRANCH_NAME" ] || [ -z "$BASE_BRANCH" ]; then
  echo "::error::Missing required arguments: branch_name and base_branch"
  exit 1
fi

# Stage all changes
git add -A

# Check again after staging (for new files)
if git diff --staged --quiet; then
  echo "No changes to commit after staging. Skipping PR creation."
  echo "pr_created=false" >> "$GITHUB_OUTPUT"
  exit 0
fi

# Commit changes
git commit -m "${PR_TITLE:-Changes by Rovo Dev}"

# Push the branch
git push origin "$BRANCH_NAME"

# Create the PR using GitHub CLI
PR_URL=$(gh pr create \
  --title "${PR_TITLE:-Changes by Rovo Dev}" \
  --body "${PR_BODY:-Automated changes by Rovo Dev}" \
  --base "$BASE_BRANCH" \
  --head "$BRANCH_NAME")

echo "Successfully created PR: $PR_URL"
echo "pr_created=true" >> "$GITHUB_OUTPUT"
echo "pr_url=$PR_URL" >> "$GITHUB_OUTPUT"
