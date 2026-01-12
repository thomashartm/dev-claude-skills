#!/usr/bin/env bash
#
# Install Python Clean Architecture agents into a project.
#
# Usage:
#   install.sh <project_path>
#   install.sh <project_path> --repo owner/repo-name
#   install.sh <project_path> --offline
#

set -e

# Defaults
# https://github.com/thomashartm/claude-agents/tree/main/python-agents
DEFAULT_REPO="thomashartm/claude-agents"
DEFAULT_BRANCH="main"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

log_success() { echo -e "  ${GREEN}✓${NC} $1"; }
log_warn() { echo -e "  ${YELLOW}⊘${NC} $1"; }
log_error() { echo -e "  ${RED}✗${NC} $1"; }

# CLAUDE.md snippet
read -r -d '' CLAUDE_SNIPPET << 'SNIPPET' || true

## Python Development Agents

Agents in `.claude/agents/`:

| Agent | Use For |
|-------|---------|
| `architect.md` | System design, layers, patterns |
| `domain-modeler.md` | Entities, VOs, aggregates |
| `implementer.md` | Production code |
| `test-engineer.md` | Testing |
| `code-reviewer.md` | Quality review |
| `patterns.md` | Quick pattern reference |

**Invoke:** `Read .claude/agents/[name].md and [task]`

**Scripts:** `.claude/scripts/validate_architecture.py src/` | `.claude/scripts/scaffold_project.py name`
SNIPPET

# Embedded agents function
install_embedded() {
    cat > "$AGENTS_DIR/architect.md" << 'EOF'
# Architect Agent

Software Architect for Python Clean Architecture applications.

## Project Structure
```
src/{name}/
├── domain/           # Pure business logic, NO external deps
├── application/      # Use cases, commands, queries, handlers
├── infrastructure/   # DB, external APIs, messaging
└── presentation/     # API routes, CLI, consumers
```

## Rules
- Dependencies flow inward only
- Domain has ZERO framework imports
- Repository interfaces in domain, implementations in infrastructure

## Tools
```bash
python .claude/scripts/scaffold_project.py <name> [-o output_dir]
```
EOF
    log_success "$AGENTS_DIR/architect.md"

    cat > "$AGENTS_DIR/domain-modeler.md" << 'EOF'
# Domain Modeler Agent

DDD expert for modeling business domains in Python.

## Building Blocks
- **Entities** - Identity matters, have behavior
- **Value Objects** - Immutable (`frozen=True`)
- **Aggregates** - Cluster with single root
- **Domain Events** - Immutable state change records
- **Repository Interfaces** - Define in domain

## Rules
- No ORM/framework imports in domain
- Entities have behavior, not just data
EOF
    log_success "$AGENTS_DIR/domain-modeler.md"

    cat > "$AGENTS_DIR/implementer.md" << 'EOF'
# Implementer Agent

Implementation specialist for Clean Architecture Python code.

## Layer Order
Implement inside-out: Domain → Application → Infrastructure → Presentation

## Standards
- Type hints everywhere
- `dataclass` for DTOs, entities, VOs
- `Protocol` for interfaces
- Inject dependencies via constructor
EOF
    log_success "$AGENTS_DIR/implementer.md"

    cat > "$AGENTS_DIR/test-engineer.md" << 'EOF'
# Test Engineer Agent

Testing specialist for Clean Architecture applications.

## Test Pyramid
- **Unit** (many): Domain logic, handlers with fakes
- **Integration** (some): Real DB, repos
- **E2E** (few): Full HTTP requests

## Coverage Targets
Domain: 95% | Application: 90% | Infrastructure: 80%
EOF
    log_success "$AGENTS_DIR/test-engineer.md"

    cat > "$AGENTS_DIR/code-reviewer.md" << 'EOF'
# Code Reviewer Agent

Quality assessor for Clean Architecture compliance.

## Red Flags
- `from sqlalchemy` in domain/ (Critical)
- Business logic in routes (Critical)
- `except Exception:` (Important)

## Tools
```bash
python .claude/scripts/validate_architecture.py src/ [--strict]
```
EOF
    log_success "$AGENTS_DIR/code-reviewer.md"

    cat > "$AGENTS_DIR/patterns.md" << 'EOF'
# Patterns Quick Reference

## Dependency Rule
Presentation → Application → Domain ← Infrastructure

## Repository
Interface in domain, implementation in infrastructure.

## Unit of Work
`with uow: ... uow.commit()`

## CQRS
Commands via domain, queries can read directly.
EOF
    log_success "$AGENTS_DIR/patterns.md"

    cat > "$SCRIPTS_DIR/scaffold_project.py" << 'EOF'
#!/usr/bin/env python3
"""Scaffold a Clean Architecture Python project."""
import argparse
from pathlib import Path

DIRS = [
    "src/{name}/domain/entities", "src/{name}/domain/value_objects",
    "src/{name}/domain/events", "src/{name}/domain/services",
    "src/{name}/domain/interfaces", "src/{name}/application/commands",
    "src/{name}/application/queries", "src/{name}/application/handlers",
    "src/{name}/infrastructure/persistence", "src/{name}/infrastructure/messaging",
    "src/{name}/presentation/api/routes", "src/{name}/presentation/api/schemas",
    "tests/unit/domain", "tests/unit/application", "tests/integration", "tests/e2e",
]

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("name")
    parser.add_argument("-o", "--output", default=".")
    args = parser.parse_args()
    for d in DIRS:
        path = Path(args.output) / d.format(name=args.name)
        path.mkdir(parents=True, exist_ok=True)
        (path / "__init__.py").touch()
        print(f"Created: {path}")
    print(f"\n✅ Scaffolded {args.name}")

if __name__ == "__main__":
    main()
EOF
    chmod +x "$SCRIPTS_DIR/scaffold_project.py"
    log_success "$SCRIPTS_DIR/scaffold_project.py"

    cat > "$SCRIPTS_DIR/validate_architecture.py" << 'EOF'
#!/usr/bin/env python3
"""Validate architectural layer boundaries."""
import argparse, ast, sys
from pathlib import Path

FORBIDDEN = {"domain": ["fastapi", "flask", "sqlalchemy", "pydantic", "django"]}
LAYER_IMPORTS = {"domain": ["application", "infrastructure", "presentation"],
                 "application": ["infrastructure", "presentation"]}

def check_file(path):
    try: tree = ast.parse(path.read_text())
    except: return []
    layer = next((l for l in ["domain", "application"] if f"/{l}/" in str(path)), None)
    if not layer: return []
    violations = []
    for node in ast.walk(tree):
        if isinstance(node, (ast.Import, ast.ImportFrom)):
            mod = node.names[0].name if isinstance(node, ast.Import) else (node.module or "")
            for f in FORBIDDEN.get(layer, []):
                if mod.startswith(f): violations.append(f"{path}:{node.lineno} - {layer} cannot import {f}")
            for fl in LAYER_IMPORTS.get(layer, []):
                if fl in mod: violations.append(f"{path}:{node.lineno} - {layer} cannot import {fl}")
    return violations

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("src_dir")
    parser.add_argument("--strict", action="store_true")
    args = parser.parse_args()
    violations = [v for py in Path(args.src_dir).rglob("*.py") for v in check_file(py)]
    if violations:
        print("❌ Violations:\n" + "\n".join(f"  {v}" for v in violations))
        sys.exit(1 if args.strict else 0)
    print("✅ No violations")

if __name__ == "__main__":
    main()
EOF
    chmod +x "$SCRIPTS_DIR/validate_architecture.py"
    log_success "$SCRIPTS_DIR/validate_architecture.py"
}

