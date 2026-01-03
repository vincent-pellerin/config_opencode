# Configuration OpenCode - Vue d'Ensemble

## Problème Initial

OpenCode cherche `.opencode/context/core/standards` dans chaque projet, ce qui ne fonctionne pas car ce chemin n'existe pas dans nos projets.

**Solution proposée:** Architecture de contextes à 2 niveaux avec un repo centralisé.

---

## Analyse de ~/.opencode/

### Structure Découverte (~500 KB de contenu utile)

```
~/.opencode/
├── agent/              ← 208 KB - Agents AI (OpenAgent, OpenCoder, System Builder)
│   ├── openagent.md    ← Agent universel principal
│   ├── opencoder.md    ← Agent de développement
│   ├── system-builder.md ← Générateur de systèmes AI
│   └── core/           ← Subagents (task-manager, coder, tester, reviewer, etc.)
├── command/            ← 108 KB - Commandes CLI
├── context/            ← 100 KB - Standards et workflows
│   ├── core/
│   │   ├── standards/  ← code.md, docs.md, tests.md
│   │   └── workflows/  ← review.md, delegation.md
│   └── index.md        ← Index des contextes
├── plugin/             ← 24 KB - Telegram bot
├── tool/               ← 24 KB - Intégration Gemini AI
├── bin/                ← 138 MB - CLI OpenCode (exécutables)
├── node_modules/       ← 6.4 MB - Dépendances Node.js
├── README.md           ← 21 KB - Documentation principale
└── env.example         ← Template configuration
```

### Sécurité: ✅ Aucun Secret Trouvé

- Aucune clé API dans `~/.opencode/`
- Variables d'environnement dans `.env` (non présent ou vide)
- Safe pour versioning Git

---

## Architecture de Contextes Proposée (2 Niveaux)

### Niveau 1: Global (`~/opencode-config/context/global/`)

Standards universels, indépendants du projet:

```markdown
context/
├── global/
│   ├── machine.md       # Outils: uv, dbt, GCP, Docker, PostgreSQL, DuckDB
│   ├── environments.md  # local (Ubuntu), VPS (Traefik), cloud
│   ├── standards.md     # Standards universels Python/SQL/Git
│   └── tools.md         # CLI: gh, bq, docker, playwright
```

### Niveau 2: Projects (`~/opencode-config/context/projects/`)

Patterns spécifiques par projet:

```markdown
context/
└── projects/
    ├── dlthub-unified/  # dbt, BigQuery, Airbyte
    ├── immo-stras/      # Scraping, DuckDB, PostgreSQL
    ├── scraping/        # Playwright, agents scraping
    ├── ga4-analytics/   # BigQuery, GA4, Looker Studio
    └── obsidian-sync/   # Obsidian, git, sync scripts
```

### Sync Dynamique

Détecter automatiquement les nouvelles stacks pour mettre à jour `global/`:
- Nouveau projet avec stack détectée → Ajouter à `global/machine.md`
- Nouveau outil populaire → Ajouter à `global/tools.md`

---

## Agents OpenCode

### OpenAgent (Principal)

- **Usage:** Questions, tâches, coordination, délégation
- **Workflow:** Plan → Approve → Execute → Validate → Summarize
- **Path:** Triggers sur bash/write/edit/task

### OpenCoder

- **Usage:** Développement pur, modifications de code
- **Workflow:** Similaire à OpenAgent avec focus code
- **Pas de subagents** (vs OpenAgent qui délègue)

### System Builder

- **Usage:** Génération de systèmes AI complets
- **10 étapes:** Research → Design → Implement → Test → Deploy
- **Prompt pattern:** "Build a [type] system that [goal]"

### Subagents (via task tool)

| Agent | Usage |
|-------|-------|
| `task-manager` | Break complex features into subtasks |
| `coder-agent` | Coding subtasks en séquence |
| `tester` | TDD, écriture tests |
| `reviewer` | Code review, sécurité |
| `build-agent` | Type check, build validation |
| `explore` | Exploration codebase rapide |
| `Documentation` | Rédaction docs |

---

## Modèles OpenCode

### Selection CLI

```bash
opencode --model [provider/model]
```

Exemples:
```bash
opencode --model anthropic/claude-sonnet-4-20250514
opencode --model google/gemini-2.5-pro
```

### Configuration Agent

Chaque agent a `recommended_models` dans frontmatter YAML:

```yaml
recommended_models:
  - anthropic/claude-sonnet-4-20250514
  - anthropic/claude-opus-4-20250507
  - google/gemini-2.5-pro
```

**Règle:** CLI `--model` override les `recommended_models` de l'agent.

---

## Repo de Backup: ~/opencode-config/

### Structure Cible Complète

