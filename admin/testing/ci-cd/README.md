# CI/CD Documentation

This directory contains CI/CD integration plans, configurations, and technical documentation.

## Contents

- `ci-cd-integration-plan.md` - Overall CI/CD integration strategy
- `ci-cd-quick-reference.md` - Quick reference for common CI/CD tasks
- `ci-cd-technical-design.md` - Technical architecture and design
- `next-steps-testing-framework.md` - Future testing framework improvements

## CI/CD Pipeline

### Current Setup
- **Platform:** GitHub Actions
- **Triggers:** Push to main, PRs to main/develop
- **Jobs:** Linting, testing, build verification

### Pipeline Stages

1. **Lint**
   - Python: flake8, black
   - JavaScript: ESLint, Prettier
   - Markdown: Link checking

2. **Test**
   - Backend: pytest
   - Frontend: Vitest
   - Integration: E2E tests (planned)

3. **Build**
   - Docker image build
   - Frontend production build
   - Verify no build errors

4. **Deploy** (planned)
   - Staging environment
   - Production deployment
   - Rollback capability

## Quick Commands

### Local Testing
```bash
# Run all tests
./admin/testing/run-tests.sh

# Backend tests only
cd backend && pytest

# Frontend tests only
cd frontend && npm test
```

### CI/CD Management
```bash
# Check workflow status
gh workflow list

# View recent runs
gh run list

# Trigger manual run
gh workflow run ci.yml
```

## Related Documentation

- `../strategies/` - Testing strategies
- `../../docs/guides/quick-reference/github-actions-quick-reference.md` - GitHub Actions guide
- `.github/workflows/` - Workflow configurations (root level)

---

*For detailed technical design, see `ci-cd-technical-design.md`*
