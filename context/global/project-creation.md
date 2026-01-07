# Project Creation Integration

## Automatic Project Setup Detection

### Project Creation Triggers

When users request project creation, automatically use the build-context-system:

**Trigger Phrases:**
- "Create a new [TYPE] project"
- "Set up a [FRAMEWORK] application"
- "Initialize a [LANGUAGE] service"
- "Build a new [PROJECT_TYPE] called [NAME]"
- "Start a fresh [STACK] project"

**Examples:**
- "Create a new Python API project called user-service"
- "Set up a React application for my dashboard"
- "Initialize a FastAPI service for data processing"
- "Build a new Node.js app called frontend"

### Automatic Detection Logic

```bash
# When OpenCode detects project creation intent:
# 1. Parse project requirements from user input
# 2. Determine project type and framework
# 3. Execute build-context-system automatically
# 4. Guide user through interactive interview

# Example flow:
User: "Create a new Python API project called user-service"
OpenCode: 
  → Detects: project creation intent
  → Extracts: name="user-service", type="python"
  → Executes: opencode --command build-context-system -- user-service --type python
  → Starts: Interactive interview for architecture customization
```

### Integration Commands

**Primary Command Pattern:**
```bash
opencode --command build-context-system -- PROJECT_NAME --type TYPE
```

**Supported Variations:**
- `opencode --command build-context-system -- my-api --type python`
- `opencode --command build-context-system -- my-app --type node`
- `opencode --command build-context-system -- my-service --type go --framework gin`

### Automatic Framework Detection

| User Input | Detected Type | Default Framework |
|------------|---------------|-------------------|
| "Python API" | python | fastapi |
| "React app" | node | react |
| "Express server" | node | express |
| "Go service" | go | gin |
| "Rust CLI" | rust | clap |
| "Django app" | python | django |
| "Next.js app" | node | nextjs |

### Post-Creation Workflow

After automatic build-context-system execution:

1. **Interactive Interview**
   ```
   🎯 Welcome to the System Builder!
   
   I'll help you create a complete OpenCode architecture for your project.
   
   Phase 1: Domain & Purpose
   - What is your primary domain or industry?
   - What is the primary purpose of this system?
   - Who are the primary users?
   ```

2. **Architecture Generation**
   ```
   📐 Generating your custom architecture...
   
   Created:
   ├── .opencode/agent/
   │   ├── my-api-orchestrator.md
   │   └── subagents/
   ├── .opencode/command/
   ├── .opencode/context/
   │   ├── domain/
   │   ├── processes/
   │   ├── standards/
   │   └── templates/
   └── .opencode/workflows/
   ```

3. **Confirm Ready**
   ```
   ✅ Your context-aware AI system is ready!
   
   📁 Location: ~/dev/my-api
   🎯 Quick Start: cd ~/dev/my-api
   
   Next steps:
   1. Test the orchestrator with a simple request
   2. Customize context files with your domain knowledge
   3. Add your specific workflows and patterns
   ```

### Integration Commands

**Primary Command Pattern:**
```bash
opencode "create project [NAME] with [STACK]"
```

**Supported Variations:**
- `opencode "new python api called user-service"`
- `opencode "setup react app for dashboard"`
- `opencode "initialize go service with gin"`
- `opencode "build rust cli tool named parser"`

### Automatic Framework Detection

| User Input | Detected Type | Default Framework |
|------------|---------------|-------------------|
| "Python API" | python | fastapi |
| "React app" | node | react |
| "Express server" | node | express |
| "Go service" | go | gin |
| "Rust CLI" | rust | clap |
| "Django app" | python | django |
| "Next.js app" | node | nextjs |

### Post-Creation Workflow

After automatic setup-project execution:

1. **Confirm Creation**
   ```
   ✅ Project 'user-service' created successfully!
   📁 Location: ~/dev/user-service
   🔧 Type: Python FastAPI
   ```

