# Phase 1: Script Comparison & Analysis

**Status:** 🚧 In Progress  
**Started:** 2025-10-06  
**Feature:** Dev-Toolkit Integration

---

## 🎯 Phase Goal

Perform a detailed comparison of Pokehub's utility scripts against dev-toolkit's canonical implementations to understand:
1. What functionality is identical (can be deleted)
2. What functionality is Pokehub-specific (must be kept)
3. What improvements exist in dev-toolkit (should be adopted)

---

## 📋 Tasks

- [ ] Compare `github-utils.sh` vs `lib/core/github.sh`
- [ ] Compare `git-flow-utils.sh` vs `lib/git/flow.sh`
- [ ] Compare `sourcery-review-parser.sh` vs `dt-review` workflow
- [ ] Document Pokehub-specific functionality
- [ ] Create detailed comparison report
- [ ] Identify scripts to delete vs keep

---

## 🔍 Comparison Approach

### For Each Script Pair

1. **Read both versions**
   - Pokehub version (copied from REPO-Magic)
   - Dev-toolkit version (canonical source)

2. **Identify differences**
   - Hardcoded paths vs dynamic paths
   - Project-specific logic
   - Bug fixes or improvements
   - Feature additions/removals

3. **Categorize functionality**
   - ✅ **Identical** - Can delete from Pokehub
   - 🔄 **Improved in dev-toolkit** - Delete Pokehub version, use dev-toolkit
   - 🎯 **Pokehub-specific** - Keep in Pokehub
   - ⚠️ **Needs investigation** - Unclear or complex

4. **Document decision**
   - Rationale for keep/delete
   - Migration notes if needed
   - Testing requirements

---

## 📊 Comparison Matrix

### 1. GitHub Utilities

| Aspect | Pokehub | Dev-Toolkit | Decision |
|--------|---------|-------------|----------|
| **File** | `scripts/core/github-utils.sh` | `lib/core/github.sh` | |
| **Functions** | | | |
| **Dependencies** | | | |
| **Configuration** | | | |
| **Pokehub-specific?** | | | |
| **Recommendation** | | | |

**Key Questions:**
- Does Pokehub version have any project-specific logic?
- Are there improvements in dev-toolkit version?
- Does anything reference Pokehub-specific paths/configs?

---

### 2. Git Flow Utilities

| Aspect | Pokehub | Dev-Toolkit | Decision |
|--------|---------|-------------|----------|
| **File** | `scripts/core/git-flow-utils.sh` | `lib/git/flow.sh` + `lib/git/safety.sh` | |
| **Functions** | | | |
| **Dependencies** | | | |
| **Configuration** | | | |
| **Pokehub-specific?** | | | |
| **Recommendation** | | | |

**Key Questions:**
- Does Pokehub version have custom branch naming?
- Are there Pokehub-specific safety checks?
- Does dev-toolkit version have the regex fix (PR #31)?

---

### 3. Sourcery Automation

| Aspect | Pokehub | Dev-Toolkit | Decision |
|--------|---------|-------------|----------|
| **File** | `scripts/monitoring/sourcery-review-parser.sh` | `dt-review` (uses `lib/sourcery/*`) | |
| **Functions** | | | |
| **Dependencies** | | | |
| **Configuration** | | | |
| **Pokehub-specific?** | | | |
| **Recommendation** | | | |

**Key Questions:**
- Does Pokehub version have custom output paths?
- Does dev-toolkit version have markdown format fix (PR #32)?
- Are there Pokehub-specific review categories?

---

## 🎯 Pokehub-Specific Indicators

Look for these patterns that indicate Pokehub-specific code:

### Hard-Coded Paths
```bash
# Pokehub-specific
ADMIN_DIR="/Users/cdwilson/Projects/pokedex/admin"
FEEDBACK_DIR="$ADMIN_DIR/feedback/sourcery"

# Dev-toolkit (dynamic)
ADMIN_DIR="$PROJECT_ROOT/admin"
FEEDBACK_DIR="$ADMIN_DIR/feedback/sourcery"
```

### Project-Specific Logic
```bash
# Pokehub-specific
if [[ "$branch" == "develop" ]] || [[ "$branch" == "main" ]]; then
    # Pokehub uses develop as default
fi

# Dev-toolkit (configurable)
DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
```

### Environment Variables
```bash
# Pokehub-specific
POKEHUB_API_URL="http://localhost"
POKEHUB_ENV="development"

# Dev-toolkit (generic)
PROJECT_ROOT=$(git rev-parse --show-toplevel)
```

---

## 📝 Comparison Report Template

For each script, document:

```markdown
## Script: [Name]

### Overview
- **Pokehub Path:** `scripts/...`
- **Dev-Toolkit Path:** `lib/...` or `bin/dt-*`
- **Lines of Code:** Pokehub: XXX, Dev-Toolkit: XXX

### Functionality Comparison

#### Identical Features
- Feature 1
- Feature 2

#### Pokehub-Specific Features
- Feature A (reason: ...)
- Feature B (reason: ...)

#### Dev-Toolkit Improvements
- Improvement 1 (benefit: ...)
- Improvement 2 (benefit: ...)

### Decision

**Recommendation:** [DELETE | KEEP | MODIFY]

**Rationale:**
- Reason 1
- Reason 2

**Migration Notes:**
- Step 1
- Step 2

**Testing Required:**
- Test 1
- Test 2
```

---

## 🔧 Tools for Comparison

### Side-by-Side Diff
```bash
# Compare two files visually
diff -y scripts/core/github-utils.sh /Users/cdwilson/Projects/dev-toolkit/lib/core/github.sh | less
```

### Function List Extraction
```bash
# Extract all function names
grep -E "^[a-z_]+\(\)" scripts/core/github-utils.sh
```

### Line Count
```bash
# Compare script sizes
wc -l scripts/core/*.sh
wc -l /Users/cdwilson/Projects/dev-toolkit/lib/**/*.sh
```

---

## 📊 Expected Outcomes

### Likely Scenario
Based on the fact that Pokehub scripts were copied from REPO-Magic (dev-toolkit's predecessor):

1. **Most functionality is identical**
   - Delete from Pokehub
   - Use dev-toolkit commands

2. **Few Pokehub-specific customizations**
   - Keep only truly project-specific code
   - Extract to separate Pokehub-only scripts

3. **Dev-toolkit has improvements**
   - Sourcery fixes (PR #31, #32)
   - Better error handling
   - More modular design

### Deliverable
A comprehensive comparison document in `admin/planning/notes/script-comparison-report.md` with:
- Detailed analysis of each script
- Clear keep/delete recommendations
- Migration steps for Phase 3
- Testing requirements

---

## ✅ Success Criteria

- [ ] All three script pairs compared in detail
- [ ] Comparison report created and reviewed
- [ ] Clear decisions documented for each script
- [ ] Pokehub-specific functionality identified (if any)
- [ ] Migration plan ready for Phase 3
- [ ] Testing strategy defined

---

## 🚀 Next Steps

After completing Phase 1:
1. Review comparison report
2. Confirm decisions with user
3. Move to Phase 2: Fix dev-toolkit issues
4. Prepare for Phase 3: Pokehub cleanup

---

**Status:** 🔴 Not Started  
**Next Action:** Read and compare first script pair (github-utils.sh) 🔍
