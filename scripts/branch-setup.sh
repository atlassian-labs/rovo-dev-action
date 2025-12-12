#!/bin/bash
# Setup a new branch for Rovo Dev changes
# This script creates a unique branch for PR creation

set -e

ENTITY_TYPE="${1:-automation}"
ENTITY_NUMBER="${2:-0}"
BASE_BRANCH="${3:-main}"
BRANCH_PREFIX="${4:-rovodev/}"

# Create timestamp for unique branch name
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")

# Create branch name
BRANCH_NAME="${BRANCH_PREFIX}${ENTITY_TYPE}-${ENTITY_NUMBER}-${TIMESTAMP}"

echo "Setting up branch: $BRANCH_NAME"

# Configure git for CI environment
git config --global --add safe.directory "$PWD"

# Configure git to use HTTPS with token if GH_TOKEN is available
if [ -n "$GH_TOKEN" ]; then
  echo "Configuring git to use HTTPS with token authentication..."
  # Extract repo info and set remote to HTTPS directly
  REMOTE_URL=$(git remote get-url origin)
  if [[ "$REMOTE_URL" == git@github.com:* ]]; then
    # Convert git@github.com:owner/repo.git to https://x-access-token:TOKEN@github.com/owner/repo.git
    REPO_PATH="${REMOTE_URL#git@github.com:}"
    NEW_URL="https://x-access-token:${GH_TOKEN}@github.com/${REPO_PATH}"
    echo "Updating remote URL from SSH to HTTPS..."
    git remote set-url origin "$NEW_URL"
  elif [[ "$REMOTE_URL" == https://github.com/* ]]; then
    # Convert https://github.com/owner/repo.git to https://x-access-token:TOKEN@github.com/owner/repo.git
    REPO_PATH="${REMOTE_URL#https://github.com/}"
    NEW_URL="https://x-access-token:${GH_TOKEN}@github.com/${REPO_PATH}"
    echo "Updating remote URL with token..."
    git remote set-url origin "$NEW_URL"
  fi
else
  echo "Warning: GH_TOKEN is not set. Git authentication may fail."
fi

# Debug: Show remote URL (masked)
echo "Remote URL configured (token masked): $(git remote get-url origin | sed 's/x-access-token:[^@]*@/x-access-token:***@/')"

# Fetch the base branch
git fetch origin "$BASE_BRANCH" --depth=1

# Create and checkout new branch from base
git checkout -b "$BRANCH_NAME" "origin/$BASE_BRANCH"

echo "Successfully created branch: $BRANCH_NAME"
echo "branch_name=$BRANCH_NAME" >> "$GITHUB_OUTPUT"
echo "base_branch=$BASE_BRANCH" >> "$GITHUB_OUTPUT"
