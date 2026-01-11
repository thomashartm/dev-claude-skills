---
name: gcp-cloudbuild
description: Manage Google Cloud Build jobs and triggers. Use when the user wants to list Cloud Build triggers/jobs, view trigger details and configurations, check build history, monitor running builds, or start new builds. Handles authentication verification and project context. Triggers on phrases like "list cloud build jobs", "show build triggers", "build history", "running builds", "start build", "deploy with cloud build", "cloudbuild status".
---

# GCP Cloud Build Management

Manage Cloud Build triggers, view build history, monitor running builds, and start new builds.

## Prerequisites

Requires authenticated `gcloud` CLI and `jq`. Use the unified `gcp-build-tool` script for all operations.

## Quick Reference

```bash
gcp-build-tool auth                    # Verify auth & show project
gcp-build-tool list                    # List all triggers
gcp-build-tool details <trigger>       # Show trigger configuration
gcp-build-tool history [trigger]       # Show build history
gcp-build-tool running                 # Show active builds
gcp-build-tool start <trigger> [opts]  # Start a build
```

## Workflow

### 1. Always Verify Authentication First

```bash
gcp-build-tool auth
```

**If authentication fails**, tell user to run:
```bash
gcloud auth login
gcloud config set project PROJECT_ID
```

**If targeting a different project**: User must authenticate to that project first. Tell user the command above.

### 2. Operations

**List triggers:**
```bash
gcp-build-tool list
```

**View trigger details** (name or ID):
```bash
gcp-build-tool details my-deploy-trigger
```

**View build history:**
```bash
gcp-build-tool history                     # All builds
gcp-build-tool history my-deploy-trigger   # Filter by trigger
```

**Check running builds:**
```bash
gcp-build-tool running
```

**Start a build:**
```bash
gcp-build-tool start my-trigger
gcp-build-tool start my-trigger --branch main
gcp-build-tool start my-trigger --sub _ENV=prod --sub _VERSION=1.2.3
gcp-build-tool start my-trigger --dry-run  # Preview only
```

## Error Handling

| Error | User Action |
|-------|-------------|
| Not authenticated | `gcloud auth login` |
| No project set | `gcloud config set project PROJECT_ID` |
| API not enabled | `gcloud services enable cloudbuild.googleapis.com` |
| Permission denied | Need `cloudbuild.builds.viewer` or `cloudbuild.builds.editor` role |

## Build Statuses

`SUCCESS` ✅ | `FAILURE` ❌ | `WORKING` 🔄 | `QUEUED` ⏳ | `TIMEOUT` ⏱️ | `CANCELLED` 🚫
