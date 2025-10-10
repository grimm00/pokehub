# Main Phases

**Purpose:** Cross-cutting development phases (full-stack, infrastructure)  
**Status:** 📁 Directory Structure  
**Last Updated:** [Date]

---

## 📋 Overview

This directory contains planning documentation for main development phases - cross-cutting major development milestones and phases that affect both frontend and backend, or infrastructure-level phases.

---

## 🎯 What Goes Here

### Main Phases Include:

- **Full-Stack Phases** - Phases affecting both frontend and backend
- **Infrastructure Phases** - Docker, deployment, environment phases
- **Cross-Cutting Architecture** - Architecture changes affecting multiple components
- **Cross-Cutting Performance** - Performance improvements across the stack
- **Cross-Cutting Security** - Security phases affecting multiple components

### Examples:

- Full-stack architecture phase
- Docker containerization phase
- Infrastructure modernization phase
- Cross-cutting performance optimization phase
- Cross-cutting security hardening phase

---

## 📁 Directory Structure

```
main/
├── README.md                    # This file
├── [phase-name]/                # Individual phase directories
│   ├── README.md               # Phase hub
│   ├── phase-plan.md           # Phase plan
│   ├── status-and-next-steps.md # Current status
│   ├── quick-start.md          # Phase guide
│   └── day-*.md                # Daily implementation plans
```

---

## 🚀 Getting Started

### Creating a New Main Phase

1. **Create phase directory:**
   ```bash
   mkdir admin/planning/phases/main/my-phase
   cd admin/planning/phases/main/my-phase
   ```

2. **Copy templates:**
   ```bash
   cp ../../../notes/opportunities/external/administration/templates/README-template.md README.md
   cp ../../../notes/opportunities/external/administration/templates/phase-template.md phase-plan.md
   cp ../../../notes/opportunities/external/administration/templates/status-and-next-steps-template.md status-and-next-steps.md
   cp ../../../notes/opportunities/external/administration/templates/quick-start-template.md quick-start.md
   ```

3. **Customize for main phase:**
   - Update `[Area]` to "Main"
   - Focus on cross-cutting phase aspects
   - Include both frontend and backend considerations
   - Plan full-stack testing strategy
   - Consider infrastructure requirements
   - Plan coordinated deployment strategy

---

## 📚 Related Documents

- [Frontend Phases](../frontend/README.md) - Client-side phases
- [Backend Phases](../backend/README.md) - Server-side phases
- [Hub-and-Spoke Templates](../../notes/opportunities/external/administration/templates/README.md) - Documentation templates

---

## 🏷️ Tags

**Type:** Phases  
**Area:** Main  
**Status:** 📁 Directory Structure

---

**Last Updated:** [Date]  
**Status:** 📁 Directory Structure