```
~/opencode-config/
├── .gitignore           ← Exclut bin/, node_modules/, .env, *.lock
├── README.md            ← Documentation du repo (à créer)
├── agent/               ← 208 KB (copié)
├── command/             ← 108 KB (copié)
├── context/             ← 100 KB (copié, à refactorer)
├── plugin/              ← 24 KB (copié)
├── tool/                ← 32 KB (copié)
├── env.example          ← Template config (copié)
├── package.json         ← Version plugin: @opencode-ai/plugin@1.0.223
├── setup/               ← Scripts d'installation automatique
│   ├── install.sh       ← Installation complète
│   ├── shell-config.sh  ← Configuration PATH shell
│   └── verify.sh        ← Vérification post-install
└── docs/                ← Notes d'architecture
```

### Éléments Critiques pour Duplication

**Découverts lors de l'analyse approfondie:**

1. **Configuration Shell** (ESSENTIEL)
   ```bash
   # Dans ~/.zshrc
   export PATH=$HOME/.opencode/bin:$PATH
   ```

2. **Configuration Secondaire** `~/.config/opencode/`
   - `package.json` (même version que `~/.opencode/`)
   - `bun.lock` (généré automatiquement)
   - `.gitignore`

3. **Variables d'Environnement**
   ```bash
   OPENCODE=1  # Définie automatiquement
   ```

4. **Version OpenCode**
   ```bash
   opencode --version  # 1.0.223
   ```

### Scripts d'Installation Automatique

#### `setup/install.sh` - Installation Complète
```bash
#!/bin/bash
set -e

echo "🚀 Installation OpenCode Configuration..."

# 1. Créer la structure ~/.opencode/
mkdir -p ~/.opencode/{agent,command,context,plugin,tool}

# 2. Copier les fichiers de configuration
cp -r ../agent/* ~/.opencode/agent/
cp -r ../command/* ~/.opencode/command/
cp -r ../context/* ~/.opencode/context/
cp -r ../plugin/* ~/.opencode/plugin/
cp -r ../tool/* ~/.opencode/tool/
cp ../package.json ~/.opencode/
cp ../env.example ~/.opencode/

# 3. Créer ~/.config/opencode/ (configuration secondaire)
mkdir -p ~/.config/opencode
cp ../package.json ~/.config/opencode/

# 4. Installer les dépendances
cd ~/.opencode
npm install  # ou bun install

# 5. Configuration shell
../setup/shell-config.sh

# 6. Vérification
../setup/verify.sh

echo "✅ Installation terminée!"
```

#### `setup/shell-config.sh` - Configuration PATH
```bash
#!/bin/bash

# Détecter le shell
if [[ $SHELL == *"zsh"* ]]; then
    SHELL_RC="$HOME/.zshrc"
elif [[ $SHELL == *"bash"* ]]; then
    SHELL_RC="$HOME/.bashrc"
else
    echo "⚠️  Shell non supporté: $SHELL"
    exit 1
fi

# Ajouter OpenCode au PATH si pas déjà présent
if ! grep -q "/.opencode/bin" "$SHELL_RC"; then
    echo "" >> "$SHELL_RC"
    echo "# OpenCode" >> "$SHELL_RC"
    echo "export PATH=\$HOME/.opencode/bin:\$PATH" >> "$SHELL_RC"
    echo "✅ PATH OpenCode ajouté à $SHELL_RC"
else
    echo "✅ PATH OpenCode déjà configuré"
fi

# Recharger la configuration
source "$SHELL_RC"
```

#### `setup/verify.sh` - Vérification Post-Install
```bash
#!/bin/bash

echo "🔍 Vérification de l'installation..."

# 1. Vérifier que le binaire existe
if [[ -f ~/.opencode/bin/opencode ]]; then
    echo "✅ Binaire OpenCode trouvé"
else
    echo "❌ Binaire OpenCode manquant"
    exit 1
fi

# 2. Vérifier la version
VERSION=$(~/.opencode/bin/opencode --version 2>/dev/null || echo "FAILED")
if [[ "$VERSION" != "FAILED" ]]; then
    echo "✅ OpenCode version: $VERSION"
else
    echo "❌ Impossible de récupérer la version"
    exit 1
fi

# 3. Vérifier les contextes
if [[ -d ~/.opencode/context/core ]]; then
    echo "✅ Contextes trouvés"
else
    echo "❌ Contextes manquants"
    exit 1
fi

# 4. Vérifier PATH
if command -v opencode >/dev/null 2>&1; then
    echo "✅ OpenCode accessible via PATH"
else
    echo "❌ OpenCode non accessible - redémarrer le terminal"
fi

echo "🎉 Installation vérifiée avec succès!"
```

### Commandes de Setup (Machine Source)

