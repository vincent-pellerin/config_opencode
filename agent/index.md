# Index des Agents OpenCode

## Version
1.0.0

## Dernière mise à jour
2026-01-09

## Description
Index global des agents OpenCode pour le workspace Vincent

---

## Context Organizer

**Fichier:** `context-organizer.md`

**Description:** Organisation et génération de fichiers de contexte pour optimal knowledge management

**Type:** subagent

**Catégorie:** context

**Capacités:**
- Context file generation
- Project structure analysis
- Workflow documentation
- Convention standardization

**Statut:** active

**Version:** 1.0.0

**Usage:**
```python
task(
  subagent_type="Context Organizer",
  description="Description",
  prompt="Instructions"
)
```

### Exemples d'Usage

| Syntaxe | Description |
|---------|-------------|
| `@agents/context-organizer` | Appel direct du Context Organizer |
| `@subagents/system-builder/context-organizer` | Appel via le système system-builder |

---

## Catégories d'Agents

### Context

**Description:** Agents de gestion de contexte et d'organisation

**Agents:**
- Context Organizer

---

## Notes

- Tous les agents sont définis en Markdown dans le répertoire `~/.opencode/agents/`
- Le subagent_type exact doit être utilisé dans les appels task()
- Les fichiers XML précédents ont été migrés vers Markdown
