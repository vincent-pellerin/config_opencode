# Project Setup Guide

## Automatic Project Setup

### Quick Setup Command

```bash
# Setup new project with OpenCode configuration
setup-project PROJECT_NAME --type TYPE --framework FRAMEWORK
```

### Supported Project Types

| Type | Languages | Default Framework | Use Case |
|------|-----------|------------------|----------|
| `python` | Python 3.12+ | FastAPI | APIs, data processing, ML |
| `node` | TypeScript/JavaScript | Express | Web apps, APIs, services |
| `go` | Go | Gin | High-performance services |
| `rust` | Rust | Axum | System programming, performance |
| `generic` | Any | None | Custom projects |

### Examples

```bash
# Python API project
setup-project my-api --type python --framework fastapi

# React web app
setup-project my-app --type node --framework react

# Data processing pipeline
setup-project data-pipeline --type python

# Custom directory
setup-project my-project --directory /custom/path

# Generic project
setup-project my-tool --type generic
```

## What Gets Created

### Project Structure
```
PROJECT_NAME/
├── .gitignore              # ✅ .opencode/ automatically ignored
├── .opencode/              # ✅ Local OpenCode configuration
│   └── context/
│       ├── stack.md        # Technology stack
│       ├── patterns.md     # Business patterns
│       └── project.md      # Project context
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
- **stack.md**: Technology stack, libraries, commands
- **patterns.md**: Business logic patterns, workflows
- **project.md**: Mission, objectives, stakeholders

## Configuration Precedence

### ✅ Global Configuration (Priority)
- `~/.opencode/` **ALWAYS** takes precedence
- Universal standards cannot be overridden
- Shared across all projects

### ✅ Local Configuration (Additive)
- `PROJECT/.opencode/` adds project-specific context
- Complements global configuration
- **NEVER** committed to Git (automatically in .gitignore)

## Post-Setup Customization

### 1. Customize Context Files
```bash
cd PROJECT_NAME
# Edit project-specific contexts
vim .opencode/context/stack.md      # Update technology stack
vim .opencode/context/patterns.md   # Add business patterns
vim .opencode/context/project.md    # Define project mission
```

### 2. Replace Template Placeholders
Look for and replace these markers:
- `[TODO: CUSTOMIZE]` - Generic placeholders
- `[DESCRIBE_ARCHITECTURE]` - System architecture
- `[DEFINE_PROJECT_MISSION]` - Project mission statement
- `[OBJECTIVE_1]` - Business objectives

### 3. Initialize Git Repository
```bash
git init
git add .
git commit -m "feat: initial project setup with OpenCode configuration"
```

## Language-Specific Setup

### Python Projects
```bash
setup-project my-api --type python --framework fastapi
cd my-api

# Install dependencies
uv sync

# Run development server
uv run python src/main.py
```

**Created files:**
- `pyproject.toml` - Modern Python configuration
- `requirements.txt` - Dependencies
- `src/main.py` - FastAPI application
- Pre-configured: Black, isort, Ruff, mypy

### Node.js Projects
```bash
setup-project my-app --type node --framework express
cd my-app

# Install dependencies
npm install

# Run development server
npm run dev
```

**Created files:**
- `package.json` - Node.js configuration
- `src/index.js` - Express application
- Pre-configured: ESLint, Prettier, Jest

### Go Projects
```bash
setup-project my-service --type go --framework gin
cd my-service

# Initialize Go module
go mod init my-service

# Install dependencies
go mod tidy

# Run application
go run main.go
```

### Rust Projects
```bash
setup-project my-tool --type rust --framework axum
cd my-tool

# Build project
cargo build

# Run application
cargo run
```

## Best Practices

### ✅ Do This
- Use `setup-project` for all new projects
- Customize `.opencode/context/` files after setup
- Keep global config in `~/.opencode/` updated
- Reference global contexts in local configs
- Add `.opencode/` to `.gitignore` (automatic)

### ❌ Don't Do This
- Don't commit `.opencode/` directories to Git
- Don't override global standards in local configs
- Don't skip customizing template placeholders
- Don't create projects without OpenCode setup

## Troubleshooting

### Script Not Found
```bash
# Add OpenCode bin to PATH
echo 'export PATH=$HOME/.opencode/bin:$PATH' >> ~/.zshrc
source ~/.zshrc
```

### Permission Denied
```bash
# Make script executable
chmod +x ~/.opencode/bin/setup-project
```

### Template Issues
```bash
# Verify templates exist
ls -la ~/.opencode/templates/project/
```

## Integration with Existing Projects

### Add OpenCode to Existing Project
```bash
cd existing-project

# Copy OpenCode configuration
mkdir -p .opencode/context
cp ~/.opencode/templates/project/.opencode/context/* .opencode/context/

# Add to .gitignore
echo ".opencode/" >> .gitignore

# Customize contexts
vim .opencode/context/stack.md
```

### Migrate from Manual Setup
If you have manually created `.opencode/` configs:
1. Backup existing configs
2. Run `setup-project` in temporary directory
3. Compare and merge configurations
4. Update references to global contexts

## Advanced Usage

### Custom Templates
Create project-specific templates in `~/.opencode/templates/`:
```bash
mkdir -p ~/.opencode/templates/my-template
# Add custom template files
```

### Batch Setup
```bash
# Setup multiple related projects
for project in api frontend mobile; do
    setup-project my-app-$project --type node
done
```

### CI/CD Integration
```yaml
# .github/workflows/setup.yml
- name: Setup OpenCode
  run: |
    setup-project ${{ github.event.repository.name }} --type python
```

This automated setup ensures every new project follows OpenCode standards and has proper configuration precedence.