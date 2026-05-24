---
name: prepare-squash-merge
description: Use when a feature branch is ready to merge into master and a single summarizing commit message needs to be drafted, reviewed, and staged before the user commits.
---

# Prepare Squash Merge

## Overview

Read all commits since the branch diverged from master, draft a single summarizing commit message, iterate with the user until approved, then stage the squash and hand off two commands.

## Process

1. Find divergence point and list commits:
   ```bash
   git merge-base HEAD master
   git log <base>..HEAD --format="%h %s%n%b%-"
   ```

2. Draft a summary commit message. Check `git log master --oneline -5` for the repo's style.

3. Present draft in conversation — iterate until the user approves.

4. Stage the squash and overwrite the generated message:
   ```bash
   BRANCH=$(git branch --show-current)
   git checkout master
   git merge --squash "$BRANCH"
   # overwrite .git/SQUASH_MSG with the approved message
   ```

5. Tell the user:
   ```bash
   git diff --cached        # review the staged diff
   git commit               # commits using SQUASH_MSG
   ```

## Commit Message Format

- **Subject:** conventional prefix + what the feature is (not "various fixes")
- **Body:** 2–5 bullets covering what changed and why — enough to understand cold
- **Trailer:** `Co-Authored-By:` if applicable

## Notes

- Nothing is committed until the user runs `git commit` — the squash only stages
- If the user wants to back out after staging: `git reset HEAD` unstages cleanly
- Do not push to master