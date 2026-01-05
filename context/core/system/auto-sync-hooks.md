# Auto-Sync Hooks Configuration

## Overview

Automatic synchronization triggers that activate after structural changes to OpenCode configuration, ensuring the backup repository stays current.

---

## Hook Integration Points

### Workflow Integration
**Enhanced Stage 6.2: Auto-Sync After Changes**

```markdown
Stage 6.2.1: Detect Structural Changes
□ Check if files were created/modified in OpenCode structure
□ Identify change categories (context, tools, config)
□ Determine if sync is needed

Stage 6.2.2: Trigger Auto-Sync
IF structural changes detected:
  □ Run sync-config automatically
  □ Log sync operation
  □ Report sync status
  □ Handle any sync errors

Stage 6.2.3: Verify Sync Success
□ Confirm backup is updated
□ Validate backup integrity
□ Update sync status
```

### Auto-Sync Triggers

#### High Priority Triggers (Always Sync)
- New context files created
- System configuration modified
- New tools added to bin/
- Agent definitions updated
- Integration configurations added

#### Medium Priority Triggers (Conditional Sync)
- Documentation updates
- Template modifications
- Minor configuration changes

#### Low Priority Triggers (Manual Sync)
- Log file updates
- Temporary file changes
- Cache modifications

## Hook Implementation Strategy

### Method 1: Workflow Integration (Recommended)
**Integration Point**: Stage 6.2 in main workflow
**Trigger**: After task completion with structural changes
**Advantages**: 
- Integrated with existing workflow
- Context-aware (knows what changed)
- Can be selectively applied

### Method 2: File System Monitoring
**Implementation**: inotify-based file watcher
**Trigger**: Real-time file system events
**Advantages**: 
- Immediate synchronization
- Catches all changes
- No workflow dependency

### Method 3: Scheduled Sync
**Implementation**: Cron job or systemd timer
**Trigger**: Time-based (hourly/daily)
**Advantages**: 
- Simple and reliable
- Low overhead
- Catches missed changes

## Auto-Sync Configuration

### Sync Policies

```bash
# Auto-sync configuration
AUTO_SYNC_ENABLED=true
AUTO_SYNC_PUSH=false  # Don't auto-push to GitHub
AUTO_SYNC_VALIDATE=true  # Always validate after sync

# Trigger thresholds
MIN_CHANGES_FOR_SYNC=1  # Sync after any structural change
MAX_SYNC_FREQUENCY=300  # Max one sync per 5 minutes

# Change categories that trigger sync
SYNC_TRIGGERS=(
    "context/**/*.md"
    "bin/*"
    "tool/**/*"
    "agent/**/*.md"
    "templates/**/*"
    "*.md"
    "package.json"
)
```

### Sync Exclusions

```bash
# Changes that DON'T trigger auto-sync
SYNC_EXCLUSIONS=(
    ".tmp/**/*"
    "*.log"
    ".env"
    "node_modules/**/*"
    ".git/**/*"
)
```

## Implementation Examples

### Workflow Integration Example

```bash
# In main workflow Stage 6.2
auto_sync_if_needed() {
    local changes_made="$1"
    local change_type="$2"
    
    # Check if auto-sync is enabled
    if [ "$AUTO_SYNC_ENABLED" != "true" ]; then
        return 0
    fi
    
    # Check if changes warrant sync
    case "$change_type" in
        "context"|"tools"|"config"|"integration")
            log "INFO" "AUTO-SYNC" "Structural changes detected, triggering sync"
            sync-config --auto
            ;;
        "documentation")
            log "INFO" "AUTO-SYNC" "Documentation changes, considering sync"
            # Sync only if significant changes
            if [ "$changes_made" -gt 3 ]; then
                sync-config --context-only --auto
            fi
            ;;
        *)
            log "INFO" "AUTO-SYNC" "Minor changes, skipping auto-sync"
            ;;
    esac
}
```

### File Watcher Example

