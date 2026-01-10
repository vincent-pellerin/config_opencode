# Synchronization Protocol - OpenCode Config Backup

## Overview

Automatic synchronization system between the active OpenCode configuration (`~/.opencode/`) and the versioned backup repository (`/home/vincent/dev/config_opencode/`).

---

## Synchronization Strategy

### Purpose
- **Backup**: Maintain versioned backup of OpenCode configuration
- **Version Control**: Track changes to configuration over time
- **Recovery**: Enable restoration from backup if needed
- **Sharing**: Allow configuration sharing via Git repository

### Sync Direction
```
~/.opencode/ (MASTER) → /home/vincent/dev/config_opencode/ (BACKUP)
```

**Important**: Synchronization is unidirectional - backup never overwrites master.

## Sync Triggers

### Automatic Triggers
- After creating new context files
- After modifying system configurations
- After adding new tools or scripts
- After structural changes to OpenCode

### Manual Triggers
- `sync-config` command
- Before major configuration changes
- Weekly maintenance sync

## Sync Protocol

### Phase 1: Pre-Sync Validation
```markdown
Pre-Sync Checks:
□ Validate ~/.opencode/ structure integrity
□ Check for uncommitted changes in backup repo
□ Verify backup repo is accessible
□ Ensure no conflicts exist
```

### Phase 2: Selective Synchronization
```markdown
Sync Categories:
□ Context files (*.md in context/)
□ System tools (bin/)
□ Templates (templates/)
□ Agent definitions (agent/)
□ Commands (command/)
□ Configuration files (.env.example, etc.)

Exclude from Sync:
□ .env (contains secrets)
□ node_modules/
□ .tmp/ directories
□ User-specific cache files
```

### Phase 3: Git Operations
```markdown
Git Workflow:
□ Check git status in backup repo
□ Add all synchronized changes
□ Create descriptive commit message
□ Commit changes locally
□ Optionally push to remote (GitHub)
```

### Phase 4: Verification
```markdown
Post-Sync Verification:
□ Verify file integrity in backup
□ Check that permissions are preserved
□ Validate backup structure with validation tool
□ Log sync operation
```

## Sync Rules

### File Handling Rules
1. **Overwrite Policy**: Always overwrite backup with master version
2. **New Files**: Copy new files from master to backup
3. **Deleted Files**: Remove files from backup if deleted in master
4. **Permissions**: Preserve executable permissions for scripts
5. **Timestamps**: Preserve modification times when possible

### Conflict Resolution
- **Master Wins**: Always prioritize ~/.opencode/ version
- **Backup Conflicts**: Backup uncommitted changes before sync
- **Permission Issues**: Fix permissions automatically
- **Missing Directories**: Create missing directories in backup

### Security Considerations
- **Never sync secrets**: Exclude .env and credential files
- **Sanitize paths**: Ensure no path traversal vulnerabilities
- **Validate content**: Check for malicious content before sync
- **Backup verification**: Verify backup integrity after sync

## Sync Implementation

### Sync Categories and Patterns

```bash
# Context files (documentation)
SYNC_PATTERNS=(
    "context/**/*.md"
    "context/**/index.md"
)

# System tools and scripts
SYNC_PATTERNS+=(
    "bin/*"
    "tool/**/*"
    "plugin/**/*"
    "command/**/*"
)

# Templates and configurations
SYNC_PATTERNS+=(
    "templates/**/*"
    "agent/**/*.md"
    ".env.example"
    "*.md"
    "package.json"
)

# Exclusion patterns
EXCLUDE_PATTERNS=(
    ".env"
    "node_modules/"
    ".tmp/"
    "*.log"
    ".git/"
    "*.key"
    "credentials.*"
)
```

### Sync Frequency
- **Real-time**: After structural changes
- **Scheduled**: Daily automatic sync
- **Manual**: On-demand via command
- **Pre-commit**: Before major changes

## Error Handling

