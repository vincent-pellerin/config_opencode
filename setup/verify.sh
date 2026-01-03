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
    echo "⚠️  OpenCode non accessible - redémarrer le terminal ou exécuter: source ~/.zshrc"
fi

echo ""
echo "🎉 Installation vérifiée avec succès!"
