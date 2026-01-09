# Docker Services on VPS

## Overview

All Docker services running on the VPS with configuration details, ports, and management commands.

---

## Service Locations

All Docker services are located in `/home/vincent/docker/` on the VPS.

```
/home/vincent/docker/
├── traefik/           # Reverse proxy and SSL termination
├── n8n-compose/       # Workflow automation
├── matomo/            # Web analytics platform
└── matomo-nginx/      # Nginx for Matomo (legacy)
```

---

## Traefik (Reverse Proxy)

### Overview
- **Purpose:** Reverse proxy, load balancer, SSL certificate management
- **Location:** `/home/vincent/docker/traefik/`
- **Image:** `traefik:latest`
- **Container Name:** `traefik`
- **Network:** `traefik-network` (external)

### Ports
- **80** - HTTP (redirects to HTTPS)
- **443** - HTTPS (SSL/TLS)
- **8080** - Dashboard (web UI)

### Dashboard
- **URL:** `https://proxy.vpdata.fr`
- **Access:** Protected by Traefik configuration

### Configuration Files
```
/home/vincent/docker/traefik/
├── docker-compose.yml    # Service definition
├── traefik.yml           # Main Traefik configuration
├── dynamic/              # Dynamic configuration
└── acme.json             # Let's Encrypt certificates (auto-generated)
```

### Key Features
- **Automatic SSL:** Let's Encrypt certificates with auto-renewal
- **Service Discovery:** Automatically detects Docker containers
- **Load Balancing:** Distributes traffic across services
- **Dashboard:** Real-time monitoring and configuration

### Management Commands
```bash
# Start Traefik
ssh vps_h 'cd /home/vincent/docker/traefik && docker-compose up -d'

# Stop Traefik
ssh vps_h 'cd /home/vincent/docker/traefik && docker-compose down'

# Restart Traefik
ssh vps_h 'cd /home/vincent/docker/traefik && docker-compose restart'

# View logs
ssh vps_h 'docker logs -f traefik'
ssh vps_h 'docker logs --tail 100 traefik'

# Check status
ssh vps_h 'docker ps | grep traefik'

# View configuration
ssh vps_h 'cat /home/vincent/docker/traefik/traefik.yml'
```

### docker-compose.yml
```yaml
services:
  traefik:
    image: traefik:latest
    container_name: traefik
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
      - "8080:8080"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./traefik.yml:/etc/traefik/traefik.yml
      - ./dynamic:/etc/traefik/dynamic
      - ./acme.json:/etc/traefik/acme.json
    networks:
      - traefik-network
    labels:
      - traefik.enable=true
      - traefik.http.routers.traefik.rule=Host(`proxy.vpdata.fr`)
      - traefik.http.routers.traefik.entrypoints=https
      - traefik.http.routers.traefik.tls=true
      - traefik.http.routers.traefik.tls.certresolver=letsencrypt
      - traefik.http.services.traefik.loadbalancer.server.port=8080

networks:
  traefik-network:
    external: true
```

---

## n8n (Workflow Automation)

### Overview
- **Purpose:** Workflow automation and integration platform
- **Location:** `/home/vincent/docker/n8n-compose/`
- **Image:** `docker.n8n.io/n8nio/n8n`
- **Container Name:** `n8n`
- **Network:** `traefik-network` (external)

### Access
- **URL:** `https://${SUBDOMAIN}.${DOMAIN_NAME}` (configured via .env)
- **Protocol:** HTTPS (via Traefik)
- **Authentication:** Basic Auth (configured via .env)

### Configuration Files
```
/home/vincent/docker/n8n-compose/
├── docker-compose.yml    # Service definition
├── .env                  # Environment variables (secrets)
└── local-files/          # Local file storage
```

### Environment Variables (.env)
- `SUBDOMAIN` - Subdomain for n8n
- `DOMAIN_NAME` - Domain name
- `N8N_BASIC_AUTH_ACTIVE` - Enable/disable basic auth
- `N8N_BASIC_AUTH_USER` - Basic auth username
- `N8N_BASIC_AUTH_PASSWORD` - Basic auth password
- `GENERIC_TIMEZONE` - Timezone setting
- `FACEBOOK_ACCESS_TOKEN` - Facebook API token
- `FACEBOOK_API_VERSION` - Facebook API version

### Key Features
- **Workflow Automation:** Visual workflow builder
- **Integrations:** 200+ app integrations
- **API Access:** Public API enabled
- **Secure:** HTTPS with basic auth
- **Persistent Data:** Volume-backed storage

