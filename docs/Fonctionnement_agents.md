# Fonctionnement des Agents OpenCode

Guide complet de l'architecture et du fonctionnement des agents OpenCode.

## 🏗️ Architecture des Agents

### 📊 Hiérarchie des Agents

```
┌─────────────────────────────────────┐
│  AGENTS PRIMAIRES (mode: primary)  │
├─────────────────────────────────────┤
│  • openagent    (universel)         │
│  • opencoder    (développement)     │  
│  • system-builder (méta-génération) │
└─────────────────────────────────────┘
                    ↓
        ┌─────────────────────────┐
        │  OUTIL DE DÉLÉGATION    │
        │  task(subagent_type=...) │
        └─────────────────────────┘
                    ↓
┌─────────────────────────────────────┐
│  SUBAGENTS (mode: subagent)        │
├─────────────────────────────────────┤
│  Core:                              │
│  • task-manager (planification)     │
│  • documentation (docs)             │
│                                     │
│  Code:                              │
│  • coder-agent (implémentation)     │
│  • tester (tests)                   │
│  • reviewer (review)                │
│  • build-agent (validation)         │
│                                     │
│  Utils:                             │
│  • image-specialist (images)        │
│  • codebase-pattern-analyst         │
└─────────────────────────────────────┘
```

## 🎯 Rôles et Responsabilités

### **Agents Primaires** (Interface utilisateur)

#### **1. OpenAgent** - Coordinateur universel
- **Usage:** `opencode --agent openagent`
- **Rôle:** Point d'entrée principal pour questions et tâches
- **Workflow:** Analyze → Approve → Execute → Validate → Summarize
- **Outils:** Tous (read, write, edit, bash, **task**)
- **Spécialité:** Délégation intelligente et coordination
- **Temperature:** 0.2 (équilibré)

**Caractéristiques:**
- Demande approbation avant exécution
- Charge automatiquement les contextes requis
- Délègue aux spécialistes selon la complexité
- Gère le workflow complet de A à Z

#### **2. OpenCoder** - Spécialiste développement
- **Usage:** `opencode --agent opencoder`
- **Rôle:** Développement complexe, refactoring, architecture
- **Workflow:** Similaire à OpenAgent mais focus code
- **Outils:** Tous sauf task (pas de délégation)
- **Spécialité:** Implémentation directe
- **Temperature:** 0.1 (précis)

**Caractéristiques:**
- Commence toujours par "DIGGING IN..."
- Implémentation directe sans délégation
- Focus sur la qualité du code
- Validation incrémentale (une étape à la fois)

#### **3. System Builder** - Générateur de systèmes
- **Usage:** `opencode --agent system-builder`
- **Rôle:** Création de systèmes AI complets
- **Workflow:** 10 étapes (Research → Design → Implement → Test → Deploy)
- **Spécialité:** Génération d'architectures AI complètes

### **Subagents** (Spécialistes délégués)

#### **Core (Coordination):**

**task-manager:**
- **Rôle:** Décompose features complexes en subtasks atomiques
- **Usage:** Délégué pour features >4 fichiers ou >60min
- **Outils:** read, write, edit, grep, glob (pas bash)
- **Spécialité:** Planification et dépendances

**documentation:**
- **Rôle:** Génère documentation technique
- **Usage:** Délégué pour création de docs
- **Spécialité:** Rédaction technique

#### **Code (Développement):**

**coder-agent:**
- **Rôle:** Exécute subtasks simples séquentiellement
- **Usage:** Implémentation de subtasks définies
- **Outils:** read, write, edit, grep, glob (pas bash)
- **Spécialité:** Implémentation focalisée
- **Temperature:** 0 (déterministe)

**tester:**
- **Rôle:** TDD, création et validation de tests
- **Usage:** Délégué pour testing
- **Outils:** Tous y compris bash (pour exécuter tests)
- **Spécialité:** Tests automatisés

**reviewer:**
- **Rôle:** Code review, sécurité, qualité
- **Usage:** Délégué pour review de code
- **Spécialité:** Analyse qualité et sécurité