2. **Guide Customization**
   ```
   🎯 Next: Let's customize your project contexts
   
   I'll help you update:
   - .opencode/context/stack.md (technology details)
   - .opencode/context/patterns.md (business logic)
   - .opencode/context/project.md (mission & objectives)
   
   Shall we start with the project mission?
   ```

3. **Interactive Setup**
   - Ask about project mission and objectives
   - Gather technology stack details
   - Define business patterns and workflows
   - Update context files automatically

### Error Handling

**Invalid Project Names:**
```
❌ Project name 'my project' contains spaces
✅ Suggested: 'my-project' or 'my_project'
```

**Unknown Type:**
```
❓ Unknown project type 'obscure-type'
Available options:
- python, node, go, rust, generic
Use --type to specify
```

**Existing Directory:**
```
⚠️ Directory ~/dev/user-service already exists
Options:
1. Choose different name
2. Use --merge to extend existing
3. Use --replace to backup and recreate
```

### Integration Examples

**Example 1: Simple API**
```
User: "Create a Python API for user management"
OpenCode: 
  → opencode --command build-context-system -- user-api --type python
  → Interview: "What domain? What's the primary purpose?"
  → Generates complete architecture with user-management context
```

**Example 2: Full Stack App**
```
User: "Build a React dashboard with Express backend"
OpenCode:
  → opencode --command build-context-system -- dashboard-frontend --type node --framework react
  → Interactive interview for frontend architecture
  → Creates both frontend and backend architectures
```

**Example 3: Data Pipeline**
```
User: "Create a data processing pipeline in Python"
OpenCode:
  → opencode --command build-context-system -- data-pipeline --type python
  → Interview: "What data sources? What transformations?"
  → Generates pipeline-specific architecture

## Implementation in Global Context

### Agent Instructions

Add to all primary agents (OpenAgent, OpenCoder):

```markdown
## Project Creation Detection

When user requests project creation:

1. **Detect Intent**: Look for project creation keywords
2. **Extract Parameters**: Parse project name and type from user input
3. **Execute System Builder**: Run `/build-context-system -- PROJECT_NAME --type TYPE`
4. **Guide Interview**: Help user through requirements gathering
5. **Verify Success**: Confirm project is ready for development

**Always use /build-context-system for new projects** - never create projects manually.
```

### Context Loading Priority

When working in newly created projects:

1. **Load global contexts** first (as always)
2. **Load local contexts** from .opencode/context/ (created by build-context-system)
3. **Use custom workflows** defined in .opencode/workflows/
4. **Execute commands** from .opencode/command/

### Integration Examples

**Example 1: Simple API**
```
User: "Create a Python API for user management"
OpenCode: 
  → opencode --command build-context-system -- user-api --type python
  → "Great! Let's design your user management API architecture..."
  → Updates .opencode/ with complete user-management context
```

**Example 2: Full Stack App**
```
User: "Build a React dashboard with Express backend"
OpenCode:
  → opencode --command build-context-system -- dashboard --type node --framework react
  → "I'll create a complete dashboard architecture..."
  → Guides through frontend + backend customization
```

**Example 3: Data Pipeline**
```
User: "Create a data processing pipeline in Python"
OpenCode:
  → opencode --command build-context-system -- data-pipeline --type python
  → "Data pipeline architecture coming up!"
  → Generates pipeline-specific context and workflows

## Benefits of Automatic Integration

### ✅ User Experience
- **One command** instead of two
- **Natural language** project creation
- **Guided setup** with context customization
- **Consistent structure** across all projects

### ✅ Developer Productivity
- **Faster project creation** (30 seconds → 10 seconds)
- **No manual setup** required
- **Automatic best practices** applied
- **Immediate development readiness**

### ✅ Team Consistency
- **Standardized project structure** always
- **Proper OpenCode configuration** guaranteed
- **No forgotten .gitignore** rules
- **Consistent context references**

This integration makes project creation seamless and automatic while maintaining all the security and consistency benefits we've built.