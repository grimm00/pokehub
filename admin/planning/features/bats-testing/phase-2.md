# Phase 2: Core Scripts Testing

**Status:** 📋 Planning  
**Duration:** 3-4 days (estimated)  
**Target:** 20-30 tests for core utility scripts  
**Prerequisites:** Phase 1 Complete ✅

---

## 🎯 Goals

### Primary Objectives
1. Test all core utility scripts (3 scripts)
2. Achieve 100% coverage of core functionality
3. Maintain fast execution (< 10 seconds for Phase 2 tests)
4. Use existing Pokehub-specific helpers

### Success Criteria
- ✅ 20-30 tests passing (100% pass rate)
- ✅ All core scripts tested
- ✅ CI/CD integration working
- ✅ Documentation updated
- ✅ Fast execution (< 10s)

---

## 📋 Target Scripts

### 1. `scripts/core/docker-startup.sh`
**Purpose:** Manages Docker container startup and initialization

**Estimated Tests:** 8-12 tests

**Test Categories:**
- Environment validation
- Docker availability checks
- Container startup process
- Health check validation
- Error handling
- Logging and output

### 2. `scripts/core/health-check.sh`
**Purpose:** Performs health checks on running services

**Estimated Tests:** 6-10 tests

**Test Categories:**
- Service availability checks
- API endpoint testing
- Database connectivity
- Redis connectivity
- Response validation
- Timeout handling

### 3. `scripts/invalidate-cache.sh`
**Purpose:** Invalidates application cache

**Estimated Tests:** 6-8 tests

**Test Categories:**
- Cache connection validation
- Invalidation commands
- Success/failure handling
- Output validation
- Error scenarios

---

## 📅 Implementation Plan

### Day 1: Analyze Scripts & Plan Tests ✅ COMPLETE

**Morning: Script Analysis**
- [x] ✅ Read `docker-startup.sh` thoroughly (51 lines, 0 functions)
- [x] ✅ Read `health-check.sh` thoroughly (112 lines, 2 functions)
- [x] ✅ Read `invalidate-cache.sh` thoroughly (51 lines, 0 functions)
- [x] ✅ Identify all functions and workflows
- [x] ✅ Document dependencies and requirements

**Afternoon: Test Planning**
- [x] ✅ Create test file templates (planned)
- [x] ✅ Plan test categories for each script
- [x] ✅ Identify required mocks (all available from Phase 1!)
- [x] ✅ Identify required assertions (all available from Phase 1!)
- [x] ✅ Document edge cases

**Deliverables:** ✅
- ✅ Script analysis notes (`phase-2-day1-analysis.md`)
- ✅ Test plan for each script (27 tests total)
- ✅ Mock/assertion requirements (no new helpers needed!)

**Key Findings:**
- docker-startup.sh: 10 tests planned
- health-check.sh: 9 tests planned
- invalidate-cache.sh: 8 tests planned
- **Total: 27 tests (within 20-30 target)**
- **No new helpers needed** - all Phase 1 mocks/assertions sufficient!

---

### Day 2: Test docker-startup.sh (12 tests) ✅ COMPLETE

**Script:** `scripts/core/docker-startup.sh`

**Tasks:**
- [x] ✅ Create `tests/shell/unit/core/test-docker-startup.bats`
- [x] ✅ Test script structure (3 tests)
- [x] ✅ Test Redis startup (2 tests)
- [x] ✅ Test database initialization (2 tests)
- [x] ✅ Test Pokemon seeding (3 tests)
- [x] ✅ Test service startup (2 tests)

**Test Categories (Actual):**

#### Script Structure (3 tests) ✅
- [x] Script exists and is executable
- [x] Has proper shebang
- [x] Uses set -e for error handling

#### Redis Startup (2 tests) ✅
- [x] Attempts to start Redis server
- [x] Uses Redis daemonize mode

#### Database Initialization (2 tests) ✅
- [x] Runs database initialization
- [x] Imports correct database modules

#### Pokemon Seeding (3 tests) ✅
- [x] Uses timeout for Pokemon seeding
- [x] Handles seeding timeout gracefully
- [x] Continues on seeding failure

#### Service Startup (2 tests) ✅
- [x] Starts Flask in background
- [x] Starts nginx in foreground

**Mocks Used:**
- None needed - all structure tests using grep

**Assertions Used:**
- `assert_output_contains()`
- `assert_file_exists()`
- `assert_script_executable()`

**Result:** ✅ 12 tests passing (exceeded target of 8-12!)

**Total Tests Now:** 90 (78 Phase 1 + 12 Phase 2 Day 2)

---

### Day 3: Test health-check.sh (6-10 tests)

**Script:** `scripts/core/health-check.sh`

