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

echo "ℹ️  Pour activer immédiatement: source $SHELL_RC"
