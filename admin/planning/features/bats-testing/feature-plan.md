# Bats Testing Implementation Feature Plan

**Status:** 🚧 Ready to Start  
**Created:** 2025-10-06  
**Feature Branch:** `feature/bats-testing`  
**Priority:** 🔴 HIGH (Critical gap in test coverage)

---

## 📋 Overview

Implement Bats (Bash Automated Testing System) testing framework for Pokehub's shell scripts, filling the critical gap in test coverage (currently 0% for shell scripts).

### Goals

1. **Set Up Infrastructure** - Port Bats framework from dev-toolkit
2. **Test Critical Scripts** - Deployment, core, monitoring scripts
3. **CI/CD Integration** - Add to test pipeline
4. **Documentation** - Create TESTING-SHELL.md guide
5. **Achieve 80%+ Coverage** - For all tested shell scripts

---

## 🎯 Success Criteria

- [ ] Bats testing infrastructure set up
- [ ] 80-100 tests written for critical/high priority scripts
- [ ] < 30 seconds execution time
- [ ] CI/CD integration complete
- [ ] Documentation written
- [ ] Team trained on writing Bats tests

---

## 🚫 Out of Scope

**Excluded from this feature:**
- ❌ `workflow-helper.sh` (648 lines) - **DEFERRED**
  - **Reason:** Very complex, will be replaced by dev-toolkit's version
  - **Future:** Test after dev-toolkit develops `dt-init-workflow-helper`
  - **For now:** Use at own risk, manual testing only

---

## 📊 Scripts to Test (Priority Order)

### 🔴 CRITICAL Priority (Test First)

**Deployment Scripts** - Production-critical, must be reliable

| Script | Lines | Why Critical | Est. Tests |
|--------|-------|--------------|------------|
| `scripts/deployment/deploy.sh` | ~150 | Production deployments | 15-20 |
| `scripts/deployment/rollback.sh` | ~100 | Disaster recovery | 10-15 |
| `scripts/deployment/test-docker.sh` | ~80 | Pre-deployment validation | 8-10 |

**Subtotal:** ~330 lines, **33-45 tests**

---

### 🟠 HIGH Priority (Test Second)

**Core Scripts** - Used in Docker, health monitoring

| Script | Lines | Why High Priority | Est. Tests |
|--------|-------|-------------------|------------|
| `scripts/core/docker-startup.sh` | 50 | Docker container startup | 8-10 |
| `scripts/core/health-check.sh` | 111 | Service health monitoring | 12-15 |
| `scripts/core/invalidate-cache.sh` | 50 | Cache management API | 6-8 |

**Subtotal:** ~211 lines, **26-33 tests**

---

### 🟡 MEDIUM Priority (Test Third)

**Monitoring Scripts** - Project health, reporting

| Script | Lines | Why Medium Priority | Est. Tests |
|--------|-------|---------------------|------------|
| `scripts/monitoring/automated-status-check.sh` | 220 | Automated health checks | 15-20 |
| `scripts/monitoring/verify-project-status.sh` | 196 | Project verification | 12-15 |
| `scripts/monitoring/weekly-status-review.sh` | 204 | Weekly reporting | 10-12 |

**Subtotal:** ~620 lines, **37-47 tests**

---

### 🟢 LOW Priority (Optional/Future)

**Setup Scripts** - One-time use, lower risk

| Script | Lines | Priority | Est. Tests |
|--------|-------|----------|------------|
| `scripts/setup/setup-production-secrets.sh` | ~100 | LOW | 8-10 |
| `scripts/setup/setup-github-secrets.sh` | ~80 | LOW | 6-8 |
| `scripts/setup/setup-github-ci-cd.sh` | ~120 | LOW | 10-12 |
| `scripts/setup/security-toggle.sh` | ~60 | LOW | 5-7 |
| `scripts/setup/production-setup.sh` | ~150 | LOW | 12-15 |
| `scripts/setup/github-setup.sh` | ~100 | LOW | 8-10 |
| `scripts/setup/configure-github-permissions.sh` | ~80 | LOW | 6-8 |

**Subtotal:** ~690 lines, **55-70 tests** (DEFERRED)

---

## 📈 Total Scope (Immediate Implementation)

**Phase 1-3 (Critical + High + Medium):**
- **Scripts:** 9 scripts
- **Lines of Code:** ~1,161 lines
- **Estimated Tests:** 96-125 tests
- **Execution Time:** < 30 seconds

