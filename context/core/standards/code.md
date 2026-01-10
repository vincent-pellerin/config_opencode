<!-- Context: standards/code | Priority: critical | Version: 2.0 | Updated: 2025-01-21 -->
# Code Standards

## Quick Reference

**Core Philosophy**: Modular, Functional, Maintainable
**Golden Rule**: If you can't easily test it, refactor it

**Critical Patterns** (use these):
- ✅ Pure functions (same input = same output, no side effects)
- ✅ Immutability (create new data, don't modify)
- ✅ Composition (build complex from simple)
- ✅ Small functions (< 50 lines)
- ✅ Explicit dependencies (dependency injection)

**Anti-Patterns** (avoid these):
- ❌ Mutation, side effects, deep nesting
- ❌ God modules, global state, large functions

---

## Core Philosophy

**Modular**: Everything is a component - small, focused, reusable
**Functional**: Pure functions, immutability, composition over inheritance
**Maintainable**: Self-documenting, testable, predictable

## Principles

### Modular Design
- Single responsibility per module
- Clear interfaces (explicit inputs/outputs)
- Independent and composable
- < 100 lines per component (ideally < 50)

### Functional Approach
- **Pure functions**: Same input = same output, no side effects
- **Immutability**: Create new data, don't modify existing
- **Composition**: Build complex from simple functions
- **Declarative**: Describe what, not how

### Component Structure
```
component/
├── index.js      # Public interface
├── core.js       # Core logic (pure functions)
├── utils.js      # Helpers
└── tests/        # Tests
```

## Patterns

### Pure Functions
```javascript
// ✅ Pure
const add = (a, b) => a + b;
const formatUser = (user) => ({ ...user, fullName: `${user.firstName} ${user.lastName}` });

// ❌ Impure (side effects)
let total = 0;
const addToTotal = (value) => { total += value; return total; };
```

### Immutability
```javascript
// ✅ Immutable
const addItem = (items, item) => [...items, item];
const updateUser = (user, changes) => ({ ...user, ...changes });

// ❌ Mutable
const addItem = (items, item) => { items.push(item); return items; };
```

### Composition
```javascript
// ✅ Compose small functions
const processUser = pipe(validateUser, enrichUserData, saveUser);
const isValidEmail = (email) => validateEmail(normalizeEmail(email));

// ❌ Deep inheritance
class ExtendedUserManagerWithValidation extends UserManager { }
```

### Declarative
```javascript
// ✅ Declarative
const activeUsers = users.filter(u => u.isActive).map(u => u.name);

// ❌ Imperative
const names = [];
for (let i = 0; i < users.length; i++) {
  if (users[i].isActive) names.push(users[i].name);
}
```

## Naming

- **Files**: lowercase-with-dashes.js
- **Functions**: verbPhrases (getUser, validateEmail)
- **Predicates**: isValid, hasPermission, canAccess
- **Variables**: descriptive (userCount not uc), const by default
- **Constants**: UPPER_SNAKE_CASE

## Error Handling

```javascript
// ✅ Explicit error handling
function parseJSON(text) {
  try {
    return { success: true, data: JSON.parse(text) };
  } catch (error) {
    return { success: false, error: error.message };
  }
}

// ✅ Validate at boundaries
function createUser(userData) {
  const validation = validateUserData(userData);
  if (!validation.isValid) {
    return { success: false, errors: validation.errors };
  }
  return { success: true, user: saveUser(userData) };
}
```

## Dependency Injection

```javascript
// ✅ Dependencies explicit
function createUserService(database, logger) {
  return {
    createUser: (userData) => {
      logger.info('Creating user');
      return database.insert('users', userData);
    }
  };
}

// ❌ Hidden dependencies
import db from './database.js';
function createUser(userData) { return db.insert('users', userData); }
```

## Anti-Patterns

❌ **Mutation**: Modifying data in place
❌ **Side effects**: console.log, API calls in pure functions
❌ **Deep nesting**: Use early returns instead
❌ **God modules**: Split into focused modules
❌ **Global state**: Pass dependencies explicitly
❌ **Large functions**: Keep < 50 lines

## Best Practices

✅ Pure functions whenever possible
✅ Immutable data structures
✅ Small, focused functions (< 50 lines)
✅ Compose small functions into larger ones
✅ Explicit dependencies (dependency injection)
✅ Validate at boundaries
✅ Self-documenting code
✅ Test in isolation

**Golden Rule**: If you can't easily test it, refactor it.

---

## Python-Specific Standards

### Style Guide
- **PEP 8** compliance with modern adaptations
- **Line length**: 100 characters (balance readability and modern screens)
- **Python version**: 3.12+ (use modern syntax)

### Naming Conventions
- **Variables & Functions**: `snake_case`
- **Classes**: `PascalCase`
- **Constants**: `UPPER_SNAKE_CASE`
- **Private members**: `_leading_underscore`

### Type Hints (Python 3.12+)
```python
# ✅ Modern type hints
def process_items(items: list[str]) -> dict[str, int]:
    return {item: len(item) for item in items}

def get_user(user_id: int) -> User | None:
    return database.get(user_id)

# ❌ Old-style (avoid)
from typing import List, Dict, Optional
def process_items(items: List[str]) -> Dict[str, int]: ...
def get_user(user_id: int) -> Optional[User]: ...
```

### Import Organization
Three groups separated by blank lines:
1. **Standard library** imports
2. **Third-party** imports  
3. **Local/project** imports

```python
# ✅ Correct order
import os
import sys
from datetime import datetime

from dotenv import load_dotenv
from google.genai import Client

from src.processor import Processor
from src.utils import validate_input
```

### Docstrings (Google Style)
```python
def summarize_text(text: str, max_length: int = 500) -> str:
    """
    Generate a summary from input text.
    
    Args:
        text: The full text to summarize
        max_length: Maximum length of summary in words
        
    Returns:
        A concise summary of the text
        
    Raises:
        ValueError: If text is empty or max_length is invalid
    """
    pass
```

### Error Handling
```python
# ✅ Specific exceptions with context
import logging

logger = logging.getLogger(__name__)

def process_data(data: dict) -> dict:
    try:
        result = transform_data(data)
        logger.info(f"Processed {len(result)} items")
        return result
    except KeyError as e:
        logger.error(f"Missing required field: {e}", exc_info=True)
        raise ValueError(f"Invalid data structure: {e}") from e
    except Exception as e:
        logger.error(f"Unexpected error: {e}", exc_info=True)
        raise

# ❌ Bare except (avoid)
try:
    result = process()
except:
    pass
```

### Linting Tools

#### 1. Ruff (Primary Linter)
Fast Python linter replacing flake8, isort, pyupgrade.

**Configuration** (`pyproject.toml`):
```toml
[tool.ruff]
line-length = 100
exclude = ["archive_*", ".git", "__pycache__", ".venv"]

[tool.ruff.lint]
select = ["E", "F", "W", "I"]  # Errors, warnings, imports
ignore = ["E501"]  # Line too long (handled by black)
```

**Commands**:
```bash
ruff check .              # Check for issues
ruff check --fix .        # Auto-fix issues
```

#### 2. Black (Code Formatter)
Uncompromising code formatter.

**Configuration** (`pyproject.toml`):
```toml
[tool.black]
line-length = 100
target-version = ["py312"]
```

**Commands**:
```bash
black --check .           # Check formatting
black .                   # Auto-format
```

#### 3. isort (Import Sorter)
Sort and organize imports.

**Configuration** (`pyproject.toml`):
```toml
[tool.isort]
profile = "black"
line_length = 100
```

**Commands**:
```bash
isort --check-only .      # Check imports
isort .                   # Auto-sort imports
```

#### 4. mypy (Type Checker)
Static type checking.

**Configuration** (`pyproject.toml`):
```toml
[tool.mypy]
python_version = "3.12"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = false  # Enable gradually
```

**Commands**:
```bash
mypy .                    # Run type checking
```

### Security Best Practices

#### Environment Variables
```python
# ✅ Use environment variables for secrets
import os
from dotenv import load_dotenv

load_dotenv()
api_key = os.getenv("API_KEY")
if not api_key:
    raise ValueError("API_KEY not configured")

# ❌ Never hardcode secrets
api_key = "sk-1234567890abcdef"  # NEVER DO THIS
```

#### Never Commit
- `.env` files
- `credentials.json`
- `*.key`, `*.pem`
- API keys or tokens

#### Anti-Detection Patterns

**Proxy Rotation Best Practices:**
```python
# ✅ Geolocation-aware proxy rotation
class ProxyRotator:
    def get_proxy_with_location(self) -> Tuple[Dict, str]:
        """Return proxy config with detected country."""
        proxy = self.get_next_proxy()
        location = self.detect_location(proxy)
        return proxy, location

# ✅ Anonymous cookie generation per session
def generate_anonymous_cookies(country: str) -> Dict:
    """Generate realistic cookies for specific country."""
    timezone = COUNTRY_TIMEZONES.get(country, 'UTC')
    return create_session_cookies(timezone)
```

**Anonymous Cookie Management:**
```python
# ✅ Session-based anonymous cookies
class SmartCookieManager:
    def get_session_cookies(self, ip: str) -> Dict:
        """Get or create anonymous cookies for IP."""
        if ip not in self.sessions:
            self.sessions[ip] = self.generate_anonymous_session()
        return self.sessions[ip]['cookies']

# ❌ Personal cookie reuse
cookies = load_personal_cookies()  # AVOID - Privacy risk
```

**Anti-Detection Headers:**
```python
# ✅ Realistic browser fingerprinting
def get_realistic_headers(country: str) -> Dict:
    """Generate realistic headers for country."""
    return {
        'User-Agent': get_random_user_agent(),
        'Accept-Language': get_country_language(country),
        'Accept-Encoding': 'gzip, deflate, br',
        'DNT': '1',
        'Connection': 'keep-alive',
        'Upgrade-Insecure-Requests': '1'
    }
```

### Package Management (uv)
Modern, fast Python package manager.

```bash
# Add dependency
uv add package-name

# Add dev dependency  
uv add --dev ruff black isort mypy

# Sync dependencies
uv sync

# Run command
uv run python script.py
uv run pytest tests/
```

### Git Commit Standards
```
<type>: <description>

Types:
- feat: New feature
- fix: Bug fix
- docs: Documentation
- refactor: Code refactoring
- test: Tests
- chore: Maintenance
- perf: Performance
- style: Formatting

Examples:
feat: add YouTube Data API support
fix: handle None values in transcript processing
docs: update installation instructions
refactor: extract retry logic to utility
```

### Git Ignore Standards

**CRITICAL: Always add these to .gitignore in every project:**

```gitignore
# OpenCode local configurations (NEVER commit)
.opencode/

# Environment files
.env
.env.local
.env.*.local

# API Keys and credentials
*.key
*.pem
credentials.json
service-account*.json

# Python
__pycache__/
*.py[cod]
*$py.class
.venv/
venv/
.pytest_cache/

# Node.js
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.pnpm-debug.log*

# IDEs
.vscode/settings.json
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log
logs/

# Database
*.db
*.sqlite
*.sqlite3

# Build outputs
dist/
build/
*.egg-info/
```

**Why .opencode/ must be ignored:**
- ✅ **Security**: Prevents accidental commit of local configs with sensitive data
- ✅ **Personal configs**: Each developer has their own OpenCode setup
- ✅ **Clean repos**: Project code ≠ Developer tools configuration
- ✅ **Team flexibility**: Allows individual OpenCode customization

**Global config precedence:**
- `~/.opencode/` (global) **ALWAYS** takes precedence over local configs
- Local `.opencode/` only adds project-specific context
- Global standards and workflows cannot be overridden locally

### Development Workflow

#### Makefile Pattern
```makefile
.PHONY: lint fix test

lint:
	uv run ruff check .
	uv run black --check .
	uv run isort --check-only .

fix:
	uv run ruff check --fix .
	uv run black .
	uv run isort .

test:
	uv run pytest tests/ -v
```

#### Pre-commit Hooks
```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.14.10
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format

  - repo: https://github.com/psf/black
    rev: 25.12.0
    hooks:
      - id: black
        args: [--line-length, "100"]
```

### CI/CD Pipeline Patterns

#### Standard CI Pipeline (GitHub Actions)

```yaml
# .github/workflows/ci.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  lint-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
      
      - uses: astral-sh/setup-uv@v4
      
      - run: uv sync --all-groups
      
      - run: uv run ruff check .
      - run: uv run black --check .
      - run: uv run isort --check-only .
      - run: uv run pytest tests/ -v
```

#### VPS Auto-Deploy Pattern (Alternative to SSH Deployment)

For projects with large binaries or SSH timeout issues:

```bash
# VPS-based auto-deploy with cron job
# Eliminates network latency and SSH timeouts
# Builds locally on VPS instead of transferring binaries

# auto-deploy.sh (runs every 5 minutes via cron)
#!/bin/bash
LOCK_FILE="/tmp/auto-deploy.lock"
if [ -f "$LOCK_FILE" ]; then exit 0; fi
echo $$ > "$LOCK_FILE"

git fetch origin main
if [ "$(git rev-parse HEAD)" != "$(git rev-parse origin/main)" ]; then
  echo "🚀 New commits detected, deploying..."
  git reset --hard origin/main
  go build -o ~/.local/bin/binary ./cmd/
  uv sync
  ./restart-services.sh
fi

rm -f "$LOCK_FILE"
```

**When to use VPS Auto-Deploy:**
- ✅ Large binary transfers (>5MB)
- ✅ SSH timeout issues
- ✅ VPS has reliable git access
- ✅ Local builds are faster than transfers

**Architecture:**
```
Developer → GitHub → GitHub Actions (CI only)
                           ↓ (no deployment)
VPS Cron → git pull → local build → restart services
```

### Python-Specific Anti-Patterns

❌ **Mutable default arguments**:
```python
# ❌ Bad
def add_item(item, items=[]):
    items.append(item)
    return items

# ✅ Good
def add_item(item, items=None):
    if items is None:
        items = []
    return [*items, item]
```

❌ **Bare except**:
```python
# ❌ Bad
try:
    risky_operation()
except:
    pass

# ✅ Good
try:
    risky_operation()
except SpecificError as e:
    logger.error(f"Operation failed: {e}")
    raise
```

❌ **Global state**:
```python
# ❌ Bad
cache = {}
def get_data(key):
    if key not in cache:
        cache[key] = fetch_data(key)
    return cache[key]

# ✅ Good
def create_cache():
    cache = {}
    def get_data(key):
        if key not in cache:
            cache[key] = fetch_data(key)
        return cache[key]
    return get_data
```

### Python Best Practices Checklist

Before committing Python code:
- ✅ Runs `ruff check .` with 0 errors
- ✅ Runs `black --check .` with 0 changes needed
- ✅ Runs `isort --check-only .` with 0 changes needed
- ✅ Type hints on public functions
- ✅ Google-style docstrings
- ✅ No hardcoded secrets
- ✅ Specific exception handling
- ✅ Logging with context
- ✅ Tests pass