### Common Issues and Solutions

#### 1. Backup Repository Dirty
**Issue**: Uncommitted changes in backup repo
**Solution**: 
```bash
cd /home/vincent/dev/config_opencode
git stash push -m "Auto-stash before sync $(date)"
# Proceed with sync
git stash pop  # If needed later
```

#### 2. Permission Denied
**Issue**: Cannot write to backup directory
**Solution**: Fix permissions and retry
```bash
chmod -R u+w /home/vincent/dev/config_opencode
```

#### 3. Git Conflicts
**Issue**: Git merge conflicts in backup
**Solution**: Reset backup to clean state
```bash
cd /home/vincent/dev/config_opencode
git reset --hard HEAD
# Retry sync
```

#### 4. Missing Directories
**Issue**: Target directories don't exist in backup
**Solution**: Create missing directory structure
```bash
mkdir -p /home/vincent/dev/config_opencode/{context,bin,templates,agent}
```

## Monitoring and Logging

### Sync Logging
```bash
# Log location
SYNC_LOG="$HOME/.opencode/.tmp/sync.log"

# Log format
[TIMESTAMP] [LEVEL] [OPERATION] Message
[2026-01-05 15:30:00] [INFO] [SYNC] Starting synchronization
[2026-01-05 15:30:01] [INFO] [COPY] Copied context/core/system/sync-protocol.md
[2026-01-05 15:30:02] [INFO] [GIT] Committed changes: "sync: update system protocols"
[2026-01-05 15:30:03] [SUCCESS] [SYNC] Synchronization completed successfully
```

### Health Monitoring
```bash
# Sync health check
sync-config --check

# Last sync status
sync-config --status

# Sync statistics
sync-config --stats
```

## Integration with Workflow

### Enhanced Workflow Integration

**Modified Stage 6: Handoff + Sync**

```markdown
Stage 6.1: Complete Task (EXISTING)
□ Mark task as completed
□ Update documentation
□ Run final validations

Stage 6.2: Sync Configuration (NEW)
IF structural changes made:
  □ Run sync-config automatically
  □ Verify backup integrity
  □ Log sync operation
  □ Report sync status

Stage 6.3: Handoff Recommendations (EXISTING)
□ Suggest next steps
□ Recommend additional tools
□ Update task status
```

### Sync Triggers in Workflow
- **After validation system changes**
- **After new integration setup**
- **After tool creation or modification**
- **After context file updates**

## Usage Examples

### Basic Sync
```bash
# Sync all changes
sync-config

# Sync with push to GitHub
sync-config --push

# Dry run (show what would be synced)
sync-config --dry-run
```

### Selective Sync
```bash
# Sync only context files
sync-config --context-only

# Sync only tools
sync-config --tools-only

# Sync specific directory
sync-config --include="context/integrations/*"
```

### Maintenance Operations
```bash
# Check sync status
sync-config --status

# Validate backup integrity
sync-config --validate

# Force full resync
sync-config --force
```

## Best Practices

### When to Sync
✅ **Always sync after**:
- Creating new context files
- Adding new tools or scripts
- Modifying system configurations
- Completing major features

✅ **Consider syncing before**:
- Major configuration changes
- System updates or maintenance
- Sharing configuration with others

### What NOT to Sync
❌ **Never sync**:
- Secret files (.env, *.key, credentials.*)
- Temporary files (.tmp/, *.log)
- User-specific data
- Large binary files
- Node modules or dependencies

### Sync Hygiene
- **Regular syncs**: Don't let changes accumulate
- **Descriptive commits**: Use meaningful commit messages
- **Validation**: Always validate after sync
- **Monitoring**: Check sync logs regularly
- **Cleanup**: Remove old stash entries periodically

---

**Integration Point**: Stage 6.2 (Handoff + Sync)
**Tool**: `~/.opencode/bin/sync-config`
**Frequency**: After structural changes + daily automatic
**Last Updated**: 2026-01-05