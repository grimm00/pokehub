# Bats Testing Quick Start Guide

**Ready to implement Bats testing for Pokehub shell scripts!**

---

## 🎯 What We're Doing

Testing **9 critical shell scripts** (1,161 lines) with Bats framework:
- ✅ Deployment scripts (CRITICAL)
- ✅ Core scripts (HIGH)
- ✅ Monitoring scripts (MEDIUM)

**NOT testing:**
- ❌ workflow-helper.sh - Wait for dev-toolkit version
- ❌ Setup scripts - Low priority, deferred

---

## 🚀 Quick Start (5 Minutes)

### Step 1: Install Bats
```bash
brew install bats-core
bats --version  # Should show 1.x.x
```

### Step 2: Create Feature Branch
```bash
cd /Users/cdwilson/Projects/pokedex
git checkout develop
git pull origin develop
git checkout -b feature/bats-testing
```

### Step 3: Create Directory Structure
```bash
mkdir -p tests/shell/{helpers,unit/{deployment,core,monitoring},integration}
```

### Step 4: Port Helpers from Dev-Toolkit
```bash
cp /Users/cdwilson/Projects/dev-toolkit/tests/helpers/*.bash tests/shell/helpers/
```

### Step 5: Create Smoke Test
```bash
cat > tests/shell/unit/test-simple.bats << 'EOF'
#!/usr/bin/env bats

@test "smoke test: bats is working" {
  [ 1 -eq 1 ]
}

@test "smoke test: can source helpers" {
  load '../helpers/setup'
  [ -n "$PROJECT_ROOT" ]
}
EOF

chmod +x tests/shell/unit/test-simple.bats
```

### Step 6: Run First Test
```bash
bats tests/shell/unit/test-simple.bats
# Should see: 2 tests, 0 failures
```

---

## 📋 Implementation Checklist

### Phase 1: Foundation + Deployment (Week 1)

- [ ] Install Bats
- [ ] Create directory structure
- [ ] Port helpers from dev-toolkit
- [ ] Create smoke test
- [ ] Test `scripts/deployment/deploy.sh` (15-20 tests)
- [ ] Test `scripts/deployment/rollback.sh` (10-15 tests)
- [ ] Test `scripts/deployment/test-docker.sh` (8-10 tests)
- [ ] Add to CI/CD pipeline
- [ ] Update `tests/run-all-tests.sh`

**Goal:** 33-45 tests, CI/CD integrated

---

### Phase 2: Core Scripts (Week 2)

- [ ] Test `scripts/core/docker-startup.sh` (8-10 tests)
- [ ] Test `scripts/core/health-check.sh` (12-15 tests)
- [ ] Test `scripts/core/invalidate-cache.sh` (6-8 tests)

**Goal:** 26-33 tests, 59-78 total

---

### Phase 3: Monitoring Scripts (Week 3)

- [ ] Test `scripts/monitoring/automated-status-check.sh` (15-20 tests)
- [ ] Test `scripts/monitoring/verify-project-status.sh` (12-15 tests)
- [ ] Test `scripts/monitoring/weekly-status-review.sh` (10-12 tests)

**Goal:** 37-47 tests, 96-125 total, 80%+ coverage

---

### Phase 4: Documentation (Week 4)

- [ ] Write `docs/testing/TESTING-SHELL.md`
- [ ] Update `tests/README.md`
- [ ] Update `tests/run-all-tests.sh` with `--shell-only` flag
- [ ] Team training session
- [ ] Update CI/CD documentation

**Goal:** Complete documentation, team trained

---

## 📚 Resources

### Documentation
- **Feature Plan:** `admin/planning/features/bats-testing/feature-plan.md`
- **Assessment:** `admin/planning/notes/opportunities/external/testing-overhaul/bats-testing-assessment.md`
- **Dev-Toolkit Guide:** `admin/planning/notes/opportunities/external/testing-overhaul/TESTING.md`

### Examples
- **Dev-Toolkit Tests:** `/Users/cdwilson/Projects/dev-toolkit/tests/`
- **Helpers:** `/Users/cdwilson/Projects/dev-toolkit/tests/helpers/`

### External
- **Bats Docs:** https://bats-core.readthedocs.io/
- **Bats GitHub:** https://github.com/bats-core/bats-core

---

## 💡 Test Writing Tips

### Basic Test Structure
```bash
#!/usr/bin/env bats

load '../helpers/setup'
load '../helpers/mocks'

setup() {
  setup_file  # Sets PROJECT_ROOT
}

@test "script_name: behavior description" {
  run script_function
  [ "$status" -eq 0 ]
  [[ "$output" =~ "expected" ]]
}
```

### Mocking External Commands
```bash
@test "deploy: calls docker command" {
  docker() {
    echo "mocked docker"
    return 0
  }
  export -f docker
  
  run deploy_script
  [ "$status" -eq 0 ]
}
```

### Testing Error Conditions
```bash
@test "rollback: fails when version not found" {
  run rollback_to_version "nonexistent"
  [ "$status" -ne 0 ]
  [[ "$output" =~ "Version not found" ]]
}
```

---

## 🎯 Success Metrics

**After Phase 1:**
- ✅ 33-45 tests passing
- ✅ Deployment scripts 80%+ coverage
- ✅ CI/CD integrated

**After Phase 2:**
- ✅ 59-78 tests passing
- ✅ Core scripts 80%+ coverage

**After Phase 3:**
- ✅ 96-125 tests passing
- ✅ All tested scripts 80%+ coverage
- ✅ < 30 seconds execution

**After Phase 4:**
- ✅ Complete documentation
- ✅ Team trained
- ✅ Production-ready

---

## 🚀 Let's Go!

**Ready to start?**

1. Run the Quick Start steps above
2. Verify smoke test passes
3. Begin Phase 1: Test deployment scripts
4. Follow the feature plan for detailed guidance

**Questions?** See `feature-plan.md` for comprehensive details.

---

**Last Updated:** 2025-10-06  
**Status:** 🚧 Ready to Start  
**Priority:** 🔴 HIGH
