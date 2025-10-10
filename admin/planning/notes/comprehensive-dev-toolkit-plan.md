# Comprehensive Dev Toolkit - Planning Document

**Date**: October 5, 2025  
**Decision**: Create standalone toolkit with Sourcery automation AND Git workflow utilities  
**Scope**: Portable development tools for all projects

---

## 🎯 Vision

Create a **comprehensive development toolkit** that provides:
1. **Sourcery Automation** - Parse and analyze code reviews
2. **Git Flow Utilities** - Workflow helpers, safety checks, branch management
3. **GitHub Integration** - PR management, status checks, automation
4. **Project Management** - Status dashboards, tracking, reporting

---

## 📦 Proposed Repository: `dev-toolkit`

### **Why "dev-toolkit" instead of "sourcery-automation-toolkit"?**
- Broader scope (not just Sourcery)
- Room to grow (can add more tools)
- More useful across projects
- Better name for open-source

---

## 🗂️ Repository Structure

```
dev-toolkit/
├── README.md                       # Main documentation
├── LICENSE                         # MIT License
├── install.sh                      # Installation script
├── uninstall.sh                    # Uninstallation script
├── VERSION                         # v1.0.0
├── CHANGELOG.md                    # Track changes
│
├── bin/                            # Executable commands (added to PATH)
│   ├── dt-sourcery-parse          # Parse Sourcery reviews
│   ├── dt-sourcery-analyze        # Analyze priorities (future)
│   ├── dt-git-status              # Enhanced git status
│   ├── dt-git-cleanup             # Clean up branches
│   ├── dt-git-flow                # Git flow helper
│   └── dt-pr-check                # Check PR status
│
├── lib/                            # Core libraries
│   ├── core/
│   │   ├── github-utils.sh        # GitHub CLI utilities
│   │   ├── git-utils.sh           # Git utilities
│   │   ├── config.sh              # Configuration management
│   │   └── colors.sh              # Color/formatting utilities
│   │
│   ├── sourcery/
│   │   ├── parser.sh              # Sourcery review parser
│   │   ├── analyzer.sh            # Priority matrix analyzer (future)
│   │   └── templates.sh           # Output templates
│   │
│   ├── git-flow/
│   │   ├── safety.sh              # Pre-commit safety checks
│   │   ├── branch-manager.sh     # Branch management
│   │   ├── cleanup.sh             # Branch cleanup
│   │   └── workflow-helper.sh    # Workflow automation
│   │
│   └── github/
│       ├── pr-manager.sh          # PR management
│       ├── status-checker.sh      # Status checks
│       └── api-utils.sh           # GitHub API utilities
│
├── config/
│   ├── config.example             # Example configuration
│   ├── .dev-toolkit.yml           # YAML config template
│   └── templates/                 # Output templates
│       ├── sourcery-review.md
│       └── pr-summary.md
│
├── hooks/                          # Git hooks
│   ├── pre-commit                 # Safety checks
│   ├── pre-push                   # Branch validation
│   └── commit-msg                 # Commit message validation
│
├── docs/
│   ├── README.md                  # Documentation index
│   ├── installation.md            # Installation guide
│   ├── configuration.md           # Configuration guide
│   ├── sourcery/
│   │   ├── parser.md              # Parser documentation
│   │   └── analyzer.md            # Analyzer documentation
│   ├── git-flow/
│   │   ├── workflow.md            # Git Flow workflow
│   │   ├── safety.md              # Safety features
│   │   └── cleanup.md             # Cleanup utilities
│   └── contributing.md            # Contribution guide
│
├── examples/
│   ├── basic-usage.sh             # Basic examples
│   ├── sourcery-workflow.sh      # Sourcery workflow
│   ├── git-flow-workflow.sh      # Git Flow workflow
│   └── integration.sh             # Full integration example
│
└── tests/
    ├── test-github-utils.sh
    ├── test-git-utils.sh
    ├── test-parser.sh
    └── test-workflow.sh
```

---

## 🔧 Tools to Include

### **From Pokehub/REPO-Magic**:

#### Sourcery Automation ✅
- [x] `github-utils.sh` - GitHub CLI utilities
- [x] `sourcery-review-parser.sh` - Parse Sourcery reviews
- [ ] `sourcery-priority-matrix.sh` - Priority analysis (future)

#### Git Flow Utilities ✅
- [x] `git-flow-utils.sh` - Core Git Flow utilities
- [x] `git-flow-safety.sh` - Safety checks (branch validation, conflict detection)
- [x] `workflow-helper.sh` - Workflow automation
- [ ] Git hooks (pre-commit, pre-push)

#### GitHub Integration ✅
- [x] PR status checking
- [x] Branch cleanup (local + remote)
- [x] Squash merge detection
- [x] API batching for performance

