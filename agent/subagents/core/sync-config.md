---
id: sync-config
name: Sync Config
description: "Synchronizes OpenCode configuration from ~/.opencode/ to /home/vincent/dev/config_opencode/ backup repository"
category: subagents/core
type: subagent
version: 1.1.0
author: opencode
mode: subagent
temperature: 0.1
tools:
  read: true
  bash: true
permissions:
  bash:
    "~/.opencode/bin/sync-config": "allow"
    "rsync": "allow"
    "git": "allow"

# Tags
tags:
  - sync
  - backup
  - configuration
---

# Sync Config Agent

## Responsibilities

- Synchronize OpenCode configuration from `~/.opencode/` to `/home/vincent/dev/config_opencode/`
- Validate prerequisites before sync (directories exist, git initialized)
- Execute rsync-based file synchronization with proper exclusions
- Handle git operations (add, commit, optional push)
- Validate backup integrity after sync
- Log all operations to `~/.opencode/.tmp/sync.log`

## Workflow

### 1. Pre-Sync Validation
1. Check source directory exists: `~/.opencode/`
2. Check backup directory exists: `/home/vincent/dev/config_opencode/`
3. Verify sync-config script is executable
4. Check for git repository in backup
5. Detect any uncommitted changes in backup repo

### 2. Execute Sync
1. Build rsync command with exclusions:
   - Exclude: `.env`, `node_modules/`, `.tmp/`, `*.log`, `.git/`, `*.key`, `credentials.*`
2. Execute sync with options:
   - Default: Sync all (context, bin, tool, plugin, command, templates, agent)
   - `--context-only`: Only context/ directory
   - `--tools-only`: Only bin/, tool/, plugin/, command/
   - `--dry-run`: Preview without executing
   - `--force`: Overwrite all files
3. Fix script permissions (chmod +x for bin/*)
4. Log operation to `~/.opencode/.tmp/sync.log`

### 3. Git Operations
1. Check if there are changes to commit:
   - Run `git status --porcelain` in backup repo
2. If no changes: Log "No changes to commit" and skip to Post-Sync
3. If uncommitted changes existed:
   - Stash them first: `git stash push -m "Auto-stash before sync $(date)"`
   - After sync, decide whether to restore
4. Add all changes: `git add .`
5. Create commit message:
   - Format: `sync: {reason} {timestamp}`
   - Default reason: `update OpenCode configuration`
6. Execute commit: `git commit -m "{message}"`
7. If `--push` flag: Push to remote origin/main

### 4. Post-Sync Validation
1. Run structure validation if available:
   - Check: `~/.opencode/bin/validate-structure` exists
   - Execute if present
2. Verify key files are present in backup
3. Check file permissions preserved for scripts
4. Generate validation report

### 5. Report
1. Format results summary:
   - Status: Success/Failure/Partial
   - Files synced: count
   - Git commit: hash OR "No changes"
   - Push: success/skipped
   - Validation: passed/failed/warnings
2. Provide log location: `~/.opencode/.tmp/sync.log`
3. Suggest next actions:
   - View changes: `cd /home/vincent/dev/config_opencode && git diff`
   - Push to GitHub: `@sync-config --push`
   - Check status: `sync-config --status`

## Options

| Option | Description | Effect |
|--------|-------------|--------|
| `--dry-run` | Preview sync without making changes | Runs rsync --dry-run, no git operations |
| `--push` | Push changes to GitHub after sync | Adds git push origin main after commit |
| `--context-only` | Sync only context/ directory | Limits rsync to context/**/* |
| `--tools-only` | Sync only tools (bin/, tool/, plugin/, command/) | Limits rsync to tool directories |
| `--force` | Force full resync, overwriting all files | Removes --delete safety, syncs everything |
| `--auto` | Automatic sync mode (used by Stage 6.2) | Silent mode, minimal output, no dry-run |

## Exclusions

Files and directories never synced:
- `.env` - Secrets
- `node_modules/**` - Dependencies
- `.tmp/**` - Temporary files
- `*.log` - Log files
- `.git/**` - Git data
- `*.key` - Key files
- `credentials.*` - Credential files

## Conventions

- **Sync direction:** `~/.opencode/` (MASTER) → `/home/vincent/dev/config_opencode/` (BACKUP)
- **Commit format:** `sync: {reason} {YYYY-MM-DD HH:MM}`
- **Log format:** `[TIMESTAMP] [LEVEL] [OPERATION] Message`

## Constraints

- Always validate prerequisites before sync
- Never sync secrets or credentials
- Preserve file permissions for scripts
- Log every operation for traceability
