# Project Creation Integration

## Automatic Project Setup Detection

### Project Creation Triggers

When users request project creation, automatically use the setup-project system:

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
# 3. Execute setup-project automatically
# 4. Guide user through customization

# Example flow:
User: "Create a new Python API project called user-service"
OpenCode: 
  → Detects: project creation intent
  → Extracts: name="user-service", type="python", framework="api"
  → Executes: setup-project user-service --type python --framework fastapi
  → Guides: "Project created! Let's customize your contexts..."
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

**Existing Directories:**
```
⚠️ Directory ~/dev/user-service already exists
Options:
1. Use different name
2. Continue anyway (merge)
3. Backup existing and recreate
```

**Unknown Stack:**
```
❓ I don't recognize 'obscure-framework'
Available options:
- Python: fastapi, django, flask
- Node.js: express, react, nextjs
- Go: gin, echo, fiber
- Or specify --type generic for custom setup
```

## Implementation in Global Context

### Agent Instructions

Add to all primary agents (OpenAgent, OpenCoder):

```markdown
## Project Creation Detection

When user requests project creation:

1. **Detect Intent**: Look for project creation keywords
2. **Extract Parameters**: Parse project name, type, framework
3. **Execute Setup**: Run setup-project command automatically
4. **Guide Customization**: Help user customize contexts
5. **Verify Success**: Confirm project is ready for development

**Always use setup-project for new projects** - never create projects manually.
```

### Context Loading Priority

When working in newly created projects:

1. **Load global contexts** first (as always)
2. **Load local contexts** from .opencode/context/
3. **Prompt for customization** if templates not updated
4. **Guide through first development steps**

### Integration Examples

**Example 1: Simple API**
```
User: "Create a Python API for user management"
OpenCode: 
  → setup-project user-management-api --type python --framework fastapi
  → "Great! I've created your FastAPI project. Let's define your user management requirements..."
  → Updates .opencode/context/project.md with user management context
```

**Example 2: Full Stack App**
```
User: "Build a React dashboard with Express backend"
OpenCode:
  → setup-project dashboard-frontend --type node --framework react
  → setup-project dashboard-backend --type node --framework express
  → "I've created both frontend and backend projects. Let's configure their integration..."
```

**Example 3: Data Pipeline**
```
User: "Create a data processing pipeline in Python"
OpenCode:
  → setup-project data-pipeline --type python
  → "Data pipeline project created! Let's define your data sources and processing steps..."
  → Guides through data pipeline specific context setup
```

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