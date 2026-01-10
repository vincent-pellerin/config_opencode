# Project Context & Architecture

## Global Context References

For detailed environment, tools, and infrastructure information, see:
- **@.opencode/context/global/environments.md** - Complete environment configuration (local, VPS vincent, VPS dlthub)
- **@.opencode/context/global/machine.md** - Installed tools and software stack
- **@.opencode/context/global/tools.md** - CLI commands and usage reference
- **@.opencode/context/global/docker-services.md** - Docker services on VPS (Traefik, n8n, Matomo)

## Environment Architecture

### Quick Environment Detection
```bash
# Detect current environment
CURRENT_ENV="$(whoami)@$(hostname)"

if [[ "$CURRENT_ENV" == "vincent@vincent-X390-2025" ]]; then
    echo "Local Development Environment"
elif [[ "$CURRENT_ENV" == "vincent@host" ]]; then
    echo "VPS Production Environment (vincent)"
elif [[ "$CURRENT_ENV" == "dlthub@host" ]]; then
    echo "VPS Production Environment (dlthub)"
else
    echo "Unknown Environment: $CURRENT_ENV"
fi
```

### Environment Summary

#### Local Development
- **Hostname:** `vincent-X390-2025`
- **User:** `vincent`
- **Path:** `/home/vincent/dev/`
- **Purpose:** Development, testing, local Obsidian vault

#### VPS Production (vincent)
- **Hostname:** `host`
- **User:** `vincent`
- **SSH Alias:** `vps_h`
- **Path:** `/home/vincent/`
- **Purpose:** Production services, Docker, Obsidian vault, web scraping

#### VPS Production (dlthub)
- **Hostname:** `host`
- **User:** `dlthub`
- **SSH Alias:** `vps_dlt`
- **Path:** `/home/dlthub/`
- **Purpose:** dlt pipelines, dbt transformations, BigQuery operations

### Project Mapping

| Project | Local | VPS | VPS User | Stack |
|---------|-------|-----|----------|-------|
| **dlthub-unified** | `/home/vincent/dev/dlthub-unified/` | `/home/dlthub/dlthub-project/dlthub-unified/` | `dlthub` (vps_dlt) | Python, dlt, dbt, BigQuery |
| **immo-stras** | `/home/vincent/dev/immo-stras/` | `/home/vincent/immo-stras/` | `vincent` (vps_h) | Python, Playwright, DuckDB, PostgreSQL |
| **ga4-weekly-report** | `/home/vincent/dev/ga4-weekly-report/` | `/home/vincent/ga4-weekly-report/` | `vincent` (vps_h) | Python, GA4 API, BigQuery |

### Critical Rules for Agents
- **ALWAYS verify environment** before executing commands
- **Use appropriate SSH alias** for VPS operations (`vps_h` or `vps_dlt`)
- **Check project mapping** to determine correct VPS user and path
- **Consult global context files** for detailed configuration

## Technology Stack

**Primary Language:** TypeScript
**Runtime:** Node.js/Bun
**Package Manager:** npm/pnpm/yarn
**Build Tools:** TypeScript Compiler (tsc)
**Testing:** Jest/Vitest (if configured)
**Linting:** ESLint (if configured)

## Project Structure

```
.opencode/
├── agent/           # AI agents for specific tasks
│   ├── subagents/   # Specialized subagents
│   └── *.md         # Primary agents
├── command/         # Slash commands
├── context/         # Knowledge base for agents
└── plugin/          # Extensions and integrations

tasks/               # Task management files
```

## Core Patterns

### Agent Structure Pattern
```markdown
---
description: "What this agent does"
mode: primary|subagent
tools: [read, edit, bash, etc.]
permissions: [security restrictions]
---

# Agent Name

[Direct instructions for behavior]

**EXECUTE** this [process type] for every [task type]:

**1. [ACTION]** the [subject]:
- [Specific instruction 1]
- [Specific instruction 2]

**RULES:**
- **ALWAYS** [critical requirement]
- **NEVER** [forbidden action]
```

### Command Structure Pattern
```markdown
---
name: command-name
agent: target-agent
---

You are [doing specific task].

**Request:** $ARGUMENTS

**Context Loaded:**
@.opencode/context/core/essential-patterns.md
@[additional context files]

Execute [task] now.
```

### Context Loading Rules
- Commands load context immediately using @ references
- Agents can look up additional context deterministically
- Maximum 4 context files per command (250-450 lines total)
- Keep context files focused (50-150 lines each)

## Security Guidelines

- Agents have restricted permissions by default
- Sensitive operations require explicit approval
- No direct file system modifications without validation
- Build commands limited to safe operations

## Development Workflow

1. **Planning:** Create detailed task plans for complex work
2. **Implementation:** Execute one step at a time with validation
3. **Review:** Code review and security checks
4. **Testing:** Automated testing and build validation
5. **Documentation:** Update docs and context files

## Quality Gates

- TypeScript compilation passes
- Code review completed
- Build process succeeds
- Tests pass (if available)
- Documentation updated