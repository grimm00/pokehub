# External Review Workflow Guide

**Date:** 2025-01-20  
**Purpose:** Guide for managing external review tools (Sourcery, Cursor Bugbot) to optimize quota usage and development workflow

---

## 🎯 Overview

This guide explains how external review tools are configured to only trigger on Pull Request creation, not during development, enabling efficient development workflow with validation on push and reviews on PR.

---

## 🔧 Configuration

### Sourcery Configuration

**File:** `.sourcery.yaml`

```yaml
# GitHub integration settings
github:
  # Only request reviews on PR creation, not on push
  request_review: pull_request
  
  # Events to trigger reviews
  events:
    - pull_request.opened
    - pull_request.synchronize
    - pull_request.reopened
  
  # Skip reviews on push events
  skip_on_push: true
```

### Cursor Bugbot Configuration

**File:** `.cursor-bugbot.yaml`

```yaml
# GitHub integration settings
github:
  # Only run on PR events, not on push
  events:
    - pull_request.opened
    - pull_request.synchronize
    - pull_request.reopened
  
  # Skip on push events to branches
  skip_on_push: true
  
  # Only review on PR creation
  trigger_on_pr_only: true
```

### GitHub Actions Control

**File:** `.github/workflows/external-reviews.yml`

- Only triggers on PR events (`pull_request.opened`, `pull_request.synchronize`, `pull_request.reopened`)
- Explicitly excludes push events
- Configures external tools for PR-based reviews

---

## 🚀 Workflow

### Development Phase (No External Reviews)

1. **Create Feature Branch**
   ```bash
   git checkout -b feat/new-feature
   ```

2. **Make Changes and Push**
   ```bash
   git add .
   git commit -m "Add new feature"
   git push origin feat/new-feature
   ```
   - ✅ CI validation runs (fast feedback)
   - ❌ No external reviews (quota preserved)

3. **Iterate and Push**
   ```bash
   git commit -m "Fix implementation"
   git push origin feat/new-feature
   ```
   - ✅ CI validation runs
   - ❌ No external reviews (quota preserved)

### Review Phase (External Reviews Triggered)

4. **Create Pull Request**
   ```bash
   gh pr create --title "Add new feature" --body "Description"
   ```
   - ✅ External reviews triggered (Sourcery, Cursor Bugbot)
   - ✅ Quality assurance before merge
   - ✅ Quota used efficiently (only on complete features)

5. **Address Review Feedback**
   ```bash
   git commit -m "Address review feedback"
   git push origin feat/new-feature
   ```
   - ✅ External reviews re-triggered (updated PR)
   - ✅ Focus on changed files only

---

## 📊 Benefits

### Quota Optimization
- **Before:** Reviews on every push (high quota usage)
- **After:** Reviews only on PR creation (80-90% quota reduction)

### Development Speed
- **Before:** Wait for external reviews on every push
- **After:** Fast CI feedback during development, reviews on complete features

### Review Quality
- **Before:** Reviews on work-in-progress code
- **After:** Reviews on complete, ready-to-merge features

---

## 🛠️ Troubleshooting

### External Reviews Not Triggering

1. **Check PR Event**
   ```bash
   # Verify PR was created, not just pushed
   gh pr view
   ```

2. **Check Configuration**
   ```bash
   # Verify configuration files exist
   ls -la .sourcery.yaml .cursor-bugbot.yaml
   ```

3. **Check GitHub Actions**
   ```bash
   # Verify external-reviews workflow ran
   gh run list --workflow=external-reviews.yml
   ```

### Reviews Triggering on Push

1. **Check Configuration**
   - Verify `skip_on_push: true` in both config files
   - Verify `events` only include PR events

2. **Check GitHub Integration**
   - Verify Sourcery/Cursor Bugbot GitHub app settings
   - Ensure webhooks are configured correctly

---

## 📈 Monitoring

### Quota Usage
- Monitor Sourcery quota in dashboard
- Monitor Cursor Bugbot usage
- Track review frequency vs. development activity

### Review Quality
- Track review feedback quality
- Monitor time from PR creation to review
- Measure review coverage of changed files

---

## 🔄 Maintenance

### Regular Updates
- Update configuration files as tools evolve
- Monitor new features in Sourcery/Cursor Bugbot
- Adjust quota limits based on usage patterns

### Team Training
- Ensure team understands the workflow
- Document any custom configurations
- Share best practices for PR-based reviews

---

## 📚 Related Documentation

- [CI Workflow Integration](../planning/ci/main/ci-workflow-integration/README.md)
- [Development Workflow Optimized](development-workflow-optimized.md)
- [Sourcery Control Guide](sourcery-control-guide.md)

---

**Last Updated:** 2025-01-20  
**Status:** Active  
**Next Review:** As needed