---

## 🎯 Command Structure

### **Sourcery Commands**:
```bash
dt-sourcery-parse [PR_NUMBER] [OPTIONS]     # Parse Sourcery review
dt-sourcery-analyze [PR_NUMBER]             # Analyze priorities (future)
dt-sourcery-export [PR_NUMBER] [FILE]       # Export to file
```

### **Git Flow Commands**:
```bash
dt-git-status                               # Enhanced git status with safety checks
dt-git-cleanup [--local] [--remote] [--all] # Clean up branches
dt-git-flow [start|finish|status]           # Git Flow workflow
dt-git-safety                               # Run safety checks
```

### **GitHub Commands**:
```bash
dt-pr-check [PR_NUMBER]                     # Check PR status
dt-pr-list [--author] [--state]             # List PRs
dt-pr-merge [PR_NUMBER] [--squash]          # Merge PR
```

### **Utility Commands**:
```bash
dt-config [init|show|edit]                  # Configuration management
dt-update                                   # Update toolkit
dt-version                                  # Show version
dt-help [COMMAND]                           # Show help
```

---

## 📝 Configuration System

### **Global Config**: `~/.dev-toolkit/config`
```yaml
# Dev Toolkit Configuration
version: "1.0.0"

# Project Detection (auto-detect if not set)
auto_detect: true

# Sourcery Settings
sourcery:
  output_dir: "docs/sourcery"
  show_details: true
  think_mode: false
  template: "detailed"

# Git Flow Settings
git_flow:
  main_branch: "main"
  develop_branch: "develop"
  protected_branches:
    - "main"
    - "develop"
  branch_prefixes:
    - "feat/"
    - "fix/"
    - "chore/"
    - "hotfix/"
  
# GitHub Settings
github:
  api_batch_size: 10
  rate_limit_check: true
  
# Safety Settings
safety:
  pre_commit_checks: true
  conflict_detection: true
  branch_validation: true
```

### **Per-Project Config**: `.dev-toolkit.yml` (in project root)
```yaml
# Project-specific overrides
project:
  name: "Pokehub"
  repo: "grimm00/pokedex"

sourcery:
  output_dir: "admin/docs/sourcery-reviews"

git_flow:
  protected_branches:
    - "main"
    - "develop"
    - "production"
```

---

## 🚀 Installation Process

### **Step 1: Clone Repository**
```bash
git clone https://github.com/grimm00/dev-toolkit.git ~/.dev-toolkit
cd ~/.dev-toolkit
```

### **Step 2: Run Installer**
```bash
./install.sh
```

**Installer does**:
1. Check dependencies (gh, git, bash 4.0+)
2. Create symlinks in `~/.local/bin/` or `/usr/local/bin/`
3. Add to PATH if needed
4. Create global config `~/.dev-toolkit/config`
5. Install Git hooks (optional)
6. Run validation tests

### **Step 3: Initialize in Project**
```bash
cd ~/Projects/my-project
dt-config init
```

**Creates**:
- `.dev-toolkit.yml` (project config)
- `.git/hooks/` (Git hooks, if enabled)

---

## 🔄 Update Process

### **For Users**:
```bash
dt-update  # Pulls latest version and reinstalls
```

### **For Maintainer**:
```bash
cd ~/.dev-toolkit
git pull origin main
./install.sh  # Reinstall with new version
```

---

## 📊 Migration Plan

### **Phase 1: Create Repository** (Day 1)
1. Create `dev-toolkit` repo on GitHub
2. Set up basic structure (directories)
3. Add README, LICENSE, .gitignore
4. Create VERSION file (v0.1.0-alpha)

### **Phase 2: Extract Core Utilities** (Day 1-2)
1. Copy `github-utils.sh` from Pokehub
2. Make project-agnostic (auto-detect project info)
3. Copy `git-flow-utils.sh` from Pokehub
4. Copy `git-flow-safety.sh` from Pokehub
5. Test in isolation

### **Phase 3: Extract Sourcery Tools** (Day 2)
1. Copy `sourcery-review-parser.sh`
2. Update imports to use toolkit structure
3. Test with multiple projects

### **Phase 4: Create Command Wrappers** (Day 2-3)
1. Create `bin/` executables
2. Add command-line argument parsing
3. Add help system
4. Test all commands

### **Phase 5: Configuration System** (Day 3)
1. Create config parser
2. Add global config support
3. Add per-project config support
4. Test config loading

### **Phase 6: Installation System** (Day 3-4)
1. Create `install.sh` script
2. Add dependency checking
3. Add PATH management
4. Add Git hooks installation
5. Test on clean system

### **Phase 7: Documentation** (Day 4-5)
1. Write comprehensive README
2. Installation guide
3. Configuration guide
4. Command reference
5. Examples and tutorials

