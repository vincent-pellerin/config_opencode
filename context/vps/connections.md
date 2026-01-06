# VPS SSH Connections

> **Sécurité**: Ce fichier est sync vers GitHub. Les credentials NE sont PAS inclus.
> Les vrais identifiants sont dans `~/.ssh/config` (jamais sync).

## Connexions disponibles

| Alias SSH | Usage | Chemin config |
|-----------|-------|---------------|
| `vps_h` | VPS principal (Hostinger) - user vincent | `~/.ssh/config` |
| `vps_dlt` | VPS DLThub - user dlthub | `~/.ssh/config` |

## Utilisation

### Connexion SSH
```bash
ssh vps_h           # VPS principal
ssh vps_dlt         # VPS DLThub
```

### Exécution remote
```bash
ssh vps_h 'ls -la ~/dev'
ssh vps_dlt 'pm2 list'
```

### Transfert de fichiers (SCP)
```bash
scp file.txt vps_h:/home/vincent/
scp vps_h:/home/vincent/backups/ ./local-backup/
```

## Structure des credentials

Les credentials réels sont dans `~/.ssh/config`:

```
Host vps_h
    HostName 82.25.97.95
    User vincent
    Port 22
    IdentityFile ~/.ssh/id_vps_hostinger
    ForwardAgent yes
    AddKeysToAgent yes
    ServerAliveInterval 60

Host vps_dlt
    HostName 82.25.97.95
    User dlthub
    Port 22
    IdentityFile ~/.ssh/dlthub_ed25519
    ForwardAgent yes
    AddKeysToAgent yes
    ServerAliveInterval 60
```

## Dépannage SSH

### Erreur "agent refused operation"
```bash
# Vérifier les clés dans l'agent
ssh-add -l

# Réparer les permissions
chmod 600 ~/.ssh/id_*
chmod 644 ~/.ssh/*.pub

# Relancer l'agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_vps_hostinger
```

### Connexion lente
```bash
# Désactiver DNS lookup côté client
# Dans ~/.ssh/config:
Host *
    UseDNS no
```

## Alias pratiques (bash/zsh)

```bash
# ~/.bashrc ou ~/.zshrc
alias vps='ssh vps_h'
alias vps-dlt='ssh vps_dlt'
alias vps-logs='ssh vps_h "tail -f ~/dev/*/logs/*.log"'
alias vps-status='ssh vps_h "cd ~/dev && docker ps && pm2 list"'
```

## Récupération si clés perdues

1. **Via Hostinger Panel**: Console → Accès Rescue → Générer nouvelle clé
2. **Backup先**: Always garder une clé de secours dans un password manager

---

**Sync**: Ce fichier est sync vers GitHub. Ne JAMAIS ajouter de credentials.
**Credentials**: Dans `~/.ssh/config` (protégé par .gitignore)
