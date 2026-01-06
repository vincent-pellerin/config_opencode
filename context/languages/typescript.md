<!-- Context: languages/typescript | Priority: high | Version: 1.0 | Updated: 2025-01-06 -->
# TypeScript/JavaScript Standards

## Quick Reference

**Core Philosophy**: Type-Safe, Modular, Async-First
**Golden Rule**: TypeScript for new projects, JavaScript for quick scripts and Node.js legacy

**Critical Patterns** (use these):
- ✅ Type annotations on all public APIs
- ✅ Async/await for asynchronous operations
- ✅ Explicit return types for functions
- ✅ Interface segregation over inheritance
- ✅ Default exports for modules

**Anti-Patterns** (avoid these):
- ❌ `any` type without justification
- ❌ Callback hell, prefer async/await
- ❌ Mutable global state
- ❌ Implicit `any` type inference
- ❌ Side effects in pure functions

---

## Core Philosophy

**Type-Safe**: Leverage TypeScript's type system to catch errors at compile time
**Modular**: Everything is a module with explicit exports/imports
**Async-First**: Modern JavaScript uses promises and async/await natively
**Functional**: Prefer pure functions, avoid mutations when possible

## Principles

### TypeScript Approach
- **Strict Typing**: Enable strict mode, avoid `any`
- **Interface vs Type**: Use interfaces for objects, types for unions/primitives
- **Generics**: Write reusable, type-safe code
- **Explicit Types**: Return types on functions, parameter types

### Modular Design
- Single responsibility per module
- Named exports for clarity
- Barrel files (`index.ts`) for public APIs
- < 200 lines per file (ideally < 100)

### Async-First
- **Promises**: Use for all async operations
- **Async/Await**: Prefer over raw promises
- **Error Handling**: Try/catch with typed errors
- **Concurrency**: `Promise.all()` for parallel operations

## Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| **Variables** | camelCase | `userName`, `isActive` |
| **Constants** | UPPER_SNAKE_CASE | `MAX_RETRIES`, `API_URL` |
| **Functions** | camelCase (verb phrase) | `getUser()`, `fetchData()` |
| **Classes** | PascalCase | `UserService`, `DataProcessor` |
| **Interfaces** | PascalCase (no 'I' prefix) | `User`, `ApiResponse` |
| **Types** | PascalCase | `StatusCode`, `UserId` |
| **Enums** | PascalCase | `LogLevel`, `UserRole` |
| **Files** | kebab-case | `user-service.ts`, `api-client.ts` |
| **Components** | PascalCase | `UserProfile.tsx` |

## TypeScript-Specific Standards

### Type Annotations

```typescript
// ✅ Explicit types on public APIs
function getUser(id: string): Promise<User> {
  return db.findUser(id);
}

// ✅ Parameter types
function processItems(items: ReadonlyArray<Item>): Result[] {
  return items.map(transformItem);
}

// ✅ Return types
function calculateTotal(price: number, quantity: number): number {
  return price * quantity;
}

// ❌ Avoid any (unless absolutely necessary)
function badExample(data: any): any {
  return data;
}
```

### Interface vs Type

```typescript
// ✅ Interface for objects (extensible)
interface User {
  id: string;
  name: string;
  email: string;
}

interface AdminUser extends User {
  permissions: string[];
}

// ✅ Type for unions, intersections, primitives
type Status = 'pending' | 'active' | 'deleted';
type UserId = string & { readonly brand: unique symbol };
type ApiResponse<T> = SuccessResponse<T> | ErrorResponse;
```

### Generics

```typescript
// ✅ Generic functions
function firstOrDefault<T>(arr: T[], defaultValue: T): T {
  return arr.length > 0 ? arr[0] : defaultValue;
}

// ✅ Generic classes
class Cache<T> {
  private store: Map<string, T> = new Map();

  get(key: string): T | undefined {
    return this.store.get(key);
  }

  set(key: string, value: T): void {
    this.store.set(key, value);
  }
}

// ✅ Generic constraints
function getId<T extends { id: unknown }>(obj: T): T['id'] {
  return obj.id;
}
```

### Utility Types

```typescript
// ✅ Use utility types for common patterns
interface User {
  id: string;
  name: string;
  email: string;
  password: string;
}

// Partial (all optional)
type PartialUser = Partial<User>;

// Required (all required, opposite of Partial)
type RequiredUser = Required<User>;

// Pick (select specific fields)
type UserPreview = Pick<User, 'id' | 'name'>;

// Omit (exclude specific fields)
type UserWithoutPassword = Omit<User, 'password'>;

// Readonly
type ReadonlyUser = Readonly<User>;

// Record (object with specific keys and value type)
type UserMap = Record<string, User>;
```