### **Phase 8: Testing** (Day 5)
1. Test in REPO-Magic
2. Test in Pokehub
3. Test in other projects
4. Fix any issues

### **Phase 9: Release** (Day 5-6)
1. Tag v1.0.0
2. Create GitHub release
3. Update all projects to use toolkit
4. Remove duplicated code from projects

---

## 🎯 Features to Extract from Pokehub

### **High Priority** (Include in v1.0.0):
- [x] `github-utils.sh` - Core GitHub utilities
- [x] `sourcery-review-parser.sh` - Sourcery parser
- [x] `git-flow-utils.sh` - Git Flow utilities
- [x] `git-flow-safety.sh` - Safety checks
- [x] Branch cleanup (local + remote)
- [x] Squash merge detection
- [x] API batching

### **Medium Priority** (v1.1.0):
- [ ] `workflow-helper.sh` - Full workflow automation
- [ ] Git hooks (pre-commit, pre-push)
- [ ] PR management utilities
- [ ] Status dashboard generation

### **Low Priority** (v1.2.0+):
- [ ] `sourcery-priority-matrix.sh` - Automated analysis
- [ ] CI/CD integration templates
- [ ] Slack/Discord notifications
- [ ] Web dashboard

---

## 🔧 Making Tools Project-Agnostic

### **Current (Hardcoded)**:
```bash
PROJECT_NAME="Pokehub"
PROJECT_REPO="grimm00/pokedex"
```

### **Future (Auto-Detect)**:
```bash
# Auto-detect from git remote
detect_project_info() {
    if command -v gh >/dev/null 2>&1; then
        PROJECT_REPO=$(gh repo view --json nameWithOwner --jq '.nameWithOwner' 2>/dev/null)
    else
        # Fallback: parse git remote
        PROJECT_REPO=$(git remote get-url origin 2>/dev/null | sed -E 's/.*[:/]([^/]+\/[^/]+)(\.git)?$/\1/')
    fi
    
    PROJECT_NAME=$(basename "$PROJECT_REPO")
    PROJECT_OWNER=$(dirname "$PROJECT_REPO")
    
    # Override from config if present
    if [ -f ".dev-toolkit.yml" ]; then
        # Parse YAML config
        source_config ".dev-toolkit.yml"
    fi
}
```

---

## 📝 Naming Convention

### **Command Prefix**: `dt-` (dev-toolkit)
**Why**:
- Short and memorable
- Avoids conflicts with existing commands
- Easy to tab-complete
- Consistent namespace

**Examples**:
- `dt-sourcery-parse` (not `sourcery-parse`)
- `dt-git-cleanup` (not `git-cleanup`)
- `dt-pr-check` (not `pr-check`)

---

## 🎯 Success Criteria

### **v1.0.0 Release**:
- [x] Core utilities extracted and working
- [x] Sourcery parser functional
- [x] Git Flow utilities functional
- [ ] Installation script working
- [ ] Configuration system working
- [ ] Tested in 3+ projects
- [ ] Comprehensive documentation
- [ ] All commands have `--help`

### **Adoption**:
- [ ] Installed in REPO-Magic
- [ ] Installed in Pokehub
- [ ] Installed in 2+ other projects
- [ ] Duplicated code removed from projects

---

## 💡 Benefits

### **For You**:
- ✅ One place to maintain all dev tools
- ✅ Consistent workflow across all projects
- ✅ Easy to add new projects
- ✅ Can share with community

### **For Projects**:
- ✅ No duplicated code
- ✅ Always up-to-date tools
- ✅ Easy to onboard new developers
- ✅ Consistent conventions

### **For Community** (if open-source):
- ✅ Reusable dev tools
- ✅ Can contribute improvements
- ✅ Learn from your workflow

---

## 🚀 Next Steps

### **Immediate** (Today):
1. Create `dev-toolkit` repository on GitHub
2. Set up basic structure
3. Extract `github-utils.sh` and make project-agnostic
4. Test in one project

### **This Week**:
1. Extract all core utilities
2. Create command wrappers
3. Build installation system
4. Write basic documentation

### **Next Week**:
1. Test in all projects
2. Complete documentation
3. Tag v1.0.0 release
4. Migrate all projects to use toolkit

---

## 🤔 Open Questions

1. **Repository visibility**: Public or private?
2. **License**: MIT, Apache 2.0, or other?
3. **Versioning**: Follow semantic versioning strictly?
4. **Breaking changes**: How to handle in projects?
5. **Installation location**: `~/.dev-toolkit` or `~/.local/share/dev-toolkit`?

---

**Last Updated**: October 5, 2025  
**Status**: Planning document  
**Next Step**: Create repository and start extraction
