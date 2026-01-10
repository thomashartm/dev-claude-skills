# Everyday development Claude Skills

A collection of useful Claude Code skills for daily development and ops work.

## Available Skills

| Skill | Description |
|-------|-------------|
| [gcp-cloudbuild](./gcp-cloudbuild) | Manage Google Cloud Build triggers, view build history, and start builds |
| [github-actions](./github-actions) | Manage GitHub Actions workflows, view runs, trigger dispatches, and view logs |

## Installation

Use the `sync-with-claude` script to install skills to `~/.claude/skills/`:

```bash
# Interactive mode - select skill(s) from menu
./sync-with-claude

# Install a specific skill
./sync-with-claude github-actions

# Install all skills
./sync-with-claude --all

# List available skills
./sync-with-claude --list
```

## Skill Structure

Each skill contains:
- `SKILL.md` - Skill definition with frontmatter (name, description) and instructions
- Executable scripts/tools used by the skill
