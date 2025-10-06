# Portable Sourcery Tools Discussion

**Date**: October 5, 2025  
**Context**: Considering making Sourcery automation tools portable across projects  
**Current State**: Tools exist in both REPO-Magic and Pokehub

---

## 🤔 The Question

Should we create a new repository for Sourcery automation tools to make them portable across projects?

---

## 📊 Current Situation

### **Tools We Have**
1. **`github-utils.sh`** - GitHub CLI utilities, status printing, project management
2. **`sourcery-review-parser.sh`** - Extracts Sourcery reviews from PRs
3. **Future tools** - Priority matrix, workflow integration, etc.

### **Current Locations**
- **REPO-Magic**: Original implementation
- **Pokehub**: Ported with minimal changes
- **Pattern**: Copy → Adapt → Use

---

## 🎯 Options for Portability

### **Option A: New Standalone Repository** 🆕

**Structure**:
```
sourcery-automation-toolkit/
├── scripts/
│   ├── core/
│   │   └── github-utils.sh
│   ├── monitoring/
│   │   ├── sourcery-review-parser.sh
│   │   └── sourcery-priority-matrix.sh
│   └── workflow/
│       └── git-flow-integration.sh
├── docs/
│   ├── README.md
│   ├── installation.md
│   └── usage-guide.md
├── examples/
│   └── sample-configs/
└── install.sh
```

**Pros**:
- ✅ **Single source of truth**: One place to maintain and improve
- ✅ **Easy distribution**: `git clone` or `npm install -g`
- ✅ **Version control**: Semantic versioning for releases
- ✅ **Community potential**: Others could contribute and use
- ✅ **Focused development**: Dedicated repo for the tooling
- ✅ **Clear documentation**: Standalone docs for the toolkit

**Cons**:
- ❌ **Extra maintenance**: Another repo to manage
- ❌ **Dependency management**: Projects need to install/update separately
- ❌ **Sync complexity**: Keeping projects in sync with toolkit updates
- ❌ **Overhead**: May be overkill for 2-3 projects

**Best For**:
- Planning to use across 5+ projects
- Want to open-source the toolkit
- Expect frequent updates and improvements
- Want community contributions

---

### **Option B: Git Submodule** 📦

**Structure**:
```
shared-dev-tools/  (separate repo)
├── sourcery/
│   ├── github-utils.sh
│   └── sourcery-review-parser.sh
└── README.md

pokehub/
├── scripts/
│   └── shared/ -> (git submodule: shared-dev-tools)
└── ...
```

**Pros**:
- ✅ **Shared codebase**: One place to maintain
- ✅ **Git-native**: Uses built-in Git functionality
- ✅ **Version pinning**: Each project can pin to specific version
- ✅ **Easy updates**: `git submodule update`

**Cons**:
- ❌ **Submodule complexity**: Developers often struggle with submodules
- ❌ **Clone friction**: Requires `--recurse-submodules` flag
- ❌ **Update friction**: Extra steps to update submodules
- ❌ **Learning curve**: Team needs to understand submodules

**Best For**:
- Team comfortable with Git submodules
- Want version control without extra repos
- Projects are closely related

---

### **Option C: NPM Package** 📦

**Structure**:
```
@grimm00/sourcery-automation
├── bin/
│   ├── sourcery-parse
│   └── sourcery-analyze
├── lib/
│   └── utils.js
└── package.json
```

**Pros**:
- ✅ **Standard distribution**: `npm install -g @grimm00/sourcery-automation`
- ✅ **Version management**: npm handles versions automatically
- ✅ **Easy updates**: `npm update`
- ✅ **CLI tools**: Can create global commands
- ✅ **Dependency resolution**: npm handles it

**Cons**:
- ❌ **Node.js dependency**: Requires Node even for bash scripts
- ❌ **Packaging overhead**: Need to learn npm packaging
- ❌ **Not native**: Bash scripts wrapped in Node ecosystem
- ❌ **Extra complexity**: May be overkill