**build-agent:**
- **Rôle:** Validation build, type checking
- **Usage:** Délégué pour validation technique
- **Outils:** Tous y compris bash (pour builds)
- **Spécialité:** Validation technique

#### **Utils (Utilitaires):**

**image-specialist:**
- **Rôle:** Génération d'images avec Gemini AI
- **Usage:** Délégué pour création d'images
- **Spécialité:** Génération visuelle

**codebase-pattern-analyst:**
- **Rôle:** Analyse de patterns dans le code
- **Usage:** Délégué pour analyse de codebase
- **Spécialité:** Détection de patterns

## 🔧 Différences Techniques Clés

### **Permissions et Outils**

| Agent Type | bash | task | write | edit | Rôle |
|------------|------|------|-------|------|------|
| **openagent** | ✅ | ✅ | ✅ | ✅ | Interface + délégation |
| **opencoder** | ✅ | ❌ | ✅ | ✅ | Développement direct |
| **system-builder** | ✅ | ✅ | ✅ | ✅ | Génération systèmes |
| **task-manager** | ❌ | ❌ | ✅ | ✅ | Planification |
| **coder-agent** | ❌ | ❌ | ✅ | ✅ | Implémentation |
| **tester** | ✅ | ❌ | ✅ | ✅ | Tests (besoin bash) |
| **build-agent** | ✅ | ❌ | ✅ | ✅ | Build (besoin bash) |
| **reviewer** | ❌ | ❌ | ✅ | ✅ | Review |

**Règles de sécurité:**
- Subagents: permissions bash limitées ou interdites
- Tous: interdiction fichiers sensibles (.env, .key, .secret)
- Tous: interdiction node_modules/, .git/

### **Workflow de Délégation**

```javascript
// Syntaxe de délégation dans OpenAgent
task(
  subagent_type="task-manager",
  description="Break down feature",
  prompt="Create subtasks for user authentication system"
)
```

**Processus de délégation:**
1. Agent primaire crée contexte temporaire
2. Contexte sauvé dans `.tmp/sessions/{id}/context.md`
3. Subagent invoqué avec référence au contexte
4. Subagent charge contexte + standards projet
5. Subagent exécute tâche spécialisée
6. Retour à l'agent primaire
7. Cleanup des fichiers temporaires

## 🎯 Quand Utiliser Quoi ?

### **OpenAgent** (Recommandé par défaut)
```bash
opencode --agent openagent

# Questions (réponse directe)
> "What does this function do?"
> "How to implement authentication?"
> "Explain this error message"

# Tâches simples (exécution directe)
> "Fix this typo in README"
> "Add a comment to this function"

# Tâches complexes (délégation automatique)
> "Create a user authentication system"    # → task-manager
> "Add comprehensive tests to this module" # → tester
> "Review my code for security issues"     # → reviewer
> "Generate documentation for this API"   # → documentation
```

### **OpenCoder** (Développement direct)
```bash
opencode --agent opencoder

# Développement complexe sans délégation
> "Refactor this codebase to use dependency injection"
> "Analyze architecture and suggest improvements"
> "Implement a complete REST API with error handling"
> "Optimize this algorithm for better performance"
```

### **System Builder** (Génération de systèmes)
```bash
opencode --agent system-builder

# Génération d'architectures complètes
> "Build an e-commerce system with order processing"
> "Create a content management system"
> "Design a microservices architecture"
```

### **Subagents** (Jamais directement)
- ❌ Pas d'accès direct utilisateur
- ✅ Invoqués uniquement via `task()` par agents primaires
- ✅ Spécialisés avec permissions limitées

## 🔄 Flux de Travail Typique

### **Exemple: "Create a todo app"**

