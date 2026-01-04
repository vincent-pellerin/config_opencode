# Variables d'Environnement - Référence Complète

## Vue d'Ensemble

Ce document liste toutes les variables d'environnement configurées dans `~/.opencode/.env` avec leur source et leur utilisation.

---

## 📋 Table des Matières

1. [Telegram Bot](#telegram-bot)
2. [Gemini API](#gemini-api)
3. [VPS Configuration](#vps-configuration)
4. [Docker Services](#docker-services)
5. [n8n](#n8n)
6. [Matomo](#matomo)
7. [Obsidian Sync](#obsidian-sync)
8. [Projets](#projets)
9. [GCP & BigQuery](#gcp--bigquery)
10. [Facebook/Meta API](#facebookmeta-api)
11. [Google OAuth](#google-oauth)

---

## Telegram Bot

**Source:** À configurer manuellement

| Variable | Valeur | Description |
|----------|--------|-------------|
| `TELEGRAM_BOT_TOKEN` | `your_bot_token_here` | Token du bot Telegram (depuis @BotFather) |
| `TELEGRAM_CHAT_ID` | `your_chat_id_here` | ID du chat Telegram |
| `TELEGRAM_BOT_USERNAME` | `@YourBotUsername` | Nom d'utilisateur du bot |
| `TELEGRAM_IDLE_TIMEOUT` | `300000` | Timeout d'inactivité (5 min) |
| `TELEGRAM_CHECK_INTERVAL` | `30000` | Intervalle de vérification (30 sec) |
| `TELEGRAM_ENABLED` | `true` | Activer/désactiver le plugin |

---

## Gemini API

**Source:** À configurer manuellement

| Variable | Valeur | Description |
|----------|--------|-------------|
| `GEMINI_API_KEY` | `your_gemini_api_key_here` | Clé API Gemini (depuis makersuite.google.com) |

---

## VPS Configuration

**Source:** Configuration SSH existante

### VPS Vincent (vps_h)

| Variable | Valeur | Description |
|----------|--------|-------------|
| `VPS_HOST_VINCENT` | `host` | Hostname du VPS |
| `VPS_USER_VINCENT` | `vincent` | Nom d'utilisateur |
| `VPS_SSH_ALIAS_VINCENT` | `vps_h` | Alias SSH |
| `VPS_PORT_VINCENT` | `22` | Port SSH |
| `VPS_HOME_VINCENT` | `/home/vincent` | Répertoire home |
| `VPS_DOCKER_PATH` | `/home/vincent/docker` | Chemin des services Docker |
| `VPS_CREDENTIALS_PATH` | `/home/vincent/.credentials` | Chemin des credentials |
| `VPS_OBSIDIAN_VAULT` | `/home/vincent/obsidian-second-brain-vps` | Vault Obsidian VPS |
| `VPS_IMMO_STRAS` | `/home/vincent/immo-stras` | Projet immo-stras |
| `VPS_GA4_REPORT` | `/home/vincent/ga4-weekly-report` | Projet GA4 |

### VPS dlthub (vps_dlt)

| Variable | Valeur | Description |
|----------|--------|-------------|
| `VPS_HOST_DLTHUB` | `host` | Hostname du VPS |
| `VPS_USER_DLTHUB` | `dlthub` | Nom d'utilisateur |
| `VPS_SSH_ALIAS_DLTHUB` | `vps_dlt` | Alias SSH |
| `VPS_PORT_DLTHUB` | `22` | Port SSH |
| `VPS_HOME_DLTHUB` | `/home/dlthub` | Répertoire home |
| `VPS_DLTHUB_PROJECT` | `/home/dlthub/dlthub-project/dlthub-unified` | Projet dlthub-unified |

---

## Docker Services

**Source:** Exploration VPS

| Variable | Valeur | Description |
|----------|--------|-------------|
| `DOCKER_TRAEFIK_PATH` | `/home/vincent/docker/traefik` | Chemin Traefik |
| `DOCKER_N8N_PATH` | `/home/vincent/docker/n8n-compose` | Chemin n8n |
| `DOCKER_MATOMO_PATH` | `/home/vincent/docker/matomo` | Chemin Matomo |
| `DOCKER_NETWORK` | `traefik-network` | Réseau Docker externe |

---

## n8n

**Source:** `/home/vincent/docker/n8n-compose/.env` (VPS)

| Variable | Valeur | Description |
|----------|--------|-------------|
| `N8N_DOMAIN_NAME` | `vpdata.fr` | Domaine principal |
| `N8N_SUBDOMAIN` | `n8n` | Sous-domaine |
| `N8N_GENERIC_TIMEZONE` | `Europe/Berlin` | Timezone |
| `N8N_SSL_EMAIL` | `galakbibi@gmail.com` | Email pour SSL |
| `N8N_BASIC_AUTH_ACTIVE` | `true` | Activer Basic Auth |
| `N8N_BASIC_AUTH_USER` | `galakbibi@gmail.com` | User Basic Auth |
| `N8N_BASIC_AUTH_PASSWORD` | `bf*8!9aPqe2aSDN` | Password Basic Auth |
| `N8N_WEBHOOK_URL` | `https://n8n.vpdata.fr/webhook/immo-scraping` | URL webhook immo |

---

## Matomo

**Source:** `/home/vincent/docker/matomo/.env` (VPS)

| Variable | Valeur | Description |
|----------|--------|-------------|
| `MATOMO_ROOT_PASSWORD` | `vincent123*` | Password root MariaDB |
| `MATOMO_DB_NAME` | `matomo` | Nom de la base de données |
| `MATOMO_DB_USER` | `vincent` | Utilisateur DB |
| `MATOMO_DB_PASSWORD` | `data4nerds*` | Password DB |

---

## Obsidian Sync

**Source:** `/home/vincent/obsidian-sync/.env` (VPS)

| Variable | Valeur | Description |
|----------|--------|-------------|
| `OBSIDIAN_DOMAIN` | `obsidian.vpdata.fr` | Domaine Obsidian |
| `COUCHDB_USER` | `admin` | User CouchDB |
| `COUCHDB_PASSWORD` | `46iWxeRv9oEvX4QYResb43lrAThkaN` | Password CouchDB |
| `OBSIDIAN_SYNC_LOCAL` | `/home/vincent/dev/obsidian-sync` | Chemin local |
| `OBSIDIAN_SYNC_VPS` | `/home/vincent/obsidian-sync` | Chemin VPS |

---

## Projets

### dlthub-unified

**Source:** Exploration VPS

| Variable | Valeur | Description |
|----------|--------|-------------|
| `DLTHUB_INGESTION_PATH` | `/home/dlthub/dlthub-project/dlthub-unified/ingestion` | Pipelines dlt |
| `DLTHUB_TRANSFORMATION_PATH` | `/home/dlthub/dlthub-project/dlthub-unified/transformation` | Modèles dbt |
| `DLTHUB_LOGS_PATH` | `/home/dlthub/dlthub-project/dlthub-unified/logs` | Logs |
| `DLTHUB_SERVICE_ACCOUNT` | `/home/dlthub/dlthub-project/dlthub-unified/infrastructure/credentials/service-account.json` | Service account |
| `DBT_SERVICE_ACCOUNT` | `/home/dlthub/dbt-transfo-key.json` | Service account dbt (legacy) |

### immo-stras

**Source:** `/home/vincent/immo-stras/.env` (VPS)

| Variable | Valeur | Description |
|----------|--------|-------------|
| `IMMO_STRAS_LOCAL` | `/home/vincent/dev/immo-stras` | Chemin local |
| `IMMO_STRAS_VPS` | `/home/vincent/immo-stras` | Chemin VPS |
| `IMMO_DATABASE_PATH` | `/app/data/immo.db` | Base de données DuckDB |
| `IMMO_IMAGES_PATH` | `/app/images` | Stockage images |
| `IMMO_API_HOST` | `0.0.0.0` | Host API |
| `IMMO_API_PORT` | `8000` | Port API |
| `IMMO_BASIC_AUTH_USERS` | `vincent:$$apr1$$1A9ZhAKw$$yPR3Q8xD9aghq0QdP47/40` | Basic Auth |

**Search Criteria:**

| Variable | Valeur | Description |
|----------|--------|-------------|
| `IMMO_SEARCH_CITIES` | `Strasbourg,Lingolsheim,Oberhausbergen,Wolfisheim,Eckbolsheim` | Villes de recherche |
| `IMMO_SEARCH_ZIPCODES` | `67200,67380,67205,67202,67201` | Codes postaux |
| `IMMO_SEARCH_PRICE_MAX` | `420000` | Prix maximum (€) |
| `IMMO_SEARCH_SURFACE_MIN` | `85` | Surface minimum (m²) |
| `IMMO_SEARCH_PROPERTY_TYPES` | `apartment,house` | Types de biens |

**Scraping:**

| Variable | Valeur | Description |
|----------|--------|-------------|
| `IMMO_SCRAPING_USER_AGENT` | `Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36` | User agent |
| `IMMO_SCRAPING_TIMEOUT` | `30` | Timeout (secondes) |
| `IMMO_SCRAPING_MAX_RETRIES` | `3` | Nombre de tentatives |

### ga4-weekly-report

**Source:** `/home/vincent/ga4-weekly-report/.env` (VPS)

| Variable | Valeur | Description |
|----------|--------|-------------|
| `GA4_REPORT_LOCAL` | `/home/vincent/dev/ga4-weekly-report` | Chemin local |
| `GA4_REPORT_VPS` | `/home/vincent/ga4-weekly-report` | Chemin VPS |
| `GA4_PROPERTY_ID` | `490700163` | ID propriété GA4 |
| `GA4_SERVICE_ACCOUNT` | `/home/vincent/.credentials/ga4-service-account.json` | Service account local |
| `GA4_SERVICE_ACCOUNT_VPS` | `/home/vincent/.credentials/ga4-service-account.json` | Service account VPS |

**Email:**

| Variable | Valeur | Description |
|----------|--------|-------------|
| `GA4_EMAIL_TO` | `vpellerindata@gmail.com` | Destinataire |
| `GA4_EMAIL_FROM` | `ga4-report@host` | Expéditeur |
| `GA4_SMTP_HOST` | `localhost` | Serveur SMTP |
| `GA4_SMTP_PORT` | `25` | Port SMTP |
| `GA4_USE_TLS` | `false` | Utiliser TLS |

---

## GCP & BigQuery

**Source:** `gcloud config` + `/home/dlthub/.dbt/profiles.yml` (VPS)

| Variable | Valeur | Description |
|----------|--------|-------------|
| `GCP_PROJECT_ID_PERSO` | `perso-478120` | Projet GCP personnel |
| `GCP_PROJECT_ID_BREDELERS` | `bredelers` | Projet GCP Bredelers |
| `BQ_DATASET_DEV` | `bredelers_analytics_dev` | Dataset dev |
| `BQ_DATASET_STAGING` | `bredelers_analytics_staging` | Dataset staging |
| `BQ_DATASET_PROD` | `bredelers_analytics_prod` | Dataset prod |
| `GCP_LOCATION` | `EU` | Localisation GCP |

---

## Facebook/Meta API

**Source:** `/home/dlthub/dlthub-project/dlthub-unified/.dlt/secrets.toml` (VPS)

| Variable | Valeur | Description |
|----------|--------|-------------|
| `FACEBOOK_ACCESS_TOKEN` | `your_facebook_access_token` | Token d'accès long-lived |
| `FACEBOOK_API_VERSION` | `v23.0` | Version API |
| `FACEBOOK_APP_ID` | `your_facebook_app_id` | ID application |
| `FACEBOOK_APP_SECRET` | `your_facebook_app_secret` | Secret application |
| `FACEBOOK_PAGE_ID` | `169730229756555` | ID page Les Bredelers |
| `INSTAGRAM_ACCOUNT_ID` | `17841406518723992` | ID compte Instagram |

---

## Google OAuth

**Source:** `/home/vincent/docker/n8n-compose/.env` + `.dlt/secrets.toml` (VPS)

### n8n OAuth

| Variable | Valeur | Description |
|----------|--------|-------------|
| `GOOGLE_OAUTH_CLIENT_ID` | `your_google_oauth_client_id` | Client ID |
| `GOOGLE_OAUTH_CLIENT_SECRET` | `your_google_oauth_client_secret` | Client Secret |

### YouTube Analytics

| Variable | Valeur | Description |
|----------|--------|-------------|
| `YOUTUBE_CLIENT_ID` | `your_youtube_client_id` | Client ID YouTube |
| `YOUTUBE_CLIENT_SECRET` | `your_youtube_client_secret` | Client Secret YouTube |
| `YOUTUBE_REFRESH_TOKEN` | `your_youtube_refresh_token` | Refresh Token |

---

## Chemins Locaux

| Variable | Valeur | Description |
|----------|--------|-------------|
| `LOCAL_DEV_PATH` | `/home/vincent/dev` | Racine développement |
| `LOCAL_OBSIDIAN_VAULT` | `/home/vincent/dev/Obsidian` | Vault Obsidian local |

---

## Sécurité

### ⚠️ Fichiers Sensibles

- `~/.opencode/.env` - **NE JAMAIS COMMITER**
- Permissions: `600` (lecture/écriture user uniquement)
- Backup sécurisé recommandé

### 🔄 Rotation des Secrets

Les tokens suivants doivent être renouvelés régulièrement :

- `FACEBOOK_ACCESS_TOKEN` - Token long-lived (expire après 60 jours)
- `YOUTUBE_REFRESH_TOKEN` - Peut expirer si non utilisé
- Passwords des bases de données
- Tokens API

### 📝 Mise à Jour

Pour mettre à jour une variable :

```bash
# Éditer le fichier
nano ~/.opencode/.env

# Vérifier les permissions
chmod 600 ~/.opencode/.env

# Redémarrer les services si nécessaire
ssh vps_h 'cd /home/vincent/docker/n8n-compose && docker-compose restart'
```

---

**Dernière mise à jour:** 2026-01-04  
**Version:** 1.0  
**Fichier source:** `~/.opencode/.env`
