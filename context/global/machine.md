# Machine Configuration & Tools

## Overview

This document describes all tools, runtimes, and software installed across environments.

---

## Python Ecosystem

### Package Managers
- **uv** - Fast Python package installer and resolver (primary)
- **pip** - Python package installer (fallback)
- **pipx** - Install Python applications in isolated environments

### Python Versions
- **Python 3.x** - Primary Python runtime
- **Virtual Environments** - `.venv/` directories in projects

### Python Tools
- **Black** - Code formatter (line length: 100)
- **isort** - Import sorter
- **Ruff** - Fast Python linter
- **mypy** - Static type checker

### Usage
```bash
# Install dependencies with uv
uv pip install -r requirements.txt

# Run Python script with uv
uv run python script.py

# Run pytest with uv
uv run pytest tests/

# Format code
black -l 100 .
isort .

# Lint code
ruff check .

# Type check
mypy .
```

---

## Data & Analytics Stack

### Data Ingestion
- **dlt (data load tool)** - Python library for data ingestion
  - Configuration: `.dlt/` directory
  - Secrets: `.dlt/secrets.toml`
  - Pipelines: Extract data from sources to destinations

### Data Transformation
- **dbt (data build tool)** - SQL-based transformation framework
  - Configuration: `.dbt/` directory
  - Profiles: `~/.dbt/profiles.yml`
  - Commands: `dbt run`, `dbt test`, `dbt build`

### Databases

#### DuckDB
- **Type:** In-process analytical database
- **Usage:** Local analytics, data exploration
- **File Extension:** `.duckdb`, `.db`
- **Python Library:** `duckdb`

#### PostgreSQL
- **Type:** Relational database
- **Usage:** Production data storage
- **Client:** `psql` (command-line)
- **Python Library:** `psycopg2`, `sqlalchemy`

#### BigQuery
- **Type:** Cloud data warehouse (Google Cloud Platform)
- **Usage:** Large-scale analytics, dbt transformations
- **CLI:** `bq` (BigQuery command-line tool)
- **Python Library:** `google-cloud-bigquery`

### Usage
```bash
# dlt pipeline execution
uv run python ingestion/pipeline.py

# dbt commands
dbt run                    # Run all models
dbt test                   # Run all tests
dbt build                  # Run and test models
dbt run --select model_name  # Run specific model

# BigQuery CLI
bq query --use_legacy_sql=false 'SELECT * FROM dataset.table LIMIT 10'
bq ls                      # List datasets
bq show dataset.table      # Show table schema

# DuckDB CLI
duckdb database.duckdb
```

---

## Cloud & Infrastructure

### Google Cloud Platform (GCP)
- **gcloud** - GCP command-line tool
- **bq** - BigQuery CLI
- **gsutil** - Google Cloud Storage utility
- **Authentication:** Service account keys, OAuth2

### Docker
- **docker** - Container platform
- **docker-compose** - Multi-container orchestration
- **Docker Networks:** `traefik-network` (external)

### VPS Infrastructure
- **Traefik** - Reverse proxy and load balancer
  - Dashboard: `proxy.vpdata.fr`
  - Ports: 80 (HTTP), 443 (HTTPS), 8080 (Dashboard)
  - SSL: Let's Encrypt automatic certificates

### Usage
```bash
# GCP authentication
gcloud auth login
gcloud config set project PROJECT_ID

# Docker commands
docker ps                           # List running containers
docker-compose up -d                # Start services in background
docker-compose down                 # Stop services
docker-compose logs -f service_name # Follow logs
docker-compose restart service_name # Restart service

# Docker on VPS
ssh vps_h 'docker ps'
ssh vps_h 'cd /home/vincent/docker/traefik && docker-compose up -d'
```

---

## Development Tools

### Version Control
- **Git** - Version control system
- **GitHub CLI (gh)** - GitHub command-line tool
  - Required for private repositories
  - Commands: `gh repo view`, `gh pr create`, `gh issue list`

### Node.js Ecosystem
- **Node.js** - JavaScript runtime
- **Bun** - Fast JavaScript runtime and package manager
- **npm** - Node package manager
- **npx** - Execute npm packages

