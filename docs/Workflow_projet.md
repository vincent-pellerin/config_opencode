# Workflow OpenCode par Phase de Projet

Guide complet pour utiliser OpenCode efficacement selon les phases d'un projet de développement.

## 🎯 Vue d'Ensemble

Ce guide présente un workflow optimisé pour utiliser les agents OpenCode selon les 7 phases principales d'un projet :

1. **Conception d'architecture & stack technique**
2. **Questions, avancements & validation de choix**
3. **Génération du plan de conception**
4. **Exécution des tâches & code**
5. **Tests**
6. **Validation des tests**
7. **Push sur GitHub**

---

## 📋 **Phase 1: Conception d'Architecture & Stack Technique**

### **Agent recommandé:** `system-builder` ou `openagent`

#### **Option A: System Builder** (projets complexes)
```bash
opencode --agent system-builder

# Exemples d'usage
> "Design an e-commerce system with microservices architecture using Node.js, React, PostgreSQL, and Docker"
> "Create a data analytics platform with Python, Apache Kafka, and machine learning components"
> "Build a content management system with headless CMS architecture"
```

#### **Option B: OpenAgent** (projets standards)
```bash
opencode --agent openagent

# Exemples d'usage
> "Help me choose the best tech stack for a real estate web application with scraping, dashboard, and API"
> "Design the architecture for a social media app with real-time messaging"
> "What's the optimal stack for a fintech application with high security requirements?"
```

### **Livrables attendus:**
- ✅ Architecture globale du système
- ✅ Choix de stack technique justifiés
- ✅ Structure de projet recommandée
- ✅ Dépendances principales identifiées
- ✅ Considérations de sécurité et performance

### **Modèle recommandé:**
```bash
# Créativité pour l'architecture
--model anthropic/claude-sonnet-4-5
```

---

## 📋 **Phase 2: Questions, Avancements & Validation de Choix**

### **Agent recommandé:** `openagent` (mode conversationnel)

```bash
opencode --agent openagent

# Questions d'architecture
> "Should I use PostgreSQL or MongoDB for this use case?"
> "What's the best way to handle authentication in this stack?"
> "How to structure a monorepo with multiple services?"
> "Is GraphQL or REST better for my API design?"

# Validation de choix techniques
> "Review my database schema design for performance issues"
> "Is this API structure following REST best practices?"
> "Validate my Docker compose configuration"
> "Check if my microservices boundaries make sense"

# Questions d'implémentation
> "How to implement real-time notifications efficiently?"
> "What's the best caching strategy for this application?"
> "How to handle file uploads in a scalable way?"
```

### **Avantages de cette approche:**
- ✅ Réponses directes (pas de délégation = plus rapide)
- ✅ Expertise multi-domaine
- ✅ Validation rapide des décisions
- ✅ Clarification des concepts complexes

### **Modèle recommandé:**
```bash
# Équilibre créativité/précision
--model anthropic/claude-sonnet-4-5
```

---

## 📋 **Phase 3: Génération du Plan de Conception**

### **Agent recommandé:** `openagent` → délégation automatique à `task-manager`

```bash
opencode --agent openagent

# Demandes de planification détaillée
> "Create a detailed implementation plan for the e-commerce system with user auth, product catalog, shopping cart, and payment processing"
> "Generate a step-by-step plan to implement the real-time messaging feature"
> "Plan the implementation of the data analytics dashboard with charts and filters"
```

### **Workflow automatique:**
```
1. OpenAgent analyse la complexité de la demande
2. Détecte les critères de délégation:
   ├─ Feature touchant 4+ fichiers ✅
   ├─ Estimation >60 minutes ✅
   └─ Dépendances complexes ✅
3. Délègue automatiquement à task-manager
4. task-manager crée subtasks atomiques avec dépendances
5. Retour du plan structuré à l'utilisateur
```

### **Critères de délégation automatique:**
- ✅ Feature touchant 4+ fichiers
- ✅ Estimation >60 minutes
- ✅ Dépendances complexes entre composants
- ✅ Architecture à définir

### **Livrables générés:**
```
tasks/subtasks/{feature}/
├── objective.md              # Vue d'ensemble de la feature
├── 01-setup-database.md      # Subtask 1
├── 02-create-models.md       # Subtask 2
├── 03-implement-api.md       # Subtask 3
├── 04-create-frontend.md     # Subtask 4
├── 05-add-tests.md           # Subtask 5
└── 06-documentation.md       # Subtask 6
```