```bash
#!/bin/bash
# File system watcher for auto-sync

WATCH_DIR="$HOME/.opencode"
SYNC_COOLDOWN=300  # 5 minutes

watch_and_sync() {
    inotifywait -m -r -e create,modify,delete \
        --include '\.(md|json)$' \
        --exclude '\.tmp/|\.log$|\.env$' \
        "$WATCH_DIR" | while read path action file; do
        
        # Check cooldown period
        if [ -f "/tmp/last_auto_sync" ]; then
            last_sync=$(cat /tmp/last_auto_sync)
            current_time=$(date +%s)
            if [ $((current_time - last_sync)) -lt $SYNC_COOLDOWN ]; then
                continue
            fi
        fi
        
        # Trigger sync
        log "INFO" "WATCHER" "File change detected: $path$file"
        sync-config --auto
        echo "$(date +%s)" > /tmp/last_auto_sync
    done
}
```

### Scheduled Sync Example

```bash
# Cron job entry (add to crontab -e)
# Sync every hour if changes detected
0 * * * * /home/vincent/.opencode/bin/sync-config --check-and-sync

# sync-config --check-and-sync implementation
check_and_sync() {
    local last_sync_file="$HOME/.opencode/.tmp/last_sync_timestamp"
    local source_newer=false
    
    # Check if source has newer files than last sync
    if [ -f "$last_sync_file" ]; then
        local last_sync=$(cat "$last_sync_file")
        if find "$OPENCODE_SOURCE" -newer "$last_sync_file" -type f | grep -q .; then
            source_newer=true
        fi
    else
        source_newer=true  # First sync
    fi
    
    if [ "$source_newer" = true ]; then
        log "INFO" "SCHEDULED" "Changes detected, performing scheduled sync"
        sync-config
        date +%s > "$last_sync_file"
    else
        log "INFO" "SCHEDULED" "No changes detected, skipping sync"
    fi
}
```

## Auto-Sync Safety Features

### Rate Limiting
- Maximum one sync per 5 minutes
- Cooldown period after failed syncs
- Exponential backoff for repeated failures

### Error Handling
- Graceful failure handling
- Automatic retry with backoff
- Error notification and logging
- Fallback to manual sync

### Conflict Resolution
- Detect and handle git conflicts
- Automatic stashing of uncommitted changes
- Recovery procedures for failed syncs

## Monitoring and Control

### Auto-Sync Status
```bash
# Check auto-sync status
sync-config --auto-status

# Enable/disable auto-sync
sync-config --auto-enable
sync-config --auto-disable

# View auto-sync history
sync-config --auto-history
```

### Configuration Management
```bash
# View current auto-sync config
sync-config --show-config

# Update auto-sync settings
sync-config --set-config AUTO_SYNC_PUSH=true
sync-config --set-config MAX_SYNC_FREQUENCY=600
```

## Best Practices

### When to Use Auto-Sync
✅ **Recommended for**:
- Development environments
- Frequent configuration changes
- Team collaboration scenarios
- Backup safety requirements

### When to Disable Auto-Sync
❌ **Not recommended for**:
- Production environments
- Sensitive configuration changes
- Network-limited environments
- During major restructuring

### Auto-Sync Hygiene
- **Monitor logs**: Check auto-sync logs regularly
- **Validate backups**: Ensure auto-synced backups are valid
- **Control frequency**: Don't over-sync (respect cooldowns)
- **Handle failures**: Address auto-sync failures promptly
- **Review changes**: Periodically review auto-synced commits

## Integration with Validation System

### Enhanced Validation + Auto-Sync
```markdown
Stage 6.2: Enhanced Handoff + Validation + Sync
1. Complete task validation
2. Detect structural changes
3. Run structure validation
4. IF validation passes AND changes detected:
   - Trigger auto-sync
   - Validate backup integrity
   - Report sync status
5. Proceed with handoff recommendations
```

### Validation-Gated Sync
- Auto-sync only triggers after successful validation
- Failed validation blocks auto-sync
- Validation errors are logged and reported
- Manual intervention required for validation failures

---

**Implementation Status**: Ready for integration
**Recommended Method**: Workflow integration (Stage 6.2)
**Fallback Method**: Scheduled sync (hourly)
**Safety Features**: Rate limiting, error handling, validation gating
**Last Updated**: 2026-01-05