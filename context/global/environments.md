# Global Environments Configuration

## Overview

This document describes all environments where projects are deployed and how to interact with them.

---

## Local Development Environment

### System Information
- **Hostname:** `vincent-X390-2025`
- **User:** `vincent`
- **OS:** Ubuntu Linux
- **Shell:** Bash/Zsh

### Directory Structure
```
/home/vincent/dev/
├── dlthub-unified/          # dlt + dbt data pipeline
├── immo-stras/              # Real estate scraping (DuckDB, PostgreSQL)
├── ga4-weekly-report/       # Google Analytics 4 reporting
├── scraping/                # Web scraping projects
├── obsidian-sync/           # Obsidian vault sync scripts
├── Obsidian/                # Local Obsidian vault
└── config_opencode/         # OpenCode configuration backup
```

### Purpose
- Development and testing
- Local Obsidian vault management
- Git repository development
- Testing before VPS deployment

### Environment Detection
```bash
# Quick environment detection
if [[ "$(whoami)@$(hostname)" == "vincent@vincent-X390-2025" ]]; then
    echo "Local Development Environment"
fi
```

---

## VPS Production Environment (User: vincent)

### Connection
- **SSH Alias:** `vps_h`
- **User:** `vincent`
- **Hostname:** `host`
- **Authentication:** SSH key (no password required)
- **Connection Test:** `ssh vps_h 'echo "Connected to VPS"'`

### Directory Structure
```
/home/vincent/
├── immo-stras/                              # Real estate scraping (production)
├── ga4-weekly-report/                       # GA4 reporting (production)
├── obsidian-second-brain-vps/               # VPS Obsidian vault
├── obsidian-sync/                           # Sync scripts
├── obsidian-vault/                          # Additional vault
├── docker/                                  # Docker services
│   ├── traefik/                            # Reverse proxy
│   ├── n8n-compose/                        # Workflow automation
│   ├── matomo/                             # Analytics platform
│   └── matomo-nginx/                       # Nginx for Matomo
├── .credentials/                            # Secrets and credentials
│   └── ga4-service-account.json            # GA4 service account
├── .config/                                 # Configuration files
├── .docker/                                 # Docker config
└── .ssh/                                    # SSH keys
```

### Purpose
- Production services deployment
- Docker container orchestration
- VPS Obsidian vault management
- Bot deployment and automation

### Environment Detection
```bash
# Quick environment detection
if [[ "$(whoami)@$(hostname)" == "vincent@host" ]]; then
    echo "VPS Production Environment (vincent)"
fi
```

### Common Operations
```bash
# Connect to VPS
ssh vps_h

# File transfer
scp local-file.txt vps_h:/home/vincent/
rsync -avz local-dir/ vps_h:/home/vincent/remote-dir/

# Execute remote command
ssh vps_h 'command-to-run'

# Check running services
ssh vps_h 'docker ps'
```

---

## VPS Production Environment (User: dlthub)

### Connection
- **SSH Alias:** `vps_dlt`
- **User:** `dlthub`
- **Hostname:** `host`
- **Authentication:** SSH key (no password required)
- **Connection Test:** `ssh vps_dlt 'echo "Connected to VPS as dlthub"'`

### Directory Structure
```
/home/dlthub/
├── dlthub-project/
│   └── dlthub-unified/                      # Main dlt + dbt project
│       ├── ingestion/                       # dlt pipelines
│       ├── transformation/                  # dbt models
│       ├── orchestration/                   # Workflow orchestration
│       ├── infrastructure/                  # Infrastructure as code
│       ├── logs/                            # Application logs
│       ├── .venv/                           # Python virtual environment
│       ├── .dlt/                            # dlt configuration
│       ├── pyproject.toml                   # Python dependencies
│       └── uv.lock                          # uv lock file
├── .dbt/                                    # dbt global config
├── .dlt/                                    # dlt global config
├── .config/                                 # Configuration files
├── .ssh/                                    # SSH keys
├── github_secrets_prep/                     # GitHub secrets preparation
├── dbt-transfo-key.json                     # dbt service account key
└── crontab_backup_*.txt                     # Crontab backups
```

### Purpose
- dlt data ingestion pipelines
- dbt data transformation
- BigQuery data warehouse management
- Scheduled data pipeline execution (cron)

### Environment Detection
```bash
# Quick environment detection
if [[ "$(whoami)@$(hostname)" == "dlthub@host" ]]; then
    echo "VPS Production Environment (dlthub)"
fi
```