**Excluded:**
- ❌ workflow-helper.sh (648 lines) - Wait for dev-toolkit
- ❌ Setup scripts (690 lines) - Low priority, defer

---

## 🗺️ Implementation Phases

### Phase 1: Foundation + Critical Scripts (Week 1)

**Goal:** Set up Bats infrastructure and test deployment scripts

**Tasks:**
- [ ] Install Bats (`brew install bats-core`)
- [ ] Create `tests/shell/` directory structure
- [ ] Port helpers from dev-toolkit:
  - `helpers/setup.bash`
  - `helpers/mocks.bash`
  - `helpers/assertions.bash`
- [ ] Create smoke test (`test-simple.bats`)
- [ ] Test deployment scripts:
  - [ ] `deploy.sh` (15-20 tests)
  - [ ] `rollback.sh` (10-15 tests)
  - [ ] `test-docker.sh` (8-10 tests)
- [ ] Add to CI/CD pipeline

**Deliverable:** 
- ✅ Bats infrastructure working
- ✅ 33-45 tests for deployment scripts
- ✅ CI/CD integration

**Effort:** 🟡 MEDIUM (5 days)

---

### Phase 2: Core Scripts (Week 2)

**Goal:** Test core Docker and health monitoring scripts

**Tasks:**
- [ ] Test `docker-startup.sh` (8-10 tests)
  - Wait for database
  - Run migrations
  - Seed data
  - Error handling
- [ ] Test `health-check.sh` (12-15 tests)
  - Service health checks
  - API endpoint checks
  - Return codes
  - Error conditions
- [ ] Test `invalidate-cache.sh` (6-8 tests)
  - API calls
  - Error handling
  - Response validation

**Deliverable:**
- ✅ 26-33 tests for core scripts
- ✅ 59-78 total tests

**Effort:** 🟢 LOW-MEDIUM (3-4 days)

---

### Phase 3: Monitoring Scripts (Week 3)

**Goal:** Test monitoring and status scripts

**Tasks:**
- [ ] Test `automated-status-check.sh` (15-20 tests)
  - Container detection
  - Git status checks
  - API health checks
  - Report generation
- [ ] Test `verify-project-status.sh` (12-15 tests)
  - Component verification
  - Failure reporting
  - Status aggregation
- [ ] Test `weekly-status-review.sh` (10-12 tests)
  - Weekly report generation
  - Data collection
  - Output formatting

**Deliverable:**
- ✅ 37-47 tests for monitoring scripts
- ✅ 96-125 total tests
- ✅ 80%+ coverage for tested scripts

**Effort:** 🟡 MEDIUM (5 days)

---

### Phase 4: Documentation & Polish (Week 4)

**Goal:** Complete documentation and team training

**Tasks:**
- [ ] Write `docs/testing/TESTING-SHELL.md`
  - How to run Bats tests
  - How to write new tests
  - Mocking patterns
  - Best practices
- [ ] Update `tests/README.md`
- [ ] Update `tests/run-all-tests.sh`
  - Add `--shell-only` flag
  - Integrate with full test suite
- [ ] Team training session
- [ ] Update CI/CD documentation

**Deliverable:**
- ✅ Complete documentation
- ✅ Team trained
- ✅ Production-ready

**Effort:** 🟢 LOW (2-3 days)

---

## 📁 Directory Structure

```
tests/
├── shell/                      # NEW: Shell script tests
│   ├── README.md              # Shell testing guide
│   ├── helpers/               # Test utilities (from dev-toolkit)
│   │   ├── setup.bash        # Common setup functions
│   │   ├── mocks.bash        # Command mocking utilities
│   │   └── assertions.bash   # Custom assertions
│   ├── unit/                 # Unit tests for shell functions
│   │   ├── test-simple.bats           # Smoke tests
│   │   ├── deployment/
│   │   │   ├── test-deploy.bats
│   │   │   ├── test-rollback.bats
│   │   │   └── test-docker.bats
│   │   ├── core/
│   │   │   ├── test-docker-startup.bats
│   │   │   ├── test-health-check.bats
│   │   │   └── test-invalidate-cache.bats
│   │   └── monitoring/
│   │       ├── test-status-check.bats
│   │       ├── test-verify-status.bats
│   │       └── test-weekly-review.bats
│   └── integration/          # Integration tests (if needed)
│       └── test-deployment-workflow.bats
├── unit/                     # EXISTING: Python/JS tests
├── integration/              # EXISTING
├── e2e/                      # EXISTING
└── performance/              # EXISTING
```

