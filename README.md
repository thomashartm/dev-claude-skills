# Claude Code Skills

A collection of useful Claude Code skills for daily development and ops work.

## Available Skills

| Skill | Description |
|-------|-------------|
| [gcp-cloudbuild](./skills/gcp-cloudbuild) | Manage Google Cloud Build triggers, view build history, and start builds |
| [github-actions](./skills/github-actions) | Manage GitHub Actions workflows, view runs, trigger dispatches, and view logs |
| [install-python-agents](./skills/install-python-agents) | Install Python Clean Architecture agents (architect, domain-modeler, implementer, test-engineer, code-reviewer) into a project |
| [list-plans](./skills/list-plans) | List Claude Code plan files with titles, purposes, and progress |

## Installation

Use the `install-to-claude` script to install skills to `~/.claude/skills/`:

```bash
# Interactive mode - select from menu
./install-to-claude

# Install all skills
./install-to-claude --all

# Install a specific skill
./install-to-claude list-plans

# Preview what would be installed
./install-to-claude --dry-run --all

# List available skills
./install-to-claude --list

# Uninstall a skill
./install-to-claude --uninstall list-plans

# Clean up old backup directories
./install-to-claude --cleanup
```

## Skill Structure

Each skill directory contains:
- `SKILL.md` - Skill definition with YAML frontmatter (name, description) and instructions for Claude
- Executable scripts/tools used by the skill

Skills are installed to: `~/.claude/skills/`
