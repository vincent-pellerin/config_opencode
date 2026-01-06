<!-- Context: languages/go | Priority: high | Version: 1.0 | Updated: 2025-01-06 -->
# Go Standards

## Quick Reference

**Core Philosophy**: Simple, Concurrent, Efficient
**Golden Rule**: Write clear, type-safe Go; use goroutines for concurrency

**Critical Patterns** (use these):
- ✅ Go modules (`go.mod`)
- ✅ Goroutines for concurrency
- ✅ Error handling (no exceptions)
- ✅ Interfaces for abstraction
- ✅ Context for cancellation/timeouts

**Anti-Patterns** (avoid these):
- ❌ `any`/`interface{}` without type assertion
- ❌ Blocking in goroutines
- ❌ Global variables
- ❌ Error swallowing
- ❌ Mutable state shared between goroutines

---

## Language Selection Summary

| Task Type | Keywords | Language | Score |
|-----------|----------|----------|-------|
| **High Concurrency** | parallel, goroutines, websocket | Go | +0.8 |
| **REST API** | endpoint, router, middleware | Go | +0.7 |
| **Production Service** | daemon, supervisor, monitor | Go | +0.8 |
| **System Tool** | cli, binary, cross-platform | Go | +0.9 |
| **Performance Critical** | latency <10ms, throughput >1000/s | Go | +0.8 |
| **Data Engineering** | etl, pipeline, streaming | Go | +0.7 |

## Key Differences from Python

| Aspect | Go | Python |
|--------|-----|--------|
| **Typing** | Static, nominal | Dynamic + hints |
| **Concurrency** | Goroutines, channels | asyncio, threads |
| **Error Handling** | Return errors | Exceptions |
| **Package Manager** | go mod | uv/pip |
| **Linter** | golangci-lint | ruff |
| **Formatter** | gofmt | Black |
| **Main Use** | Services/CLI | Data/ML/Scripts |

## Go-Specific Patterns

### Error Handling

```go
// ✅ Return errors explicitly
func GetUser(id string) (*User, error) {
    user, err := db.FindUser(id)
    if err != nil {
        return nil, fmt.Errorf("get user %s: %w", id, err)
    }
    return user, nil
}

// ✅ Handle errors at call site
user, err := GetUser("123")
if err != nil {
    log.Errorf("failed: %v", err)
    return err
}

// ✅ Custom error types
type NotFoundError struct {
    Resource string
    ID       string
}

func (e *NotFoundError) Error() string {
    return fmt.Sprintf("%s not found: %s", e.Resource, e.ID)
}
```

### Concurrency (Goroutines)

```go
// ✅ Use goroutines for concurrent operations
func processItems(items []Item) []Result {
    results := make([]Result, len(items))
    var wg sync.WaitGroup

    for i, item := range items {
        wg.Add(1)
        go func(i int, item Item) {
            defer wg.Done()
            results[i] = processItem(item)
        }(i, item)
    }

    wg.Wait()
    return results
}

// ✅ Use channels for communication
func workerPool(numWorkers int, jobs <-chan Job, results chan<- Result) {
    for i := 0; i < numWorkers; i++ {
        go func() {
            for job := range jobs {
                results <- process(job)
            }
        }()
    }
}
```

### Interfaces

```go
// ✅ Define interfaces where used
type UserRepository interface {
    FindByID(id string) (*User, error)
    Save(user *User) error
}

// ✅ Implement implicitly
type PostgresRepository struct {
    db *sql.DB
}

// No explicit "implements" declaration needed

// ✅ Use interfaces for testing
type UserService struct {
    repo UserRepository  // Depends on interface, not concrete type
}
```

### Context

```go
// ✅ Use context for cancellation
func FetchData(ctx context.Context, url string) ([]byte, error) {
    req, err := http.NewRequestWithContext(ctx, "GET", url, nil)
    if err != nil {
        return nil, err
    }

    resp, err := http.DefaultClient.Do(req)
    if err != nil {
        return nil, err
    }
    defer resp.Body.Close()

    return io.ReadAll(resp.Body)
}

// ✅ With timeout
ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
defer cancel()

data, err := FetchData(ctx, "https://api.example.com/data")
```

## Common Commands

```bash
# Initialize module
go mod init github.com/vincent/project

# Download dependencies
go mod tidy

# Build
go build -o bin/service ./cmd/server

# Run tests
go test ./... -v
go test ./... -race  # Race detector

# Linting
golangci-lint run

# Format
gofmt -w .
goimports -w .

# Type checking
go build ./...

# Module management
go get github.com/package@latest
go mod download
```

## Linting Configuration

**.golangci.yml**:
```yaml
linters:
  enable:
    - errcheck
    - gofmt
    - goimports
    - gosimple
    - staticcheck
    - typecheck
    - unused
    - govet

linters-settings:
  errcheck:
    check-type-assertions: true
  goimports:
    local-prefixes: github.com/vincent/project
```

## Project Structure

```
project/
├── cmd/
│   └── server/
│       └── main.go          # Entry point
├── internal/
│   ├── config/
│   │   └── config.go
│   ├── handler/
│   │   └── api.go
│   ├── repository/
│   │   └── user.go
│   └── service/
│       └── user.go
├── pkg/
│   └── utils/
│       └── helpers.go
├── go.mod
├── go.sum
└── README.md
```

## Git Ignore

```gitignore
# Go
/bin/
/dist/
*.exe
*.exe~
*.dll
*.so
*.dylib

# Test binary
*.test

# Output of go coverage
*.out

# Go workspace
go.work

# IDE
.vscode/
.idea/

# Environment
.env
*.local
```

## Go Best Practices Checklist

Before committing Go code:
- ✅ `go build ./...` passes
- ✅ `go test ./...` passes
- ✅ `golangci-lint run` passes
- ✅ `gofmt -w .` formatted
- ✅ Error handling on all function calls
- ✅ Context parameter for cancellation support
- ✅ Documentation comments on exported types/functions
- ✅ No hardcoded secrets
- ✅ Tests pass with `-race` flag

---

## When to Choose Go

### ✅ Choose Go for:
- High-performance APIs and microservices
- CLI tools and system utilities
- Concurrent processing (goroutines)
- Production services requiring reliability
- Containerized applications
- Data engineering pipelines (high throughput)

### ❌ Consider Python for:
- Machine learning / AI
- Data analysis / visualization
- Prototyping and exploration
- Quick automation scripts
- Jupyter notebooks
- NLP and text processing

### ❌ Consider TypeScript for:
- Frontend web applications
- Node.js APIs (if team preference)
- Browser automation
- React/Vue/Svelte projects

### ❌ Consider Rust for:
- Memory-safe systems programming
- WASM/WebAssembly modules
- Performance-critical components
- Embedded systems
- Maximum performance with safety guarantees