---

## 🧪 Testing Strategy

### Test Patterns (from dev-toolkit)

**1. Pure Function Testing**
```bash
@test "health_check: returns 0 when all services healthy" {
  # Mock service checks
  check_api() { return 0; }
  check_db() { return 0; }
  export -f check_api check_db
  
  run health_check
  [ "$status" -eq 0 ]
}
```

**2. Command Mocking**
```bash
@test "deploy: validates environment variables" {
  # Mock docker command
  docker() {
    echo "mocked docker"
    return 0
  }
  export -f docker
  
  run deploy_script
  [ "$status" -eq 0 ]
}
```

**3. Error Condition Testing**
```bash
@test "rollback: fails gracefully when version not found" {
  run rollback_to_version "nonexistent"
  [ "$status" -ne 0 ]
  [[ "$output" =~ "Version not found" ]]
}
```

**4. Integration Testing**
```bash
@test "docker-startup: complete startup workflow" {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  
  # Set up test environment
  # Run actual script
  # Verify results
  
  cd - > /dev/null
  rm -rf "$TEST_DIR"
}
```

---

## 🔧 Tools & Dependencies

### Required

```bash
# Install Bats
brew install bats-core

# Verify installation
bats --version
```

### Optional (for enhanced testing)

```bash
# bats-support - Additional assertions
brew tap kaos/shell
brew install bats-support

# bats-assert - More assertion helpers
brew install bats-assert

# bats-file - File testing helpers
brew install bats-file
```

---

## 🚀 Getting Started

### Step 1: Install Bats

```bash
brew install bats-core
bats --version  # Should show version 1.x.x
```

### Step 2: Create Structure

```bash
mkdir -p tests/shell/{helpers,unit/{deployment,core,monitoring},integration}
```

### Step 3: Port Helpers

```bash
# Copy from dev-toolkit
cp /Users/cdwilson/Projects/dev-toolkit/tests/helpers/*.bash tests/shell/helpers/
```

### Step 4: Create First Test

```bash
# tests/shell/unit/test-simple.bats
#!/usr/bin/env bats

@test "smoke test: bats is working" {
  [ 1 -eq 1 ]
}
```

### Step 5: Run Tests

```bash
bats tests/shell/
# Should see: 1 test, 0 failures
```

---

## 📊 Progress Tracking

### Phase 1: Foundation + Critical ⏳

**Status:** 🔴 Not Started

**Tasks:**
- [ ] Install Bats
- [ ] Create directory structure
- [ ] Port helpers
- [ ] Smoke test
- [ ] Test deploy.sh (15-20 tests)
- [ ] Test rollback.sh (10-15 tests)
- [ ] Test test-docker.sh (8-10 tests)
- [ ] CI/CD integration

**Progress:** 0% (0/8 tasks)

---

### Phase 2: Core Scripts ⏳

**Status:** 🔴 Not Started

**Tasks:**
- [ ] Test docker-startup.sh (8-10 tests)
- [ ] Test health-check.sh (12-15 tests)
- [ ] Test invalidate-cache.sh (6-8 tests)

**Progress:** 0% (0/3 tasks)

---

### Phase 3: Monitoring Scripts ⏳

**Status:** 🔴 Not Started

**Tasks:**
- [ ] Test automated-status-check.sh (15-20 tests)
- [ ] Test verify-project-status.sh (12-15 tests)
- [ ] Test weekly-status-review.sh (10-12 tests)

**Progress:** 0% (0/3 tasks)

---

### Phase 4: Documentation ⏳

**Status:** 🔴 Not Started

**Tasks:**
- [ ] Write TESTING-SHELL.md
- [ ] Update tests/README.md
- [ ] Update run-all-tests.sh
- [ ] Team training

**Progress:** 0% (0/4 tasks)

---

## 🎉 Success Metrics

### Coverage Goals

**After Phase 1:**
- ✅ Deployment scripts: 80%+ coverage
- ✅ 33-45 tests passing
- ✅ CI/CD integrated

**After Phase 2:**
- ✅ Core scripts: 80%+ coverage
- ✅ 59-78 tests passing

