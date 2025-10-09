# Main Features

**Purpose:** Cross-cutting functionality that affects both frontend and backend  
**Status:** 📁 Directory Structure  
**Last Updated:** [Date]

---

## 📋 Overview

This directory contains planning documentation for main features - cross-cutting functionality that affects both the frontend and backend, or features that don't fit neatly into either category.

---

## 🎯 What Goes Here

### Main Features Include:

- **Full-Stack Features** - Features requiring both frontend and backend changes
- **Infrastructure** - Docker, deployment, environment setup
- **Cross-Cutting Concerns** - Logging, monitoring, error handling
- **Development Tools** - Scripts, automation, developer experience
- **Documentation** - User guides, API docs, technical documentation
- **Testing** - End-to-end tests, test infrastructure
- **Security** - Security features, vulnerability fixes

### Examples:

- User authentication (frontend + backend)
- Pokemon search (API + UI)
- Docker containerization
- CI/CD pipeline improvements
- Error handling and logging
- Performance monitoring
- Security enhancements

---

## 📁 Directory Structure

```
main/
├── README.md                    # This file
├── [feature-name]/              # Individual feature directories
│   ├── README.md               # Feature hub
│   ├── feature-plan.md         # Feature plan
│   ├── status-and-next-steps.md # Current status
│   ├── quick-start.md          # How-to guide
│   └── phase-*.md              # Implementation phases
```

---

## 🚀 Getting Started

### Creating a New Main Feature

1. **Create feature directory:**
   ```bash
   mkdir admin/planning/features/main/my-feature
   cd admin/planning/features/main/my-feature
   ```

2. **Copy templates:**
   ```bash
   cp ../../../notes/opportunities/external/administration/templates/README-template.md README.md
   cp ../../../notes/opportunities/external/administration/templates/feature-plan-template.md feature-plan.md
   cp ../../../notes/opportunities/external/administration/templates/status-and-next-steps-template.md status-and-next-steps.md
   cp ../../../notes/opportunities/external/administration/templates/quick-start-template.md quick-start.md
   ```

3. **Customize for main:**
   - Update `[Area]` to "Main"
   - Focus on cross-cutting aspects
   - Include both frontend and backend considerations
   - Plan full-stack testing strategy
   - Consider infrastructure requirements
   - Plan deployment and monitoring

---

## 📚 Related Documents

- [Frontend Features](../frontend/README.md) - Client-side functionality
- [Backend Features](../backend/README.md) - Server-side functionality
- [Hub-and-Spoke Templates](../../notes/opportunities/external/administration/templates/README.md) - Documentation templates

---

## 🏷️ Tags

**Type:** Features  
**Area:** Main  
**Status:** 📁 Directory Structure

---

**Last Updated:** [Date]  
**Status:** 📁 Directory Structure
