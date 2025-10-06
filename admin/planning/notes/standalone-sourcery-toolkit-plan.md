# Standalone Sourcery Toolkit - Action Plan

**Date**: October 5, 2025  
**Context**: User has multiple projects that could benefit from shared Sourcery automation tools  
**Decision**: Create standalone repository for portability

---

## 🎯 Recommendation: Create Standalone Repository

Since you have **multiple projects**, a standalone toolkit makes sense!

---

## 📦 Proposed Repository Structure

```
sourcery-automation-toolkit/
├── README.md                    # Main documentation
├── LICENSE                      # MIT or your choice
├── install.sh                   # Installation script
├── VERSION                      # Semantic versioning
├── CHANGELOG.md                 # Track changes
│
├── bin/                         # Executable scripts (symlinked to PATH)
│   ├── sourcery-parse          # Wrapper for parser
│   └── sourcery-analyze        # Wrapper for analyzer (future)
│
├── lib/                         # Core library scripts
│   ├── core/
│   │   ├── github-utils.sh     # GitHub utilities
│   │   └── config.sh           # Configuration management
│   ├── parsers/
│   │   └── sourcery-review-parser.sh
│   └── analyzers/
│       └── priority-matrix.sh  # Future
│
├── config/
│   ├── config.example          # Example configuration
│   └── templates/              # Output templates
│
├── docs/
│   ├── installation.md         # How to install
│   ├── usage.md                # How to use
│   ├── configuration.md        # How to configure
│   └── contributing.md         # How to contribute
│
├── examples/
│   ├── basic-usage.sh          # Example usage
│   └── advanced-workflow.sh   # Advanced examples
│
└── tests/
    ├── test-github-utils.sh
    └── test-parser.sh
```

---

## 🚀 Implementation Plan

### Phase 1: Create Repository
1. Create new repo: `sourcery-automation-toolkit`
2. Initialize with README, LICENSE, .gitignore
3. Set up basic structure (directories)

### Phase 2: Extract Core Tools
1. Copy `github-utils.sh` from REPO-Magic
2. Make it project-agnostic (remove hardcoded project names)
3. Add configuration system for project-specific settings

### Phase 3: Extract Parser
1. Copy `sourcery-review-parser.sh`
2. Update imports to use toolkit structure
3. Test with multiple projects

### Phase 4: Installation System
1. Create `install.sh` script
2. Add to PATH or create symlinks
3. Configuration file support

### Phase 5: Documentation
1. Write comprehensive README
2. Installation guide
3. Usage examples
4. Configuration guide

### Phase 6: Integrate into Projects
1. Install toolkit in REPO-Magic
2. Install toolkit in Pokehub
3. Install toolkit in other projects
4. Remove duplicated code

---

## 🔧 Making Scripts Project-Agnostic

### Current (Project-Specific):
```bash
# In github-utils.sh
PROJECT_NAME="Pokehub"
PROJECT_OWNER="grimm00"
PROJECT_REPO="grimm00/pokedex"
```

### Future (Toolkit - Auto-Detect):
```bash
# In github-utils.sh
# Auto-detect from git remote
PROJECT_REPO=$(gh repo view --json nameWithOwner --jq '.nameWithOwner' 2>/dev/null)
PROJECT_NAME=$(basename "$PROJECT_REPO")
PROJECT_OWNER=$(dirname "$PROJECT_REPO")

# Or load from config file
if [ -f ".sourcery-config" ]; then
    source .sourcery-config
fi
```

---

## 📝 Configuration File Format

### `.sourcery-config` (per-project):
```bash
# Sourcery Automation Toolkit Configuration

# Project Information (auto-detected if not set)
PROJECT_NAME="Pokehub"
PROJECT_REPO="grimm00/pokedex"

# Output Preferences
OUTPUT_DIR="admin/docs/sourcery-reviews"
TEMPLATE_STYLE="detailed"  # or "compact"

# Parser Options
SHOW_DETAILS=true
THINK_MODE=false

# Custom Priority Levels (optional)
PRIORITY_LEVELS="CRITICAL,HIGH,MEDIUM,LOW"
```

---

## 🎯 Installation Methods