## Import Organization

### Modern ESM Imports (TypeScript 5+)

```typescript
// ✅ Standard library
import { readFile, writeFile } from 'node:fs/promises';
import { join, basename } from 'node:path';

// Third-party
import express, { Request, Response } from 'express';
import { z } from 'zod';
import { v4 as uuidv4 } from 'uuid';

// Local (relative imports first)
import { UserRepository } from '../repository/user.repository';
import { ApiError } from '../errors/api.error';
import { validateInput } from '../utils/validation';

// Barrel exports
import { UserService } from './user.service';
```

### Import Ordering

1. **Standard library** (node:, empty for built-in)
2. **Third-party** (external packages)
3. **Local/Relative** (., ..)

```typescript
// ✅ Correct order
import { readFile } from 'node:fs/promises';
import { join } from 'node:path';

import express from 'express';
import { z } from 'zod';

import { config } from '../config';
import { UserService } from './user.service';
```

## Error Handling

### Typed Errors

```typescript
// ✅ Custom error classes
class ValidationError extends Error {
  constructor(
    message: string,
    public readonly field?: string,
    public readonly value?: unknown
  ) {
    super(message);
    this.name = 'ValidationError';
  }
}

class NotFoundError extends Error {
  constructor(resource: string, public readonly id: string) {
    super(`${resource} with id ${id} not found`);
    this.name = 'NotFoundError';
  }
}

// ✅ Async error handling
async function getUser(id: string): Promise<User> {
  try {
    const user = await database.findById(id);
    if (!user) {
      throw new NotFoundError('User', id);
    }
    return user;
  } catch (error) {
    if (error instanceof NotFoundError) {
      throw error;
    }
    logger.error('Failed to get user', { id, error });
    throw new ApiError('Database error', 500);
  }
}

// ✅ Result type pattern (alternative to exceptions)
type Result<T, E = Error> =
  | { success: true; data: T }
  | { success: false; error: E };

function safeParse<T>(json: string): Result<T, SyntaxError> {
  try {
    return { success: true, data: JSON.parse(json) };
  } catch (error) {
    return { success: false, error: error as SyntaxError };
  }
}
```

### Async/Await Error Handling

```typescript
// ✅ Using try/catch with async/await
async function fetchData<T>(url: string): Promise<T> {
  try {
    const response = await fetch(url);
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`);
    }
    return response.json();
  } catch (error) {
    logger.error('Fetch failed', { url, error });
    throw new ApiError('Failed to fetch data', 500, { cause: error });
  }
}

// ✅ Promise.all for parallel operations
async function getUserWithPosts(userId: string): Promise<UserWithPosts> {
  const [user, posts] = await Promise.all([
    userService.getUser(userId),
    postService.getPostsByUser(userId),
  ]);
  return { user, posts };
}

// ✅ Promise.allSettled for error tolerance
async function fetchAll<T>(urls: string[]): Promise<T[]> {
  const results = await Promise.allSettled(urls.map(url => fetchJson<T>(url)));
  return results
    .filter((r): r is PromiseFulfilledResult<T> => r.status === 'fulfilled')
    .map(r => r.value);
}
```

## Linting Tools

### ESLint (Primary Linter)

**Configuration** (`.eslintrc.json` or `eslint.config.js`):
```json
{
  "parser": "@typescript-eslint/parser",
  "plugins": ["@typescript-eslint"],
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:@typescript-eslint/strict"
  ],
  "rules": {
    "@typescript-eslint/explicit-function-return-type": "error",
    "@typescript-eslint/explicit-module-boundary-types": "error",
    "@typescript-eslint/no-explicit-any": "warn",
    "@typescript-eslint/no-unused-vars": ["error", { "argsIgnorePattern": "^_" }]
  }
}
```

**Commands**:
```bash
# Check for issues
npx eslint .

# Fix auto-fixable issues
npx eslint --fix .

# Fix specific file
npx eslint src/user.service.ts
```

### Prettier (Code Formatter)

**Configuration** (`.prettierrc.json`):
```json
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 100,
  "bracketSpacing": true,
  "arrowParens": "avoid"
}
```

**Commands**:
```bash
# Check formatting
npx prettier --check .

# Format files
npx prettier --write .

# Format specific file
npx prettier --write src/user.service.ts
```

### TypeScript Compiler (tsc)

**Configuration** (`tsconfig.json`):
```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "lib": ["ES2022"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "**/*.test.ts"]
}
```

**Commands**:
```bash
# Type check
npx tsc --noEmit

