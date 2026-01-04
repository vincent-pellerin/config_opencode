# CLI Tools & Commands Reference

## Overview

Quick reference for commonly used CLI tools and commands across all environments.

---

## Python Commands

### uv (Primary Package Manager)
```bash
# Install dependencies
uv pip install package_name
uv pip install -r requirements.txt

# Run Python scripts
uv run python script.py
uv run pytest tests/
uv run python -m module_name

# Create virtual environment
uv venv
uv venv --python 3.11

# Sync dependencies
uv pip sync requirements.txt
```

### Code Quality
```bash
# Format code (Black)
black -l 100 .
black -l 100 file.py

# Sort imports (isort)
isort .
isort file.py

# Lint code (Ruff)
ruff check .
ruff check --fix .

# Type checking (mypy)
mypy .
mypy file.py
```

### Testing
```bash
# Run all tests
uv run pytest

# Run specific test file
uv run pytest tests/test_file.py

# Run specific test
uv run pytest tests/test_file.py::test_function_name

# Run with coverage
uv run pytest --cov=app tests/

# Run with verbose output
uv run pytest -v
```

---

## Data Tools

### dlt (Data Load Tool)
```bash
# Initialize dlt pipeline
dlt init pipeline_name destination

# Run pipeline
uv run python pipeline.py

# Verify pipeline
dlt pipeline pipeline_name info
dlt pipeline pipeline_name trace

# List pipelines
dlt pipeline list

# Configuration
# Edit: .dlt/config.toml
# Secrets: .dlt/secrets.toml
```

### dbt (Data Build Tool)
```bash
# Run all models
dbt run

# Run specific model
dbt run --select model_name

# Run models with dependencies
dbt run --select +model_name+

# Test all models
dbt test

# Test specific model
dbt test --select model_name

# Build (run + test)
dbt build

# Compile SQL
dbt compile

# Generate documentation
dbt docs generate
dbt docs serve

# Debug connection
dbt debug

# Clean artifacts
dbt clean
```

### BigQuery CLI (bq)
```bash
# Query data
bq query --use_legacy_sql=false 'SELECT * FROM dataset.table LIMIT 10'

# List datasets
bq ls
bq ls project_id:

# List tables in dataset
bq ls dataset_name

# Show table schema
bq show dataset.table

# Show table info
bq show --format=prettyjson dataset.table

# Load data
bq load --source_format=CSV dataset.table file.csv schema.json

# Extract data
bq extract dataset.table gs://bucket/file.csv

# Copy table
bq cp source_dataset.table dest_dataset.table

# Delete table
bq rm -t dataset.table

# Delete dataset
bq rm -r -d dataset_name
```

---

## Google Cloud Platform (GCP)

### gcloud (GCP CLI)
```bash
# Authentication
gcloud auth login
gcloud auth application-default login

# List projects
gcloud projects list

# Set active project
gcloud config set project PROJECT_ID

# Get current project
gcloud config get-value project

# List service accounts
gcloud iam service-accounts list

# Create service account key
gcloud iam service-accounts keys create key.json \
  --iam-account=SERVICE_ACCOUNT_EMAIL

# List compute instances
gcloud compute instances list

# SSH to instance
gcloud compute ssh INSTANCE_NAME
```

### gsutil (Cloud Storage)
```bash
# List buckets
gsutil ls

# List files in bucket
gsutil ls gs://bucket_name/

# Copy file to bucket
gsutil cp file.txt gs://bucket_name/

# Copy file from bucket
gsutil cp gs://bucket_name/file.txt ./

# Sync directory
gsutil rsync -r local_dir/ gs://bucket_name/remote_dir/

# Remove file
gsutil rm gs://bucket_name/file.txt

# Make file public
gsutil acl ch -u AllUsers:R gs://bucket_name/file.txt
```

---

## Docker Commands

### Docker
```bash
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# Start container
docker start container_name

# Stop container
docker stop container_name

# Restart container
docker restart container_name

# Remove container
docker rm container_name

# View logs
docker logs container_name
docker logs -f container_name  # Follow logs
docker logs --tail 100 container_name  # Last 100 lines

# Execute command in container
docker exec -it container_name bash
docker exec container_name command

# Inspect container
docker inspect container_name

# List images
docker images

# Remove image
docker rmi image_name

# Prune unused resources
docker system prune
docker system prune -a  # Remove all unused images
```