### Common Operations
```bash
# Connect to VPS as dlthub
ssh vps_dlt

# Navigate to project
ssh vps_dlt 'cd /home/dlthub/dlthub-project/dlthub-unified && pwd'

# Run dlt pipeline
ssh vps_dlt 'cd /home/dlthub/dlthub-project/dlthub-unified && uv run python ingestion/pipeline.py'

# Run dbt models
ssh vps_dlt 'cd /home/dlthub/dlthub-project/dlthub-unified/transformation && dbt run'

# Check crontab
ssh vps_dlt 'crontab -l'

# View logs
ssh vps_dlt 'tail -f /home/dlthub/dlthub-project/dlthub-unified/logs/*.log'
```

---

## Project Mapping (Local ↔ VPS)

### dlthub-unified
- **Local:** `/home/vincent/dev/dlthub-unified/`
- **VPS:** `/home/dlthub/dlthub-project/dlthub-unified/`
- **VPS User:** `dlthub` (via `vps_dlt`)
- **Stack:** Python (uv), dlt, dbt, BigQuery
- **Deployment:** Git push + SSH to VPS

### immo-stras
- **Local:** `/home/vincent/dev/immo-stras/`
- **VPS:** `/home/vincent/immo-stras/`
- **VPS User:** `vincent` (via `vps_h`)
- **Stack:** Python, Playwright, DuckDB, PostgreSQL
- **Deployment:** Git push + SSH to VPS

### ga4-weekly-report
- **Local:** `/home/vincent/dev/ga4-weekly-report/`
- **VPS:** `/home/vincent/ga4-weekly-report/`
- **VPS User:** `vincent` (via `vps_h`)
- **Stack:** Python, Google Analytics 4 API, BigQuery
- **Deployment:** Git push + SSH to VPS
- **Credentials:** `/home/vincent/.credentials/ga4-service-account.json` (VPS)

---

## Critical Rules for Agents

### Environment Verification
- **ALWAYS verify environment** before executing commands
- **Check `whoami@hostname`** to confirm current environment
- **Use appropriate SSH alias** for VPS operations (`vps_h` or `vps_dlt`)

### Task Assignment by Environment
- **Local tasks:**
  - Development and testing
  - Local vault operations
  - Git commits and pushes
  - Code editing and refactoring

- **VPS tasks (vincent):**
  - Production deployment (immo-stras, ga4-weekly-report)
  - Docker service management
  - VPS vault operations
  - Bot deployment

- **VPS tasks (dlthub):**
  - dlt pipeline execution
  - dbt transformation runs
  - BigQuery operations
  - Cron job management

### Connection Commands
```bash
# Connect to VPS as vincent
ssh vps_h

# Connect to VPS as dlthub
ssh vps_dlt

# Execute command on VPS (vincent)
ssh vps_h 'command'

# Execute command on VPS (dlthub)
ssh vps_dlt 'command'
```

### File Transfer
```bash
# Local → VPS (vincent)
scp file.txt vps_h:/home/vincent/
rsync -avz local-dir/ vps_h:/home/vincent/remote-dir/

# Local → VPS (dlthub)
scp file.txt vps_dlt:/home/dlthub/
rsync -avz local-dir/ vps_dlt:/home/dlthub/dlthub-project/dlthub-unified/

# VPS → Local
scp vps_h:/home/vincent/file.txt ./
rsync -avz vps_h:/home/vincent/remote-dir/ ./local-dir/
```

---

## Security & Credentials

### Credential Locations

#### Local
- **GCP Credentials:** `~/.config/gcloud/`
- **SSH Keys:** `~/.ssh/`
- **Environment Variables:** `.env` files in project roots

#### VPS (vincent)
- **GA4 Service Account:** `/home/vincent/.credentials/ga4-service-account.json`
- **SSH Keys:** `/home/vincent/.ssh/`
- **Docker Secrets:** `/home/vincent/docker/*/` (in `.env` files)
- **GCP Credentials:** `/home/vincent/.config/gcloud/`

#### VPS (dlthub)
- **dbt Service Account:** `/home/dlthub/dbt-transfo-key.json`
- **SSH Keys:** `/home/dlthub/.ssh/`
- **dlt Secrets:** `/home/dlthub/dlthub-project/dlthub-unified/.dlt/secrets.toml`
- **dbt Profiles:** `/home/dlthub/.dbt/profiles.yml`

### Security Rules
- **NEVER commit credentials** to Git repositories
- **Use `.env` files** for environment-specific secrets
- **Keep service account keys** in dedicated credential directories
- **Use SSH key authentication** (no passwords)
- **Restrict file permissions** on credential files (600 or 400)

---

## Environment Variables

See `~/.opencode/.env` for sensitive configuration values.

Common environment variables:
- `VPS_HOST_VINCENT` - VPS hostname for vincent user
- `VPS_HOST_DLTHUB` - VPS hostname for dlthub user
- `VPS_USER_VINCENT` - VPS username (vincent)
- `VPS_USER_DLTHUB` - VPS username (dlthub)
- `LOCAL_DEV_PATH` - Local development root path
- `VPS_DOCKER_PATH` - VPS Docker services path
