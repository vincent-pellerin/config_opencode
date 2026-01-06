<!-- Context: languages/rust | Priority: high | Version: 1.0 | Updated: 2025-01-06 -->
# Rust Standards

## Quick Reference

**Core Philosophy**: Memory-Safe, Concurrent, Zero-Cost
**Golden Rule**: Leverage the borrow checker; use unsafe only when absolutely necessary

**Critical Patterns** (use these):
- ✅ Ownership and borrowing for memory safety
- ✅ Error handling with Result<T, E>
- ✅ Iterator adapters and closures
- ✅ Pattern matching (match, if let, while let)
- ✅ Crate organization (lib + bin)
- ✅ cargo clippy and cargo fmt

**Anti-Patterns** (avoid these):
- ❌ Unnecessary unsafe blocks
- ❌ Clone when borrowing would work
- ❌ panic! for normal error handling
- ❌ Collecting into Vec when iterators suffice
- ❌ Ignoring Result/Option values (use ? or expect)
- ❌ Large monolithic files

---

## Language Selection Summary

| Task Type | Keywords | Language | Score |
|-----------|----------|----------|-------|
| **Systems Programming** | rust, embedded, kernel, driver, os | Rust | +0.9 |
| **WASM/WebAssembly** | wasm, webassembly, browser-module | Rust | +0.8 |
| **Memory Safety** | memory-safe, zero-allocation, security | Rust | +0.8 |
| **Performance Critical** | latency <10ms, throughput >1000/s | Rust | +0.8 |
| **CLI Tools** | cli, binary, cross-platform | Rust | +0.8 |
| **High Concurrency** | parallel, thread-safe, async | Rust | +0.7 |

## Key Differences from Other Languages

| Aspect | Rust | Go | Python | TypeScript |
|--------|------|-----|--------|------------|
| **Memory** | Ownership + borrow checker | GC | GC | GC |
| **Concurrency** | async/await, threads | Goroutines | asyncio | async/await |
| **Error Handling** | Result/Option | Errors | Exceptions | Exceptions |
| **Type System** | Strong static, inferred | Static | Dynamic + hints | Static |
| **Package Manager** | Cargo | go mod | uv/pip | npm/pnpm |
| **Learning Curve** | ★★☆☆☆ | ★★★★☆ | ★★★★★ | ★★★☆☆ |
| **Performance** | ★★★★★ | ★★★★☆ | ★★★☆☆ | ★★★☆☆ |

## Core Philosophy

### Ownership Model
- **Ownership**: Each value has a single owner
- **Borrowing**: References (borrows) to data
- **Lifetime**: Scope of borrowed references
- **Move semantics**: Transfer ownership on assignment

### Zero-Cost Abstractions
- Traits and generics compile to static dispatch
- Iterators compile to tight loops
- Closures have no runtime overhead
- Async compiles to state machines

### Error Handling
- **Result<T, E>** for recoverable errors
- **Option<T>** for optional values
- **?** operator for propagation
- **panic!** for unrecoverable errors only

## Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| **Variables** | snake_case | `user_count`, `is_active` |
| **Constants** | UPPER_SNAKE_CASE | `MAX_RETRIES`, `API_URL` |
| **Functions** | snake_case | `get_user()`, `process_data()` |
| **Structs** | PascalCase | `UserService`, `ApiResponse` |
| **Enums** | PascalCase | `Status`, `ErrorKind` |
| **Traits** | PascalCase | `Serialize`, `Drawable` |
| **Modules** | snake_case | `user_service`, `api_client` |
| **Files** | snake_case.rs | `user_service.rs`, `api_client.rs` |
| **Crates** | kebab-case | `my-crate`, `serde-json` |

## Rust-Specific Patterns

### Ownership and Borrowing