### **Modèle recommandé:**
```bash
# Précision pour la planification
--model anthropic/claude-sonnet-4-5
```

---

## 📋 **Phase 4: Exécution des Tâches & Code**

### **Choix d'agent selon la complexité:**

#### **4A: Tâches Complexes/Multiples** → `openagent`

**Quand utiliser:**
- Features nouvelles avec multiples fichiers
- Coordination entre plusieurs composants
- Besoin de délégation à des spécialistes

```bash
opencode --agent openagent

# Implémentation avec délégation intelligente
> "Implement the user authentication system from the task plan"
> "Create the product catalog with search and filtering"
> "Build the real-time messaging feature with WebSocket"

# OpenAgent délègue automatiquement:
# → coder-agent pour implémentation séquentielle
# → reviewer pour validation qualité en cours de route
```

#### **4B: Développement Direct/Refactoring** → `opencoder`

**Quand utiliser:**
- Refactoring de code existant
- Optimisation de performance
- Développement expert nécessitant focus

```bash
opencode --agent opencoder

# Développement expert sans délégation
> "Refactor the authentication module to use JWT with refresh tokens"
> "Optimize the database queries for the product search"
> "Implement advanced error handling across the API"
> "Add comprehensive logging and monitoring"
```

### **Critères de choix:**

| Critère | OpenAgent | OpenCoder |
|---------|-----------|-----------|
| **Nouveaux composants** | ✅ | ❌ |
| **Multiples fichiers** | ✅ | ⚠️ |
| **Coordination nécessaire** | ✅ | ❌ |
| **Refactoring** | ⚠️ | ✅ |
| **Optimisation** | ❌ | ✅ |
| **Expertise technique** | ⚠️ | ✅ |

### **Modèle recommandé:**
```bash
# Précision maximale pour le code
--model anthropic/claude-sonnet-4-5
```

---

## 📋 **Phase 5: Tests**

### **Agent recommandé:** `openagent` → délégation automatique à `tester`

```bash
opencode --agent openagent

# Tests automatiques
> "Add comprehensive tests for the authentication module"
> "Create integration tests for the API endpoints"
> "Implement end-to-end tests for the user registration flow"
> "Add unit tests for the payment processing logic"

# Tests spécialisés
> "Create performance tests for the search functionality"
> "Add security tests for the authentication system"
> "Implement visual regression tests for the UI components"
```

### **Workflow automatique:**
```
1. OpenAgent charge automatiquement standards/tests.md
2. Analyse le type de tests requis
3. Délègue à tester (qui a accès bash pour exécuter tests)
4. tester crée tests selon standards du projet
5. Exécution et validation automatique
6. Rapport de couverture et résultats
```

### **Types de tests gérés:**
- ✅ **Unit tests** (fonctions individuelles)
- ✅ **Integration tests** (modules ensemble)
- ✅ **End-to-end tests** (workflow complet)
- ✅ **API tests** (endpoints et contrats)
- ✅ **Performance tests** (charge et stress)
- ✅ **Security tests** (vulnérabilités)

### **Modèle recommandé:**
```bash
# Précision pour les tests
--model anthropic/claude-sonnet-4-5
```

---

## 📋 **Phase 6: Validation des Tests**

### **Agent recommandé:** `openagent` → délégation automatique à `build-agent`

```bash
opencode --agent openagent

# Validation complète
> "Run all tests and validate the build"
> "Check type safety and lint issues across the project"
> "Validate test coverage requirements are met"
> "Ensure all dependencies are properly configured"

# Validation spécialisée
> "Check for security vulnerabilities in dependencies"
> "Validate Docker build and deployment readiness"
> "Run performance benchmarks and validate thresholds"
```

### **Workflow automatique:**
```
1. OpenAgent délègue à build-agent
2. build-agent exécute suite complète de tests
3. Vérification type checking (TypeScript, mypy, etc.)
4. Validation lint et formatting
5. Vérification coverage minimale
6. Tests de build et packaging
7. Rapport de qualité détaillé
```

### **Validations effectuées:**
- ✅ **Tests unitaires** (100% passage)
- ✅ **Tests d'intégration** (validation complète)
- ✅ **Type checking** (TypeScript, Python types)
- ✅ **Linting** (ESLint, Pylint, etc.)
- ✅ **Coverage** (seuils définis)
- ✅ **Build** (compilation réussie)
- ✅ **Dependencies** (sécurité et compatibilité)

### **Modèle recommandé:**
```bash
# Précision maximale pour validation
--model anthropic/claude-sonnet-4-5
```

---

