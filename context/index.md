# OpenCode Context Index

## Quick Map (Common Tasks)

- **Code task** → `core/standards/code.md`
- **Documentation** → `core/standards/docs.md`
- **Testing** → `core/standards/tests.md`
- **Code review** → `core/workflows/review.md`
- **Task delegation** → `core/workflows/delegation.md`
- **n8n debugging** → `integrations/n8n/config.md`

## Context Categories

### Core Standards (Quality Guidelines)
- `core/standards/code.md` - Modular, functional code principles [critical]
- `core/standards/docs.md` - Documentation standards [critical]
- `core/standards/tests.md` - Testing standards [critical]
- `core/standards/patterns.md` - Core patterns (error handling, security) [high]
- `core/standards/analysis.md` - Analysis framework [high]

### Core Workflows (Process Templates)
- `core/workflows/delegation.md` - Delegation template [high]
- `core/workflows/task-breakdown.md` - Complex task breakdown [high]
- `core/workflows/sessions.md` - Session lifecycle [medium]
- `core/workflows/review.md` - Code review guidelines [high]

### Core System (Internal Guidelines)
- `core/system/context-guide.md` - Context system usage [critical]
- `core/system/validation-checklist.md` - Structure validation checklist [critical]
- `core/system/validation-protocol.md` - Integrated validation workflow [critical]

### Global Context
- `global/environments.md` - Environment configurations
- `global/tools.md` - CLI tools and commands
- `global/machine.md` - Machine-specific settings
- `global/docker-services.md` - Docker service configurations
- `global/project-setup.md` - Project setup patterns
- `global/project-creation.md` - Project creation workflows

### Integrations
- `integrations/n8n/config.md` - n8n API connection and debugging
- `integrations/index.md` - Integration overview

## Triggers and Keywords

### Code Development
**Triggers**: code, implementation, function, class, module, refactor
**Load**: `core/standards/code.md`
**Deps**: `core/standards/patterns.md`

### Documentation
**Triggers**: docs, readme, documentation, comments, api docs
**Load**: `core/standards/docs.md`

### Testing
**Triggers**: test, testing, unit test, integration test, pytest
**Load**: `core/standards/tests.md`
**Deps**: `core/standards/code.md`

### Code Review
**Triggers**: review, pr, pull request, code review, audit
**Load**: `core/workflows/review.md`
**Deps**: `core/standards/code.md`, `core/standards/patterns.md`

### Task Management
**Triggers**: delegate, complex task, multi-file, breakdown
**Load**: `core/workflows/delegation.md`, `core/workflows/task-breakdown.md`

### n8n Workflow Debugging
**Triggers**: n8n, workflow, automation, api integration, debugging
**Load**: `integrations/n8n/config.md`
**Usage**: `integrations/n8n/usage-guide.md`

### Analysis and Investigation
**Triggers**: analyze, investigate, bug, performance, architecture
**Load**: `core/standards/analysis.md`

### Environment Setup
**Triggers**: environment, setup, configuration, docker, tools
**Load**: `global/environments.md`, `global/tools.md`

### Structure Validation
**Triggers**: validate, structure, standards, compliance, file creation
**Load**: `core/system/validation-checklist.md`, `core/system/validation-protocol.md`
**Tool**: `~/.opencode/bin/validate-structure`

## Usage Patterns

### Lazy Loading (Recommended)
1. Check quick map for common tasks
2. Load specific context files as needed
3. Follow dependency chains when required

### Context Dependencies
- `code.md` → often needs `patterns.md`
- `tests.md` → depends on `code.md`
- `review.md` → needs `code.md` + `patterns.md`
- `delegation.md` → may need task-specific contexts

### Session Context
- Create temporary context in `.tmp/sessions/{id}/context.md`
- Include relevant static context references
- Clean up after task completion

---

**Golden Rule**: Fetch context when needed, not before (lazy loading)