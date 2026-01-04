# Configuration VPS pour OpenCode

## Vue d'Ensemble

La configuration VPS a été intégrée dans `~/.opencode/context/global/` pour permettre aux agents OpenCode d'accéder facilement aux informations d'environnement et de déploiement.

## Structure Créée

```
~/.opencode/
├── context/
│   ├── global/                          # ← NOUVEAU
│   │   ├── environments.md              # Configuration des environnements
│   │   ├── machine.md                   # Outils et stack technique
│   │   ├── tools.md                     # CLI et commandes
│   │   └── docker-services.md           # Services Docker sur VPS
│   ├── project/
│   │   └── project-context.md           # ← ENRICHI avec références
│   └── core/
│       └── standards/
├── .env                                 # ← CRÉÉ (variables d'environnement)
└── env.example                          # Template existant
```

## Fichiers Créés

### 1. `~/.opencode/context/global/environments.md` (9.0 KB)

**Contenu:**
- Configuration complète des 3 environnements :
  - Local Development (vincent@vincent-X390-2025)
  - VPS Production - vincent user (vps_h)
  - VPS Production - dlthub user (vps_dlt)
- Mapping des projets (local ↔ VPS)
- Chemins critiques et credentials
- Commandes de connexion et transfert de fichiers
- Règles de sécurité

**Projets documentés:**
- dlthub-unified (VPS user: dlthub)
- immo-stras (VPS user: vincent)
- ga4-weekly-report (VPS user: vincent)

### 2. `~/.opencode/context/global/machine.md` (7.7 KB)

**Contenu:**
- Python ecosystem (uv, pip, black, ruff, mypy)
- Data & Analytics (dlt, dbt, DuckDB, PostgreSQL, BigQuery)
- Cloud & Infrastructure (GCP, Docker, Traefik)
- Development tools (Git, GitHub CLI, Node.js, Playwright)
- Web scraping tools
- Obsidian configuration
- Commandes d'installation

### 3. `~/.opencode/context/global/tools.md` (12 KB)

**Contenu:**
- Référence complète des commandes CLI
- Python (uv, pytest, black, ruff, mypy)
- Data tools (dlt, dbt, bq)
- GCP (gcloud, gsutil)
- Docker & Docker Compose
- Git & GitHub CLI
- SSH & File Transfer (scp, rsync)
- Playwright
- System management (cron, systemd)
- Quick reference par tâche

### 4. `~/.opencode/context/global/docker-services.md` (12 KB)

