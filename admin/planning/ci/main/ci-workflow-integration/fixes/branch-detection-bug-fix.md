# Branch Detection Bug Fix

**Priority:** 🟠 HIGH | **Impact:** 🟠 HIGH | **Effort:** 🟢 LOW  
**Status:** 🟡 In Progress  
**Created:** 2025-01-20  

---

## 🐛 Problem Description

**Sourcery Comment #1:** Branch detection logic may not work correctly for push events.

**Issue:** The current branch detection logic `${{ github.head_ref || github.ref_name }}` may not work correctly for push events.

**Root Cause:** For push events, only `github.ref_name` is populated, but we're using `github.head_ref || github.ref_name` which could cause issues.

**Impact:** This is critical for CI functionality as incorrect branch detection could cause wrong jobs to run or skip.

---

## 🔍 Current Code

```yaml
- name: Detect branch type and requirements
  id: detect
  run: |
    BRANCH_NAME="${{ github.head_ref || github.ref_name }}"
    
    # Default values
    echo "type=unknown" >> $GITHUB_OUTPUT
    echo "needs-lint=false" >> $GITHUB_OUTPUT
    echo "needs-test=false" >> $GITHUB_OUTPUT
    echo "needs-install=false" >> $GITHUB_OUTPUT
    echo "needs-docs=false" >> $GITHUB_OUTPUT
    echo "needs-external-reviews=false" >> $GITHUB_OUTPUT
    
    # Feature branches
    if [[ "$BRANCH_NAME" =~ ^feat/ ]]; then
      echo "type=feature" >> $GITHUB_OUTPUT
      echo "needs-lint=true" >> $GITHUB_OUTPUT
      echo "needs-test=true" >> $GITHUB_OUTPUT
      echo "needs-install=true" >> $GITHUB_OUTPUT
      echo "needs-docs=true" >> $GITHUB_OUTPUT
      echo "needs-external-reviews=false" >> $GITHUB_OUTPUT
    # ... rest of the logic
```

---

## ✅ Solution

**Fix:** Differentiate between push and pull_request events to use the correct branch name variable.

### Updated Code

```yaml
- name: Detect branch type and requirements
  id: detect
  run: |
    # Differentiate between push and pull_request events
    if [ "${{ github.event_name }}" = "pull_request" ]; then
      BRANCH_NAME="${{ github.head_ref }}"
    else
      BRANCH_NAME="${{ github.ref_name }}"
    fi
    
    echo "Event: ${{ github.event_name }}"
    echo "Branch: $BRANCH_NAME"
    
    # Default values
    echo "type=unknown" >> $GITHUB_OUTPUT
    echo "needs-lint=false" >> $GITHUB_OUTPUT
    echo "needs-test=false" >> $GITHUB_OUTPUT
    echo "needs-install=false" >> $GITHUB_OUTPUT
    echo "needs-docs=false" >> $GITHUB_OUTPUT
    echo "needs-external-reviews=false" >> $GITHUB_OUTPUT
    
    # Feature branches
    if [[ "$BRANCH_NAME" =~ ^feat/ ]]; then
      echo "type=feature" >> $GITHUB_OUTPUT
      echo "needs-lint=true" >> $GITHUB_OUTPUT
      echo "needs-test=true" >> $GITHUB_OUTPUT
      echo "needs-install=true" >> $GITHUB_OUTPUT
      echo "needs-docs=true" >> $GITHUB_OUTPUT
      echo "needs-external-reviews=false" >> $GITHUB_OUTPUT
    # ... rest of the logic remains the same
```

---

## 🧪 Testing Plan

### Test Cases

1. **Push Event to feat/ branch**
   - Expected: `BRANCH_NAME` should be `feat/feature-name`
   - Expected: `type=feature`, `needs-test=true`

2. **Push Event to docs/ branch**
   - Expected: `BRANCH_NAME` should be `docs/doc-name`
   - Expected: `type=documentation`, `needs-test=false`

3. **Pull Request Event**
   - Expected: `BRANCH_NAME` should be the head ref of the PR
   - Expected: Correct branch type detection

4. **Push Event to main/develop**
   - Expected: `BRANCH_NAME` should be `main` or `develop`
   - Expected: `type=main`, `needs-external-reviews=true`

### Test Commands

```bash
# Test the fix locally (if possible)
echo "Testing branch detection logic..."

# Simulate push event
export GITHUB_EVENT_NAME="push"
export GITHUB_REF_NAME="feat/test-feature"
export GITHUB_HEAD_REF=""

# Simulate pull_request event  
export GITHUB_EVENT_NAME="pull_request"
export GITHUB_REF_NAME="main"
export GITHUB_HEAD_REF="feat/test-feature"
```

---

## 📋 Implementation Steps

1. **Create fix branch**
   ```bash
   git checkout -b fix/branch-detection-bug
   ```

2. **Update CI workflow**
   - Modify `.github/workflows/ci.yml`
   - Update branch detection logic
   - Add event type logging

3. **Test the fix**
   - Push the branch to trigger CI
   - Verify correct branch detection
   - Check job execution

4. **Create PR and merge**
   - Create PR to develop
   - Review and merge
   - Verify fix works in production

---

## 🎯 Success Criteria

- [ ] Branch detection works correctly for push events
- [ ] Branch detection works correctly for pull_request events
- [ ] CI jobs execute based on correct branch type
- [ ] No regression in existing functionality
- [ ] Event type and branch name are logged for debugging

---

## 📚 Related Documents

- [Sourcery Feedback Analysis](../../../feedback/sourcery/pr42.md) - Original issue
- [CI Workflow](../../../../.github/workflows/ci.yml) - File to modify
- [Fixes README](README.md) - Parent directory

---

## 🏷️ Tags

**Type:** Bug Fix  
**Priority:** High  
**Component:** CI Workflow  
**Status:** In Progress  

---

**Last Updated:** 2025-01-20  
**Next:** Implement the fix and test
