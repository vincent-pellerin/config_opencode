# Configuration du Workspace OpenCode

> **NOTE PORTABILITÉ:** Ce document utilise des chemins génériques avec la variable `$WORKSPACE`. Voir la section [Configuration des chemins](#configuration-des-chemins) pour configurer votre machine.

## Vue d'ensemble

Ce document décrit l'architecture de contexte mise en place pour permettre à différents agents IA (Claude Sonnet 4-5, MiniMax 2.1, etc.) de découvrir automatiquement le contexte des projets sans nécessiter de ré-explications manuelles.

## Problématique initiale

Avant cette configuration, chaque agent IA perdait le contexte lorsqu'un utilisateur changeait d'agent :

```
Problème:
┌─────────────────────────────────────────────────────────────┐
│ Agent A (Claude) travaille sur scraping/                    │
│   → Explique la stack, conventions, CI/CD                   │
│   → Sessions productive                                      │
├─────────────────────────────────────────────────────────────┤
│ Agent B (MiniMax) reprend le même projet                    │
│   → Contexte vide                                           │
│   → "Où sont les commandes?"                                │
│   → "Quelles sont les conventions?"                         │
│   → Nécessite re-explication complète                       │
└─────────────────────────────────────────────────────────────┘
```

## Solution : Héritage de contexte

La solution implémente un **système d'héritage de contexte** en 3 niveaux :

```
┌─────────────────────────────────────────────────────────────┐
│ ~/.opencode/ (NIVEAU 1 - Global)                            │
│   └── context/core/standards/                               │
│       ├── code.md     ← Standards universels OpenCode      │
│       ├── docs.md     ← Documentation                      │
│       └── tests.md    ← Tests                              │
│   └── context/core/workflows/                               │
│       ├── delegation.md ← Workflow de délégation           │
│       └── review.md    ← Workflow de revue                 │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ $WORKSPACE/ (NIVEAU 2 - Workspace)                          │
│   └── .opencode/context/                                    │
│       └── index.md     ← Standards workspace + projets     │
│   └── AGENTS.md       ← Documentation principale           │
│   └── config_opencode/ ← Backup configuration              │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ $WORKSPACE/<projet>/ (NIVEAU 3 - Projet)                    │
│   └── .opencode/context/                                    │
│       └── index.md     ← Stack, commands, conventions      │
│   └── docs/            ← Documentation projet              │
│   └── .github/workflows/ ← CI/CD                           │
└─────────────────────────────────────────────────────────────┘
```

## Configuration des chemins

### Sur chaque machine, définissez la variable d'environnement

```bash
# Dans ~/.bashrc ou ~/.zshrc

# Exemple pour Linux
export WORKSPACE="/home/votre-nom/dev"

# Exemple pour macOS
export WORKSPACE="/Users/votre-nom/Projects/dev"

# Exemple pour autre configuration
export WORKSPACE="/chemin/vers/votre/workspace"
```

### Chargement de la configuration

```bash
# Charger la configuration
source ~/.bashrc  # ou ~/.zshrc

# Vérifier
echo $WORKSPACE
# Affiche: /home/votre-nom/dev
```

### Structure attendue après configuration

```
$WORKSPACE/                    ← Chemin défini par $WORKSPACE
├── AGENTS.md                  ← Documentation principale
├── .opencode/
│   └── context/
│       └── index.md           ← Context workspace
├── config_opencode/           ← Backup configuration (ce repo)
│   ├── docs/
│   │   └── workspace_configuration.md
│   └── README.md
├── scraping/
│   └── .opencode/context/index.md
├── dlthub-unified/
│   └── .opencode/context/index.md
├── immo-stras/
│   └── .opencode/context/index.md
└── ...autres projets
```

## Ordre de chargement automatique

Chaque agent doit lire les fichiers dans cet ordre :

```markdown
1. ~/.opencode/context/core/standards/code.md   ← REQUIRED
2. ~/.opencode/context/core/standards/docs.md   ← REQUIRED
3. ~/.opencode/context/core/standards/tests.md  ← REQUIRED
4. ~/.opencode/context/core/workflows/          ← REQUIRED
5. $WORKSPACE/.opencode/context/index.md        ← REQUIRED (Workspace)
6. <projet>/.opencode/context/index.md          ← REQUIRED (Projet)
```

## Structure des fichiers

### Niveau 1 : Standards globaux (~/.opencode/)

Emplacement : `~/.opencode/context/core/standards/`

| Fichier | Rôle | Contenu |
|---------|------|---------|
| `code.md` | Standards code | PEP8, types, docstrings, conventions |
| `docs.md` | Documentation | Structure docs, templates |
| `tests.md` | Tests | Frameworks, couverture, patterns |

### Niveau 2 : Workspace ($WORKSPACE/)

#### Fichier principal : `.opencode/context/index.md`

Emplacement : `$WORKSPACE/.opencode/context/index.md`

```markdown
# Index du Workspace

## Héritage de Contexte
1. Standards globaux (~/.opencode/)
2. Ce fichier (workspace)
3. Contexte projet spécifique

## Langages supportés
| Langage | Projets | Conventions |
|---------|---------|-------------|
| Python | scraping, dlthub-unified... | PEP8, Black, types |
| Go | go-agents | Standard Go |
| SQL | dlthub-unified, immo-stras | dbt规范 |

## Commandes par langage
- Python: `uv run`, `uv run pytest`, `ruff check`
- Go: `go build`, `go test`, `go fmt`
- dbt: `dbt run`, `dbt test`

## CI/CD
- Global: `$WORKSPACE/.github/workflows/`
- Par projet: `<projet>/.github/workflows/`

## Projets
| Projet | Type | Stack | Contexte |
|--------|------|-------|----------|
| scraping | Scraping | Playwright | .opencode/context/index.md |
| dlthub-unified | Data Eng | dbt, DuckDB | .opencode/context/index.md |

## Sécurité
- Secrets: ~/.opencode/.env
- Interdit: .env, credentials.json, *.key
```

#### Documentation : `AGENTS.md`

Emplacement : `$WORKSPACE/AGENTS.md`

Fichier de référence principale avec :
- Instructions de découverte de contexte
- Commandes par langage
- Conventions de code
- Gestion n8n
- Structure des projets
- Notes pour agents

### Niveau 3 : Projet spécifique

#### Fichier : `.opencode/context/index.md`

Emplacement : `$WORKSPACE/<projet>/.opencode/context/index.md`

```markdown
# Contexte du Projet: <NOM>

## Héritage
1. Standards globaux
2. Workspace index
3. Ce fichier (projet)

## Stack technologique
| Composant | Technologie | Usage |
|-----------|-------------|-------|
| Langage | Python | Principal |
| Outils | Playwright | Scraping |

## CI/CD
- Emplacement: `.github/workflows/`
- Workflows: deploy.yml, ci.yml

## Structure du projet
<projet>/
├── src/
├── tests/
├── docs/
├── .github/workflows/
├── pyproject.toml
└── .env

## Commandes spécifiques
```bash
uv sync
uv run pytest
dbt run  # si dbt
```

## Conventions locales
- Respecter robots.txt
- Logging avec contexte
- Retry avec backoff

## Secrets
- ~/.opencode/.env (global)
- .env local (non commité)
```

## Workflow de découverte pour un agent

```
┌────────────────────────────────────────────────────────────────┐
│ Agent se connecte au workspace ($WORKSPACE)                    │
└────────────────────────────────────────────────────────────────┘
                              ↓
┌────────────────────────────────────────────────────────────────┐
│ 1. Lit ~/.opencode/context/core/standards/code.md              │
│    → Comprend les standards universels (PEP8, types...)        │
└────────────────────────────────────────────────────────────────┘
                              ↓
┌────────────────────────────────────────────────────────────────┐
│ 2. Lit ~/.opencode/context/core/standards/docs.md              │
│    → Comprend les conventions de documentation                 │
└────────────────────────────────────────────────────────────────┘
                              ↓
┌────────────────────────────────────────────────────────────────┐
│ 3. Lit ~/.opencode/context/core/standards/tests.md             │
│    → Comprend les patterns de test                             │
└────────────────────────────────────────────────────────────────┘
                              ↓
┌────────────────────────────────────────────────────────────────┐
│ 4. Lit ~/.opencode/context/core/workflows/                     │
│    → Comprend les workflows globaux (délégation, revue)        │
└────────────────────────────────────────────────────────────────┘
                              ↓
┌────────────────────────────────────────────────────────────────┐
│ 5. Lit $WORKSPACE/.opencode/context/index.md                   │
│    → Workspace: langages, commands, CI/CD                      │
└────────────────────────────────────────────────────────────────┘
                              ↓
┌────────────────────────────────────────────────────────────────┐
│ 6. Identifie le projet courant (via cwd)                       │
│    → scraping / dlthub-unified / immo-stras / etc.             │
└────────────────────────────────────────────────────────────────┘
                              ↓
┌────────────────────────────────────────────────────────────────┐
│ 7. Lit <projet>/.opencode/context/index.md                     │
│    → Stack, conventions locales, commandes spécifiques         │
└────────────────────────────────────────────────────────────────┘
                              ↓
┌────────────────────────────────────────────────────────────────┐
│ ✓ Contexte COMPLET chargé                                      │
│   L'agent sait:                                                │
│   - Standards à appliquer                                      │
│   - Langages utilisés                                          │
│   - Commandes disponibles                                      │
│   - CI/CD à utiliser                                           │
│   - Conventions du projet                                      │
│   - Secrets et configuration                                   │
└────────────────────────────────────────────────────────────────┘
```

## Langages supportés

| Langage | Projets utilisant ce langage | Conventions |
|---------|------------------------------|-------------|
| **Python** | scraping, dlthub-unified, immo-stras, ga4-*, obsidian-sync, second-brain-workflow | PEP8, Black (100 chars), types requis, Google docstrings, uv |
| **Go** | go-agents/, upgrade_language_setup/ | Standard Go (go fmt, golint), Go modules |
| **SQL** | dlthub-unified, immo-stras, MusicBrainz Dataset | dbt规范, CTEs documentées, naming cohérent |
| **C/C++** | qmk/ | QMK firmware standards |
| **YAML** | .github/workflows/* | GitHub Actions |
| **JavaScript** | node_modules, Playwright | Playwright test conventions |
| **Markdown** | docs/*, README.md | Documentation projet |

## Commandes par langage

### Python (principal)

```bash
# Gestion dépendances
uv sync              # Installer/mettre à jour dépendances
uv add <package>     # Ajouter une dépendance
uv remove <package>  # Supprimer une dépendance

# Exécution
uv run python <script>.py
uv run pytest        # Tests
uv run pytest <path>::<test_name>  # Test unitaire spécifique

# Linting et formatage
ruff check .         # Linting
black -l 100 .       # Formatage
isort .              # Imports triés
mypy .               # Type checking
```

### Go

```bash
# Build et test
go build ./...
go test ./...
go fmt ./...
golangci-lint run

# Go modules
go mod tidy
go mod download
```

### SQL (dbt)

```bash
# Dans les sous-projets dbt
cd <projet> && dbt run              # Exécuter les models
cd <projet> && dbt test             # Exécuter les tests
cd <projet> && dbt build            # Build complet
cd <projet> && dbt deps             # Installer dépendances
cd <projet> && dbt compile          # Compiler le projet
```

### GitHub CLI

```bash
# PR management
gh repo view                        # Voir le repo
gh pr create                        # Créer une PR
gh pr list                          # Lister les PRs

# Workflows
gh workflow run <workflow>.yml      # Déclencher un workflow
gh workflow list                    # Lister les workflows
gh run list                         # Lister les runs
```

## CI/CD

### Structure standard

```
$WORKSPACE/.github/workflows/       ← Workflows globaux
$WORKSPACE/<projet>/.github/workflows/  ← Workflows par projet
```

### Workflows par type de projet

#### Python Projects

```yaml
# Tests + Linting
- name: Run tests
  run: uv run pytest

- name: Lint
  run: |
    ruff check .
    black --check .
    mypy .
```

#### dbt Projects

```yaml
# dbt workflow
- name: Run dbt
  run: |
    cd <projet>
    dbt deps
    dbt run
    dbt test
```

#### Deploy Projects

```yaml
# Déploiement
- name: Deploy
  run: <commande de déploiement>
```

## Documentation

### Convention standard

```
$WORKSPACE/<projet>/
├── README.md                       ← Page d'accueil (obligatoire)
├── docs/                           ← Documentation détaillée
│   ├── ARCHITECTURE.md
│   ├── SETUP.md
│   ├── API.md
│   ├── TROUBLESHOOTING.md
│   └── ...
├── .opencode/
│   └── context/
│       └── index.md                ← Contexte pour agents
└── tests/ ou test/
```

### Bonnes pratiques

- **README.md** obligatoire pour tout projet
- **docs/** pour documentation détaillée
- **CHANGELOG.md** pour les changements
- **Architecture** documentée pour projets complexes
- **Setup** documenté pour configuration locale

## Sécurité

### Secrets et configuration

- **Secrets globaux:** `~/.opencode/.env`
- **Secrets projet:** `<projet>/.env` (jamais commité)
- **API Keys:** Stocker dans `~/.opencode/.env`

### Fichiers interdits au commit

- `.env`
- `credentials.json`
- `*.key`
- `*.pem`
- Token files

### Bonnes pratiques

- Variables d'environnement pour secrets
- `.env.example` pour structure (sans valeurs)
- Validation des secrets au démarrage

## Infrastructure

- **OS:** Ubuntu (ou macOS, Windows WSL)
- **Base de données:** DuckDB, PostgreSQL, BigQuery, SQLite
- **Conteneurisation:** Docker
- **Reverse Proxy:** Traefik
- **Scheduler:** n8n (automatisation)
- **Cloud:** GCP (BigQuery)

## Liste des projets

| Projet | Type | Stack | Langages | CI/CD |
|--------|------|-------|----------|-------|
| `scraping/` | Scraping | Playwright, Scrapy | Python | - |
| `dlthub-unified/` | Data Engineering | dbt, DuckDB, BigQuery | Python, SQL | ✅ |
| `immo-stras/` | Immobilier | dbt, DuckDB, n8n | Python, SQL | ✅ |
| `ga4-analytics/` | Analytics | BigQuery | Python | - |
| `ga4-weekly-report/` | Analytics | - | Python | ✅ |
| `obsidian-sync/` | Notes | Obsidian | Python | ✅ |
| `second-brain-workflow/` | Workflow | n8n, YouTube API | Python | ✅ |
| `go-agents/` | Agents | - | Go | - |
| `qmk/` | Firmware | QMK | C/C++ | ✅ |
| `portfolio/` | Site web | Hugo | YAML, Markdown | ✅ |
| `n8n/` | Automatisation | n8n | - | - |

## Chemins importants

> **Note:** Remplacer `$WORKSPACE` par le chemin de votre workspace

| Élément | Chemin |
|---------|--------|
| Workspace | `$WORKSPACE/` |
| Context workspace | `$WORKSPACE/.opencode/context/index.md` |
| Documentation principale | `$WORKSPACE/AGENTS.md` |
| Scripts n8n | `~/dev/n8n/scripts/` |
| Backups n8n | `~/dev/n8n/backups/` |
| Configuration OpenCode | `~/.opencode/` |
| Documentation config | `$WORKSPACE/config_opencode/docs/` |

## Installation sur une nouvelle machine

### Étape 1 : Cloner le repository de configuration

```bash
# Cloner le repo de configuration
git clone <url-du-repo-config_opencode> $HOME/config_opencode

# Ou copier manuellement
cp -r /chemin/vers/config_opencode $HOME/
```

### Étape 2 : Configurer la variable d'environnement

```bash
# Éditer ~/.bashrc ou ~/.zshrc
echo 'export WORKSPACE="/chemin/vers/votre/workspace"' >> ~/.bashrc

# Charger la configuration
source ~/.bashrc
```

### Étape 3 : Créer la structure du workspace

```bash
# Créer la structure
mkdir -p $WORKSPACE/.opencode/context
mkdir -p $WORKSPACE/scraping/.opencode/context
mkdir -p $WORKSPACE/dlthub-unified/.opencode/context
mkdir -p $WORKSPACE/immo-stras/.opencode/context
mkdir -p $WORKSPACE/ga4-analytics/.opencode/context
mkdir -p $WORKSPACE/obsidian-sync/.opencode/context
mkdir -p $WORKSPACE/second-brain-workflow/.opencode/context

# Copier les fichiers de contexte
cp $HOME/config_opencode/docs/workspace_configuration.md $WORKSPACE/.opencode/context/
# Copier les autres fichiers de contexte...
```

### Étape 4 : Configurer les secrets

```bash
# Créer le fichier de secrets
touch ~/.opencode/.env
chmod 600 ~/.opencode/.env

# Éditer avec vos secrets
nano ~/.opencode/.env
```

### Étape 5 : Vérifier l'installation

```bash
# Vérifier les variables
echo "WORKSPACE: $WORKSPACE"

# Vérifier la structure
ls -la $WORKSPACE/.opencode/context/

# Tester avec un agent
cd $WORKSPACE/scraping
# L'agent devrait pouvoir lire le contexte automatiquement
```

## Mise à jour du système de contexte

### Quand mettre à jour

- Nouveau langage ajouté
- Nouvelle commande ou outil
- Nouveau projet
- Modification des conventions
- Nouvelle infrastructure

### Fichiers à modifier

| Modification | Fichier à modifier |
|--------------|-------------------|
| Nouvelle commande globale | `$WORKSPACE/.opencode/context/index.md` |
| Nouveau projet | Créer `<projet>/.opencode/context/index.md` |
| Modification convention | `$WORKSPACE/AGENTS.md` |
| Nouveau standard global | `~/.opencode/context/core/standards/` |
| Documentation config | `$WORKSPACE/config_opencode/docs/` |

### Synchroniser les modifications

```bash
# Après modification, synchroniser vers config_opencode
cd $WORKSPACE/config_opencode
git add .
git commit -m "update: description des modifications"
git push

# Sur une autre machine
cd $WORKSPACE/config_opencode
git pull
```

## Avantages de cette configuration

| Avant | Après |
|-------|-------|
| Contexte perdu entre agents | Héritage automatique (3 niveaux) |
| Ré-explications manuelles nécessaires | Index auto-chargés |
| Conventions non documentées | Standards globaux + locaux |
| Commandes à rechercher | Tableau des commandes par langage |
| CI/CD non standardisé | Structure documentée |
| Secrets exposés | Configuration centralisée |
| Chemins hardcodés | Variable $WORKSPACE portable |

## Dépannage

### La variable $WORKSPACE n'est pas définie

```bash
# Vérifier
echo $WORKSPACE

# Si vide, ajouter dans ~/.bashrc
echo 'export WORKSPACE="/chemin/vers/votre/workspace"' >> ~/.bashrc
source ~/.bashrc
```

### Les fichiers de contexte ne sont pas trouvés

```bash
# Vérifier la structure
ls -la $WORKSPACE/.opencode/context/index.md
ls -la $WORKSPACE/<projet>/.opencode/context/index.md

# Si manquant, créer depuis config_opencode
cp $WORKSPACE/config_opencode/.opencode/context/index.md $WORKSPACE/.opencode/context/
```

### L'agent ne charge pas le contexte

Vérifier que l'agent lit les fichiers dans l'ordre :
1. `~/.opencode/context/core/standards/code.md`
2. `~/.opencode/context/core/standards/docs.md`
3. `~/.opencode/context/core/standards/tests.md`
4. `~/.opencode/context/core/workflows/`
5. `$WORKSPACE/.opencode/context/index.md`
6. `<projet>/.opencode/context/index.md`

## Conclusion

Cette architecture de contexte permet à n'importe quel agent IA de :

1. **Découvrir automatiquement** le contexte du workspace
2. **Comprendre les standards** applicables
3. **Utiliser les bonnes commandes** pour chaque langage
4. **Respecter les conventions** du projet
5. **Accéder à la documentation** appropriée
6. **Configurer les secrets** correctement

Le système est :
- **Portable** : fonctionne sur n'importe quelle machine avec $WORKSPACE configuré
- **Extensible** : nouveaux projets, nouveaux langages
- **Maintenable** : modifications centralisées au niveau approprié
- **Collaboratif** : configuration backupée dans config_opencode

---

**Dernière mise à jour:** 2026-01-08  
**Documentation:** `$WORKSPACE/config_opencode/docs/workspace_configuration.md`
