# OpenCode Team Guide

## 🚀 Quick Start for New Team Members

### 1. Install OpenCode Configuration

```bash
# Clone the configuration repository
git clone https://github.com/VOTRE_USERNAME/config_opencode.git ~/config_opencode

# Run automated installation
cd ~/config_opencode
chmod +x setup/*.sh
./setup/install.sh

# Restart terminal or reload shell
source ~/.zshrc  # or ~/.bashrc
```

### 2. Verify Installation

```bash
# Check OpenCode version
opencode --version  # Should show: 1.1.2+

# Verify configuration
ls -la ~/.opencode/context/

# Test project setup
setup-project test-project --type python
```

### 3. Create Your First Project

```bash
# Create new project with OpenCode configuration
setup-project my-awesome-project --type python --framework fastapi

# Navigate to project
cd ~/dev/my-awesome-project

# Customize project contexts
vim .opencode/context/stack.md
vim .opencode/context/patterns.md
vim .opencode/context/project.md
```

## 📋 OpenCode Architecture Overview

### Global Configuration (`~/.opencode/`)
- **Universal standards** that apply to all projects
- **Shared workflows** for code review, delegation, testing
- **Machine configuration** for tools and environments
- **Cannot be overridden** by local project configs

### Local Configuration (`PROJECT/.opencode/`)
- **Project-specific** technology stack and patterns
- **Business context** and objectives
- **Automatically references** global standards
- **Never committed** to Git (in .gitignore)

### Configuration Precedence
```
Global Config (~/.opencode/) → ALWAYS PRIORITY
    ↓
Local Config (PROJECT/.opencode/) → Additive only
```

## 🛠️ Development Workflow

### Starting New Projects

```bash
# 1. Create project with proper setup
setup-project PROJECT_NAME --type TYPE --framework FRAMEWORK

# 2. Customize OpenCode contexts
cd PROJECT_NAME
vim .opencode/context/stack.md      # Technology stack
vim .opencode/context/patterns.md   # Business patterns  
vim .opencode/context/project.md    # Project mission

# 3. Initialize Git repository
git init
git add .
git commit -m "feat: initial project setup"

# 4. Start development
# OpenCode will automatically load global + local contexts
```

### Working with Existing Projects

```bash
# If project doesn't have OpenCode config
cd existing-project

# Add OpenCode configuration
mkdir -p .opencode/context
cp ~/.opencode/templates/project/.opencode/context/* .opencode/context/

# Add to .gitignore (if not already there)
echo ".opencode/" >> .gitignore

# Customize contexts for the project
vim .opencode/context/stack.md
```

## 🎯 OpenCode Agents & Usage

### Primary Agents

| Agent | Usage | Command |
|-------|-------|---------|
| **OpenAgent** | General tasks, coordination | `opencode` (default) |
| **OpenCoder** | Pure development, code focus | `opencode --agent opencoder` |
| **System Builder** | Complete system generation | `opencode --agent system-builder` |

### Subagents (via task tool)

| Subagent | Purpose | When to Use |
|----------|---------|-------------|
| `task-manager` | Break complex features | 4+ files, >60 min tasks |
| `coder-agent` | Focused implementation | Simple coding tasks |
| `tester` | Test-driven development | Writing tests, TDD |
| `reviewer` | Code review & security | PR reviews, audits |
| `build-agent` | Build validation | CI/CD, type checking |

### Example Usage

```bash
# General development
opencode "Add user authentication to my API"

# Pure coding focus
opencode --agent opencoder "Implement JWT token validation"

# Complex feature breakdown
opencode "Build a complete e-commerce checkout system"
# → Will delegate to task-manager for breakdown

# Code review
opencode --agent reviewer "Review this pull request for security issues"
```

## 📚 Context System

### Global Contexts (Always Loaded)

| Context | Purpose | When Loaded |
|---------|---------|-------------|
| `code.md` | Universal code standards | All coding tasks |
| `tools.md` | CLI commands reference | Tool usage |
| `environments.md` | Environment setup | Deployment, config |

### Local Contexts (Project-Specific)