```rust
// ✅ Ownership transfer (move)
fn process_user(user: User) -> Result<(), Error> {
    // user is owned here
    database.save(user)?;
    Ok(())
}

// ❌ Avoid: cloning when borrowing works
fn bad_example(user: &User) {
    let cloned = user.clone(); // Unnecessary clone
}

// ✅ Borrowing with references
fn print_user(user: &User) {
    println!("{}", user.name); // Read-only borrow
}

// ✅ Mutable borrow
fn update_user(user: &mut User, name: String) {
    user.name = name;
}

// ❌ Avoid: dangling references
fn dangling() -> &String {
    let s = String::from("hello");
    &s  // ERROR: s is dropped at end of scope
}

// ✅ Proper lifetime annotation
fn longest<'a>(s1: &'a str, s2: &'a str) -> &'a str {
    if s1.len() > s2.len() { s1 } else { s2 }
}
```

### Error Handling

```rust
// ✅ Result type for recoverable errors
type Result<T, E = Error> = std::result::Result<T, E>;

#[derive(Debug)]
pub enum ApiError {
    NotFound(String),
    Unauthorized(String),
    RateLimited,
    ServerError(String),
}

impl std::error::Error for ApiError {}

impl std::fmt::Display for ApiError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            ApiError::NotFound(resource) => write!(f, "{} not found", resource),
            ApiError::Unauthorized(msg) => write!(f, "Unauthorized: {}", msg),
            ApiError::RateLimited => write!(f, "Rate limited"),
            ApiError::ServerError(msg) => write!(f, "Server error: {}", msg),
        }
    }
}

// ✅ Using ? operator
async fn fetch_user(id: &str) -> Result<User> {
    let response = http_client.get(format!("/users/{}", id)).send().await?;
    if response.status() == 404 {
        return Err(ApiError::NotFound("User".to_string()));
    }
    let user = response.json::<User>().await?;
    Ok(user)
}

// ✅ Pattern matching with Result
match result {
    Ok(user) => println!("Found: {}", user.name),
    Err(e) => eprintln!("Error: {}", e),
}

// ✅ ? with context
fn process_data() -> Result<Data> {
    let raw = read_file("data.json")?;        // Propagate error
    let parsed = parse_json(&raw)?;           // Add context
    validate(&parsed)?;                       // More context
    Ok(parsed)
}
```

### Option Type

```rust
// ✅ Using Option
fn find_user(id: &str) -> Option<User> {
    database.find_by_id(id)
}

// ✅ Pattern matching
let user = find_user("123");
match user {
    Some(u) => println!("Found: {}", u.name),
    None => println!("User not found"),
}

// ✅ if let / while let
if let Some(user) = find_user("123") {
    println!("Found: {}", user.name);
}

// ✅ unwrap / expect (use sparingly)
let user = find_user("123").expect("User must exist");

// ✅ unwrap_or / unwrap_or_default
let name = user.nickname.unwrap_or(user.name);

// ✅ map and_then
let email = user.and_then(|u| u.email);
```

### Pattern Matching

```rust
// ✅ Comprehensive match
fn process_status(status: Status) -> String {
    match status {
        Status::Pending => "Waiting".to_string(),
        Status::Active => "Running".to_string(),
        Status::Paused => "Paused".to_string(),
        Status::Completed => "Done".to_string(),
    }
}

// ✅ Match with guards
fn classify(n: i32) -> &'static str {
    match n {
        n if n < 0 => "negative",
        0 => "zero",
        n if n > 0 && n < 10 => "small positive",
        _ => "large",
    }
}

// ✅ Destructuring
fn print_coords(point: &(i32, i32)) {
    match point {
        (x, y) => println!("({}, {})", x, y),
    }
}

// ✅ if let for single pattern
if let Status::Active = status {
    println!("Currently active");
}
```

### Iterators

