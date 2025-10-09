# Main Releases

**Purpose:** Cross-cutting release management (full-stack, infrastructure)  
**Status:** 📁 Directory Structure  
**Last Updated:** [Date]

---

## 📋 Overview

This directory contains planning documentation for main releases - cross-cutting version management, deployment, and release planning that affects both frontend and backend, or infrastructure-level releases.

---

## 🎯 What Goes Here

### Main Releases Include:

- **Full-Stack Releases** - Releases affecting both frontend and backend
- **Infrastructure Releases** - Docker, deployment, environment updates
- **Cross-Cutting Features** - Features requiring coordinated frontend/backend changes
- **Cross-Cutting Security** - Security releases affecting multiple components
- **Cross-Cutting Performance** - Performance improvements across the stack

### Examples:

- Full-stack feature releases
- Docker containerization releases
- Infrastructure updates
- Security patches
- Performance improvements
- Cross-cutting bug fixes

---

## 📁 Directory Structure

```
main/
├── README.md                    # This file
├── [version]/                   # Individual release directories
│   ├── README.md               # Release hub
│   ├── release-plan.md         # Release plan
│   ├── status-and-next-steps.md # Current status
│   ├── quick-start.md          # Release guide
│   └── release-notes.md        # Release notes
```

---

## 🚀 Getting Started

### Creating a New Main Release

1. **Create release directory:**
   ```bash
   mkdir admin/planning/releases/main/v1.2.0
   cd admin/planning/releases/main/v1.2.0
   ```

2. **Copy templates:**
   ```bash
   cp ../../../notes/opportunities/external/administration/templates/README-template.md README.md
   cp ../../../notes/opportunities/external/administration/templates/feature-plan-template.md release-plan.md
   cp ../../../notes/opportunities/external/administration/templates/status-and-next-steps-template.md status-and-next-steps.md
   cp ../../../notes/opportunities/external/administration/templates/quick-start-template.md quick-start.md
   ```

3. **Customize for main release:**
   - Update `[Area]` to "Main"
   - Focus on cross-cutting release aspects
   - Include both frontend and backend considerations
   - Plan coordinated deployment strategy
   - Consider infrastructure requirements
   - Plan cross-cutting rollback procedures

---

## 📚 Related Documents

- [Frontend Releases](../frontend/README.md) - Client-side releases
- [Backend Releases](../backend/README.md) - Server-side releases
- [Hub-and-Spoke Templates](../../notes/opportunities/external/administration/templates/README.md) - Documentation templates

---

## 🏷️ Tags

**Type:** Releases  
**Area:** Main  
**Status:** 📁 Directory Structure

---

**Last Updated:** [Date]  
**Status:** 📁 Directory Structure
