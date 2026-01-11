# Claude Code Skills & Commands

A collection of useful Claude Code skills and commands for daily development and ops work.

## Directory Structure

```
claude-skills/
├── install-to-claude         # Installer script
├── commands/                  # Claude Code commands
│   └── list-plans/           # /list-plans command
└── skills/                   # Claude Code skills
    ├── gcp-cloudbuild/       # GCP Cloud Build management
    └── github-actions/       # GitHub Actions management
```

## Available Skills

| Skill | Description |
|-------|-------------|
| [gcp-cloudbuild](./skills/gcp-cloudbuild) | Manage Google Cloud Build triggers, view build history, and start builds |
| [github-actions](./skills/github-actions) | Manage GitHub Actions workflows, view runs, trigger dispatches, and view logs |

## Available Commands

| Command | Description |
|---------|-------------|
| [list-plans](./commands/list-plans) | List Claude Code plan files with titles, purposes, and progress |

## Installation

Use the `install-to-claude` script to install skills and commands to `~/.claude/`:

```bash
# Interactive mode - select from menu
./install-to-claude

# Install everything
./install-to-claude --all

# Install only skills
./install-to-claude --skills

# Install only commands
./install-to-claude --commands

# Install a specific item
./install-to-claude github-actions
./install-to-claude list-plans

# Preview what would be installed
./install-to-claude --dry-run --all

# List available items
./install-to-claude --list

# Uninstall an item
./install-to-claude --uninstall list-plans
```

## Structure

### Skills

Skills are domain expertise modules that Claude uses to handle specialized tasks. Each skill contains:
- `SKILL.md` - Skill definition with YAML frontmatter (name, description) and instructions
- Executable scripts/tools used by the skill

Skills are installed to: `~/.claude/skills/`

### Commands

Commands are slash commands that users can invoke directly. Each command contains:
- `COMMAND.md` - Command definition with YAML frontmatter (name, description) and usage docs
- Executable scripts/tools used by the command

Commands are installed to: `~/.claude/commands/`