```rust
// ✅ Iterator adapters (lazy)
let numbers = [1, 2, 3, 4, 5];

// map
let doubled: Vec<_> = numbers.iter().map(|x| x * 2).collect();

// filter
let evens: Vec<_> = numbers.iter().filter(|x| *x % 2 == 0).collect();

// chain
let combined: Vec<_> = numbers1.iter().chain(numbers2.iter()).collect();

// ✅ Iterator methods
let sum: i32 = numbers.iter().sum();
let max = numbers.iter().max();
let count = numbers.iter().count();

// ✅ Iterator adapters with closures
let result: Vec<_> = items
    .iter()
    .filter(|item| item.is_active)
    .map(|item| item.name)
    .take(10)
    .collect();

// ❌ Avoid: collecting when lazy is fine
let _collected: Vec<_> = items.iter().map(|x| x * 2).collect(); // Unnecessary

// ✅ Collect when needed
let doubled: Vec<_> = numbers.iter().map(|x| x * 2).collect();
```

### Traits and Generics

```rust
// ✅ Define traits
pub trait Repository {
    fn find_by_id(&self, id: &str) -> Option<User>;
    fn save(&mut self, user: &User) -> Result<()>;
    fn delete(&mut self, id: &str) -> Result<()>;
}

// ✅ Default implementations
pub trait Logger {
    fn log(&self, message: &str) {
        println!("[INFO] {}", message);
    }
}

// ✅ Implement trait
impl Repository for PostgresRepository {
    fn find_by_id(&self, id: &str) -> Option<User> {
        self.db.query("SELECT * FROM users WHERE id = ?", &[&id])
            .first()
            .map(|row| User::from_row(row))
    }

    fn save(&mut self, user: &User) -> Result<()> {
        // Implementation
        Ok(())
    }
}

// ✅ Generic functions
fn process_items<T: Repository>(repo: &T, ids: &[&str]) {
    for id in ids {
        if let Some(user) = repo.find_by_id(id) {
            println!("Found: {}", user.name);
        }
    }
}

// ✅ Trait bounds with where clauses
fn print_display<T>(item: &T)
where
    T: std::fmt::Display,
{
    println!("{}", item);
}

// ✅ Common traits (derive macros)
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct User {
    pub id: String,
    pub name: String,
    pub email: String,
}
```

### Concurrency (async/await)

```rust
// ✅ Using Tokio for async
#[tokio::main]
async fn main() -> Result<()> {
    let client = reqwest::Client::new();

    // Spawn tasks
    let handles: Vec<_> = (0..10)
        .map(|i| {
            tokio::spawn(async move {
                fetch_data(i).await
            })
        })
        .collect();

    // Wait for all
    let results: Vec<Result<Data>> = futures::future::join_all(handles)
        .await
        .into_iter()
        .map(|r| r.unwrap())
        .collect();

    Ok(())
}

// ✅ Parallel processing with Rayon
use rayon::prelude::*;

let sum: i32 = (0..1_000_000)
    .into_par_iter()
    .sum();

// ✅ Channels for communication
use std::sync::mpsc;

let (tx, rx) = mpsc::channel();

thread::spawn(move || {
    tx.send("Hello".to_string()).unwrap();
});

let received = rx.recv().unwrap();

// ✅ Mutex for shared state
use std::sync::Mutex;

let counter = Mutex::new(0);
let mut guard = counter.lock().unwrap();
*guard += 1;
```

### Error Context with thiserror

```rust
// ✅ Using thiserror for clean error definitions
use thiserror::Error;

#[derive(Error, Debug)]
pub enum ServiceError {
    #[error("Database error: {source}")]
    Database {
        #[from]
        source: sqlx::Error,
    },

    #[error("Validation failed: {field} = {value}")]
    Validation {
        field: String,
        value: String,
    },

    #[error("Not found: {resource} {id}")]
    NotFound {
        resource: String,
        id: String,
    },

    #[error(transparent)]
    Io(#[from] std::io::Error),
}

// ✅ Automatic From implementations
fn connect() -> Result<DbConnection, ServiceError> {
    sqlx::postgres::PgConnection::connect(&url)
        .await
        .map_err(ServiceError::Database)?  // Auto-converted
}
```

## Project Structure

