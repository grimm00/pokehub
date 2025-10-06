# Admin Directory

This directory contains all project management, planning, documentation, and coordination files for Pokehub.

## 📁 Directory Structure

```
admin/
├── chat-logs/              # AI conversation history
│   ├── 2024/              # 2024 development sessions
│   ├── 2025/              # 2025 development sessions
│   └── README.md
│
├── feedback/               # External code reviews
│   └── sourcery/          # Sourcery AI reviews
│       ├── pr02.md
│       └── pr10.md
│
├── planning/               # Project planning and roadmap
│   ├── features/          # Feature-based planning
│   │   ├── sourcery-automation/
│   │   └── README.md
│   ├── phases/            # High-level roadmap phases
│   │   ├── completed/     # Finished phases
│   │   └── README.md
│   ├── releases/          # Release management
│   │   ├── v1.0.0/
│   │   ├── history.md
│   │   └── README.md
│   ├── architecture/      # Architecture decisions
│   │   ├── adrs/          # Architecture Decision Records
│   │   └── database/      # Database design
│   ├── progress/          # Progress tracking
│   ├── notes/             # Planning insights
│   └── roadmap.md         # Project roadmap
│
├── docs/                   # User-facing documentation
│   ├── guides/            # Technical guides
│   │   ├── quick-reference/
│   │   └── troubleshooting/
│   ├── enhancements/      # Enhancement documentation
│   ├── PROJECT_STATUS_*.md
│   └── README.md
│
├── testing/                # Testing strategies and results
│   ├── strategies/        # Testing strategies
│   ├── ci-cd/             # CI/CD documentation
│   ├── frontend/          # Frontend tests
│   ├── performance/       # Performance testing
│   ├── results/           # Test results
│   └── README.md
│
├── PROJECT-STRUCTURE.md    # Complete structure documentation
└── README.md              # This file
```

## 📚 Key Directories Explained

### **Chat Logs** (`chat-logs/`)
AI conversation history organized by year. Provides context for decisions and problem-solving approaches.

### **Feedback** (`feedback/`)
External code reviews, primarily from Sourcery AI. Generated using `dt-review` command from dev-toolkit.

### **Planning** (`planning/`)
Project planning hub with multiple subdirectories:

- **Features** - Feature-based planning with `feature-plan.md` and `phase-#.md` files
- **Phases** - High-level roadmap phases (strategic view)
  - `completed/` - Finished phases for historical reference
- **Releases** - Release management with checklists and notes
- **Architecture** - ADRs and database design decisions
- **Progress** - Progress tracking and status updates
- **Notes** - Planning insights and brainstorming
- **roadmap.md** - Overall project direction

### **Docs** (`docs/`)
User-facing documentation and guides:
- Quick reference materials
- Troubleshooting guides
- Enhancement documentation
- Project status dashboards

### **Testing** (`testing/`)
Testing strategies, results, and automation:
- **strategies/** - Testing approaches and plans
- **ci-cd/** - CI/CD integration documentation
- **frontend/** - Frontend-specific tests
- **performance/** - Performance testing and benchmarks
- **results/** - Test execution results

## 🎯 Quick Navigation

### **Project Status & Progress**
- [Project Roadmap](planning/roadmap.md) - Overall project direction
- [Current Status](planning/progress/current-status.md) - What's happening now
- [Project Status Dashboard](docs/PROJECT_STATUS_DASHBOARD.md) - Detailed status view
- [Release History](planning/releases/history.md) - Past releases

### **Planning & Features**
- [Active Features](planning/features/) - Current feature development
- [Completed Phases](planning/phases/completed/) - Historical phases
- [Architecture Decisions](planning/architecture/adrs/) - ADRs
- [Planning Notes](planning/notes/) - Insights and brainstorming

### **Documentation & Guides**
- [Quick Reference](docs/guides/quick-reference/) - Common commands
- [Troubleshooting](docs/guides/troubleshooting/) - Problem solving
- [Enhancements](docs/enhancements/) - Enhancement docs

### **Testing & Quality**
- [Testing Strategies](testing/strategies/) - Testing approaches
- [CI/CD Documentation](testing/ci-cd/) - CI/CD integration
- [Test Results](testing/results/) - Execution results
- [Performance Testing](testing/performance/) - Benchmarks

### **Development History**
- [Chat Logs 2025](chat-logs/2025/) - Recent development sessions
- [Chat Logs 2024](chat-logs/2024/) - Historical sessions
- [Sourcery Reviews](feedback/sourcery/) - AI code reviews

## 📝 Documentation Standards

### **File Naming**
- Use descriptive, kebab-case filenames
- Include dates for time-sensitive documents
- Use consistent prefixes for related documents

### **Content Structure**
- Start with clear objectives and status
- Include implementation details and code examples
- Document decisions and rationale
- Update status as work progresses

### **Maintenance**
- Keep documentation current with code changes
- Archive outdated information
- Regular review and cleanup of old content

## 🎨 Design Philosophy

### Two-Level Planning System
- **High-Level Phases** (`planning/phases/`) - Strategic roadmap milestones
- **Feature-Level** (`planning/features/`) - Tactical implementation work
- **Completed** subdirectory for historical reference

### Feature Naming Convention
- **New features**: Descriptive names (e.g., `sourcery-automation/`)
- **Legacy phases**: Keep original names in `phases/completed/`
- **Structure**: `feature-plan.md` + `phase-#.md` files

### Clear Separation of Concerns
- **Planning** - Roadmap, features, releases, architecture
- **Docs** - User-facing guides and documentation
- **Testing** - Strategies, results, CI/CD
- **Feedback** - External code reviews

## 🔄 Recent Restructuring (October 2025)

This structure was reorganized to follow proven patterns from dev-toolkit v0.2.0:

**Moved:**
- `docs/roadmap.md` → `planning/roadmap.md`
- `docs/progress/` → `planning/progress/`
- `docs/testing/` → `testing/ci-cd/`
- Testing strategies → `testing/strategies/`

**Added:**
- `planning/releases/` - Release management
- `planning/features/` - Feature-based planning structure
- Better organization within `testing/`

**Benefits:**
- Clearer organization
- Better AI navigation
- Release management ready
- Proven patterns from successful projects

## 📞 Navigation Tips

- **For current work**: Check `planning/features/` and `planning/progress/`
- **For history**: Check `chat-logs/` and `planning/phases/completed/`
- **For guides**: Check `docs/guides/`
- **For testing**: Check `testing/strategies/` and `testing/ci-cd/`
- **For structure**: See `PROJECT-STRUCTURE.md`

---

**Last Updated**: October 6, 2025  
**Status**: ✅ Restructured with dev-toolkit patterns  
**Next Review**: After v1.0.0 release