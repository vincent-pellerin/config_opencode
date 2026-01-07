# Project Setup Guide

## Using the System Builder

### Quick Setup Command

```bash
# Create new project with complete OpenCode architecture
opencode --command build-context-system -- PROJECT_NAME --type TYPE
```

### Supported Project Types

| Type | Languages | Default Framework | Use Case |
|------|-----------|------------------|----------|
| `python` | Python 3.12+ | - | APIs, data processing, ML |
| `node` | TypeScript/JavaScript | - | Web apps, APIs, services |
| `go` | Go | - | High-performance services |
| `rust` | Rust | - | System programming, performance |
| `generic` | Any | - | Custom projects |

### Examples

```bash
# Python API project
opencode --command build-context-system -- my-api --type python

# Node.js web app
opencode --command build-context-system -- my-app --type node

# Data processing pipeline
opencode --command build-context-system -- data-pipeline --type python

# Go service
opencode --command build-context-system -- my-service --type go

# Generic project
opencode --command build-context-system -- my-tool --type generic
```

## What Gets Created

### Project Structure

```
PROJECT_NAME/
├── .gitignore              # ✅ .opencode/ automatically ignored
├── .opencode/              # ✅ Complete OpenCode configuration
│   ├── agent/              # Custom agents and subagents
│   ├── command/            # Custom slash commands
│   ├── context/            # Domain-specific contexts
│   │   ├── domain/         # Domain concepts and terminology
│   │   ├── processes/      # Workflow documentation
│   │   ├── standards/      # Quality criteria
│   │   └── templates/      # Output formats and patterns
│   └── workflows/          # Workflow definitions
├── src/                    # Source code
├── tests/                  # Test suites
├── config/                 # Configuration files
├── docs/                   # Documentation
├── scripts/                # Utility scripts
└── README.md               # Project documentation
```

### OpenCode Configuration

#### Global References (Automatic)
Every local config automatically references global contexts:
- `@~/.opencode/context/core/standards/code.md` - Universal code standards
- `@~/.opencode/context/global/tools.md` - CLI commands and tools
- `@~/.opencode/context/global/environments.md` - Environment configuration

#### Local Contexts (Project-Specific)
The system builder creates:
- **domain/**: Domain concepts, terminology, business rules
- **processes/**: Step-by-step procedures, workflows
- **standards/**: Quality criteria, validation rules, error handling
- **templates/**: Output formats, reusable patterns

## Configuration Precedence

### ✅ Global Configuration (Priority)
- `~/.opencode/` **ALWAYS** takes precedence
- Universal standards cannot be overridden
- Shared across all projects

### ✅ Local Configuration (Additive)
- `PROJECT/.opencode/` adds project-specific context
- Complements global configuration
- **NEVER** committed to Git (automatically in .gitignore)

## What to Expect

### Interactive Interview
The system builder will ask you:
1. **Domain & Purpose**: What is your industry? What's the system purpose?
2. **Use Cases**: What tasks should the system handle?
3. **Complexity**: How many specialized agents? What integrations?
4. **Review**: Confirm the architecture before generation

### Generated Files

| Category | Files | Description |
|----------|-------|-------------|
| Agents | 3-5 files | Orchestrator + subagents tailored to your domain |
| Commands | 2-3 files | Custom slash commands for common operations |
| Context | 6-10 files | Domain knowledge, processes, standards, templates |
| Workflows | 2-5 files | Defined workflows with stages and criteria |

## Best Practices

### ✅ Do This
- Use `/build-context-system` for all new projects
- Customize generated contexts after creation
- Keep global config in `~/.opencode/` updated
- Reference global contexts in local configs
- Add `.opencode/` to `.gitignore` (automatic)

### ❌ Don't Do This
- Don't commit `.opencode/` directories to Git
- Don't override global standards in local configs
- Don't create projects without using the system builder
- Don't skip the interactive interview - it's quick and valuable!

## Troubleshooting

### Command Not Found
```bash
# Verify build-context-system is installed
ls ~/.opencode/command/build-context-system.md

# If missing, reinstall OpenCode agents
# Check OpenCode CLI installation
```

### Permission Issues
```bash
# Verify OpenCode is properly configured
opencode --help

# Reinstall if needed
```

### Interview Questions
The interview is quick (3-5 minutes). Answer honestly for best results:
- Be specific about your domain
- List your actual use cases
- Don't overcomplicate - start simple

## Integration with Existing Projects

### Add OpenCode to Existing Project
```bash
cd existing-project

# Run system builder in existing directory
opencode --command build-context-system -- $(basename "$(pwd)") --type python
```

### Migrate from Manual Setup
If you have manually created `.opencode/` configs:
1. Backup existing configs
2. Run system builder with same project name
3. Compare and merge configurations
4. Update references to global contexts

This automated setup ensures every new project follows OpenCode standards and has proper configuration precedence.
