---
name: install-python-agents
description: Install Python Clean Architecture development agents into a local project. Fetches latest agent definitions from GitHub and installs to .claude/agents/. Use when setting up architect, domain-modeler, implementer, test-engineer, and code-reviewer agents in a new or existing project.
---

# Install Python Development Agents

Fetches agent definitions from GitHub and installs them to a project's `.claude/agents/` directory.

## Usage

```
Install Python development agents to /path/to/project
```

Or with custom repo:
```
Install Python agents from github.com/user/repo to /path/to/project
```

## Default Source

Agents are fetched from: `github.com/thomashartm/claude-agents/tree/main/python-agents/`

Expected files in repo:
- `architect.md`
- `domain-modeler.md`
- `implementer.md`
- `test-engineer.md`
- `code-reviewer.md`
- `patterns.md`

Scripts:
- `scripts/scaffold_project.py`
- `scripts/validate_architecture.py`

## Installation Result

```
project/
├── CLAUDE.md                    # Snippet appended
└── .claude/
    ├── agents/                  # Agent definitions
    │   ├── architect.md
    │   ├── domain-modeler.md
    │   ├── implementer.md
    │   ├── test-engineer.md
    │   ├── code-reviewer.md
    │   └── patterns.md
    └── scripts/                 # Utility scripts
        ├── scaffold_project.py
        └── validate_architecture.py
```

## Manual Installation

```bash
~/.claude/skills/install-python-agents/scripts/install.sh /path/to/project
```

With custom repo:
```bash
~/.claude/skills/install-python-agents/scripts/install.sh /path/to/project --repo owner/repo-name
```

Offline (embedded fallback):
```bash
~/.claude/skills/install-python-agents/scripts/install.sh /path/to/project --offline
```

## CLAUDE.md Snippet

Appends minimal agent reference (~15 lines) to existing CLAUDE.md or creates new one.