### Docker Compose
```bash
# Start services
docker-compose up
docker-compose up -d  # Detached mode

# Stop services
docker-compose down

# Restart services
docker-compose restart

# Restart specific service
docker-compose restart service_name

# View logs
docker-compose logs
docker-compose logs -f  # Follow logs
docker-compose logs -f service_name  # Follow specific service

# List services
docker-compose ps

# Execute command in service
docker-compose exec service_name bash
docker-compose exec service_name command

# Build services
docker-compose build
docker-compose build service_name

# Pull images
docker-compose pull

# Scale service
docker-compose up -d --scale service_name=3
```

### Docker on VPS
```bash
# List containers on VPS
ssh vps_h 'docker ps'

# Start service on VPS
ssh vps_h 'cd /home/vincent/docker/traefik && docker-compose up -d'

# View logs on VPS
ssh vps_h 'docker logs -f traefik'

# Restart service on VPS
ssh vps_h 'cd /home/vincent/docker/n8n-compose && docker-compose restart'

# Stop all services on VPS
ssh vps_h 'docker stop $(docker ps -q)'
```

---

## Git & GitHub

### Git
```bash
# Status
git status

# Add files
git add .
git add file.py

# Commit
git commit -m "feat: add new feature"
git commit -m "fix: resolve bug"
git commit -m "docs: update documentation"

# Push
git push
git push origin branch_name

# Pull
git pull
git pull origin main

# Branch
git branch  # List branches
git branch branch_name  # Create branch
git checkout branch_name  # Switch branch
git checkout -b branch_name  # Create and switch

# Merge
git merge branch_name

# Log
git log
git log --oneline
git log --graph --oneline --all

# Diff
git diff
git diff file.py
git diff branch1..branch2

# Stash
git stash
git stash pop
git stash list

# Reset
git reset HEAD file.py  # Unstage file
git reset --hard HEAD  # Discard all changes
```

### GitHub CLI (gh)
```bash
# Repository
gh repo view
gh repo clone owner/repo
gh repo create

# Pull Requests
gh pr list
gh pr create --title "Title" --body "Description"
gh pr view PR_NUMBER
gh pr checkout PR_NUMBER
gh pr merge PR_NUMBER

# Issues
gh issue list
gh issue create --title "Title" --body "Description"
gh issue view ISSUE_NUMBER
gh issue close ISSUE_NUMBER

# Authentication
gh auth login
gh auth status

# Workflow runs
gh run list
gh run view RUN_ID
gh run watch RUN_ID
```

---

## SSH & File Transfer

### SSH
```bash
# Connect to VPS (vincent)
ssh vps_h

# Connect to VPS (dlthub)
ssh vps_dlt

# Execute remote command
ssh vps_h 'command'
ssh vps_h 'cd /path && command'

# Execute multiple commands
ssh vps_h 'command1 && command2'

# SSH with port forwarding
ssh -L local_port:localhost:remote_port vps_h

# SSH with X11 forwarding
ssh -X vps_h

# Copy SSH key to server
ssh-copy-id vps_h
```

### scp (Secure Copy)
```bash
# Copy file to VPS
scp file.txt vps_h:/home/vincent/

# Copy file from VPS
scp vps_h:/home/vincent/file.txt ./

# Copy directory to VPS
scp -r directory/ vps_h:/home/vincent/

# Copy with compression
scp -C file.txt vps_h:/home/vincent/
```

### rsync (Efficient Sync)
```bash
# Sync directory to VPS
rsync -avz local_dir/ vps_h:/home/vincent/remote_dir/

# Sync from VPS to local
rsync -avz vps_h:/home/vincent/remote_dir/ ./local_dir/

# Sync with delete (remove files not in source)
rsync -avz --delete local_dir/ vps_h:/home/vincent/remote_dir/

# Dry run (preview changes)
rsync -avz --dry-run local_dir/ vps_h:/home/vincent/remote_dir/

# Exclude files
rsync -avz --exclude='*.log' local_dir/ vps_h:/home/vincent/remote_dir/

# Show progress
rsync -avz --progress local_dir/ vps_h:/home/vincent/remote_dir/
```

