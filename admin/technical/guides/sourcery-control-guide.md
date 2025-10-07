# Sourcery Control Guide

**How to control when Sourcery reviews your PRs**

---

## 🎯 Automatic Control (via .sourcery.yaml)

The `.sourcery.yaml` file in the project root controls what Sourcery reviews automatically.

**Current Configuration:**
- ✅ **Reviews:** Python, TypeScript/JavaScript, Shell scripts, GitHub Actions
- ❌ **Skips:** Documentation, planning docs, chat logs, feedback, markdown files

**Files Reviewed:**
- `backend/**/*.py`
- `frontend/src/**/*.{ts,tsx,js,jsx}`
- `scripts/**/*.sh`
- `tests/**/*.{py,bats}`
- `.github/workflows/*.yml`

**Files Skipped:**
- `admin/**` (all planning, docs, logs)
- `docs/**` (all documentation)
- `**/*.md` (all markdown files)
- `**/chat-logs/**`
- `**/planning/**`
- `**/feedback/**`

---

## 🛑 Manual Control (Per-PR)

### Method 1: Use PR Labels

**Add label to PR:**
- `skip-sourcery` - Sourcery will skip the entire PR
- `documentation` - Sourcery will skip (if configured)

**How to add:**
```bash
# Using GitHub CLI
gh pr edit <PR_NUMBER> --add-label "skip-sourcery"

# Or on GitHub web UI
# Go to PR → Labels → Add "skip-sourcery"
```

### Method 2: Use PR Description Comment

**Add to PR description:**
```markdown
<!-- @sourcery-ai ignore -->
```

**Example:**
```markdown
## Description

This PR adds documentation for the Bats testing suite.

<!-- @sourcery-ai ignore -->

## Changes
- Added planning documents
- Added chat logs
```

### Method 3: Disable for Specific Commits

**In commit message:**
```bash
git commit -m "docs: Add planning documents

[skip sourcery]"
```

### Method 4: Disable Sourcery Temporarily

**Comment on PR:**
```
@sourcery-ai pause
```

**Resume later:**
```
@sourcery-ai resume
```

---

## 📊 When to Skip Sourcery Reviews

### ✅ Skip Sourcery For:
- Documentation-only PRs
- Planning documents
- Chat logs
- Markdown file updates
- README updates
- License changes
- Configuration file updates (non-code)
- Dependency updates (package.json, requirements.txt)

### ❌ Use Sourcery For:
- Python code changes
- TypeScript/JavaScript code changes
- Shell script changes
- Test file changes
- GitHub Actions workflow changes
- Any actual implementation code

---

## 🎯 Recommended Workflow

### Documentation PRs
```bash
# Create PR
gh pr create --title "docs: Add feature planning" --body "<!-- @sourcery-ai ignore -->"

# Or add label after creation
gh pr edit <PR_NUMBER> --add-label "skip-sourcery"
```

### Implementation PRs
```bash
# Create PR normally - Sourcery will review automatically
gh pr create --title "feat: Add new feature"
```

### Mixed PRs (Code + Docs)
```bash
# Let Sourcery review, but it will only review code files
# Documentation files will be automatically skipped per .sourcery.yaml
gh pr create --title "feat: Add feature with docs"
```

---

## 🔧 Modifying .sourcery.yaml

**To add more file types to review:**
```yaml
path_patterns:
  - "backend/**/*.py"
  - "frontend/src/**/*.{ts,tsx,js,jsx}"
  - "scripts/**/*.sh"
  - "your-new-pattern/**/*.ext"  # Add here
```

**To skip more patterns:**
```yaml
ignore_patterns:
  - "admin/**"
  - "docs/**"
  - "your-new-pattern/**"  # Add here
```

**After modifying:**
```bash
git add .sourcery.yaml
git commit -m "chore: Update Sourcery configuration"
git push
```

Changes take effect on next PR.

---

## 📈 Monitoring Sourcery Usage

**Check your Sourcery dashboard:**
- https://app.sourcery.ai/dashboard
- View: Characters reviewed this week
- View: PRs reviewed
- View: Rate limit status

**Typical usage with new config:**
- Documentation PR (skipped): 0 characters
- Small implementation PR (500 lines): ~25,000 characters
- Large implementation PR (1,500 lines): ~75,000 characters

**Team plan limit:** Usually 10-15M characters/week

---

## 🎯 Quick Reference

| Scenario | Action | Sourcery Behavior |
|----------|--------|-------------------|
| Doc-only PR | Add `<!-- @sourcery-ai ignore -->` | Skips entire PR |
| Planning docs | None needed | Auto-skipped via .sourcery.yaml |
| Code PR | None needed | Auto-reviews code files only |
| Mixed PR | None needed | Reviews code, skips docs |
| Emergency skip | Comment `@sourcery-ai pause` | Pauses review |

---

## 💡 Pro Tips

1. **Use .sourcery.yaml for permanent rules** (like skipping admin/)
2. **Use PR labels for one-off skips** (like `skip-sourcery`)
3. **Use PR comments for temporary pauses** (like `@sourcery-ai pause`)
4. **Check Sourcery dashboard weekly** to monitor usage
5. **Adjust .sourcery.yaml as needed** based on usage patterns

---

**Last Updated:** 2025-10-07  
**Sourcery Plan:** Team  
**Configuration File:** `.sourcery.yaml` in project root