# Files to fetch
AGENT_FILES="architect.md domain-modeler.md implementer.md test-engineer.md code-reviewer.md patterns.md"
SCRIPT_FILES="scaffold_project.py validate_architecture.py"

# Parse arguments
REPO="$DEFAULT_REPO"
BRANCH="$DEFAULT_BRANCH"
OFFLINE=false
PROJECT_PATH=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --repo)    REPO="$2"; shift 2 ;;
        --branch)  BRANCH="$2"; shift 2 ;;
        --offline) OFFLINE=true; shift ;;
        -h|--help) echo "Usage: install.sh <project_path> [--repo owner/name] [--branch name] [--offline]"; exit 0 ;;
        *)         PROJECT_PATH="$1"; shift ;;
    esac
done

if [[ -z "$PROJECT_PATH" ]]; then
    echo "Error: Project path required"
    exit 1
fi

if [[ ! -d "$PROJECT_PATH" ]]; then
    echo "Error: $PROJECT_PATH is not a directory"
    exit 1
fi

# Setup directories
AGENTS_DIR="$PROJECT_PATH/.claude/agents"
SCRIPTS_DIR="$PROJECT_PATH/.claude/scripts"
mkdir -p "$AGENTS_DIR" "$SCRIPTS_DIR"

echo "Installing Python agents to $PROJECT_PATH"

if [[ "$OFFLINE" == true ]]; then
    echo "Using embedded agents..."
    install_embedded
else
    echo "Fetching from $REPO@$BRANCH..."

    for file in $AGENT_FILES; do
        url="https://raw.githubusercontent.com/$REPO/$BRANCH/python-agents/$file"
        if curl -sfL "$url" -o "$AGENTS_DIR/$file" 2>/dev/null; then
            log_success "$AGENTS_DIR/$file"
        else
            log_error "Failed: $file (try --offline)"
        fi
    done

    for file in $SCRIPT_FILES; do
        url="https://raw.githubusercontent.com/$REPO/$BRANCH/python-agents/$file"
        if curl -sfL "$url" -o "$SCRIPTS_DIR/$file" 2>/dev/null; then
            chmod +x "$SCRIPTS_DIR/$file"
            log_success "$SCRIPTS_DIR/$file"
        else
            log_error "Failed: $file"
        fi
    done
fi

# Update CLAUDE.md
CLAUDE_MD="$PROJECT_PATH/CLAUDE.md"
if [[ -f "$CLAUDE_MD" ]]; then
    if grep -q "Python Development Agents" "$CLAUDE_MD" 2>/dev/null; then
        log_warn "$CLAUDE_MD already configured"
    else
        echo "$CLAUDE_SNIPPET" >> "$CLAUDE_MD"
        log_success "Appended to $CLAUDE_MD"
    fi
else
    echo "# Project Configuration" > "$CLAUDE_MD"
    echo "$CLAUDE_SNIPPET" >> "$CLAUDE_MD"
    log_success "Created $CLAUDE_MD"
fi

echo ""
echo -e "${GREEN}✅ Done!${NC}"