### Testing
- **Playwright** - End-to-end testing framework
  - Command: `npx playwright test`
  - Browsers: Chromium, Firefox, WebKit
  - Headless mode supported

### Usage
```bash
# Git commands
git status
git add .
git commit -m "feat: add new feature"
git push

# GitHub CLI
gh repo view
gh pr create --title "Title" --body "Description"
gh issue list

# Playwright
npx playwright test                    # Run all tests
npx playwright test --headed           # Run with browser visible
npx playwright test tests/example.spec.ts  # Run specific test
```

---

## Web Scraping

### Playwright
- **Purpose:** Browser automation and web scraping
- **Languages:** Python, JavaScript/TypeScript
- **Features:** Headless browsing, screenshots, PDF generation

### Python Libraries
- **requests** - HTTP library
- **beautifulsoup4** - HTML parsing
- **selenium** - Browser automation (legacy)
- **scrapy** - Web scraping framework

### Usage
```bash
# Python Playwright
uv run python scraper.py

# Install Playwright browsers
playwright install
```

---

## Text Editors & IDEs

### Visual Studio Code
- **Remote SSH:** Connect to VPS for remote development
- **Extensions:** Python, Pylance, Docker, GitLens
- **Settings:** `.vscode/` directory in projects

### Vim
- **Configuration:** `~/.viminfo`, `~/.vimrc`
- **Usage:** Quick file editing on VPS

---

## System Tools

### Shell
- **Bash** - Default shell
- **Zsh** - Alternative shell (with Oh My Zsh)
- **Configuration:** `~/.bashrc`, `~/.zshrc`, `~/.profile`

### File Transfer
- **scp** - Secure copy (SSH-based)
- **rsync** - Efficient file synchronization
- **git** - Version control-based transfer

### Process Management
- **systemd** - System and service manager
- **cron** - Job scheduler
- **docker-compose** - Container orchestration

### Usage
```bash
# Cron jobs
crontab -l                 # List cron jobs
crontab -e                 # Edit cron jobs
ssh vps_dlt 'crontab -l'   # View VPS cron jobs

# Systemd services
systemctl status service_name
systemctl restart service_name
sudo systemctl enable service_name
```

---

## Obsidian

### Obsidian Vaults
- **Local:** `/home/vincent/dev/Obsidian/`
- **VPS:** `/home/vincent/obsidian-second-brain-vps/`
- **Sync:** Git-based synchronization scripts

### Sync Scripts
- **Location:** `/home/vincent/dev/obsidian-sync/`
- **VPS Location:** `/home/vincent/obsidian-sync/`
- **Purpose:** Automated vault synchronization between local and VPS

---

## Environment-Specific Tools

### Local Development
- All tools available for development and testing
- Full IDE support (VS Code)
- Direct database access

### VPS (vincent user)
- Docker and docker-compose
- Git and GitHub CLI
- Python with uv
- Obsidian sync scripts
- Web scraping tools (Playwright)

### VPS (dlthub user)
- Python with uv
- dlt and dbt
- BigQuery CLI (bq)
- GCP tools (gcloud, gsutil)
- Cron for scheduled jobs

---

## Tool Versions

Check installed versions:
```bash
# Python ecosystem
python --version
uv --version
pip --version

# Data tools
dlt --version
dbt --version

# Cloud tools
gcloud --version
bq version

# Docker
docker --version
docker-compose --version

# Node.js
node --version
npm --version
bun --version

# Git
git --version
gh --version

# Playwright
npx playwright --version
```

---

## Installation Commands

### Python Tools
```bash
# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install dbt
pip install dbt-core dbt-bigquery

# Install dlt
pip install dlt
```

### Cloud Tools
```bash
# Install gcloud
curl https://sdk.cloud.google.com | bash

# Install GitHub CLI
sudo apt install gh
```

### Docker
```bash
# Install Docker
curl -fsSL https://get.docker.com | sh

# Install docker-compose
sudo apt install docker-compose
```

### Node.js Tools
```bash
# Install Bun
curl -fsSL https://bun.sh/install | bash

# Install Playwright
npm install -D @playwright/test
npx playwright install
```