### Management Commands
```bash
# Start n8n
ssh vps_h 'cd /home/vincent/docker/n8n-compose && docker-compose up -d'

# Stop n8n
ssh vps_h 'cd /home/vincent/docker/n8n-compose && docker-compose down'

# Restart n8n
ssh vps_h 'cd /home/vincent/docker/n8n-compose && docker-compose restart'

# View logs
ssh vps_h 'docker logs -f n8n'
ssh vps_h 'docker logs --tail 100 n8n'

# Check status
ssh vps_h 'docker ps | grep n8n'

# Access n8n shell
ssh vps_h 'docker exec -it n8n sh'

# Backup n8n data
ssh vps_h 'docker run --rm -v n8n_data:/data -v $(pwd):/backup alpine tar czf /backup/n8n-backup.tar.gz /data'
```

### docker-compose.yml (Key Settings)
```yaml
services:
  n8n:
    image: docker.n8n.io/n8nio/n8n
    restart: always
    container_name: n8n
    env_file:
      - .env
    environment:
      - N8N_HOST=${SUBDOMAIN}.${DOMAIN_NAME}
      - N8N_PORT=5678
      - N8N_PROTOCOL=https
      - NODE_ENV=production
      - WEBHOOK_URL=https://${SUBDOMAIN}.${DOMAIN_NAME}/
      - N8N_RUNNERS_ENABLED=true
      - N8N_PUBLIC_API_DISABLED=false
      - N8N_SECURE_COOKIE=true
    volumes:
      - n8n_data:/home/node/.n8n
      - ./local-files:/files
    networks:
      - traefik-network
```

---

## Matomo (Web Analytics)

### Overview
- **Purpose:** Web analytics platform (self-hosted alternative to Google Analytics)
- **Location:** `/home/vincent/docker/matomo/`
- **Images:** 
  - `matomo:5.5.0` (application)
  - `linuxserver/mariadb` (database)
- **Containers:**
  - `matomo` (application)
  - `matomo-db` (MariaDB database)
- **Network:** `traefik-network` (external)

### Ports
- **3306** - MariaDB (mapped to localhost only: `127.0.0.1:3306`)
- **80** - Matomo web interface (via Traefik)

### Configuration Files
```
/home/vincent/docker/matomo/
├── docker-compose.yml           # Service definition
├── docker-compose.yml.backup    # Backup configuration
└── .env                         # Environment variables (secrets)
```

### Data Volumes
- **Database:** `/apps/matomo/db` (MariaDB data)
- **Application:** `/apps/matomo/data` (Matomo files)

### Environment Variables (.env)
- `ROOT_PASSWORD` - MariaDB root password
- `DB_NAME` - Database name
- `DB_USER` - Database user
- `DB_PASSWORD` - Database password

### Key Features
- **Self-Hosted Analytics:** Full data ownership
- **MariaDB Backend:** Persistent data storage
- **Traefik Integration:** Automatic HTTPS
- **Local Database Access:** Port 3306 for DBeaver/SQL clients

### Management Commands
```bash
# Start Matomo
ssh vps_h 'cd /home/vincent/docker/matomo && docker-compose up -d'

# Stop Matomo
ssh vps_h 'cd /home/vincent/docker/matomo && docker-compose down'

# Restart Matomo
ssh vps_h 'cd /home/vincent/docker/matomo && docker-compose restart'

# Restart specific service
ssh vps_h 'cd /home/vincent/docker/matomo && docker-compose restart matomo'
ssh vps_h 'cd /home/vincent/docker/matomo && docker-compose restart matomo-db'

# View logs
ssh vps_h 'docker logs -f matomo'
ssh vps_h 'docker logs -f matomo-db'

# Check status
ssh vps_h 'docker ps | grep matomo'

# Access Matomo shell
ssh vps_h 'docker exec -it matomo bash'

# Access MariaDB shell
ssh vps_h 'docker exec -it matomo-db mysql -u root -p'

# Backup database
ssh vps_h 'docker exec matomo-db mysqldump -u root -p${ROOT_PASSWORD} ${DB_NAME} > matomo-backup.sql'
```

