<!-- Context: standards/language-selection | Priority: critical | Version: 1.0 | Updated: 2025-01-06 -->
# Sélection Automatique de Langage pour Agents Multi-Tâches

## Vue d'Ensemble

Ce système permet aux agents OpenCode de choisir automatiquement entre Python et Go selon les caractéristiques de la tâche, optimisant ainsi les performances et la maintenabilité.

## Règles de Décision Automatique

### Règle 1 - Dominante Data/ML
```javascript
if (task.requires_ml || task.requires_dataframe || task.requires_nlp || 
    task.involves_analysis || task.involves_ai || task.involves_data_science) {
    language = "python"
    rationale = "Écosystème Python riche en ML/data/NLP (pandas, numpy, scikit-learn, transformers)"
    confidence = "high"
}
```

**Mots-clés déclencheurs** : ml, ai, data, analysis, pandas, numpy, scikit, tensorflow, pytorch, nlp, embeddings, model, training, prediction, visualization

### Règle 2 - Dominante I/O et Concurrence
```javascript
if (task.is_io_bound && task.concurrency_requirements > 10 ||
    task.involves_scraping_high_volume || task.involves_api_gateway ||
    task.involves_streaming || task.involves_websockets) {
    language = "go"
    rationale = "Concurrence native (goroutines) et gestion efficace des I/O"
    confidence = "high"
}
```

**Mots-clés déclencheurs** : concurrent, parallel, scraping, api calls, websocket, streaming, high throughput, thousands of requests, goroutines

### Règle 3 - Services Long-Running
```javascript
if (task.service_type === "long_running" && task.requires_reliability ||
    task.involves_orchestration || task.involves_scheduler ||
    task.involves_daemon || task.involves_monitoring) {
    language = "go"
    rationale = "Robustesse opérationnelle, gestion d'état et fiabilité"
    confidence = "high"
}
```

**Mots-clés déclencheurs** : service, daemon, scheduler, orchestrator, supervisor, monitoring, always-on, production service, reliability

### Règle 4 - Prototypage et Exploration
```javascript
if (task.is_exploratory || task.spec_stability === "low" ||
    task.involves_data_exploration || task.is_research ||
    task.involves_jupyter || task.involves_experimentation) {
    language = "python"
    rationale = "Flexibilité, rapidité de développement et écosystème interactif"
    confidence = "medium"
}
```

**Mots-clés déclencheurs** : prototype, explore, experiment, research, jupyter, notebook, quick test, proof of concept, investigation

### Règle 5 - Tooling et Infrastructure
```javascript
if (task.is_cli_tool || task.is_system_utility ||
    task.involves_deployment_automation || task.involves_infrastructure ||
    task.involves_binary_distribution) {
    language = "go"
    rationale = "Binaires statiques, simplicité de déploiement et performance système"
    confidence = "high"
}
```

**Mots-clés déclencheurs** : cli, tool, utility, deploy, automation, infrastructure, binary, system, devops, kubernetes

## Module d'Analyse de Tâches

### Classification Automatique

```javascript
class TaskAnalyzer {
    analyzeRequest(userRequest, projectContext) {
        const analysis = {
            domain: this.detectDomain(userRequest),
            complexity: this.assessComplexity(userRequest),
            concurrency_needs: this.analyzeConcurrency(userRequest),
            io_intensity: this.analyzeIO(userRequest),
            longevity: this.assessServiceLongevity(userRequest),
            exploration_level: this.detectExploration(userRequest),
            keywords: this.extractKeywords(userRequest)
        }
        
        return this.applySelectionRules(analysis, projectContext)
    }
    
    detectDomain(request) {
        const domains = {
            data: ['ml', 'data', 'analysis', 'pandas', 'numpy', 'ai', 'model', 'training', 'prediction'],
            io: ['scraping', 'api', 'requests', 'concurrent', 'parallel', 'websocket', 'streaming'],
            infrastructure: ['cli', 'tool', 'deploy', 'automation', 'script', 'devops', 'kubernetes'],
            orchestration: ['scheduler', 'supervisor', 'orchestrator', 'daemon', 'service', 'monitoring'],
            exploration: ['prototype', 'explore', 'experiment', 'research', 'jupyter', 'notebook']
        }
        
        // Analyse de fréquence des mots-clés par domaine
        // Retourne le domaine avec le score le plus élevé
    }
}
```