```
project/
├── Cargo.toml
├── src/
│   ├── lib.rs              # Library crate root
│   ├── bin/
│   │   └── cli.rs          # CLI binary
│   ├── main.rs             # Binary (if no bin/ dir)
│   ├── api/
│   │   ├── mod.rs
│   │   ├── routes.rs
│   │   └── handlers.rs
│   ├── models/
│   │   ├── mod.rs
│   │   └── user.rs
│   ├── services/
│   │   ├── mod.rs
│   │   └── user_service.rs
│   ├── repository/
│   │   ├── mod.rs
│   │   └── user_repo.rs
│   ├── config/
│   │   ├── mod.rs
│   │   └── settings.rs
│   └── utils/
│       ├── mod.rs
│       └── error.rs
├── tests/
│   ├── integration/
│   │   └── api_tests.rs
│   └── unit/
│       └── user_tests.rs
├── examples/
│   └── simple_example.rs
└── benches/
    └── benchmark.rs
```

## Cargo Commands

```bash
# Initialize project
cargo new project_name
cargo init --lib

# Build
cargo build
cargo build --release
cargo build --target x86_64-unknown-linux-musl  # Static binary

# Run tests
cargo test
cargo test --lib  # Unit tests only
cargo test --test integration  # Integration tests
cargo test -- --nocapture  # Show output
cargo test -- --test-threads=1  # Single thread

# Benchmarks
cargo bench

# Linting
cargo clippy
cargo clippy -- -D warnings  # Treat warnings as errors

# Formatting
cargo fmt
cargo fmt -- --check  # Check only

# Documentation
cargo doc --open
cargo doc --no-deps  # Only this crate

# Dependency management
cargo update
cargo update -p crate_name  # Update specific crate
cargo tree  # Show dependency tree
cargo audit  # Check for vulnerabilities

# Clean
cargo clean
cargo clean --release

# Expand macros
cargo expand
```

## Cargo Configuration

**Cargo.toml**:
```toml
[package]
name = "my-project"
version = "0.1.0"
edition = "2021"
authors = ["Vincent <vincent@example.com>"]
description = "A Rust project"
repository = "https://github.com/vincent/my-project"
license = "MIT"

[dependencies]
# Core
tokio = { version = "1.35", features = ["full"] }
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
thiserror = "2.0"
anyhow = "1.0"

# Web
axum = "0.7"
reqwest = { version = "0.11", features = ["json"] }

# Database
sqlx = { version = "0.7", features = ["postgres", "runtime-tokio"] }

# CLI
clap = { version = "4.4", features = ["derive"] }

# Utilities
once_cell = "1.19"
tracing = "0.1"
tracing-subscriber = "0.3"

[dev-dependencies]
# Test utilities
rstest = "0.18"
proptest = "1.4"
wiremock = "0.5"

[profile.release]
opt-level = 3
lto = true
codegen-units = 1

[profile.dev]
debug = true

[workspace]
members = ["crates/cli", "crates/lib"]
```

**rust-toolchain.toml**:
```toml
[toolchain]
channel = "1.75"
components = ["rustfmt", "clippy", "rust-analyzer"]
targets = ["x86_64-unknown-linux-musl", "wasm32-unknown-unknown"]
```

## Error Handling Patterns

### anyhow for Application Errors

```rust
// ✅ Using anyhow for application-level errors
use anyhow::{anyhow, Context, Result};

fn read_config() -> Result<Config> {
    let content = std::fs::read_to_string("config.yaml")
        .context("Failed to read config file")?;
    
    let config: Config = serde_yaml::from_str(&content)
        .context("Failed to parse config")?;
    
    Ok(config)
}

// ✅ Adding context
fn process_user(user_id: &str) -> Result<User> {
    let user = database
        .find_by_id(user_id)
        .with_context(|| format!("User {} not found", user_id))?;
    
    Ok(user)
}
```

### Custom Error Types

