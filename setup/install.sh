#!/bin/bash
set -e

echo "🚀 Installation OpenCode Configuration..."

# 1. Créer la structure ~/.opencode/
mkdir -p ~/.opencode/{agent,command,context,plugin,tool}

# 2. Copier les fichiers de configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

cp -r "$REPO_DIR/agent/"* ~/.opencode/agent/
cp -r "$REPO_DIR/command/"* ~/.opencode/command/
cp -r "$REPO_DIR/context/"* ~/.opencode/context/
cp -r "$REPO_DIR/plugin/"* ~/.opencode/plugin/
cp -r "$REPO_DIR/tool/"* ~/.opencode/tool/
cp "$REPO_DIR/package.json" ~/.opencode/
cp "$REPO_DIR/env.example" ~/.opencode/

# 3. Créer ~/.config/opencode/ (configuration secondaire)
mkdir -p ~/.config/opencode
cp "$REPO_DIR/package.json" ~/.config/opencode/

# 4. Installer les dépendances
cd ~/.opencode
if command -v bun >/dev/null 2>&1; then
    echo "📦 Installation avec Bun..."
    bun install
elif command -v npm >/dev/null 2>&1; then
    echo "📦 Installation avec npm..."
    npm install
else
    echo "❌ Erreur: npm ou bun requis pour l'installation"
    exit 1
fi

# 5. Configuration shell
"$SCRIPT_DIR/shell-config.sh"

# 6. Vérification
"$SCRIPT_DIR/verify.sh"

echo "✅ Installation terminée!"
echo "⚠️  Redémarrez votre terminal ou exécutez: source ~/.zshrc (ou ~/.bashrc)"
