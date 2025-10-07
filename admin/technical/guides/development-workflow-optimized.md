# Optimized Development Workflow

**Granular process to minimize Sourcery usage and improve efficiency**

---

## 🎯 Core Principle

**Separate planning from implementation - commit planning directly to develop!**

Planning documents don't need code review, so don't waste Sourcery credits on them.

---

## 📋 Three-Phase Workflow

### Phase 1: Planning (Direct to Develop)
**No PR needed - commit directly!**

```bash
# Start from develop
git checkout develop
git pull

# Create planning documents
mkdir -p admin/planning/features/my-feature
# Add: feature-plan.md, phase-1.md, etc.

# Commit directly to develop
git add admin/planning/features/my-feature/
git commit -m "docs: Add planning for my-feature"
git push origin develop
```

**Why:**
- ✅ No PR = No Sourcery usage
- ✅ Planning is documentation, not code
- ✅ Team can see plans immediately
- ✅ No waiting for PR approval on docs

**What to commit directly:**
- Feature planning documents
- Phase plans
- Assessment documents
- Reference materials (like TESTING.md)
- Quick start guides
- Roadmaps

---

### Phase 2: Implementation (Small PRs)
**Create focused PRs for actual code**

```bash
# Start from develop (with planning already there!)
git checkout develop
git pull

# Create feature branch
git checkout -b feature/my-feature

# Implement ONLY the code
# - No planning docs (already in develop)
# - No chat logs (add later)
# - No extensive docs (add later)
# - Just code + essential README

# Commit and create PR
git add backend/ frontend/ tests/
git commit -m "feat: Implement my-feature"
git push origin feature/my-feature

# Create PR
gh pr create --title "feat: Implement my-feature" \
  --body "Implements my-feature as planned in admin/planning/features/my-feature/

Implementation:
- Added core functionality
- Added tests
- Updated essential docs

Refs: admin/planning/features/my-feature/feature-plan.md"
```

**Why:**
- ✅ Small PRs (500-1,000 lines)
- ✅ Sourcery reviews only code
- ✅ Faster review process
- ✅ Clear separation of concerns

**What to include in PRs:**
- Actual code implementation
- Test files
- Essential README updates
- Configuration changes

---

### Phase 3: Documentation (Direct to Develop)
**After PR merges, add comprehensive docs**

```bash
# After feature PR is merged
git checkout develop
git pull

# Add comprehensive documentation
# - Detailed guides
# - Architecture docs
# - Usage examples

git add docs/ admin/technical/guides/
git commit -m "docs: Add comprehensive documentation for my-feature"
git push origin develop
```

**Why:**
- ✅ No PR = No Sourcery usage
- ✅ Documentation doesn't need code review
- ✅ Can be more detailed without worrying about PR size
- ✅ Keeps implementation PRs focused

**What to commit directly:**
- Comprehensive guides
- Architecture documentation
- Usage examples
- API documentation

---

### Phase 4: Chat Logs (Direct to Develop)
**After everything is done, add chat log**

```bash
git checkout develop
git pull

# Add chat log
git add admin/chat-logs/2025/
git commit -m "docs: Add chat log for my-feature development"
git push origin develop
```

**Why:**
- ✅ No PR = No Sourcery usage
- ✅ Historical record preserved
- ✅ Doesn't inflate feature PRs
- ✅ Added when work is complete

---

## 📊 Comparison: Old vs New Workflow

### Old Workflow (What We Were Doing)
```
┌─────────────────────────────────────┐
│ Feature Branch                      │
│ ├── Planning docs (800 lines)      │
│ ├── Implementation (1,500 lines)   │
│ ├── Documentation (1,000 lines)    │
│ ├── Chat logs (500 lines)          │
│ └── Reference materials (800 lines)│
│                                     │
│ Total: 4,600 lines in ONE PR        │
│ Sourcery: ~230,000 characters       │
└─────────────────────────────────────┘
```

### New Workflow (Optimized)
```
┌─────────────────────────────────────┐
│ Phase 1: Planning (Direct Commit)  │
│ ├── Planning docs (800 lines)      │
│ Sourcery: 0 characters              │
└─────────────────────────────────────┘
         ↓
┌─────────────────────────────────────┐
│ Phase 2: Implementation (PR)        │
│ ├── Code (1,000 lines)              │
│ ├── Tests (500 lines)               │
│ Sourcery: ~75,000 characters        │
└─────────────────────────────────────┘
         ↓
┌─────────────────────────────────────┐
│ Phase 3: Documentation (Direct)     │
│ ├── Comprehensive docs (1,000 lines)│
│ Sourcery: 0 characters              │
└─────────────────────────────────────┘
         ↓
┌─────────────────────────────────────┐
│ Phase 4: Chat Logs (Direct)         │
│ ├── Chat log (500 lines)            │
│ Sourcery: 0 characters              │
└─────────────────────────────────────┘

Total Sourcery: 75,000 characters (67% reduction!)
```

---

## 🎯 Real Example: Bats Testing (What We Should Have Done)

### What We Did (6,071 lines in one PR)
```bash
feature/bats-testing
├── Planning docs (2,500 lines)
├── Implementation (1,500 lines)
├── Documentation (1,500 lines)
└── Chat logs (500 lines)

Result: 6,071 lines, ~303,000 Sourcery characters
```