**After Phase 3:**
- ✅ Monitoring scripts: 80%+ coverage
- ✅ 96-125 tests passing
- ✅ < 30 seconds execution

**After Phase 4:**
- ✅ Complete documentation
- ✅ Team trained
- ✅ Production-ready

### Quality Metrics

- **Test Execution:** < 30 seconds
- **Test Success Rate:** 100%
- **Code Coverage:** 80%+ for tested scripts
- **Maintainability:** Clear, well-documented tests

---

## 🚧 Risks & Mitigations

### Risk 1: Mocking Complexity

**Issue:** Some scripts interact with Docker, APIs, databases

**Mitigation:**
- Use dev-toolkit's proven mocking patterns
- Mock external commands (docker, curl, psql)
- Test interfaces, not implementations
- Focus on what we control

**Likelihood:** 🟡 MEDIUM  
**Impact:** 🟡 MEDIUM

---

### Risk 2: CI/CD Integration Issues

**Issue:** Bats may not integrate smoothly with existing pytest/Vitest

**Mitigation:**
- Keep test types independent
- Add `--shell-only` flag to run-all-tests.sh
- Use TAP output for CI compatibility
- Test integration early (Phase 1)

**Likelihood:** 🟢 LOW  
**Impact:** 🟢 LOW

---

### Risk 3: Team Adoption

**Issue:** Team unfamiliar with Bats

**Mitigation:**
- Comprehensive documentation
- Training session (Phase 4)
- Pair programming for first tests
- Clear examples in test files

**Likelihood:** 🟡 MEDIUM  
**Impact:** 🟢 LOW

---

## 📚 Related Documents

### Planning
- [Bats Testing Assessment](../../notes/opportunities/external/testing-overhaul/bats-testing-assessment.md)
- [Dev-Toolkit TESTING.md](../../notes/opportunities/external/testing-overhaul/TESTING.md)

### Dev-Toolkit Resources
- [Dev-Toolkit Tests](https://github.com/grimm00/dev-toolkit/tree/main/tests)
- [Bats Documentation](https://bats-core.readthedocs.io/)

### Pokehub Testing
- [Tests README](../../../../tests/README.md)
- [Testing Strategy](../../../testing/strategies/comprehensive-testing-strategy.md)

---

## 🎯 Timeline

**Total Duration:** 4 weeks

| Phase | Duration | Dates (Estimated) |
|-------|----------|-------------------|
| Phase 1: Foundation + Critical | 5 days | Week 1 |
| Phase 2: Core Scripts | 3-4 days | Week 2 |
| Phase 3: Monitoring Scripts | 5 days | Week 3 |
| Phase 4: Documentation | 2-3 days | Week 4 |

**Milestones:**
- ✅ Week 1: Deployment scripts tested, CI/CD integrated
- ✅ Week 2: Core scripts tested
- ✅ Week 3: Monitoring scripts tested, 80%+ coverage
- ✅ Week 4: Documentation complete, team trained

---

## 💰 Cost-Benefit Analysis

### Investment

**Time:**
- Phase 1: 5 days
- Phase 2: 3-4 days
- Phase 3: 5 days
- Phase 4: 2-3 days
- **Total:** 15-17 days (~3 weeks)

**Ongoing:**
- Write tests for new scripts
- Maintain existing tests (~10% overhead)

### Return

**Immediate:**
- ✅ Catch deployment bugs before production
- ✅ Safer rollback procedures
- ✅ Reliable health monitoring
- ✅ Faster debugging

**Long-term:**
- ✅ Reduced production incidents
- ✅ Easier onboarding
- ✅ Higher code quality
- ✅ Confident refactoring

**ROI:** 🟢 **VERY HIGH** - Prevents production issues

---

## 🚀 Next Steps

### Immediate (This Week)

1. **Create Feature Branch**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/bats-testing
   ```

2. **Install Bats**
   ```bash
   brew install bats-core
   bats --version
   ```

3. **Set Up Structure**
   ```bash
   mkdir -p tests/shell/{helpers,unit/{deployment,core,monitoring},integration}
   ```

4. **Start Phase 1**
   - Port helpers from dev-toolkit
   - Create smoke test
   - Begin testing deploy.sh

---

**Last Updated:** 2025-10-06  
**Status:** 🚧 Ready to Start  
**Next:** Create feature branch and begin Phase 1  
**Priority:** 🔴 HIGH (Critical test coverage gap)