**Contenu:**
- **Traefik** (reverse proxy)
  - Ports: 80, 443, 8080
  - Dashboard: proxy.vpdata.fr
  - SSL automatique (Let's Encrypt)
  - Configuration complète
  
- **n8n** (workflow automation)
  - Configuration et variables d'environnement
  - Commandes de gestion
  - Backup et restore
  
- **Matomo** (web analytics)
  - MariaDB backend
  - Port 3306 (localhost)
  - Commandes de gestion
  - Backup database

- **Docker Network** (traefik-network)
- Opérations communes
- Troubleshooting

### 5. `~/.opencode/.env` (5.1 KB)

**Contenu:**
- Variables d'environnement pour tous les services
- Configuration Telegram Bot
- Configuration Gemini API
- Chemins VPS (vincent et dlthub)
- Chemins locaux
- Configuration Docker
- Configuration projets
- Configuration GCP/BigQuery
- Configuration bases de données

**⚠️ IMPORTANT:** Ce fichier contient des secrets et ne doit JAMAIS être commité.

### 6. `~/.opencode/context/project/project-context.md` (ENRICHI)

**Modifications:**
- Ajout de références aux fichiers globaux
- Amélioration de la détection d'environnement
- Tableau de mapping des projets
- Références croisées vers la documentation globale

## Utilisation par les Agents

### Chargement du Contexte

Les agents OpenCode peuvent maintenant charger le contexte global :

```markdown
**Context Loaded:**
@.opencode/context/global/environments.md
@.opencode/context/global/machine.md
@.opencode/context/global/tools.md
@.opencode/context/global/docker-services.md
```

### Détection d'Environnement

Les agents peuvent détecter automatiquement l'environnement :

```bash
CURRENT_ENV="$(whoami)@$(hostname)"

if [[ "$CURRENT_ENV" == "vincent@vincent-X390-2025" ]]; then
    # Local development
elif [[ "$CURRENT_ENV" == "vincent@host" ]]; then
    # VPS (vincent user)
elif [[ "$CURRENT_ENV" == "dlthub@host" ]]; then
    # VPS (dlthub user)
fi
```

### Exemples de Commandes

#### Déployer sur VPS
```bash
# 1. Commit local
git add . && git commit -m "feat: new feature" && git push

# 2. Pull sur VPS
ssh vps_h 'cd /home/vincent/immo-stras && git pull'

# 3. Restart service (si Docker)
ssh vps_h 'cd /home/vincent/docker/n8n-compose && docker-compose restart'
```

#### Exécuter Pipeline dlt
```bash
ssh vps_dlt 'cd /home/dlthub/dlthub-project/dlthub-unified && uv run python ingestion/pipeline.py'
```

#### Exécuter Transformations dbt
```bash
ssh vps_dlt 'cd /home/dlthub/dlthub-project/dlthub-unified/transformation && dbt run'
```

## Synchronisation avec config_opencode

Pour synchroniser cette configuration avec le repo de backup :

```bash
# Copier les nouveaux fichiers
cp -r ~/.opencode/context/global/* ~/dev/config_opencode/context/global/
cp ~/.opencode/.env ~/dev/config_opencode/.env.example  # Template seulement
cp ~/.opencode/context/project/project-context.md ~/dev/config_opencode/context/project/

# Commit et push
cd ~/dev/config_opencode
git add .
git commit -m "feat: add VPS configuration in global context"
git push
```

**⚠️ ATTENTION:** Ne jamais copier le fichier `.env` avec les vraies valeurs dans le repo Git !

## Sécurité

### Fichiers Sensibles

- `~/.opencode/.env` - **NE JAMAIS COMMITER**
- `/home/vincent/.credentials/*` (VPS) - Credentials GCP, GA4
- `/home/dlthub/dbt-transfo-key.json` (VPS) - Service account dbt
- `/home/dlthub/dlthub-project/dlthub-unified/.dlt/secrets.toml` (VPS) - Secrets dlt

### Bonnes Pratiques

1. **Toujours utiliser `.env.example`** comme template dans Git
2. **Permissions strictes** sur les fichiers de credentials (600)
3. **SSH key authentication** uniquement (pas de passwords)
4. **Backup sécurisé** des fichiers `.env` avant modifications
5. **Rotation régulière** des secrets et tokens

## Maintenance

### Mise à Jour de la Configuration

Quand vous ajoutez un nouveau service ou projet :

1. **Mettre à jour** `~/.opencode/context/global/environments.md`
2. **Ajouter les outils** dans `machine.md` si nécessaire
3. **Documenter les commandes** dans `tools.md`
4. **Ajouter le service Docker** dans `docker-services.md` si applicable
5. **Mettre à jour** les variables dans `.env`
6. **Synchroniser** avec le repo config_opencode

### Vérification de la Configuration

```bash
# Vérifier que tous les fichiers existent
ls -lh ~/.opencode/context/global/

# Vérifier les connexions VPS
ssh vps_h 'echo "Connected as $(whoami)@$(hostname)"'
ssh vps_dlt 'echo "Connected as $(whoami)@$(hostname)"'

# Vérifier les services Docker
ssh vps_h 'docker ps --format "table {{.Names}}\t{{.Status}}"'
```

## Prochaines Étapes

1. ✅ Configuration VPS créée dans `~/.opencode/context/global/`
2. ✅ Fichier `.env` créé avec toutes les variables
3. ✅ Documentation complète des services Docker
4. ✅ Enrichissement de `project-context.md`
5. ⏳ Synchroniser avec le repo `config_opencode`
6. ⏳ Tester l'utilisation par les agents OpenCode
7. ⏳ Créer des commandes personnalisées pour les opérations VPS courantes

## Support

Pour toute question sur la configuration VPS :
- Consulter `~/.opencode/context/global/environments.md`
- Vérifier les commandes dans `tools.md`
- Consulter la documentation Docker dans `docker-services.md`

---

**Créé le:** 2026-01-04  
**Version OpenCode:** 1.0.223  
**Environnements:** Local (Ubuntu) + VPS (2 users: vincent, dlthub)
