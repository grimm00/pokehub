# Feature-Based Planning

This directory contains feature-specific planning and implementation tracking.

## Structure

Each feature gets its own directory with a consistent structure:

```
feature-name/
├── feature-plan.md    # Vision, goals, and overview
├── phase-1.md         # Implementation phases
├── phase-2.md
└── phase-3.md
```

## Feature Naming Convention

### ✅ New Features (Current Standard)
Use descriptive names that clearly indicate the feature:
- `sourcery-automation/` - Sourcery AI integration
- `generation-expansion/` - Pokemon generation expansion
- `user-profiles/` - User profile system

### 🔄 Legacy Features
Historical features keep their original phase-based names:
- Located in `../phases/completed/`
- Examples: `phase2-api-integration/`, `phase3-authentication/`

## Feature Lifecycle

### 1. Planning
- Create feature directory
- Write `feature-plan.md` with:
  - Vision and goals
  - Success criteria
  - Dependencies
  - Timeline estimate

### 2. Implementation
- Create `phase-#.md` files for each implementation phase
- Track progress with checkboxes
- Document decisions and blockers
- Update as work progresses

### 3. Completion
- Mark all phases complete
- Document lessons learned
- Archive or keep for reference

## Active Features

### Sourcery Automation
**Status:** In Progress  
**Goal:** Integrate Sourcery AI code reviews into workflow  
**Phases:** 2 phases planned

## Planned Features

### Generation Expansion
**Status:** Planned  
**Goal:** Add Sinnoh and Unova regions  
**Phases:** TBD

## Relationship to High-Level Phases

Features can span multiple high-level phases from `../phases/`:
- High-level phases = Strategic roadmap milestones
- Features = Tactical implementation work

Example:
- **Phase 5** (Strategic) might include multiple features:
  - `generation-expansion/` (Feature)
  - `advanced-search/` (Feature)
  - `team-builder/` (Feature)

---

*This structure combines Pokehub's two-level phase system with dev-toolkit's feature-based planning*