---

## Playwright (E2E Testing)

```bash
# Run all tests
npx playwright test

# Run specific test file
npx playwright test tests/example.spec.ts

# Run tests in headed mode (visible browser)
npx playwright test --headed

# Run tests in specific browser
npx playwright test --project=chromium
npx playwright test --project=firefox
npx playwright test --project=webkit

# Run tests in debug mode
npx playwright test --debug

# Generate code
npx playwright codegen https://example.com

# Show report
npx playwright show-report

# Install browsers
npx playwright install
npx playwright install chromium
```

---

## System Management

### Cron (Scheduled Jobs)
```bash
# List cron jobs
crontab -l

# Edit cron jobs
crontab -e

# Remove all cron jobs
crontab -r

# View cron jobs on VPS
ssh vps_dlt 'crontab -l'

# Cron syntax: minute hour day month weekday command
# Example: Run every day at 2:00 AM
# 0 2 * * * /path/to/script.sh

# Example: Run every hour
# 0 * * * * /path/to/script.sh

# Example: Run every 15 minutes
# */15 * * * * /path/to/script.sh
```

### systemd (Service Management)
```bash
# Start service
sudo systemctl start service_name

# Stop service
sudo systemctl stop service_name

# Restart service
sudo systemctl restart service_name

# Enable service (start on boot)
sudo systemctl enable service_name

# Disable service
sudo systemctl disable service_name

# Check service status
systemctl status service_name

# View service logs
journalctl -u service_name
journalctl -u service_name -f  # Follow logs
journalctl -u service_name --since today
```

### Process Management
```bash
# List processes
ps aux
ps aux | grep process_name

# Kill process
kill PID
kill -9 PID  # Force kill

# Kill by name
pkill process_name
killall process_name

# Monitor processes
top
htop  # If installed

# Background jobs
command &  # Run in background
jobs  # List background jobs
fg  # Bring to foreground
bg  # Resume in background
```

---

## File Operations

### Find Files
```bash
# Find by name
find /path -name "filename"
find /path -name "*.py"

# Find by type
find /path -type f  # Files
find /path -type d  # Directories

# Find and execute
find /path -name "*.log" -exec rm {} \;

# Find modified in last N days
find /path -mtime -7  # Last 7 days
```

### Search Content (grep)
```bash
# Search in files
grep "pattern" file.txt
grep -r "pattern" directory/  # Recursive
grep -i "pattern" file.txt  # Case insensitive
grep -n "pattern" file.txt  # Show line numbers
grep -v "pattern" file.txt  # Invert match (exclude)

# Search with context
grep -A 3 "pattern" file.txt  # 3 lines after
grep -B 3 "pattern" file.txt  # 3 lines before
grep -C 3 "pattern" file.txt  # 3 lines before and after
```

### Disk Usage
```bash
# Check disk space
df -h

# Check directory size
du -sh directory/
du -h --max-depth=1 directory/

# Find large files
find /path -type f -size +100M
```

---

## Quick Reference by Task

### Deploy to VPS
```bash
# 1. Commit changes locally
git add .
git commit -m "feat: new feature"
git push

# 2. Pull on VPS
ssh vps_h 'cd /home/vincent/project && git pull'

# 3. Restart service (if needed)
ssh vps_h 'cd /home/vincent/docker/service && docker-compose restart'
```

### Run dlt Pipeline on VPS
```bash
ssh vps_dlt 'cd /home/dlthub/dlthub-project/dlthub-unified && uv run python ingestion/pipeline.py'
```

### Run dbt Models on VPS
```bash
ssh vps_dlt 'cd /home/dlthub/dlthub-project/dlthub-unified/transformation && dbt run'
```

### Check Docker Logs on VPS
```bash
ssh vps_h 'docker logs -f --tail 100 container_name'
```

### Sync Files to VPS
```bash
rsync -avz --exclude='.git' --exclude='__pycache__' project/ vps_h:/home/vincent/project/
```