# Compile
npx tsc

# Watch mode
npx tsc --watch
```

## Security Best Practices

### Environment Variables

```typescript
// ✅ Use environment variables for secrets
import { loadEnv } from './env';

const config = loadEnv();

const apiKey = process.env.API_KEY;
if (!apiKey) {
  throw new Error('API_KEY is required');
}

// ✅ Type-safe environment parsing
import { z } from 'zod';

const envSchema = z.object({
  API_KEY: z.string().min(1),
  DB_URL: z.string().url(),
  LOG_LEVEL: z.enum(['debug', 'info', 'warn', 'error']).default('info'),
});

type Env = z.infer<typeof envSchema>;
const env = envSchema.parse(process.env);

// ❌ Never hardcode secrets
const apiKey = 'sk-1234567890abcdef'; // NEVER DO THIS
```

### Input Validation

```typescript
// ✅ Validate all input
import { z } from 'zod';

const createUserSchema = z.object({
  name: z.string().min(1).max(100),
  email: z.string().email(),
  role: z.enum(['user', 'admin']).default('user'),
});

async function createUser(raw: unknown): Promise<User> {
  const data = createUserSchema.parse(raw);
  // Now data is validated and typed
  return userService.create(data);
}
```

### Never Commit

- `.env`, `.env.local`, `.env.*.local`
- `*.key`, `*.pem`, `credentials.json`
- `service-account*.json`
- `secrets/`
- `node_modules/` (use .gitignore)

## Package Management

### npm/pnpm Commands

```bash
# Install dependency
npm install express
pnpm add express

# Install dev dependency
npm install --save-dev typescript
pnpm add -D typescript

# Install exact version
npm install express@4.18.2
pnpm add express@4.18.2

# Update dependencies
npm update
pnpm update

# Check for outdated
npm outdated
pnpm outdated

# Run script
npm run build
pnpm run build

# Clean install
npm ci
pnpm install --frozen-lockfile
```

### package.json Example

```json
{
  "name": "my-project",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "build": "tsc",
    "dev": "tsx watch src/index.ts",
    "lint": "eslint src/**/*.ts",
    "test": "vitest",
    "test:coverage": "vitest --coverage"
  },
  "dependencies": {
    "express": "^4.18.2",
    "zod": "^3.22.4"
  },
  "devDependencies": {
    "@types/express": "^4.17.21",
    "@types/node": "^20.10.0",
    "eslint": "^8.55.0",
    "typescript": "^5.3.0",
    "vitest": "^1.0.0"
  }
}
```

## Git Commit Standards

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
- ci: CI/CD changes

Examples:
feat: add user authentication endpoint
fix: handle null values in API response
docs: update API documentation
refactor: extract validation to separate module
test: add unit tests for user service
```

## Git Ignore Standards

```gitignore
# TypeScript/Node.js
dist/
build/
*.tsbuildinfo
node_modules/

# Environment
.env
.env.local
.env.*.local

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

# Testing
coverage/
.nyc_output/

# Misc
*.pem
*.key
secrets/
```

## Development Workflow

### Makefile Pattern

```makefile
.PHONY: lint fix test build dev

lint:
	npx eslint src/
	npx prettier --check src/

fix:
	npx eslint --fix src/
	npx prettier --write src/

test:
	npx vitest run
	npx vitest coverage

build:
	npx tsc

dev:
	npx tsx watch src/index.ts

type-check:
	npx tsc --noEmit
```

### Pre-commit Hooks

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.6.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files

  - repo: https://github.com/typescript-eslint/typescript-eslint
    rev: v6.13.0
    hooks:
      - id: eslint
        args: [--fix]

  - repo: https://github.com/prettier/prettier
    rev: v3.1.0
    hooks:
      - id: prettier
        args: [--write]
```

## CI/CD Pipeline Pattern

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

      - uses: actions/setup-node@v4
        with:
          node-version: "20"
          cache: 'pnpm'

      - run: pnpm install --frozen-lockfile

      - run: pnpm run lint
      - run: pnpm run type-check
      - run: pnpm run test
```

## JavaScript-Specific Standards

### When to Use JavaScript

- Quick scripts and one-liners
- Node.js legacy codebases
- Browser automation (Playwright, Puppeteer)
- Package.json scripts

### Modern JavaScript (ES2022+)

