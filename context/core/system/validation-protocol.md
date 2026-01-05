# Validation Protocol - Integrated Workflow

## Overview

This protocol integrates systematic validation into the main OpenAgent workflow to prevent structural errors and ensure OpenCode standards compliance.

---

## Enhanced Workflow Integration

### Modified Stage 3.1: LoadContext + Validation

**BEFORE any file/directory creation:**

```markdown
Step 3.1.1: Load Required Context (EXISTING)
□ Load task-specific context files
□ Apply context to current task

Step 3.1.2: Load Validation Context (NEW)
□ Load: ~/.opencode/context/core/system/validation-checklist.md
□ Load: ~/.opencode/context/core/system/context-guide.md

Step 3.1.3: Apply Validation Protocol (NEW)
□ Classify content type (doc/script/config/template)
□ Determine correct OpenCode location
□ Validate naming conventions
□ Check for anti-patterns
□ Verify dependencies exist

Step 3.1.4: Validation Gate (NEW)
IF creating files/directories:
  □ STOP and validate placement
  □ Confirm structure follows OpenCode standards
  □ Proceed only after validation passes
ELSE:
  □ Continue to execution
```

## Validation Triggers

**ALWAYS validate when:**
- Creating new files or directories
- Modifying OpenCode structure
- Adding integrations or tools
- Setting up new contexts

**NEVER skip validation for:**
- "Quick" file creation
- "Temporary" scripts
- "Simple" documentation
- Any structural changes

## Pre-Creation Validation Checklist

### 1. Context Loading Verification
```markdown
Required Context Loaded:
□ ~/.opencode/context/core/system/context-guide.md
□ ~/.opencode/context/core/system/validation-checklist.md
□ ~/.opencode/context/core/standards/patterns.md
```

### 2. Content Classification
```markdown
File Type Classification:
□ Documentation (.md) → ~/.opencode/context/
□ Executable script → ~/.opencode/bin/
□ Configuration template → ~/.opencode/templates/
□ Agent definition → ~/.opencode/agent/
□ Tool/plugin → ~/.opencode/tool/ or ~/.opencode/plugin/
□ Command → ~/.opencode/command/
```

### 3. Structure Validation
```markdown
OpenCode Compliance:
□ Location follows OpenCode hierarchy
□ Naming uses kebab-case convention
□ No mixing of executable and documentation content
□ No spaces or special characters in names
□ Follows existing patterns in target directory
```

### 4. Anti-Pattern Detection
```markdown
Avoid These Mistakes:
□ Scripts in /context/ directories
□ Documentation in /bin/ directories
□ Mixed content types in same file
□ Hardcoded paths or credentials
□ Non-descriptive or abbreviated names
```

## Validation Commands

### Manual Validation
```bash
# Run full structure validation
~/.opencode/bin/validate-structure

# Quick check before creating files
ls -la ~/.opencode/context/core/system/validation-checklist.md
```

### Automated Checks
```bash
# Check if validation context is loaded (in session)
echo "Validation context loaded: $([ -f ~/.opencode/context/core/system/validation-checklist.md ] && echo 'YES' || echo 'NO')"

# Verify target directory exists and is appropriate
target_dir="$1"  # e.g., ~/.opencode/context/integrations/
[ -d "$target_dir" ] && echo "Target directory valid" || echo "Target directory invalid"
```

## Integration Examples

### Example 1: Creating Integration Documentation
```markdown
Task: Create GitHub integration docs

Validation Process:
1. Load validation context ✓
2. Classify: Documentation (.md files) ✓
3. Location: ~/.opencode/context/integrations/github/ ✓
4. Naming: config.md, usage-guide.md ✓
5. Anti-patterns: None detected ✓
6. Proceed with creation ✓
```

### Example 2: Creating Utility Script
```markdown
Task: Create database backup script

Validation Process:
1. Load validation context ✓
2. Classify: Executable script ✓
3. Location: ~/.opencode/bin/db-backup ✓
4. Naming: kebab-case, no extension ✓
5. Anti-patterns: None detected ✓
6. Set executable permissions ✓
7. Proceed with creation ✓
```

### Example 3: Creating Mixed Content (WRONG)
```markdown
Task: Create tool with embedded documentation

Validation Process:
1. Load validation context ✓
2. Classify: Mixed content (script + docs) ❌
3. Anti-pattern detected: Mixed content types ❌
4. STOP - Separate into:
   - Script: ~/.opencode/bin/tool-name
   - Docs: ~/.opencode/context/tools/tool-name.md
5. Retry with separated content ✓
```

## Error Prevention

### Common Mistakes Prevented
1. **Scripts in context directories** → Caught by content classification
2. **Documentation in bin directories** → Caught by location validation
3. **Mixed content types** → Caught by anti-pattern detection
4. **Poor naming conventions** → Caught by naming validation
5. **Missing dependencies** → Caught by dependency check

### Validation Failure Actions
```markdown
When validation fails:
1. STOP current action immediately
2. Review validation checklist
3. Identify specific violation
4. Correct structure/approach
5. Re-run validation
6. Proceed only after validation passes
```

## Monitoring and Maintenance

### Regular Structure Audits
```bash
# Weekly structure validation
~/.opencode/bin/validate-structure

# Check for new anti-patterns
find ~/.opencode -name "*.sh" -path "*/context/*" 2>/dev/null || echo "No scripts in context (good)"
```

### Continuous Improvement
- Update validation rules based on discovered patterns
- Enhance validation script with new checks
- Document new anti-patterns as they're identified
- Refine classification rules for edge cases

---

**Implementation Status**: Active
**Integration Point**: Stage 3.1 (LoadContext + Validation)
**Validation Tool**: `~/.opencode/bin/validate-structure`
**Last Updated**: 2026-01-05