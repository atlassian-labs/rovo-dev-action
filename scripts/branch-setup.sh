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

# Fetch the base branch
git fetch origin "$BASE_BRANCH" --depth=1

# Create and checkout new branch from base
git checkout -b "$BRANCH_NAME" "origin/$BASE_BRANCH"

echo "Successfully created branch: $BRANCH_NAME"
echo "branch_name=$BRANCH_NAME" >> "$GITHUB_OUTPUT"
echo "base_branch=$BASE_BRANCH" >> "$GITHUB_OUTPUT"