### docker-compose.yml (Key Settings)
```yaml
services:
  matomo-db:
    image: linuxserver/mariadb
    restart: unless-stopped
    container_name: matomo-db
    environment:
      - MYSQL_ROOT_PASSWORD=${ROOT_PASSWORD}
      - MYSQL_DATABASE=${DB_NAME}
      - MYSQL_USER=${DB_USER}
      - MYSQL_PASSWORD=${DB_PASSWORD}
      - MARIADB_EXTRA_FLAGS=--max_allowed_packet=64MB
    volumes:
      - /apps/matomo/db:/config
    ports:
      - "127.0.0.1:3306:3306"
    networks:
      - traefik-network

  matomo:
    image: matomo:5.5.0
    container_name: matomo
    restart: unless-stopped
    environment:
      - MATOMO_DATABASE_HOST=matomo-db
      - MATOMO_DATABASE_DBNAME=${DB_NAME}
      - MATOMO_DATABASE_USERNAME=${DB_USER}
      - MATOMO_DATABASE_PASSWORD=${DB_PASSWORD}
    volumes:
      - /apps/matomo/data:/var/www/html
    depends_on:
      - matomo-db
    networks:
      - traefik-network
```

---

## Docker Network

### traefik-network
- **Type:** External network
- **Purpose:** Connect all services to Traefik reverse proxy
- **Creation:** Must be created before starting services

```bash
# Create network (if not exists)
ssh vps_h 'docker network create traefik-network'

# List networks
ssh vps_h 'docker network ls'

# Inspect network
ssh vps_h 'docker network inspect traefik-network'

# List containers on network
ssh vps_h 'docker network inspect traefik-network | grep -A 5 Containers'
```

---

## immo-stras (Real Estate Scraper)

### Overview
- **Purpose:** Real estate listing aggregator and scraper for Strasbourg area
- **Repository:** GitHub Actions CI/CD deployment
- **Image:** GHCR (GitHub Container Registry)
- **Container Name:** `immo-stras`
- **Network:** `traefik-network` (external)
- **URL:** `https://immo.vpdata.fr`

### Deployment Pipeline
```
GitHub Push → GitHub Actions → Build & Push to GHCR → SSH to VPS → Docker Pull & Deploy
```

**CI/CD Workflow Location:** `$WORKSPACE/immo-stras/.github/workflows/deploy.yml`

### Deployment Commands
```bash
# Trigger deployment via GitHub Actions (push to main branch)
git add .
git commit -m "feat: update search criteria"
git push origin main

# Or manually via SSH on VPS
ssh vps_h 'docker pull ghcr.io/vpellerin/immo-stras:latest && \
           docker stop immo-stras && \
           docker rm immo-stras && \
           docker run -d --name immo-stras ghcr.io/vpellerin/immo-stras:latest'
```

### Configuration Files
```
$WORKSPACE/immo-stras/
├── docker-compose.yml          # Docker service definition
├── Dockerfile                  # Image build definition
├── .env.local                  # Local environment (not on VPS)
├── .env.example               # Template for environment variables
└── .github/workflows/deploy.yml  # CI/CD pipeline
```

### Environment Variables
- `API_PORT` - API port (default: 8000)
- `SCRAPING_TIMEOUT` - Timeout for scraping requests
- `SCRAPING_MAX_RETRIES` - Maximum retry attempts
- `SEARCH_CITIES` - Cities to search (Strasbourg,Lingolsheim,Oberhausbergen,Wolfisheim,Eckbolsheim)
- `SEARCH_ZIPCODES` - Postal codes (67200,67380,67205,67202,67201)
- `SEARCH_PRICE_MAX` - Maximum price (420000)
- `SEARCH_SURFACE_MIN` - Minimum surface (85)
- `N8N_WEBHOOK_URL` - n8n webhook for notifications

### Key Features
- **FastAPI** web interface for browsing listings
- **LeBonCoin** scraper (primary source)
- **Deduplication** (exact + fuzzy matching)
- **Database** (SQLite) for persistent storage
- **n8n Integration** for daily emails and automated scraping
- **Traefik** reverse proxy with HTTPS

### Management Commands
```bash
# Check status on VPS
ssh vps_h 'docker ps | grep immo-stras'

# View logs
ssh vps_h 'docker logs -f immo-stras'
ssh vps_h 'docker logs --tail 100 immo-stras'

# Restart service
ssh vps_h 'docker restart immo-stras'

# Access container shell
ssh vps_h 'docker exec -it immo-stras sh'

# Check API health
curl https://immo.vpdata.fr/api/health
```

### Traefik Labels
```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.immo-http.rule=Host(`immo.vpdata.fr`)"
  - "traefik.http.routers.immo-http.entrypoints=http"
  - "traefik.http.routers.immo.rule=Host(`immo.vpdata.fr`)"
  - "traefik.http.routers.immo.entrypoints=https"
  - "traefik.http.routers.immo.tls.certresolver=letsencrypt"
  - "traefik.http.services.immo.loadbalancer.server.port=8000"
  - "traefik.http.middlewares.immo-auth.basicauth.users=${IMMO_BASIC_AUTH_USERS}"
```

