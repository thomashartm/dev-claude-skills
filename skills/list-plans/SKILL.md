---
name: list-plans
description: List Claude Code plan files with titles, purposes, and progress. Use when user asks about plans, wants to see planning history, or needs to find a specific plan. Triggers on phrases like "list plans", "show my plans", "what plans exist", "planning history".
---

# List Plans Command

Display Claude Code plan files stored in ~/.claude/plans/ with extracted metadata.

## Quick Reference

```bash
list-plans-tool                    # Show 10 most recent plans
list-plans-tool --all              # Show all plans
list-plans-tool --limit 5          # Show 5 most recent
list-plans-tool --filter "deploy"  # Filter by title
list-plans-tool --json             # JSON output for scripting
list-plans-tool --help             # Show help
```

## Output Information

For each plan file, displays:
- **Filename**: The plan file name (e.g., happy-soaring-rabin.md)
- **Title**: Extracted from first `# heading` in the file
- **Purpose**: First paragraph after the title
- **Progress**: Count of `[x]` completed vs `[ ]` pending checkboxes
- **Modified**: Last modification timestamp

## Use Cases

1. **Find a plan**: Use `--filter` to search by title keywords
2. **Review recent work**: Default shows 10 most recent by modification time
3. **Scripting**: Use `--json` for machine-readable output
4. **Full inventory**: Use `--all` to see complete plan history
