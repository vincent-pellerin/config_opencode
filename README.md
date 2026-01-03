# OpenCode Configuration Backup

Configuration centralisée pour OpenCode AI CLI - Version 1.0.223

## 📋 Vue d'Ensemble

Ce repository contient la configuration complète d'OpenCode, permettant une duplication facile sur plusieurs machines.

**Contenu:**
- Agents AI (OpenAgent, OpenCoder, System Builder + subagents)
- Commandes CLI personnalisées
- Contextes et standards de code
- Plugins (Telegram bot)
- Outils (Gemini AI integration)
- Scripts d'installation automatique

## 🚀 Installation Rapide

### Nouvelle Machine

```bash
# 1. Cloner le repository
git clone https://github.com/VOTRE_USERNAME/config_opencode.git ~/config_opencode

# 2. Lancer l'installation automatique
cd ~/config_opencode
chmod +x setup/*.sh
./setup/install.sh

# 3. Redémarrer le terminal ou recharger le shell
source ~/.zshrc  # ou ~/.bashrc

# 4. Vérifier l'installation
opencode --version  # Doit afficher: 1.0.223
```

### Prérequis

- **Node.js** (npm) ou **Bun** pour l'installation des dépendances
- **Git** pour cloner le repository
- **Bash** ou **Zsh** comme shell

## 📁 Structure

```
config_opencode/
├── agent/               # Agents AI (208 KB)
├── command/             # Commandes CLI (108 KB)
├── context/             # Standards et workflows (100 KB)
├── plugin/              # Telegram bot (24 KB)
├── tool/                # Gemini AI integration (32 KB)
├── setup/               # Scripts d'installation
│   ├── install.sh       # Installation complète
│   ├── shell-config.sh  # Configuration PATH
│   └── verify.sh        # Vérification post-install
├── docs/                # Documentation
│   └── CONFIGURATION.md # Documentation détaillée
├── package.json         # Dépendances (@opencode-ai/plugin@1.0.223)
├── env.example          # Template de configuration
└── README.md            # Ce fichier
```

## 🔧 Configuration Manuelle

Si vous préférez installer manuellement:

```bash
# 1. Créer la structure
mkdir -p ~/.opencode/{agent,command,context,plugin,tool}

# 2. Copier les fichiers
cp -r agent/* ~/.opencode/agent/
cp -r command/* ~/.opencode/command/
cp -r context/* ~/.opencode/context/
cp -r plugin/* ~/.opencode/plugin/
cp -r tool/* ~/.opencode/tool/
cp package.json ~/.opencode/
cp env.example ~/.opencode/

# 3. Configuration secondaire
mkdir -p ~/.config/opencode
cp package.json ~/.config/opencode/

# 4. Installer les dépendances
cd ~/.opencode
npm install  # ou bun install

# 5. Ajouter au PATH (Zsh)
echo 'export PATH=$HOME/.opencode/bin:$PATH' >> ~/.zshrc
source ~/.zshrc

# 6. Vérifier
opencode --version
```

## 📚 Documentation

- **[CONFIGURATION.md](docs/CONFIGURATION.md)** - Documentation complète de la configuration
- **[README_OPENAGENTS.md](README_OPENAGENTS.md)** - Documentation OpenAgents originale

## 🎯 Agents Disponibles

### Agents Principaux
- **OpenAgent** - Agent universel pour questions et tâches
- **OpenCoder** - Agent de développement spécialisé
- **System Builder** - Générateur de systèmes AI complets

### Subagents (via task tool)
- `task-manager` - Décomposition de features complexes
- `coder-agent` - Implémentation de subtasks
- `tester` - TDD et écriture de tests
- `reviewer` - Code review et sécurité
- `build-agent` - Validation de build
- `explore` - Exploration de codebase
- `Documentation` - Génération de documentation

## 🔐 Sécurité

✅ **Safe pour Git** - Aucun secret inclus
- Les clés API doivent être dans `.env` (non versionné)
- `bin/` et `node_modules/` exclus via `.gitignore`
- Template de configuration dans `env.example`

## 🛠️ Maintenance

### Mise à Jour de la Configuration

```bash
# Sur la machine source
cd ~/dev/config_opencode
cp -r ~/.opencode/agent/* agent/
cp -r ~/.opencode/command/* command/
# ... autres dossiers

git add .
git commit -m "update: configuration OpenCode"
git push
```

### Synchronisation sur Autre Machine

```bash
cd ~/config_opencode
git pull
./setup/install.sh
```

## 📊 Informations Techniques

- **Version OpenCode:** 1.0.223
- **Plugin:** @opencode-ai/plugin@1.0.223
- **Taille totale:** ~500 KB (hors binaires et node_modules)
- **Plateforme:** Ubuntu (compatible Linux/macOS)
- **Shell supporté:** Bash, Zsh

## 🤝 Contribution

Ce repository est personnel mais peut servir de template pour d'autres configurations OpenCode.

## 📝 License

Configuration personnelle - Utilisation libre

---

**Créé par:** Vincent  
**Date:** Janvier 2026  
**OpenCode Version:** 1.0.223