### n8n Integration
- **Scraping Webhook:** `https://n8n.vpdata.fr/webhook/immo-scraping`
- **Workflows:** Located in `$WORKSPACE/immo-stras/n8n/`
  - `workflow-daily-email.json` - Daily email summary (activated ✓)
  - `workflow-scrape-leboncoin.json` - Automated scraping (2×/day)
- **Email Notifications:** Gmail SMTP with App Password

### Recent Changes Applied
- **2026-01-08:** Added Eckbolsheim (67201) to search criteria
- **Files Updated:**
  - `docker-compose.yml` (lines 33-34)
  - `README.md` (line 21)
- **Deployment:** Requires GitHub Actions push to main

---

## Common Operations

### Start All Services
```bash
ssh vps_h 'cd /home/vincent/docker/traefik && docker-compose up -d && \
           cd /home/vincent/docker/n8n-compose && docker-compose up -d && \
           cd /home/vincent/docker/matomo && docker-compose up -d'
```

### Stop All Services
```bash
ssh vps_h 'cd /home/vincent/docker/traefik && docker-compose down && \
           cd /home/vincent/docker/n8n-compose && docker-compose down && \
           cd /home/vincent/docker/matomo && docker-compose down'
```

### Restart All Services
```bash
ssh vps_h 'cd /home/vincent/docker/traefik && docker-compose restart && \
           cd /home/vincent/docker/n8n-compose && docker-compose restart && \
           cd /home/vincent/docker/matomo && docker-compose restart'
```

### View All Logs
```bash
ssh vps_h 'docker logs -f --tail 50 traefik'
ssh vps_h 'docker logs -f --tail 50 n8n'
ssh vps_h 'docker logs -f --tail 50 matomo'
ssh vps_h 'docker logs -f --tail 50 matomo-db'
```

### Check All Services Status
```bash
ssh vps_h 'docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
```

### Update Service Images
```bash
# Pull latest images
ssh vps_h 'cd /home/vincent/docker/traefik && docker-compose pull'
ssh vps_h 'cd /home/vincent/docker/n8n-compose && docker-compose pull'
ssh vps_h 'cd /home/vincent/docker/matomo && docker-compose pull'

# Recreate containers with new images
ssh vps_h 'cd /home/vincent/docker/traefik && docker-compose up -d'
ssh vps_h 'cd /home/vincent/docker/n8n-compose && docker-compose up -d'
ssh vps_h 'cd /home/vincent/docker/matomo && docker-compose up -d'
```

---

## Troubleshooting

### Service Won't Start
```bash
# Check logs for errors
ssh vps_h 'docker logs container_name'

# Check if port is already in use
ssh vps_h 'sudo netstat -tulpn | grep PORT_NUMBER'

# Check if network exists
ssh vps_h 'docker network ls | grep traefik-network'

# Recreate network if needed
ssh vps_h 'docker network rm traefik-network && docker network create traefik-network'
```

### SSL Certificate Issues
```bash
# Check Traefik logs
ssh vps_h 'docker logs traefik | grep -i acme'

# Check acme.json permissions (must be 600)
ssh vps_h 'ls -la /home/vincent/docker/traefik/acme.json'

# Fix permissions if needed
ssh vps_h 'chmod 600 /home/vincent/docker/traefik/acme.json'
```

### Database Connection Issues (Matomo)
```bash
# Check if database is running
ssh vps_h 'docker ps | grep matomo-db'

# Check database logs
ssh vps_h 'docker logs matomo-db'

# Test database connection
ssh vps_h 'docker exec matomo-db mysql -u ${DB_USER} -p${DB_PASSWORD} -e "SHOW DATABASES;"'
```

### Disk Space Issues
```bash
# Check disk usage
ssh vps_h 'df -h'

# Check Docker disk usage
ssh vps_h 'docker system df'

# Clean up unused Docker resources
ssh vps_h 'docker system prune -a'

# Remove old images
ssh vps_h 'docker image prune -a'
```

---

## Security Notes

- **Environment Files:** All `.env` files contain sensitive credentials
- **Never commit `.env` files** to version control
- **Backup `.env` files** securely before making changes
- **Restrict file permissions:** `chmod 600 .env`
- **Use strong passwords** for all database and auth credentials
- **Keep images updated** for security patches
