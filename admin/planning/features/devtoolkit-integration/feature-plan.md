# Dev-Toolkit Integration Feature Plan

**Status:** 🚧 In Progress  
**Created:** 2025-10-06  
**Feature Branch:** `feature/devtoolkit-integration`

---

## 📋 Overview

Integrate the new `dev-toolkit` repository into Pokehub's workflow, compare existing utility scripts, remove duplicates, and establish a clean separation between project-agnostic tools (dev-toolkit) and project-specific scripts (Pokehub).

### Goals

1. **Compare Utilities** - Analyze Pokehub vs dev-toolkit scripts
2. **Remove Duplicates** - Delete redundant scripts from Pokehub
3. **Fix Upstream Issues** - Address Sourcery feedback in dev-toolkit
4. **Document Integration** - Update Pokehub docs for dev-toolkit usage
5. **Establish Patterns** - Define clear boundaries for future scripts

---

## 🎯 Success Criteria

- [ ] All utility scripts compared and documented
- [ ] Duplicate scripts removed from Pokehub
- [ ] Dev-toolkit improvements implemented and tested
- [ ] Pokehub README updated with dev-toolkit instructions
- [ ] Clear guidelines for "Pokehub-specific" vs "dev-toolkit" scripts
- [ ] All Sourcery feedback addressed (PR #31, #32)

---

## 📊 Current State Analysis

### Pokehub Scripts (Copied from REPO-Magic)

**Location:** `/Users/cdwilson/Projects/pokedex/scripts/`

**Scripts to Compare/Remove:**
```
scripts/
├── core/
│   ├── github-utils.sh          # 454 lines - GitHub CLI integration
│   ├── git-flow-utils.sh        # 648 lines - Git branching/merging workflows
│   └── git-flow-safety.sh       # 277 lines - Safety checks
└── monitoring/
    └── sourcery-review-parser.sh # 337 lines - Sourcery automation
```

**Pokehub-Specific Scripts (Keep):**
```
scripts/
├── core/
│   ├── docker-startup.sh        # 50 lines - Pokehub Docker startup
│   ├── health-check.sh          # 111 lines - Pokehub health checks
│   └── invalidate-cache.sh      # 50 lines - Pokehub cache API
├── monitoring/
│   ├── automated-status-check.sh    # 220 lines - Pokehub status
│   ├── verify-project-status.sh     # 196 lines - Project verification
│   └── weekly-status-review.sh      # 204 lines - Weekly reviews
└── workflow-helper.sh           # 633 lines - Pokehub workflow orchestrator
```

**Total Lines:**
- **To Remove:** 1,716 lines (4 scripts)
- **To Keep:** 1,464 lines (7 scripts)
- **Reduction:** ~54% of script code

### Dev-Toolkit Scripts (Canonical Source)

**Location:** `/Users/cdwilson/Projects/dev-toolkit/`

**Commands:**
```
bin/
├── dt-config                    # Configuration management
├── dt-git-safety                # Pre-commit safety checks
├── dt-sourcery-parse            # Sourcery review extraction
├── dt-sourcery-analyze          # Sourcery review analysis (future)
└── dt-review                    # Combined Sourcery workflow ✅ TESTED
```

**Supporting Libraries:**
```
lib/
├── core/
│   └── github-utils.sh          # 530 lines - GitHub API operations
├── git-flow/
│   ├── utils.sh                 # 576 lines - Git flow utilities
│   ├── safety.sh                # 290 lines - Git safety checks
│   └── hooks/                   # Pre-commit hooks
└── sourcery/
    └── parser.sh                # 406 lines - Review parsing
```

**Total Lines:** 1,802 lines (4 library files)

### Key Findings

✅ **Dev-toolkit is working!** 
- `dt-review 10` successfully generated `admin/feedback/sourcery/pr10.md`
- `dt-review 31` and `dt-review 32` both worked perfectly
- Ready for production use in Pokehub

---

## 🔍 Comparison Matrix

| Feature | Pokehub Script | Dev-Toolkit Command | Status |
|---------|----------------|---------------------|--------|
| **GitHub Integration** | `scripts/core/github-utils.sh` | `lib/core/github.sh` | 🔄 Compare |
| **Git Flow** | `scripts/core/git-flow-utils.sh` | `lib/git/flow.sh` | 🔄 Compare |
| **Sourcery Parsing** | `scripts/monitoring/sourcery-review-parser.sh` | `dt-review` | 🔄 Compare |
| **Pre-commit Hooks** | ❌ None | `dt-git-safety` | ✅ Use dev-toolkit |
| **Configuration** | ❌ None | `dt-config` | ✅ Use dev-toolkit |

---

## 📝 Known Issues to Address

### From Sourcery PR #31 (5 comments)

| # | Issue | Priority | Location | Action |
|---|-------|----------|----------|--------|
| 1 | Regex escaping in branch validation | 🟠 HIGH | `git-flow-utils.sh` | Fix in dev-toolkit |
| 2 | Secret generation length truncation | 🟡 MEDIUM | `github-utils.sh` | Fix in dev-toolkit |
| 3 | REPO-Magic reference | 🟢 LOW | `github-utils.sh` | ✅ **FIXED** |
| 4 | Multiple reviews edge case | 🟢 LOW | `sourcery-review-parser.sh` | Document behavior |
| 5 | Multiple locations edge case | 🟢 LOW | `sourcery-review-parser.sh` | Document behavior |

### From Sourcery PR #32 (1 comment)

| # | Issue | Priority | Location | Action |
|---|-------|----------|----------|--------|
| 1 | Markdown block format support | 🟡 MEDIUM | `sourcery-review-parser.sh` | Fix in dev-toolkit |

---

## 🗺️ Implementation Phases

### Phase 1: Script Comparison & Analysis
**Goal:** Understand differences between Pokehub and dev-toolkit scripts

**Tasks:**
- [ ] Compare `github-utils.sh` vs `lib/core/github.sh`
- [ ] Compare `git-flow-utils.sh` vs `lib/git/flow.sh`
- [ ] Compare `sourcery-review-parser.sh` vs `dt-review`
- [ ] Document Pokehub-specific functionality (if any)
- [ ] Create comparison report in `script-comparison-report.md`

**Deliverable:** Detailed comparison document

---

### Phase 2: Dev-Toolkit Improvements
**Goal:** Fix all Sourcery feedback in dev-toolkit

**Tasks:**
- [ ] Fix regex escaping in branch validation (PR #31, Comment #1)
- [ ] Fix secret generation length (PR #31, Comment #2)
- [ ] Add markdown block format support (PR #32, Comment #1)
- [ ] Document multiple review/location behavior (PR #31, Comments #4-5)
- [ ] Test all fixes in dev-toolkit
- [ ] Create PR in dev-toolkit repo

**Deliverable:** Dev-toolkit PR with all fixes

---

### Phase 3: Pokehub Cleanup
**Goal:** Remove duplicate scripts, use dev-toolkit commands

**Tasks:**
- [ ] Delete `scripts/core/github-utils.sh` (use `dt-*` commands)
- [ ] Delete `scripts/core/git-flow-utils.sh` (use `dt-git-safety`)
- [ ] Delete `scripts/monitoring/sourcery-review-parser.sh` (use `dt-review`)
- [ ] Update `workflow-helper.sh` to use dev-toolkit commands
- [ ] Keep only Pokehub-specific scripts (if any)
- [ ] Test all workflows with dev-toolkit commands

**Deliverable:** Clean Pokehub scripts directory

---

### Phase 4: Documentation & Integration
**Goal:** Document dev-toolkit usage in Pokehub

**Tasks:**
- [ ] Update Pokehub README with dev-toolkit installation
- [ ] Add dev-toolkit commands to quick reference
- [ ] Document when to use dev-toolkit vs Pokehub scripts
- [ ] Update `.cursor/rules` to reference dev-toolkit
- [ ] Create migration guide for contributors
- [ ] Update CI/CD docs if needed

**Deliverable:** Complete integration documentation

---

## 🚨 Risk Assessment

### Low Risk (Safe to proceed immediately)
- ✅ **Removing `sourcery-review-parser.sh`**
  - Already replaced by `dt-review` command
  - Tested and working (PR #10, #31, #32)
  - No dependencies in other scripts

### Medium Risk (Needs careful comparison)
- ⚠️ **Replacing `github-utils.sh`**
  - Need to verify no Pokehub-specific functions
  - Check if dev-toolkit version has all features
  - Pokehub: 454 lines vs Dev-toolkit: 530 lines

- ⚠️ **Replacing `git-flow-utils.sh`**
  - Large file (648 lines) requires thorough review
  - Check for Pokehub-specific customizations
  - Pokehub: 648 lines vs Dev-toolkit: 576 lines

- ⚠️ **Replacing `git-flow-safety.sh`**
  - Used by pre-commit hooks
  - Pokehub: 277 lines vs Dev-toolkit: 290 lines

### High Risk (Needs extensive testing)
- 🔴 **Refactoring `workflow-helper.sh`**
  - Large orchestration script (633 lines)
  - Sources multiple utilities
  - Used by development workflows
  - Must test all commands after refactor

---

## 🎯 Decision Points

### What Stays in Pokehub?

**Keep in Pokehub if:**
- ✅ Pokehub-specific business logic
- ✅ Tightly coupled to Pokehub's structure
- ✅ Uses Pokehub-specific environment variables
- ✅ Calls Pokehub-specific APIs

**Examples:**
- `docker-startup.sh` - Pokehub Docker configuration
- `health-check.sh` - Pokehub health endpoints
- `invalidate-cache.sh` - Pokehub cache API
- `automated-status-check.sh` - Pokehub project status
- `verify-project-status.sh` - Pokehub verification
- `weekly-status-review.sh` - Pokehub reporting
- `workflow-helper.sh` - Pokehub workflow orchestrator (refactor to use dev-toolkit)

### What Removes from Pokehub?

**Remove from Pokehub if:**
- ✅ Project-agnostic functionality
- ✅ Already exists in dev-toolkit
- ✅ No Pokehub-specific dependencies
- ✅ General development utilities

**Examples:**
- `github-utils.sh` - Use `lib/core/github-utils.sh` from dev-toolkit
- `git-flow-utils.sh` - Use `lib/git-flow/utils.sh` from dev-toolkit
- `git-flow-safety.sh` - Use `lib/git-flow/safety.sh` from dev-toolkit
- `sourcery-review-parser.sh` - Use `dt-review` command from dev-toolkit

---

## 📦 Dependencies

### Required
- Dev-toolkit installed globally or locally
- GitHub CLI (`gh`) for GitHub operations
- Sourcery GitHub App (optional, for Sourcery features)

### Optional
- `jq` for JSON parsing (dev-toolkit handles gracefully if missing)

---

## 🧪 Testing Strategy

### Dev-Toolkit Testing
1. Test each fixed command in dev-toolkit
2. Verify regex escaping with special characters
3. Test secret generation length
4. Test both `~~~` and ` ``` ` markdown formats
5. Run full test suite in dev-toolkit

### Pokehub Integration Testing
1. Test Sourcery workflow: `dt-review <PR#>`
2. Test pre-commit hooks: `git commit`
3. Test configuration: `dt-config show`
4. Verify all workflows still work
5. Test on fresh clone (ensure dev-toolkit is documented)

---

## 📚 Related Documents

### Planning
- [Comprehensive Dev-Toolkit Plan](../notes/comprehensive-dev-toolkit-plan.md)
- [Pokehub Admin Restructuring Plan](../notes/pokehub-admin-restructuring-plan.md)
- [Dev-Toolkit Pokehub Overlap Analysis](../notes/dev-toolkit-pokehub-overlap-analysis.md)

### Feedback
- [Sourcery PR #31 Analysis](../../../feedback/sourcery/pr31.md)
- [Sourcery PR #32 Analysis](../../../feedback/sourcery/pr32.md)

### Dev-Toolkit
- [Dev-Toolkit README](https://github.com/grimm00/dev-toolkit/blob/main/README.md)
- [Dev-Toolkit Roadmap](https://github.com/grimm00/dev-toolkit/blob/main/admin/planning/roadmap.md)

---

## 🚀 Getting Started

### Step 1: Compare Scripts
```bash
# Read both versions side-by-side
cd /Users/cdwilson/Projects/pokedex
cat scripts/core/github-utils.sh

cd /Users/cdwilson/Projects/dev-toolkit
cat lib/core/github.sh
```

### Step 2: Document Differences
Create comparison notes in `admin/planning/notes/script-comparison.md`

### Step 3: Fix Dev-Toolkit Issues
Work in dev-toolkit repo to address Sourcery feedback

### Step 4: Clean Up Pokehub
Remove duplicate scripts, update references

---

## 📊 Progress Tracking

**Phase 1:** 🔴 Not Started  
**Phase 2:** 🔴 Not Started  
**Phase 3:** 🔴 Not Started  
**Phase 4:** 🔴 Not Started

**Overall Progress:** 0% (0/4 phases complete)

---

## 🎉 Success Metrics

- **Scripts Removed:** 0/3 target
- **Issues Fixed:** 0/6 total (0/5 from PR #31, 0/1 from PR #32)
- **Documentation Updated:** 0/5 documents
- **Tests Passing:** ⏳ Pending

---

**Next Step:** Start Phase 1 - Script Comparison & Analysis 🔍