## 📋 **Phase 7: Push sur GitHub**

### **Agent recommandé:** `openagent` (avec commandes intégrées)

```bash
opencode --agent openagent

# Review final avant push
> "Review all changes and prepare for GitHub push"
> "Check commit history and ensure clean git state"
> "Validate that all features are properly documented"

# OpenAgent délègue automatiquement à reviewer
# Puis utilise les commandes intégrées pour Git
```

### **Workflow automatique:**
```
1. OpenAgent délègue à reviewer pour analyse finale
2. reviewer vérifie:
   ├─ Qualité du code
   ├─ Sécurité
   ├─ Best practices
   ├─ Documentation
   └─ Cohérence architecturale
3. Génération du commit message intelligent
4. Validation finale avant push
5. Push vers GitHub avec tags appropriés
```

### **Commandes disponibles:**

#### **Commit intelligent:**
```bash
/commit
# Génère automatiquement un message de commit suivant les conventions
# Format: type(scope): description
# Ex: feat(auth): add JWT token refresh mechanism
```

#### **Review final:**
```bash
> "Review my code for security and best practices"
# Délégation automatique à reviewer pour analyse complète
```

#### **Push avec validation:**
```bash
> "Push to GitHub after final validation"
# Validation complète + push sécurisé
```

### **Validations avant push:**
- ✅ **Code review** complet
- ✅ **Tests** passent tous
- ✅ **Build** réussit
- ✅ **Documentation** à jour
- ✅ **Sécurité** validée
- ✅ **Git state** propre

### **Modèle recommandé:**
```bash
# Précision pour review final
--model anthropic/claude-sonnet-4-5
```

---

## 🎯 **Workflows Recommandés par Type de Projet**

### **Projet Simple** (1-2 développeurs, application standard)

```bash
# Phase 1-2: Architecture & Questions
opencode --agent openagent --model anthropic/claude-sonnet-4-5

# Phase 3: Plan (si complexe, sinon skip)
opencode --agent openagent  # → délégation task-manager si nécessaire

# Phase 4: Code (développement direct)
opencode --agent opencoder --model anthropic/claude-sonnet-4-5

# Phase 5-7: Tests & Push (délégations automatiques)
opencode --agent openagent --model anthropic/claude-sonnet-4-5
```

### **Projet Complexe** (équipe, microservices, architecture avancée)

```bash
# Phase 1: Architecture (génération système complet)
opencode --agent system-builder --model anthropic/claude-sonnet-4-5

# Phase 2: Questions & validation
opencode --agent openagent --model anthropic/claude-sonnet-4-5

# Phase 3: Plan détaillé
opencode --agent openagent  # → délégation task-manager automatique

# Phase 4: Code (coordination multiple)
opencode --agent openagent  # → délégations multiples (coder-agent, reviewer)

# Phase 5-7: Tests & Push (workflow complet)
opencode --agent openagent  # → délégations automatiques complètes
```

### **Projet de Refactoring** (optimisation, modernisation)

```bash
# Phase 1-2: Analyse & Questions
opencode --agent openagent --model anthropic/claude-sonnet-4-5

# Phase 3: Plan de refactoring
opencode --agent openagent  # → task-manager pour plan détaillé

# Phase 4: Refactoring (expertise directe)
opencode --agent opencoder --model anthropic/claude-sonnet-4-5

# Phase 5-7: Tests & Validation
opencode --agent openagent  # → délégations pour validation complète
```

---

## 📊 **Matrice de Décision par Phase**

| Phase | Agent Principal | Délégation Auto | Modèle Recommandé | Cas d'Usage |
|-------|----------------|-----------------|-------------------|-------------|
| **1. Architecture** | system-builder / openagent | Oui | claude-sonnet-4-5 | Conception globale |
| **2. Questions** | openagent | Non | claude-sonnet-4-5 | Validation rapide |
| **3. Plan** | openagent | → task-manager | claude-sonnet-4-5 | Planification détaillée |
| **4A. Code (complexe)** | openagent | → coder-agent | claude-sonnet-4-5 | Features multiples |
| **4B. Code (expert)** | opencoder | Non | claude-sonnet-4-5 | Refactoring/optimisation |
| **5. Tests** | openagent | → tester | claude-sonnet-4-5 | Tests automatisés |
| **6. Validation** | openagent | → build-agent | claude-sonnet-4-5 | Validation build |
| **7. Push** | openagent | → reviewer | claude-sonnet-4-5 | Review final |

---

## 💡 **Bonnes Pratiques**