**Tasks:**
- [ ] Create `tests/shell/unit/core/test-health-check.bats`
- [ ] Test service availability (2-3 tests)
- [ ] Test API endpoint checks (2-3 tests)
- [ ] Test database/Redis connectivity (1-2 tests)
- [ ] Test timeout handling (1-2 tests)
- [ ] Test script structure (2-3 tests)

**Test Categories:**

#### Service Availability (2-3 tests)
- [ ] Checks if services are running
- [ ] Validates container status
- [ ] Reports service state

#### API Endpoint Testing (2-3 tests)
- [ ] Tests backend API health endpoint
- [ ] Tests frontend availability
- [ ] Validates response codes

#### Database/Redis Connectivity (1-2 tests)
- [ ] Checks database connection
- [ ] Checks Redis connection
- [ ] Validates connectivity

#### Timeout Handling (1-2 tests)
- [ ] Handles timeouts gracefully
- [ ] Reports timeout errors
- [ ] Has configurable timeout

#### Script Structure (2-3 tests)
- [ ] Script exists and is executable
- [ ] Has proper shebang
- [ ] Defines expected functions

**Expected Mocks:**
- `mock_pokehub_services_healthy()` / `mock_pokehub_services_unhealthy()`
- `mock_curl_success()` / `mock_curl_failure()`
- `mock_redis_cli_success()` / `mock_redis_cli_failure()`
- `mock_psql_success()` / `mock_psql_failure()`

**Expected Assertions:**
- `assert_output_contains()`
- `assert_http_status()`
- `assert_api_accessible()`
- `assert_redis_healthy()`
- `assert_pokehub_service_healthy()`

**Goal:** 6-10 tests passing

---

### Day 4: Test invalidate-cache.sh (6-8 tests)

**Script:** `scripts/invalidate-cache.sh`

**Tasks:**
- [ ] Create `tests/shell/unit/test-invalidate-cache.bats`
- [ ] Test cache connection validation (2-3 tests)
- [ ] Test invalidation commands (2-3 tests)
- [ ] Test error handling (1-2 tests)
- [ ] Test script structure (2-3 tests)

**Test Categories:**

#### Cache Connection (2-3 tests)
- [ ] Validates Redis connection
- [ ] Checks Redis availability
- [ ] Handles connection failures

#### Invalidation Commands (2-3 tests)
- [ ] Executes FLUSHDB command
- [ ] Validates command success
- [ ] Reports invalidation status

#### Error Handling (1-2 tests)
- [ ] Handles Redis unavailable
- [ ] Reports errors clearly
- [ ] Exits with proper status codes

#### Script Structure (2-3 tests)
- [ ] Script exists and is executable
- [ ] Has proper shebang
- [ ] Uses proper Redis commands

**Expected Mocks:**
- `mock_redis_cli_success()` / `mock_redis_cli_failure()`

**Expected Assertions:**
- `assert_output_contains()`
- `assert_redis_healthy()`
- `assert_script_executable()`

**Goal:** 6-8 tests passing

---

## 🧪 Testing Strategy

### Approach
1. **CLI Interface Testing** - Test script behavior without sourcing
2. **Structure Testing** - Verify script content and functions
3. **Mock External Services** - Use Pokehub-specific mocks
4. **Fast Execution** - Keep tests under 10 seconds total

### Patterns to Use

**Pattern 1: CLI Testing (Fast)**
```bash
@test "script: validates environment" {
  mock_docker_failure  # Fail fast
  run bash "$PROJECT_ROOT/scripts/core/script.sh"
  assert_output_contains "error message"
}
```

**Pattern 2: Structure Testing (Instant)**
```bash
@test "script: defines function" {
  run grep "function_name()" "$PROJECT_ROOT/scripts/core/script.sh"
  [ "$status" -eq 0 ]
}
```

**Pattern 3: Composite Mocks (Clean)**
```bash
@test "script: works with healthy services" {
  mock_pokehub_services_healthy  # One line!
  run bash "$PROJECT_ROOT/scripts/core/script.sh"
  assert_output_contains "success"
}
```

---

## 📊 Success Metrics

### Quantitative
- **Test Count:** 20-30 tests (target range)
- **Pass Rate:** 100%
- **Execution Time:** < 10 seconds for Phase 2 tests
- **Coverage:** 100% of core scripts

### Qualitative
- ✅ All core scripts thoroughly tested
- ✅ Tests are fast and reliable
- ✅ Tests use existing helpers (no new helpers needed)
- ✅ Documentation is clear and complete
- ✅ CI/CD integration works seamlessly

---

## 🔧 Infrastructure (Already Available)

### Existing Helpers (From Phase 1)
**Mocks:**
- `mock_docker_success()` / `mock_docker_failure()`
- `mock_docker_compose_success()`
- `mock_curl_success()` / `mock_curl_failure()`
- `mock_redis_cli_success()` / `mock_redis_cli_failure()`
- `mock_psql_success()` / `mock_psql_failure()`
- `mock_pokehub_services_healthy()` / `mock_pokehub_services_unhealthy()`

