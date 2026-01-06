---
agent: sync-config
description: "Synchronize OpenCode configuration from ~/.opencode/ to /home/vincent/dev/config_opencode/ backup repository"
---

# Sync Command

Synchronize your OpenCode configuration from the active directory (`~/.opencode/`) to the backup repository (`/home/vincent/dev/config_opencode/`).

**Request:** $ARGUMENTS

**Process:**
1. Validate prerequisites (directories exist, git repo initialized)
2. Execute rsync sync with appropriate exclusions
3. Create git commit with descriptive message
4. Validate backup integrity
5. Present summary report

**Syntax:**
```bash
/sync [OPTIONS] [--reason "description"]
```

**Options:**
| Option | Description |
|--------|-------------|
| *(no option)* | Full sync with commit |
| `--dry-run` | Preview changes without executing |
| `--push` | Sync and push to GitHub |
| `--context-only` | Sync only context/ directory |
| `--tools-only` | Sync only tools (bin/, tool/, plugin/, command/) |
| `--force` | Force full resync, overwriting all files |
| `--auto` | Automatic mode (minimal output) |

**Parameters:**
- `--reason "text"` - Description for commit message (optional)

**Examples:**

```bash
# Basic sync (full sync with commit)
/sync

# Preview what would be synced
/sync --dry-run

# Sync and push to GitHub
/sync --push

# Sync with custom reason
/sync --reason "add TypeScript language support"

# Sync only context files
/sync --context-only

# Sync only tools and commands
/sync --tools-only

# Force full resync
/sync --force

# Automatic sync (used by workflow)
/sync --auto --reason "after language setup"
```

**Output:**
```yaml
sync_result:
  status: "success"
  files_synced: 42
  commit: "sync: add TypeScript language support (2026-01-06 15:30)"
  push: "pushed to origin/main"
  validation: "passed"
```

**Notes:**
- **Sync Direction:** `~/.opencode/` → `/home/vincent/dev/config_opencode/` (unidirectional)
- **Excluded Files:** .env, node_modules/, .tmp/, *.log, .git/, *.key, credentials.*
- **Commit Format:** `sync: {reason} {YYYY-MM-DD HH:MM}`
- **Log Location:** `~/.opencode/.tmp/sync.log`

**Automatic Sync:**
This command is also called automatically by Stage 6.2 in OpenAgent workflow after structural changes. Use `/sync` for manual sync when you want more control.