```
1. User → opencode --agent openagent
2. User → "Create a todo app with React and TypeScript"

3. OpenAgent → Analyse: tâche complexe détectée
4. OpenAgent → Charge context/core/standards/code.md
5. OpenAgent → Propose plan détaillé
6. OpenAgent → Demande approbation utilisateur

7. User → Approuve

8. OpenAgent → task(subagent_type="task-manager")
   └─ task-manager → Crée subtasks:
      ├─ 1-setup-project.md
      ├─ 2-create-models.md  
      ├─ 3-create-components.md
      ├─ 4-add-styling.md
      └─ 5-add-tests.md

9. OpenAgent → task(subagent_type="coder-agent")
   └─ coder-agent → Exécute subtasks 1-4 séquentiellement

10. OpenAgent → task(subagent_type="tester")
    └─ tester → Implémente tests (subtask 5)

11. OpenAgent → task(subagent_type="build-agent")
    └─ build-agent → Valide build et types

12. OpenAgent → task(subagent_type="reviewer")
    └─ reviewer → Review final du code

13. OpenAgent → Résumé et confirmation utilisateur
14. OpenAgent → Cleanup fichiers temporaires
```

## 📋 Critères de Délégation

### **OpenAgent délègue quand:**

**À task-manager:**
- Feature touchant 4+ fichiers
- Estimation >60 minutes
- Dépendances complexes
- Architecture à définir

**À coder-agent:**
- Subtasks simples et définies
- Implémentation séquentielle
- Pas de décisions architecturales

**À tester:**
- Création de tests
- Validation de tests existants
- TDD workflow

**À reviewer:**
- Review de sécurité
- Analyse qualité code
- Suggestions d'amélioration

**À build-agent:**
- Validation build
- Type checking
- Vérification dépendances

**À documentation:**
- Génération docs API
- README, guides utilisateur
- Documentation technique

## 🤖 Système de Modèles et Délégation

### 📊 Configuration des Modèles

#### **Agents Primaires** (ont des modèles définis)

| Agent | Model Family | Recommended Models | Temperature |
|-------|--------------|-------------------|-------------|
| **openagent** | claude | claude-sonnet-4-5, claude-3-5-sonnet-20241022 | 0.2 |
| **opencoder** | claude | claude-sonnet-4-5, claude-3-5-sonnet-20241022 | 0.1 |
| **system-builder** | (non défini) | (non défini) | 0.2 |

#### **Subagents** (PAS de modèles définis)

| Subagent | Model Family | Recommended Models | Temperature |
|----------|--------------|-------------------|-------------|
| **task-manager** | ❌ Non défini | ❌ Non défini | 0.1 |
| **coder-agent** | ❌ Non défini | ❌ Non défini | 0 |
| **tester** | ❌ Non défini | ❌ Non défini | 0.1 |
| **reviewer** | ❌ Non défini | ❌ Non défini | 0.1 |
| **build-agent** | ❌ Non défini | ❌ Non défini | 0.1 |
| **documentation** | ❌ Non défini | ❌ Non défini | (non défini) |

### 🔄 Hiérarchie des Modèles

```
CLI --model override
        ↓
┌─────────────────────────┐
│  AGENT PRIMAIRE         │
│  recommended_models:    │
│  - claude-sonnet-4-5    │
│  - claude-3-5-sonnet    │
└─────────────────────────┘
        ↓ (délégation)
┌─────────────────────────┐
│  SUBAGENT               │
│  ❌ PAS de modèles      │
│  ✅ Hérite du parent    │
└─────────────────────────┘
```

### 📋 Règles de Fonctionnement des Modèles

#### **1. Priorité des Modèles**
```
1. CLI --model (priorité absolue)
2. Agent recommended_models (si pas de CLI override)
3. Héritage du parent (pour subagents)
```

#### **2. Héritage pour Subagents**
- **Subagents n'ont PAS de modèles propres**
- **Héritent TOUJOURS du modèle de l'agent primaire parent**
- **Température peut être différente** (définie dans chaque agent)

#### **3. Autonomie des Agents**
```
Agents Primaires:
✅ Autonomes (modèles propres)
✅ Interface utilisateur directe
✅ Peuvent déléguer aux subagents

Subagents:
❌ PAS autonomes (pas de modèles)
❌ PAS d'interface directe
✅ Héritent du modèle parent
```

