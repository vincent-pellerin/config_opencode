# Agent Behavior Configuration

## Overview

This document defines how to configure the Development Agent to automatically load global context at the start of each session.

---

## Problem Statement

Currently, the agent searches for context in `/home/vincent/dev/.opencode/*` instead of the global context in `/home/vincent/.opencode/*`. This causes:

1. **Missing global standards** - Agent doesn't apply universal coding standards
2. **Inconsistent behavior** - Each session starts without proper context
3. **Manual context loading** - User must manually specify context files
4. **Integration failures** - n8n and other integrations not automatically available

## Solution: Automatic Global Context Loading

### 1. Session Initialization Workflow

**EVERY new session must start with:**

```markdown
1. Load global context index: ~/.opencode/context/index.md
2. Identify relevant contexts based on task keywords
3. Load critical contexts (code.md, etc.)
4. Apply global configuration precedence
5. Check for relevant integrations (n8n, etc.)
```

### 2. Context Loading Priority

**Global Context Precedence (MANDATORY):**
- `~/.opencode/` **ALWAYS** takes precedence over local `.opencode/`
- Global standards cannot be overridden by local configurations
- Local configs only add project-specific context

**Loading Order:**
1. **Global Index**: `~/.opencode/context/index.md` (ALWAYS FIRST)
2. **Critical Standards**: `~/.opencode/context/core/standards/code.md` (for code tasks)
3. **Task-Specific**: Load based on keywords from index
4. **Integrations**: Load if relevant (n8n, etc.)
5. **Local Context**: Only as additive complement

### 3. Keyword-Based Context Loading

**From index.md, load contexts based on task keywords:**

| Keywords | Load Context |
|----------|-------------|
| code, implementation, function, class | `core/standards/code.md` |
| test, testing, pytest | `core/standards/tests.md` |
| docs, documentation, readme | `core/standards/docs.md` |
| n8n, workflow, automation | `integrations/n8n/config.md` |
| review, pr, audit | `core/workflows/review.md` |
| delegate, complex, multi-file | `core/workflows/delegation.md` |

### 4. Modified Agent Prompt

**Add to system prompt:**

```markdown
<critical_context_requirement>
PURPOSE: Global context ensures consistency, quality, and alignment with established patterns.

MANDATORY SESSION INITIALIZATION:
1. ALWAYS load ~/.opencode/context/index.md FIRST
2. Load relevant contexts based on task keywords
3. Apply global configuration precedence
4. Load integrations if relevant (n8n, etc.)

CONTEXT PRECEDENCE:
- ~/.opencode/ (global) ALWAYS takes precedence
- Local .opencode/ only adds project-specific context
- Global standards cannot be overridden

BEFORE any implementation:
- Code tasks → ~/.opencode/context/core/standards/code.md (MANDATORY)
- Load task-specific contexts from index

CONSEQUENCE OF SKIPPING: Inconsistent work that doesn't match standards
</critical_context_requirement>
```

### 5. Automatic Context Discovery

**Use this workflow for every session:**

```bash
# 1. Load global index
read ~/.opencode/context/index.md

# 2. Extract keywords from user request
keywords = extract_keywords(user_request)

# 3. Match keywords to contexts (from index.md)
relevant_contexts = match_keywords_to_contexts(keywords)

# 4. Load relevant contexts
for context in relevant_contexts:
    read ~/.opencode/context/{context}

# 5. Load integrations if mentioned
if "n8n" in keywords:
    read ~/.opencode/context/integrations/n8n/config.md
    read ~/.opencode/context/integrations/n8n/usage-guide.md
```

## Implementation Steps

### Step 1: Verify Global Context

Run the test script to ensure everything is configured:

```bash
~/.opencode/bin/test-global-context
```

### Step 2: Update Agent Configuration

**Modify the agent's system prompt to include:**
- Mandatory global context loading
- Context precedence rules
- Keyword-based context discovery
- Integration awareness

### Step 3: Test Context Loading

**Test with these scenarios:**

1. **Code Task**: "Write a Python function"
   - Should load: `index.md` → `core/standards/code.md`

2. **n8n Task**: "Debug n8n workflow"
   - Should load: `index.md` → `integrations/n8n/config.md` → `integrations/n8n/usage-guide.md`

3. **Complex Task**: "Build user authentication system"
   - Should load: `index.md` → `core/standards/code.md` → `core/workflows/delegation.md`

### Step 4: Validate Behavior

**Ensure the agent:**
- ✅ Loads global context automatically
- ✅ Uses correct context precedence
- ✅ Discovers relevant contexts via keywords
- ✅ Applies global standards consistently
- ✅ Accesses integrations when needed

## Context File Locations

### Critical Files (Always Available)
```
~/.opencode/context/
├── index.md                           # Context discovery map
├── core/
│   ├── standards/
│   │   ├── code.md                   # Universal coding standards
│   │   ├── docs.md                   # Documentation standards
│   │   ├── tests.md                  # Testing standards
│   │   └── patterns.md               # Core patterns
│   ├── workflows/
│   │   ├── delegation.md             # Task delegation
│   │   ├── review.md                 # Code review
│   │   └── sessions.md               # Session management
│   └── system/
│       ├── context-guide.md          # Context usage
│       └── validation-checklist.md   # Validation protocol
├── global/
│   ├── machine.md                    # Tools and environment
│   ├── environments.md               # Environment config
│   └── project-setup.md              # Project creation
└── integrations/
    ├── n8n/
    │   ├── config.md                 # n8n connection & API
    │   └── usage-guide.md            # n8n debugging
    └── index.md                      # Integration overview
```

### Environment Configuration
```
~/.opencode/.env                      # Environment variables
~/.opencode/bin/                      # Utility scripts
```

## Troubleshooting

### Context Not Loading
```bash
# Check if global context exists
ls -la ~/.opencode/context/

# Test context accessibility
~/.opencode/bin/test-global-context

# Verify index structure
cat ~/.opencode/context/index.md
```

### Wrong Context Precedence
```bash
# Verify global precedence is documented
grep -r "Global Configuration" ~/.opencode/context/

# Check for local overrides (should not exist)
find . -name ".opencode" -type d
```

### Integration Issues
```bash
# Test n8n integration
~/.opencode/bin/n8n-test

# Check environment variables
grep "N8N_" ~/.opencode/.env
```

## Success Criteria

**The agent behavior is correctly configured when:**

1. ✅ **Automatic Loading**: Global context loads at session start
2. ✅ **Correct Precedence**: Global takes priority over local
3. ✅ **Keyword Discovery**: Relevant contexts loaded based on task
4. ✅ **Integration Access**: n8n and other integrations available
5. ✅ **Consistent Standards**: Universal coding standards applied
6. ✅ **Efficient Loading**: Only relevant contexts loaded (lazy loading)

## Validation Commands

```bash
# Test global context structure
~/.opencode/bin/test-global-context

# Validate context files
~/.opencode/bin/validate-structure

# Test n8n integration
~/.opencode/bin/n8n-test

# Check environment
cat ~/.opencode/.env | grep -E "(N8N_|VPS_)"
```

---

**Result**: Agent automatically loads global context, applies correct precedence, and has access to all integrations and standards from the start of each session.