### Method 1: Clone and Install (Recommended)
```bash
# Clone the toolkit
git clone https://github.com/grimm00/sourcery-automation-toolkit.git ~/.sourcery-toolkit

# Run installer
cd ~/.sourcery-toolkit
./install.sh

# Add to PATH (installer does this)
# Now available globally: sourcery-parse, sourcery-analyze
```

### Method 2: Direct Source (Development)
```bash
# Clone into project
cd ~/Projects/my-project
git clone https://github.com/grimm00/sourcery-automation-toolkit.git .sourcery

# Source in scripts
source .sourcery/lib/core/github-utils.sh
```

### Method 3: Git Submodule (Advanced)
```bash
# Add as submodule
git submodule add https://github.com/grimm00/sourcery-automation-toolkit.git tools/sourcery

# Update submodule
git submodule update --remote
```

---

## 🔄 Update Workflow

### For Toolkit Maintainer (You):
1. Make changes in `sourcery-automation-toolkit` repo
2. Test with one project
3. Commit and tag version (e.g., `v1.1.0`)
4. Push to GitHub

### For Project Users (Also You):
```bash
# In any project using the toolkit
sourcery-toolkit update  # Updates to latest version

# Or manually
cd ~/.sourcery-toolkit
git pull
./install.sh
```

---

## 📊 Benefits for Multiple Projects

### Before (Current):
```
REPO-Magic/scripts/...     (copy 1)
Pokehub/scripts/...        (copy 2)
Project3/scripts/...       (copy 3)
Project4/scripts/...       (copy 4)
```
**Problem**: 4 copies to maintain!

### After (Toolkit):
```
~/.sourcery-toolkit/       (single source)
  ↓
REPO-Magic/  → uses toolkit
Pokehub/     → uses toolkit
Project3/    → uses toolkit
Project4/    → uses toolkit
```
**Benefit**: One place to maintain, all projects get updates!

---

## 🎯 Versioning Strategy

### Semantic Versioning:
- **v1.0.0** - Initial release (github-utils + parser)
- **v1.1.0** - Add priority matrix analyzer
- **v1.2.0** - Add workflow integration
- **v2.0.0** - Breaking changes (if needed)

### Version Pinning (Optional):
```bash
# In project's .sourcery-config
TOOLKIT_VERSION="1.1.0"  # Pin to specific version
```

---

## 🚀 Quick Start (After Toolkit is Created)

### For New Project:
```bash
# 1. Install toolkit globally (one time)
curl -sSL https://raw.githubusercontent.com/grimm00/sourcery-automation-toolkit/main/install.sh | bash

# 2. In your project, create config
cat > .sourcery-config << EOF
PROJECT_NAME="MyProject"
OUTPUT_DIR="docs/sourcery"
EOF

# 3. Use it!
sourcery-parse 27 --output docs/sourcery/pr-27-review.md
```

---

## 💡 Additional Features to Consider

### Future Enhancements:
1. **Auto-update checker**: Notify when new version available
2. **Project templates**: Quick setup for new projects
3. **CI/CD integration**: GitHub Actions workflow templates
4. **Multiple parsers**: Support for other code review tools
5. **Web dashboard**: View all reviews in one place
6. **Slack/Discord integration**: Post reviews to team channels

---

## 📝 Next Steps

### Immediate (If You Want to Proceed):
1. **Create repo**: `sourcery-automation-toolkit` on GitHub
2. **Extract tools**: Copy from REPO-Magic, make project-agnostic
3. **Test locally**: Install in one project first
4. **Document**: Write README and installation guide
5. **Roll out**: Install in all your projects

### Or:
- **Finish current work**: Complete Pokehub phases first
- **Revisit later**: Create toolkit when you have time

---

## 🤔 Decision Time

**Questions to consider**:
1. How many projects do you actually have? (3? 5? 10?)
2. How often do you update these tools?
3. Do you want to open-source the toolkit?
4. How much time do you want to invest now vs. later?

**My recommendation**: 
- If **5+ projects**: Create toolkit now (worth the investment)
- If **3-4 projects**: Finish Pokehub phases first, then create toolkit
- If **2-3 projects**: Keep copying for now, create toolkit later if needed

---

**Last Updated**: October 5, 2025  
**Status**: Planning document  
**Next Step**: Decide if/when to create standalone toolkit