| Context | Purpose | Content |
|---------|---------|---------|
| `stack.md` | Technology stack | Languages, frameworks, tools |
| `patterns.md` | Business patterns | Domain logic, workflows |
| `project.md` | Project context | Mission, objectives, stakeholders |

### Context Loading Rules

1. **Global contexts** are loaded automatically
2. **Local contexts** complement global ones
3. **No conflicts** - local cannot override global
4. **Lazy loading** - contexts loaded when needed

## 🔐 Security & Best Practices

### ✅ Do This

- **Use `setup-project`** for all new projects
- **Customize local contexts** after project creation
- **Keep global config updated** via config_opencode repo
- **Never commit `.opencode/`** directories (auto-ignored)
- **Reference global contexts** in local configs

### ❌ Don't Do This

- **Don't commit** `.opencode/` to Git repositories
- **Don't override** global standards in local configs
- **Don't skip** customizing template placeholders
- **Don't hardcode** secrets in context files

### Security Guidelines

```bash
# ✅ Good: Environment variables
API_KEY=your_secret_key

# ❌ Bad: Hardcoded in context files
# Never put secrets in .opencode/context/ files
```

## 🔄 Keeping Configuration Updated

### Update Global Configuration

```bash
# Pull latest configuration
cd ~/config_opencode
git pull

# Reinstall updated configuration
./setup/install.sh

# Verify update
opencode --version
```

### Share Configuration Changes

```bash
# Update global config repository
cd ~/config_opencode

# Make changes to global contexts
vim context/global/tools.md

# Commit and push
git add .
git commit -m "feat: add new development tool"
git push

# Team members can then pull updates
```

## 🐛 Troubleshooting

### Common Issues

#### OpenCode Command Not Found
```bash
# Add to PATH
echo 'export PATH=$HOME/.opencode/bin:$PATH' >> ~/.zshrc
source ~/.zshrc
```

#### setup-project Not Found
```bash
# Make script executable
chmod +x ~/.opencode/bin/setup-project

# Or reinstall configuration
cd ~/config_opencode
./setup/install.sh
```

#### Context Files Not Loading
```bash
# Check global context exists
ls -la ~/.opencode/context/core/standards/code.md

# Check local context references global
grep "@~/.opencode" PROJECT/.opencode/context/stack.md
```

#### .opencode/ Accidentally Committed
```bash
# Remove from Git (keep local files)
git rm -r --cached .opencode/
echo ".opencode/" >> .gitignore
git add .gitignore
git commit -m "fix: remove .opencode/ from Git tracking"
```

### Getting Help

1. **Check documentation**: `~/.opencode/README.md`
2. **Verify installation**: `./setup/verify.sh`
3. **Check logs**: OpenCode operation logs
4. **Team support**: Ask team members familiar with OpenCode

## 📈 Advanced Usage

### Custom Project Templates

```bash
# Create custom template
mkdir -p ~/.opencode/templates/my-template
# Add custom template files

# Use custom template
setup-project my-project --template my-template
```

### Batch Project Setup

```bash
# Setup multiple related projects
for service in api frontend mobile; do
    setup-project my-app-$service --type node
done
```

### CI/CD Integration

```yaml
# .github/workflows/setup.yml
name: Setup Project
on: [push]
jobs:
  setup:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup OpenCode
        run: |
          # Install OpenCode configuration
          # Run project setup if needed
```

## 🎓 Learning Resources

### Essential Reading

1. **Global Standards**: `~/.opencode/context/core/standards/code.md`
2. **Project Setup**: `~/.opencode/context/global/project-setup.md`
3. **Workflows**: `~/.opencode/context/core/workflows/`

### Practice Exercises

1. **Create a Python API** with `setup-project`
2. **Customize contexts** for your domain
3. **Use different agents** for various tasks
4. **Practice code review** with reviewer agent

### Team Collaboration

- **Share context improvements** via config_opencode repo
- **Document project-specific patterns** in local contexts
- **Use consistent naming** across projects
- **Regular config updates** to stay synchronized

---

**Welcome to the OpenCode team! 🚀**

This configuration system will help you build better software faster while maintaining consistency across all projects.