**Best For**:
- Projects already using Node.js
- Want standard package management
- Planning to add Node-based features

---

### **Option D: Keep Copying (Current Approach)** 📋

**Structure**:
```
REPO-Magic/scripts/...  (source)
Pokehub/scripts/...     (copy)
Project3/scripts/...    (copy)
```

**Pros**:
- ✅ **Simple**: Just copy files
- ✅ **No dependencies**: Each project is self-contained
- ✅ **Customizable**: Easy to adapt per-project
- ✅ **No sync issues**: Projects are independent
- ✅ **Zero overhead**: No extra repos or tooling

**Cons**:
- ❌ **Duplication**: Same code in multiple places
- ❌ **Update friction**: Need to update each project manually
- ❌ **Divergence risk**: Projects can drift apart
- ❌ **Bug fixes**: Need to apply to each project

**Best For**:
- Only 2-3 projects
- Tools are relatively stable
- Projects have different needs
- Want simplicity over DRY

---

## 💡 Recommendation

### **For Your Current Situation (2 projects: REPO-Magic + Pokehub)**

**Recommended**: **Option D - Keep Copying** (with improvements)

**Why**:
1. **Simplicity**: You only have 2 projects currently
2. **Stability**: Tools are working well and don't change often
3. **Low overhead**: No extra repos or tooling to manage
4. **Flexibility**: Easy to customize per-project if needed

**Improvements to Current Approach**:
1. **Document the source**: Mark REPO-Magic as the "canonical" version
2. **Version in comments**: Add version numbers to scripts
3. **Changelog**: Track changes in both repos
4. **Sync script**: Create a simple script to sync updates

**Example Version Header**:
```bash
#!/bin/bash
# Sourcery Review Parser for Pokehub
# Version: 1.0.0
# Source: REPO-Magic (canonical version)
# Last Synced: 2025-10-05
```

---

### **When to Switch to Option A (Standalone Repo)**

Consider creating a standalone repo when:
- ✅ You have **3+ projects** using these tools
- ✅ Tools are **actively developed** (frequent updates)
- ✅ You want to **open-source** the toolkit
- ✅ You want **community contributions**
- ✅ Tools become **complex** (10+ scripts)

---

## 🚀 Hybrid Approach (Best of Both Worlds)

**Phase 1 (Now)**: Keep copying, but improve the process
- Add version headers to scripts
- Document REPO-Magic as canonical source
- Create sync checklist

**Phase 2 (If needed)**: Create standalone repo when you hit 3+ projects
- Extract to `sourcery-automation-toolkit`
- Keep existing copies working
- Gradually migrate projects

---

## 📝 Action Items (If Staying with Current Approach)

### Immediate
1. Add version headers to both repos' scripts
2. Document REPO-Magic as the canonical source
3. Create a sync checklist in both repos

### When Adding New Project
1. Copy scripts from REPO-Magic (canonical)
2. Update project references
3. Add to sync checklist

### When Updating Scripts
1. Update in REPO-Magic first
2. Test thoroughly
3. Sync to Pokehub
4. Document changes in both repos

---

## 🎯 Decision Framework

Ask yourself:
1. **How many projects?** 
   - 2-3 → Keep copying
   - 4+ → Consider standalone repo

2. **How often do tools change?**
   - Rarely → Keep copying
   - Weekly → Standalone repo

3. **Want to open-source?**
   - No → Keep copying
   - Yes → Standalone repo

4. **Team size?**
   - Solo/small → Keep copying
   - Large team → Standalone repo

---

## 📊 Current Recommendation Summary

**For Now**: ✅ **Keep copying** (Option D with improvements)

**Reasons**:
- Only 2 projects
- Tools are stable
- Simple and practical
- No overhead

**Future**: Consider standalone repo when you reach 3-4 projects or want to open-source.

---

**Last Updated**: October 5, 2025  
**Status**: Discussion document  
**Next Steps**: Decide on approach and implement version headers