```javascript
// ✅ Modern JavaScript features
const user = {
  name: 'John',
  // Shorthand properties
  sayHi() {
    return `Hi, ${this.name}`;
  },
  // Computed property names
  ['get' + 'Name']() {
    return this.name;
  },
};

// ✅ Destructuring
const { name, email } = user;
const [first, ...rest] = items;

// ✅ Spread operator
const newUser = { ...user, email: 'new@email.com' };
const newItems = [...items, newItem];

// ✅ Optional chaining
const city = user?.address?.city ?? 'Unknown';

// ✅ Nullish coalescing
const displayName = user.nickname ?? user.name;

// ✅ Array methods
const activeUsers = users.filter(u => u.isActive);
const names = users.map(u => u.name);
const total = items.reduce((sum, item) => sum + item.price, 0);

// ✅ Async/await
async function fetchData(url) {
  try {
    const response await fetch(url);
    return await response.json();
  } catch (error) {
    console.error('Failed:', error);
    throw error;
  }
}
```

### CommonJS to ESM Migration

```javascript
// ❌ Old CommonJS
const express = require('express');
const { Router } = require('express');

// ✅ Modern ESM
import express from 'express';
import { Router } from 'express';
```

## TypeScript Best Practices Checklist

Before committing TypeScript code:
- ✅ `npx tsc --noEmit` passes with 0 errors
- ✅ `npx eslint .` passes with 0 errors
- ✅ `npx prettier --check .` passes
- ✅ No `any` type without explicit justification
- ✅ All public functions have return types
- ✅ Error handling with typed errors
- ✅ Input validation with Zod or similar
- ✅ No hardcoded secrets
- ✅ Tests pass
- ✅ TypeScript strict mode enabled

## Anti-Patterns

### ❌ Using `any`

```typescript
// ❌ Bad
function processData(data: any): any {
  return data.property;
}

// ✅ Good
interface Data {
  property: string;
}

function processData(data: Data): string {
  return data.property;
}

// ✅ If truly unknown, use unknown
function handleUnknown(data: unknown): void {
  if (typeof data === 'string') {
    console.log('String:', data);
  }
}
```

### ❌ Callback Hell

```typescript
// ❌ Bad
fs.readFile('file1.txt', (err, data1) => {
  if (err) throw err;
  fs.readFile('file2.txt', (err, data2) => {
    if (err) throw err;
    fs.writeFile('output.txt', data1 + data2, (err) => {
      if (err) throw err;
      console.log('Done');
    });
  });
});

// ✅ Good
async function processFiles(): Promise<void> {
  const data1 = await readFile('file1.txt', 'utf8');
  const data2 = await readFile('file2.txt', 'utf8');
  await writeFile('output.txt', data1 + data2);
  console.log('Done');
}
```

### ❌ Mutable Global State

```typescript
// ❌ Bad
let config = { debug: false };
function setDebug(value: boolean) {
  config.debug = value;
}

// ✅ Good - pass dependencies
interface Config {
  debug: boolean;
}

function createService(config: Config) {
  return {
    doSomething() {
      if (config.debug) {
        console.log('Debug mode');
      }
    },
  };
}
```

### ❌ Implicit Any

```typescript
// ❌ Bad (TypeScript will error in strict mode)
function process(item) {
  return item.value;
}

// ✅ Good - explicit types
interface Item {
  value: string;
}

function process(item: Item): string {
  return item.value;
}
```

---

## When to Choose TypeScript

### ✅ Choose TypeScript for:
- Frontend web applications (React, Vue, Svelte)
- Node.js backends and APIs
- n8n custom nodes
- Browser automation (Playwright, Puppeteer)
- Full-stack TypeScript projects
- Large codebases requiring type safety

### ❌ Consider Rust for:
- Performance-critical WASM modules
- Systems programming tasks
- Memory-safe, zero-cost abstractions
- High-performance backend services

### ❌ Consider Python for:
- Machine learning / AI
- Data analysis / visualization
- Prototyping and exploration
- Quick automation scripts

### ❌ Consider Go for:
- High-concurrency services
- CLI tools and system utilities
- Production deployment (simpler)

## Summary

| Category | Recommendation |
|----------|----------------|
| **New Projects** | TypeScript with strict mode |
| **Quick Scripts** | JavaScript (ES2022+) |
| **Legacy Node.js** | Migrate to TypeScript gradually |
| **Frontend** | TypeScript with React/Vue |
| **Backend APIs** | TypeScript with Express/Fastify |
| **Browser Automation** | JavaScript (Playwright/Puppeteer) |
| **CLI Tools** | TypeScript with oclif/commander |
| **Package.json Scripts** | JavaScript |

**Golden Rules**:
1. TypeScript for production code
2. Use Zod for input validation
3. Prefer async/await over callbacks
4. Keep functions small and typed
5. Use ESLint + Prettier + TypeScript together
