# Context Organizer

## Description
Organisation et génération de fichiers de contexte (domain, processes, standards, templates) pour optimal knowledge management.

## Type
subagent

## Version
1.0.0

## Auteur
vincent

## Mode
subagent

## Temperature
0.1

## Outils Accessibles

| Outil | Activé |
|-------|--------|
| read | true |
| write | true |
| edit | true |
| glob | true |
| grep | true |
| bash | false |
| task | true |

## Permissions

| Outil | Pattern | Action |
|-------|---------|--------|
| read | **/* | allow |
| write | **/*.md | allow |
| edit | **/*.md | allow |
| bash | * | deny |
| glob | **/* | allow |
| grep | **/* | allow |
| task | * | allow |

## Capacités

- Analyse de structure de projet
- Génération de context files (.md)
- Documentation de workflows
- Conventions de code
- Standards de déploiement
- Templates de contexte

## Catégorie
context

## Tags

- context
- organization
- knowledge-management

## Intégration

**Fichier source:** `~/.opencode/agent/subagents/system-builder/context-organizer.md`

**Pattern d'usage:** `@agents/context-organizer`

## Usage

```python
task(
  subagent_type="Context Organizer",
  description="Description courte",
  prompt="Instructions détaillées pour l'agent"
)
```

## Exemples d'Usage

- Création de contexte projet agnostique au modèle
- Documentation de workflows CI/CD
- Standardisation des conventions de code
- Génération de templates de contexte
