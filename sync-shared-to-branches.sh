#!/bin/bash

# Define your architecture-specific branches
BRANCHES=("arm" "amd")

# Define folders that are architecture-specific and should NOT be synced
EXCLUDE_DIRS=(".devcontainer" ".github/workflows")

# Make sure we're on the main branch first
git checkout main
git pull origin main

# Loop over each arch-specific branch
for BRANCH in "${BRANCHES[@]}"; do
  echo "🔁 Syncing shared files to $BRANCH branch..."

  # Checkout the branch
  git checkout "$BRANCH"
  git pull origin "$BRANCH"

  # Merge from main branch, but exclude architecture-specific folders
  git checkout main -- .

  # Remove the excluded directories from the staged changes
  for DIR in "${EXCLUDE_DIRS[@]}"; do
    git restore --staged "$DIR" 2>/dev/null
    git checkout "$BRANCH" -- "$DIR" 2>/dev/null
  done

  # Commit and push changes
  git commit -m "Sync shared files from main" || echo "✅ No shared file changes for $BRANCH"
  git push origin "$BRANCH"
done

# Return to main branch
git checkout main

echo "✅ Sync complete."