### **Gestion des Modèles**

#### **Modèle unique pour cohérence:**
```bash
# Utiliser le même modèle pour tout le projet
export OPENCODE_MODEL="anthropic/claude-sonnet-4-5"
opencode --agent openagent  # Utilise automatiquement le modèle défini
```

#### **Modèles spécialisés par phase:**
```bash
# Phases créatives (1-3): Modèle équilibré
opencode --agent openagent --model anthropic/claude-sonnet-4-5

# Phases d'implémentation (4-7): Modèle précis
opencode --agent opencoder --model anthropic/claude-sonnet-4-5
```

### **Contextes Critiques**

#### **Chargement automatique des standards:**
- **Phase 4+** : Toujours charger `.opencode/context/core/standards/code.md`
- **Phase 5** : Toujours charger `.opencode/context/core/standards/tests.md`
- **Phase 7** : Toujours charger `.opencode/context/core/workflows/review.md`

#### **Contextes projet-spécifiques:**
```bash
# Assurer que le contexte projet est à jour
nano ~/.opencode/context/project/project-context.md

# Ajouter patterns spécifiques:
# - Conventions de nommage
# - Architecture patterns
# - Standards de sécurité
# - Configurations spéciales
```

### **Commandes Utiles par Phase**

#### **Validation continue:**
```bash
/validate-repo  # Validation complète du repository
/test          # Exécution des tests
/optimize      # Optimisation du code
```

#### **Gestion Git:**
```bash
/commit        # Commit intelligent avec message auto-généré
/clean         # Nettoyage des fichiers temporaires
```

#### **Gestion de contexte:**
```bash
/context       # Gestion des contextes projet
```

### **Optimisation des Performances**

#### **Délégation intelligente:**
- Laisser OpenAgent décider des délégations (critères automatiques)
- Utiliser OpenCoder pour le développement direct sans coordination
- Éviter les délégations manuelles sauf cas spéciaux

#### **Sessions de travail:**
- Une session par feature majeure
- Cleanup automatique des fichiers temporaires
- Réutilisation des contextes entre sessions

### **Gestion d'Équipe**

#### **Standards partagés:**
```bash
# Synchroniser les contextes entre développeurs
git clone <config-repo> ~/.opencode-shared
ln -s ~/.opencode-shared/context ~/.opencode/context
```

#### **Workflow collaboratif:**
1. **Architecte** : system-builder pour conception
2. **Lead dev** : openagent pour coordination
3. **Développeurs** : opencoder pour implémentation
4. **QA** : openagent → tester pour validation

---

## 🚀 **Exemple Complet : Application E-commerce**

### **Phase 1: Architecture**
```bash
opencode --agent system-builder
> "Design a scalable e-commerce platform with user management, product catalog, shopping cart, payment processing, and admin dashboard. Use Node.js, React, PostgreSQL, Redis, and Docker."
```

### **Phase 2: Questions**
```bash
opencode --agent openagent
> "Should I use Stripe or PayPal for payment processing?"
> "What's the best way to handle product images and file uploads?"
> "How to implement real-time inventory updates?"
```

### **Phase 3: Plan**
```bash
opencode --agent openagent
> "Create a detailed implementation plan for the e-commerce platform with all features"
# → Délégation automatique à task-manager
# → Génération de 15+ subtasks organisées
```

### **Phase 4: Code**
```bash
# Features complexes
opencode --agent openagent
> "Implement the user authentication and authorization system"
> "Create the product catalog with search and filtering"

# Optimisations
opencode --agent opencoder
> "Optimize database queries for product search performance"
> "Implement advanced caching strategy with Redis"
```

### **Phase 5: Tests**
```bash
opencode --agent openagent
> "Add comprehensive tests for all authentication flows"
> "Create integration tests for the payment processing"
> "Implement end-to-end tests for the complete purchase flow"
```

### **Phase 6: Validation**
```bash
opencode --agent openagent
> "Run full test suite and validate build for production deployment"
> "Check security vulnerabilities and performance benchmarks"
```

### **Phase 7: Push**
```bash
opencode --agent openagent
> "Review all changes and prepare for production deployment"
/commit  # Commit intelligent
> "Push to GitHub with proper tags and documentation"
```

---

Ce workflow vous permet d'utiliser OpenCode de manière optimale à chaque phase, en tirant parti des spécialisations de chaque agent et de leurs délégations automatiques ! 🚀

---

**Version:** 1.0  
**Dernière mise à jour:** Janvier 2026  
**OpenCode Version:** 1.0.223