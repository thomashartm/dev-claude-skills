---
name: github-actions
description: Manage GitHub Actions workflows. Use when the user wants to list workflows, view run history, check running workflows, trigger workflow_dispatch, view logs, or cancel runs. Auto-detects repository from git remote. Triggers on phrases like "list workflows", "workflow runs", "trigger workflow", "start deploy", "github actions", "view logs", "cancel run", "running workflows".
---

# GitHub Actions Management

Manage GitHub Actions workflows: list workflows, view runs, trigger dispatches, view logs, and cancel runs.

## Prerequisites

Requires authenticated `gh` CLI and `jq`. Use the unified `gh-actions-tool` script for all operations.

## Quick Reference

```bash
gh-actions-tool auth                         # Verify auth & show detected repo
gh-actions-tool list                         # List all workflows
gh-actions-tool details <workflow>           # Show workflow details & inputs
gh-actions-tool runs [workflow]              # Show recent runs
gh-actions-tool running                      # Show in-progress runs
gh-actions-tool start <workflow> [opts]      # Trigger workflow_dispatch
gh-actions-tool logs <run-id> [--job name]   # View run logs
gh-actions-tool cancel <run-id>              # Cancel a run
```

## Workflow

### 1. Confirm Repository Context (REQUIRED - First Command)

Before running any command, you MUST confirm the repository with the user:

```bash
gh-actions-tool auth
```

This shows the detected repository. **Ask the user to confirm** this is the correct repository before proceeding. Example:

> "I detected the repository as `owner/repo`. Is this correct, or would you like me to use a different repository?"

Once confirmed, you do not need to ask again for the session.

**If authentication fails**, tell user to run:
```bash
gh auth login
```

**If targeting a different repository**, use `--repo owner/repo` on all commands.

### 2. Operations

**List workflows:**
```bash
gh-actions-tool list
```

**View workflow details** (shows triggers, inputs, jobs):
```bash
gh-actions-tool details "CI Build"
gh-actions-tool details deploy.yml
```

**View run history:**
```bash
gh-actions-tool runs                    # All runs
gh-actions-tool runs "Deploy"           # Filter by workflow
gh-actions-tool runs --limit 20         # More results
```

**Check running workflows:**
```bash
gh-actions-tool running
```

**Trigger a workflow:**

Before triggering, ask the user their preference:
> "Would you like to provide inputs via command-line flags (`--input KEY=VALUE`) or use interactive mode where I'll prompt you for each input?"

Flag mode:
```bash
gh-actions-tool start "Deploy" --ref main
gh-actions-tool start "Deploy" --input environment=prod --input version=1.2.3
```

Interactive mode:
```bash
gh-actions-tool start "Deploy" --interactive
```

**View logs:**
```bash
gh-actions-tool logs 12345678                    # All logs
gh-actions-tool logs 12345678 --list-jobs        # List available jobs first
gh-actions-tool logs 12345678 --job "build"      # Specific job only
```

When viewing logs, first run with `--list-jobs` to show available jobs, then ask the user if they want all logs or a specific job.

**Cancel a run:**
```bash
gh-actions-tool cancel 12345678
```

## Error Handling

| Error | User Action |
|-------|-------------|
| Not authenticated | `gh auth login` |
| Repository not detected | Use `--repo owner/repo` or cd to a git repo |
| Workflow not found | Check workflow name with `gh-actions-tool list` |
| No workflow_dispatch | Workflow doesn't support manual triggers |
| Permission denied | Need write access to trigger/cancel |

## Run Statuses

| Status | Icon | Description |
|--------|------|-------------|
| success | ✅ | Completed successfully |
| failure | ❌ | Failed |
| in_progress | 🔄 | Currently running |
| queued | ⏳ | Waiting to run |
| cancelled | 🚫 | Manually cancelled |
| skipped | ⏭️ | Skipped (condition not met) |
| timed_out | ⏱️ | Exceeded time limit |

## Important Notes

- Always confirm the repository on first use in a session
- For `start` command: Ask user preference for input method (flags vs interactive)
- For `logs` command: List jobs first, then ask which job's logs to show
- Use `--repo owner/repo` to override auto-detected repository