```rust
// ✅ Define domain-specific errors
#[derive(Debug, thiserror::Error)]
pub enum UserError {
    #[error("User not found: {id}")]
    NotFound { id: String },

    #[error("Invalid email: {email}")]
    InvalidEmail { email: String },

    #[error("Database error: {source}")]
    Database { #[from] source: sqlx::Error },

    #[error("Unauthorized access")]
    Unauthorized,
}

// ✅ Pattern match on error
match user_service.create(&data) {
    Ok(user) => HttpResponse::Created().json(user),
    Err(UserError::NotFound { id }) => HttpResponse::NotFound().body(format!("User {} not found", id)),
    Err(UserError::InvalidEmail { email }) => HttpResponse::BadRequest().body(format!("Invalid email: {}", email)),
    Err(e) => HttpResponse::InternalServerError().body(e.to_string()),
}
```

## Async Runtime Selection

### Tokio (Recommended for Most Cases)

```rust
// ✅ Tokio for async I/O
#[tokio::main]
async fn main() -> Result<()> {
    let listener = TcpListener::bind("0.0.0.0:3000").await?;
    
    loop {
        let (stream, _) = listener.accept().await?;
        tokio::spawn(async move {
            handle_connection(stream).await;
        });
    }
}

// ✅ Tokio utilities
use tokio::sync::{Mutex, RwLock, Semaphore};
use tokio::time;

let delay = time::sleep(Duration::from_secs(1));
delay.await;
```

### async-std (Alternative)

```rust
// ✅ async-std for embedded/systems
use async_std::prelude::*;

#[async_std::main]
async fn main() -> Result<()> {
    let listener = async_std::net::TcpListener::bind("0.0.0.0:3000").await?;
    
    let mut incoming = listener.incoming();
    while let Some(stream) = incoming.next().await {
        let stream = stream?;
        async_std::task::spawn(async move {
            handle_connection(stream).await;
        });
    }
    Ok(())
}
```

## Testing Patterns

```rust
// ✅ Unit tests in module
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_user_creation() {
        let user = User::new("john", "john@example.com");
        assert_eq!(user.name, "john");
        assert_eq!(user.email, "john@example.com");
    }

    #[test]
    fn test_user_validation() {
        let result = User::new("john", "invalid-email");
        assert!(result.is_err());
    }

    #[test]
    fn test_something() -> Result<()> {
        let value = compute_value()?;
        assert_eq!(value, 42);
        Ok(())
    }
}

// ✅ Integration tests
#[tokio::test]
async fn test_api_endpoint() {
    let app = Router::new()
        .route("/users", get(list_users))
        .into_make_service();

    let response = app
        .oneshot(Request::builder().uri("/users").body(Body::empty()).unwrap())
        .await
        .unwrap();

    assert_eq!(response.status(), StatusCode::OK);
}

// ✅ Property-based testing with proptest
proptest! {
    #[test]
    fn test_sort_properties(vec in prop::collection::vec(1..1000, 0..100)) {
        let mut sorted = vec.clone();
        sorted.sort();

        // Check size
        assert_eq!(sorted.len(), vec.len());

        // Check sorted
        for i in 1..sorted.len() {
            assert!(sorted[i-1] <= sorted[i]);
        }
    }
}
```

## Security Best Practices

### No Unchecked unsafe

```rust
// ❌ Avoid: unnecessary unsafe
fn bad_example() {
    let mut value = 42;
    let ptr = &mut value as *mut i32;
    unsafe {
        *ptr = 100;  // Unnecessary unsafe
    }
}

// ✅ Safe alternative
fn good_example() {
    let mut value = 42;
    value = 100;  // Simple assignment
}
```

### Validate Input

```rust
// ✅ Validate all external input
fn create_user(input: CreateUserRequest) -> Result<User> {
    // Validate email format
    if !input.email.contains('@') {
        return Err(UserError::InvalidEmail { email: input.email });
    }

    // Validate name length
    if input.name.len() < 2 {
        return Err(UserError::InvalidName { min_length: 2 });
    }

    Ok(User::new(input.name, input.email))
}
```

### Never Commit

- `.env` files
- `secrets/`, `*.key`, `*.pem`
- `Cargo.lock` (in library crates)
- `target/` directory
- Local development files

## Git Ignore