### What We Should Do Next Time
```bash
# Day 1: Planning (Direct to develop)
git checkout develop
git add admin/planning/features/bats-testing/
git commit -m "docs: Add Bats testing planning"
git push
# Sourcery: 0 characters

# Day 2-4: Implementation (PR)
git checkout -b feature/bats-testing
git add tests/shell/ .github/workflows/ci.yml
git commit -m "feat: Add Bats testing suite"
gh pr create
# Sourcery: ~75,000 characters

# Day 5: Documentation (Direct to develop)
git checkout develop
git add tests/shell/README.md admin/technical/guides/
git commit -m "docs: Add Bats testing documentation"
git push
# Sourcery: 0 characters

# Day 6: Chat log (Direct to develop)
git checkout develop
git add admin/chat-logs/
git commit -m "docs: Add Bats testing chat log"
git push
# Sourcery: 0 characters

Total Sourcery: ~75,000 characters (75% reduction!)
```

---

## 🚀 Quick Reference

### When to Commit Directly to Develop

✅ **Always Direct Commit:**
- Planning documents (`admin/planning/`)
- Feature plans
- Phase plans
- Assessment documents
- Reference materials
- Chat logs (`admin/chat-logs/`)
- Comprehensive documentation (`docs/`, `admin/technical/guides/`)
- Roadmaps
- Architecture diagrams
- Meeting notes

### When to Create PRs

✅ **Always Create PR:**
- Python code (`backend/`)
- TypeScript/JavaScript code (`frontend/`)
- Shell scripts (`scripts/`)
- Test files (`tests/`)
- GitHub Actions workflows (`.github/workflows/`)
- Configuration files that affect code behavior
- Database migrations
- Essential README updates (brief)

### When to Use PR Comments

✅ **Use `<!-- @sourcery-ai ignore -->`:**
- Mixed PRs (mostly docs with small code changes)
- Configuration-only PRs
- Dependency update PRs

---

## 📋 Workflow Checklist

### Starting a New Feature

- [ ] **Step 1:** Create planning docs
  ```bash
  git checkout develop
  mkdir -p admin/planning/features/my-feature
  # Create feature-plan.md, phase-1.md, etc.
  git add admin/planning/features/my-feature/
  git commit -m "docs: Add planning for my-feature"
  git push
  ```

- [ ] **Step 2:** Implement feature
  ```bash
  git checkout -b feature/my-feature
  # Write code, tests
  git add backend/ frontend/ tests/
  git commit -m "feat: Implement my-feature"
  gh pr create
  ```

- [ ] **Step 3:** Add comprehensive docs (after PR merge)
  ```bash
  git checkout develop
  git pull
  # Add detailed documentation
  git add docs/ admin/technical/guides/
  git commit -m "docs: Add documentation for my-feature"
  git push
  ```

- [ ] **Step 4:** Add chat log
  ```bash
  git checkout develop
  # Add chat log
  git add admin/chat-logs/
  git commit -m "docs: Add chat log for my-feature"
  git push
  ```

---

## 💡 Pro Tips

### 1. Planning First, Always
Start every feature with planning docs committed directly to develop. This:
- ✅ Clarifies requirements before coding
- ✅ Provides context for reviewers
- ✅ Doesn't use Sourcery credits
- ✅ Creates historical record

### 2. Keep PRs Focused
Implementation PRs should be:
- ✅ 500-1,000 lines max
- ✅ Single responsibility
- ✅ Code + tests only
- ✅ Brief README updates

### 3. Document After Merging
Comprehensive documentation can be:
- ✅ Added after PR merges
- ✅ More detailed without PR size concerns
- ✅ Updated iteratively
- ✅ Committed directly to develop

### 4. Chat Logs Are History
Chat logs should be:
- ✅ Added after feature is complete
- ✅ Committed directly to develop
- ✅ Not included in feature PRs
- ✅ Preserved for future reference

### 5. Use .sourcery.yaml
The `.sourcery.yaml` file ensures:
- ✅ Only code is reviewed
- ✅ Documentation is auto-skipped
- ✅ Consistent behavior
- ✅ No manual intervention needed

---

## 📊 Expected Sourcery Usage

### Old Workflow (Before Optimization)
- Average PR: 4,000-6,000 lines
- Sourcery per PR: ~200,000-300,000 characters
- PRs per week: 3-4
- **Weekly usage: ~800,000-1,200,000 characters**
- **Result: Hitting rate limits!** ❌

### New Workflow (After Optimization)
- Planning commits: 0 Sourcery characters
- Implementation PR: 1,000-1,500 lines
- Sourcery per PR: ~50,000-75,000 characters
- PRs per week: 3-4
- Documentation commits: 0 Sourcery characters
- Chat log commits: 0 Sourcery characters
- **Weekly usage: ~150,000-300,000 characters**
- **Result: Well within limits!** ✅

**Reduction: 75-80% less Sourcery usage!**

---

## 🎯 Summary

**Key Changes:**
1. ✅ Planning docs → Direct commits to develop
2. ✅ Implementation → Small, focused PRs
3. ✅ Documentation → Direct commits to develop
4. ✅ Chat logs → Direct commits to develop
5. ✅ Only code gets reviewed by Sourcery

**Benefits:**
- ✅ 75-80% reduction in Sourcery usage
- ✅ Faster development cycle
- ✅ Better separation of concerns
- ✅ Clearer git history
- ✅ More focused code reviews

**Result:**
- ✅ Stay within Team plan limits easily
- ✅ Better workflow overall
- ✅ No more rate limit issues

---

**Last Updated:** 2025-10-07  
**Status:** Recommended workflow for all future development  
**Related:** `.sourcery.yaml`, `sourcery-control-guide.md`