### 🔧 Exemples Pratiques de Modèles

#### **Exemple 1: OpenAgent avec délégation**
```bash
# Commande
opencode --agent openagent --model anthropic/claude-sonnet-4

# Workflow
1. OpenAgent utilise Claude Sonnet 4
2. OpenAgent délègue à task-manager
3. task-manager utilise Claude Sonnet 4 (héritage)
4. OpenAgent délègue à coder-agent  
5. coder-agent utilise Claude Sonnet 4 (héritage)
```

#### **Exemple 2: OpenCoder direct**
```bash
# Commande
opencode --agent opencoder

# Workflow
1. OpenCoder utilise Claude Sonnet 4.5 (son recommended_model)
2. OpenCoder fait tout lui-même (pas de délégation)
3. Pas de subagents impliqués
```

#### **Exemple 3: Override pour OpenCoder**
```bash
# Commande
opencode --agent opencoder --model anthropic/claude-sonnet-4

# Workflow
1. OpenCoder utilise Claude Sonnet 4 (CLI override)
2. Ignore ses recommended_models (Claude Sonnet 4.5)
```

### ❌ Délégation Inter-Primaires (Impossible)

**Question fréquente:** "OpenAgent peut-il déléguer à OpenCoder ?"

**Réponse:** ❌ **NON** - Les agents primaires ne se délèguent pas entre eux.

```
❌ CE QUI NE SE PASSE PAS:
OpenAgent → OpenCoder (impossible)

✅ CE QUI SE PASSE:
OpenAgent → task-manager (subagent)
OpenAgent → coder-agent (subagent)
OpenCoder → (travail direct, pas de délégation)
```

### 🎯 Architecture Réelle des Modèles

```
Utilisateur
    ↓
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   openagent     │    │   opencoder     │    │ system-builder  │
│ (Claude S4.5)   │    │ (Claude S4.5)   │    │   (non défini)  │
│ Délègue ✅      │    │ Direct ❌       │    │ Délègue ✅      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
    ↓ délégation           (pas de délégation)     ↓ délégation
┌─────────────────┐                           ┌─────────────────┐
│   Subagents     │                           │   Subagents     │
│ (hérite modèle) │                           │ (hérite modèle) │
│ • task-manager  │                           │ • domain-analyzer│
│ • coder-agent   │                           │ • agent-generator│
│ • tester        │                           │ • etc.          │
│ • reviewer      │                           └─────────────────┘
│ • etc.          │
└─────────────────┘
```

## 💡 Points Clés à Retenir

### **Architecture:**
1. **Agents primaires** = Interface utilisateur directe
2. **Subagents** = Spécialistes délégués (jamais accès direct)
3. **Délégation** = via `task()` tool uniquement
4. **Sécurité** = Permissions graduées selon le rôle

### **Workflow:**
1. **OpenAgent** = Coordinateur intelligent (délègue selon complexité)
2. **OpenCoder** = Développeur expert (fait tout lui-même)
3. **System Builder** = Architecte de systèmes (génération complète)

### **Modèles:**
1. **CLI override absolu** = `--model` override tout
2. **Héritage de modèle** = Subagents héritent toujours du parent primaire
3. **Pas de délégation inter-primaires** = OpenAgent ≠> OpenCoder
4. **Température indépendante** = Chaque agent garde sa température
5. **Subagents = extensions** = Extensions spécialisées de l'agent primaire

### **Contexte:**
1. **Chargement automatique** des standards projet
2. **Contexte temporaire** pour délégation
3. **Cleanup automatique** après tâches

### **Sécurité:**
1. **Approbation obligatoire** avant exécution
2. **Permissions limitées** pour subagents
3. **Interdiction fichiers sensibles** pour tous

Cette architecture permet une **spécialisation poussée** avec **héritage de modèles intelligent** tout en gardant une **interface simple** pour l'utilisateur ! 🚀

---

**Version:** 1.1  
**Dernière mise à jour:** Janvier 2026  
**OpenCode Version:** 1.0.223