```bash
# Créer la structure
mkdir -p ~/opencode-config/{agent,command,context,plugin,tool,docs,setup}

# Copier les fichiers
cp -r ~/.opencode/agent/* ~/opencode-config/agent/
cp -r ~/.opencode/command/* ~/opencode-config/command/
cp -r ~/.opencode/context/* ~/opencode-config/context/
cp -r ~/.opencode/plugin/* ~/opencode-config/plugin/
cp -r ~/.opencode/tool/* ~/opencode-config/tool/
cp ~/.opencode/README.md ~/opencode-config/
cp ~/.opencode/env.example ~/opencode-config/
cp ~/.opencode/package.json ~/opencode-config/

# Créer les scripts d'installation (voir ci-dessus)
# Créer .gitignore mis à jour (voir ci-dessous)

# Initialiser Git
cd ~/opencode-config
git init
git add .
git commit -m "Initial commit: OpenCode configuration backup"
```

### .gitignore Mis à Jour

```gitignore
# OpenCode executables
bin/

# Node.js dependencies  
node_modules/

# Environment files
.env
.env.local

# Lock files
*.lock
package-lock.json
bun.lock

# OS files
.DS_Store
Thumbs.db

# IDE
.idea/
.vscode/

# Installation logs
setup/*.log
```

---

## Standards de Code (Issues/Non Codés)

Basé sur AGENTS.md:

```markdown
# Python
- PEP8, snake_case (vars), PascalCase (classes)
- Black (100 chars), isort
- Types requis pour fonctions publiques
- Google Style docstrings

# Ordre Imports
stdlib → third-party → local

# Git Commits
<type>: <description>
Types: feat, fix, docs, refactor, test, chore

# SQL (dbt)
- CTEs pour lisibilité
- Modèles documentés
- Naming cohérent
```

---

## Instructions de Duplication

### Machine Source (Setup Initial)
```bash
# 1. Créer le repo avec scripts d'installation
mkdir -p ~/opencode-config/{agent,command,context,plugin,tool,docs,setup}

# 2. Copier tous les fichiers (voir commandes ci-dessus)

# 3. Créer les scripts setup/ (install.sh, shell-config.sh, verify.sh)

# 4. Commit et push vers repo Git
```

### Nouvelle Machine (Installation)
```bash
# 1. Cloner le repo
git clone <your-repo> ~/opencode-config

# 2. Installer automatiquement
cd ~/opencode-config
chmod +x setup/*.sh
./setup/install.sh

# 3. Redémarrer le terminal ou recharger shell
source ~/.zshrc  # ou ~/.bashrc

# 4. Vérifier l'installation
opencode --version  # Doit afficher: 1.0.223
```

### Checklist de Duplication

- [ ] **Configuration shell** (PATH dans ~/.zshrc ou ~/.bashrc)
- [ ] **Structure ~/.config/opencode/** (configuration secondaire)
- [ ] **Scripts d'installation** automatique (setup/)
- [ ] **Vérification post-install** (verify.sh)
- [ ] **Documentation** des prérequis (Node.js/Bun)
- [ ] **Version OpenCode** (1.0.223)
- [ ] **Variables d'environnement** (OPENCODE=1)

---

## Prochaines Étapes

1. **Setup repo:** Créer ~/opencode-config/ avec scripts d'installation
2. **Copier fichiers:** De ~/.opencode/ vers ~/opencode-config/ (incluant package.json)
3. **Refactorer context/:** Implémenter architecture global + projects
4. **Documenter:** README.md complet + docs/architecture.md
5. **Tester duplication:** Vérifier installation sur machine test

---

## Notes Techniques

### Tailles et Sécurité
- **Taille totale:** ~500 KB (hors bin/ 138MB, node_modules/ 6.4MB)
- **Sécurité:** ✅ Safe pour Git (pas de secrets)
- **Version OpenCode:** 1.0.223
- **Plugin:** @opencode-ai/plugin@1.0.223

### Environnement
- **Plateforme:** Ubuntu (local + VPS avec Traefik)
- **Shell:** Zsh (avec PATH configuré)
- **Outils principaux:** uv, dbt, GCP, BigQuery, Docker, DuckDB, PostgreSQL

### Configurations Critiques
- **PATH:** `$HOME/.opencode/bin` ajouté au shell
- **Config secondaire:** `~/.config/opencode/` (package.json)
- **Variables:** `OPENCODE=1` (auto-définie)
- **Dépendances:** Node.js/npm ou Bun pour installation

### Duplication 100% Automatique
✅ **Scripts d'installation** pour nouvelle machine  
✅ **Vérification post-install** automatique  
✅ **Configuration shell** automatique  
✅ **Documentation complète** pour reproduction