```gitignore
# Build outputs
target/
Cargo.lock

# IDE
.vscode/settings.json
.idea/
*.swp
*.swo

# Environment
.env
.env.local
.env.*.local

# OS
.DS_Store
Thumbs.db

# Logs
*.log
logs/

# WASM
*.wasm
.wasm-pack/

# Misc
*.pem
*.key
secrets/
```

## Development Workflow

### Makefile Pattern

```makefile
.PHONY: lint fix test build doc check

lint:
	cargo clippy --all-features -- -D warnings

fix:
	cargo clippy --all-features --fix

test:
	cargo test --all-features
	cargo test --all-features --doc

build:
	cargo build --release --all-features

check:
	cargo check --all-features
	cargo check --all-features --tests
	cargo check --all-features --doc
	cargo clippy --all-features -- --check
	cargo fmt -- --check

doc:
	cargo doc --no-deps --open

bench:
	cargo bench

audit:
	cargo audit
	cargo outdated
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
- ci: CI/CD changes
- rust: Rust-specific changes (clippy, borrow checker, etc.)

Examples:
feat: add user authentication endpoint
fix: resolve lifetime issue in request handler
docs: update API documentation
refactor: extract validation to separate module
rust: apply clippy suggestions for performance
test: add integration tests for user service
```

## WebAssembly (WASM)

### Setup for WASM

```toml
[lib]
crate-type = ["cdylib", "rlib"]

[dependencies]
wasm-bindgen = "0.2"

[dependencies.web-sys]
version = "0.3"
features = [
    "console",
    "Window",
    "Document",
    "Element",
    "HtmlElement",
]
```

### WASM Example

```rust
use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub fn greet(name: &str) -> String {
    format!("Hello, {}!", name)
}

#[wasm_bindgen(start)]
pub fn main() {
    console::log!("WASM module loaded");
}
```

## Rust Best Practices Checklist

Before committing Rust code:
- ✅ `cargo check --all-features` passes
- ✅ `cargo clippy --all-features` passes (no warnings)
- ✅ `cargo fmt --check` passes
- ✅ `cargo test --all-features` passes
- ✅ `cargo doc --no-deps` generates documentation
- ✅ No unnecessary `unsafe` blocks
- ✅ All `Result` and `Option` values handled
- ✅ Documentation comments on public APIs
- ✅ No hardcoded secrets
- ✅ Tests pass with `--release` flag

---

## When to Choose Rust

### ✅ Choose Rust for:
- Systems programming (OS, drivers, embedded)
- WebAssembly modules for browser
- Performance-critical applications
- Memory-safe systems components
- CLI tools requiring reliability
- High-concurrency services
- Cryptography and security tools

### ❌ Consider Go for:
- Quick microservices deployment
- Simpler concurrent patterns
- Faster iteration cycles
- Less complex tooling needs
- Team less familiar with Rust

### ❌ Consider Python for:
- Machine learning / AI
- Data analysis / visualization
- Prototyping and exploration
- Jupyter notebooks
- Quick automation scripts

### ❌ Consider TypeScript for:
- Frontend web applications
- Node.js backends
- Browser automation
- React/Vue projects

---

## Summary

| Category | Recommendation |
|----------|----------------|
| **New Projects** | Rust for systems/performance, Go for services, Python for ML/AI |
| **Learning Investment** | Higher learning curve, but pays off in safety and performance |
| **Ecosystem** | Growing but less mature than Python/JS |
| **Tooling** | Excellent (Cargo, rust-analyzer, clippy) |
| **Compilation** | Slower than interpreted languages |
| **Deployment** | Single static binary, excellent for containers |
| **Memory Safety** | Compile-time guarantees, no GC pauses |

**Golden Rules**:
1. Trust the borrow checker; fight it only when necessary
2. Use `cargo clippy` and `cargo fmt` religiously
3. `Result` and `Option` for all fallible operations
4. Write tests alongside implementation
5. Document public APIs with doc comments
6. Prefer composition over complex trait hierarchies