### Matrice de Décision

| Critère | Python | Go | Poids |
|---------|--------|----|----|
| ML/Data/AI | ✅ Excellent | ❌ Faible | 0.9 |
| Concurrence I/O | ❌ Limitée (GIL) | ✅ Native | 0.8 |
| Services Long-Running | ❌ Moyenne | ✅ Excellente | 0.8 |
| Prototypage Rapide | ✅ Excellent | ❌ Verbeux | 0.7 |
| CLI/Infrastructure | ❌ Dépendances | ✅ Binaire statique | 0.8 |
| Écosystème Existant | ✅ Très riche | ❌ Limité | 0.6 |

### Gestion des Cas Ambigus

#### Cas de Conflit
```javascript
if (python_score === go_score || Math.abs(python_score - go_score) < 0.2) {
    // Facteurs de départage :
    1. Contexte projet existant (stack.md)
    2. Préférence équipe (si spécifiée)
    3. Contraintes de déploiement
    4. Écosystème de dépendances
    
    // Fallback : Python (plus flexible pour l'exploration)
}
```

#### Override Manuel
```bash
# Force un langage spécifique
opencode --context="FORCE_LANGUAGE=go" "create a web scraper"
opencode --context="FORCE_LANGUAGE=python" "build a CLI tool"
```

## Intégration avec OpenCode

### Workflow de Sélection

1. **Analyse de Requête** : Extraction des mots-clés et classification
2. **Évaluation Contexte** : Lecture du stack.md du projet
3. **Application des Règles** : Calcul des scores Python vs Go
4. **Génération Recommandation** : Sélection avec rationale
5. **Configuration Environnement** : Chargement des standards appropriés

### Format de Sortie

```markdown
## Language Selection Recommendation

**Selected Language**: Go
**Confidence**: High (0.85)

**Analysis**:
- Task Domain: io_intensive
- Key Factors: high concurrency, API calls, production service
- Applied Rules: Rule 2 (I/O Dominance), Rule 3 (Long-Running Service)
- Score: Python (0.2) vs Go (0.85)

**Rationale**: 
This task involves high-volume API scraping with concurrent requests, 
which strongly favors Go's native goroutines and efficient I/O handling.
The production service requirement also benefits from Go's reliability.

**Next Steps**:
- Configure Go development environment
- Load Go-specific standards and patterns
- Use Go project template with goroutines and HTTP client
```

## Standards par Langage

### Python Context
- **Outils** : uv, ruff, black, pytest, mypy
- **Patterns** : Type hints, dataclasses, async/await
- **Architecture** : Modules, packages, dependency injection
- **Tests** : pytest, unittest, coverage

### Go Context
- **Outils** : go mod, golangci-lint, gofmt, go test
- **Patterns** : Interfaces, composition, error handling
- **Architecture** : Packages, clean architecture, dependency injection
- **Tests** : go test, testify, benchmarks

## Métriques et Amélioration

### Suivi des Décisions
- Log des sélections automatiques
- Feedback utilisateur sur la pertinence
- Analyse des overrides manuels
- Ajustement des poids et règles

### Évolution du Système
- Ajout de nouveaux langages (Rust, TypeScript)
- Raffinement des règles basé sur l'usage
- Intégration de métriques de performance
- Apprentissage des préférences utilisateur

---

**Version** : 1.0  
**Dernière mise à jour** : 2025-01-06  
**Auteur** : OpenCode Language Selection System