**Assertions:**
- `assert_output_contains()`
- `assert_file_exists()`
- `assert_script_executable()`
- `assert_http_status()`
- `assert_container_running()`
- `assert_redis_healthy()`
- `assert_pokehub_service_healthy()`
- `assert_api_accessible()`

### Test Runner
- `tests/shell/run-shell-tests.sh` (already exists)
- Works with all test files automatically

### CI/CD
- GitHub Actions `shell-tests` job (already configured)
- Runs automatically on push/PR

---

## 📝 Documentation Plan

### Updates Needed
1. **`tests/shell/README.md`**
   - Update test coverage table
   - Add Phase 2 scripts to coverage
   - Update total test count

2. **Create Test Files**
   - `tests/shell/unit/core/test-docker-startup.bats`
   - `tests/shell/unit/core/test-health-check.bats`
   - `tests/shell/unit/test-invalidate-cache.bats`

3. **Update Phase 2 Plan**
   - Mark tasks as complete
   - Document any deviations
   - Add commit references

---

## 🎯 Workflow (Following New Process)

### Step 1: Planning (This Document)
```bash
# Already done - this document!
git checkout develop
git add admin/planning/features/bats-testing/phase-2.md
git commit -m "docs: Add Phase 2 planning for core scripts testing"
git push
```
**Sourcery Usage:** 0 characters ✅

### Step 2: Implementation (Small PR)
```bash
git checkout -b feature/bats-phase2-core-scripts
# Add tests for all 3 scripts
git add tests/shell/unit/core/
git add tests/shell/unit/test-invalidate-cache.bats
git commit -m "feat: Add Phase 2 tests for core scripts"
gh pr create
```
**Sourcery Usage:** ~50-75K characters ✅

### Step 3: Documentation (Quick Doc Branch)
```bash
git checkout -b docs/phase2-completion
# Update README, add completion notes
git add tests/shell/README.md admin/planning/features/bats-testing/phase-2.md
git commit -m "docs: Update documentation for Phase 2 completion"
gh pr create --body "<!-- @sourcery-ai ignore -->"
gh pr merge --squash --delete-branch --admin
```
**Sourcery Usage:** 0 characters ✅

---

## 🚀 Getting Started

### Prerequisites Check
- [x] ✅ Phase 1 complete (78 tests passing)
- [x] ✅ Helpers available (mocks + assertions)
- [x] ✅ Test runner working
- [x] ✅ CI/CD integrated
- [x] ✅ Documentation structure in place

### Ready to Start?
1. Read the target scripts thoroughly
2. Create test file templates
3. Start with `docker-startup.sh` (Day 2)
4. Follow the day-by-day plan
5. Use existing helpers (no new helpers needed)

---

## 📚 Resources

### Internal
- **Phase 1 Plan:** `phase-1.md` (reference for patterns)
- **Feature Plan:** `feature-plan.md` (overall strategy)
- **Helpers Documentation:** `../../tests/shell/helpers/README.md`
- **Test Examples:** `../../tests/shell/unit/deployment/` (Phase 1 examples)

### Scripts to Test
- `scripts/core/docker-startup.sh`
- `scripts/core/health-check.sh`
- `scripts/invalidate-cache.sh`

---

## ✅ Phase 2 Completion Checklist

### Day 1: Planning & Analysis
- [ ] All scripts read and analyzed
- [ ] Test plans created for each script
- [ ] Mock/assertion requirements identified
- [ ] Edge cases documented

### Day 2: docker-startup.sh
- [ ] Test file created
- [ ] 8-12 tests written
- [ ] All tests passing
- [ ] Uses existing helpers

### Day 3: health-check.sh
- [ ] Test file created
- [ ] 6-10 tests written
- [ ] All tests passing
- [ ] Uses existing helpers

### Day 4: invalidate-cache.sh
- [ ] Test file created
- [ ] 6-8 tests written
- [ ] All tests passing
- [ ] Uses existing helpers

### Final Tasks
- [ ] All 20-30 tests passing
- [ ] Execution time < 10 seconds
- [ ] CI/CD tests passing
- [ ] Documentation updated
- [ ] Code reviewed and approved
- [ ] PR merged to develop

**Total:** 20-30 tests, ready for Phase 3

---

## 🎊 Expected Outcomes

### Test Suite Growth
- Phase 1: 78 tests
- Phase 2: +20-30 tests
- **Total: 98-108 tests**

### Execution Time
- Phase 1: 21 seconds
- Phase 2: +10 seconds
- **Total: ~31 seconds**

### Coverage
- Deployment scripts: 100% ✅
- Core scripts: 100% (after Phase 2)
- Monitoring scripts: 0% (Phase 3)

---

**Last Updated:** 2025-10-07  
**Status:** 📋 Planning Complete - Ready to Start  
**Next:** Day 1 - Script Analysis & Test Planning
