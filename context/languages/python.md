<!-- Context: languages/python | Priority: high | Version: 1.0 | Updated: 2025-01-06 -->
# Python Standards

## Quick Reference

**Core Philosophy**: Readable, Type-Safe, Modular
**Golden Rule**: Type hints on all public functions, PEP8 compliant

**Critical Patterns** (use these):
- ✅ Type hints on public functions (Python 3.12+)
- ✅ Google-style docstrings
- ✅ Named tuples/dataclasses for structured data
- ✅ Context managers for resource handling
- ✅ `pathlib` for file operations

**Anti-Patterns** (avoid these):
- ❌ Mutable default arguments
- ❌ Bare `except:` clauses
- ❌ Hardcoded secrets in code
- ❌ `from module import *`
- ❌ Global state

---

## Language Selection Summary

| Task Type | Keywords | Language | Score |
|-----------|----------|----------|-------|
| **Machine Learning** | ml, ai, model, training | Python | +0.9 |
| **Data Analysis** | pandas, numpy, analysis | Python | +0.9 |
| **Prototyping** | prototype, explore, experiment | Python | +0.7 |
| **Automation Script** | script, cron, one-shot | Python | +0.6 |
| **Data Engineering** | etl, pipeline | Python | +0.6 |
| **Quick Scripts** | quick, glue, ad-hoc | Python | +0.8 |

## Key Differences from TypeScript

| Aspect | Python | TypeScript |
|--------|--------|------------|
| **Typing** | Duck typing + hints | Structural typing |
| **Package Manager** | uv/pip | npm/pnpm |
| **Type Compiler** | mypy | tsc |
| **Linter** | ruff | ESLint |
| **Formatter** | Black | Prettier |
| **Async** | asyncio | Promise/async-await |
| **Main Use** | Data/ML/Scripts | Web/Frontend |

## Standard Library References

**Full Standards**: See `core/standards/code.md` (Python-specific section)

**Quick Links**:
- Type hints: Lines 181-194
- Import organization: Lines 196-213
- Error handling: Lines 234-258
- Linting tools: Lines 260-329
- Security: Lines 331-352
- Package management (uv): Lines 354-370
- Git commit: Lines 372-391
- Git ignore: Lines 393-456
- CI/CD: Lines 501-531
- Anti-patterns: Lines 533-582

## Common Commands

```bash
# Run Python
uv run python script.py
uv run pytest tests/

# Linting
uv run ruff check .
uv run black --check .
uv run mypy .

# Type checking
uv run mypy .

# Format
uv run black .
uv run isort .

# Install deps
uv add package-name
uv add --dev ruff black isort mypy
```

## Python Best Practices Checklist

Before committing Python code:
- ✅ Type hints on public functions
- ✅ Google-style docstrings
- ✅ `ruff check .` passes
- ✅ `black --check .` passes
- ✅ `isort --check-only .` passes
- ✅ No hardcoded secrets
- ✅ Specific exception handling
- ✅ Tests pass

**Golden Rule**: If you can't easily test it, refactor it.

---

## When to Choose Python

### ✅ Choose Python for:
- Machine learning / AI (PyTorch, TensorFlow)
- Data analysis (Pandas, NumPy)
- Prototyping and exploration
- Quick automation scripts
- Backend APIs (FastAPI, Flask)
- Jupyter notebooks

### ❌ Consider Go for:
- High-performance services
- Production CLI tools
- Systems programming
- WASM/WebAssembly

### ❌ Consider TypeScript for:
- Frontend web apps
- Browser automation
- Node.js backends

### ❌ Consider Rust for:
- Memory-safe systems programming
- Performance-critical components
- WASM modules
- Embedded systems
