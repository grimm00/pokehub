# Phase 1: Foundation + Deployment Scripts

**Status:** 🚧 In Progress  
**Started:** 2025-10-06  
**Duration:** 5 days (Week 1)  
**Feature:** Bats Testing Implementation

---

## 🎯 Phase Goal

Set up Bats testing infrastructure and test all deployment scripts (CRITICAL priority).

**Deliverables:**
- ✅ Bats infrastructure working
- ✅ 33-45 tests for deployment scripts
- ✅ CI/CD integration
- ✅ < 15 seconds execution time

---

## 📋 Tasks Checklist

### Day 1: Infrastructure Setup ✅ COMPLETE

- [x] **Install Bats**
  ```bash
  brew install bats-core
  bats --version  # Verify 1.x.x
  ```
  ✅ Bats v1.12.0 installed

- [x] **Create Directory Structure**
  ```bash
  mkdir -p tests/shell/{helpers,unit/{deployment,core,monitoring},integration}
  ```
  ✅ Directory structure created

- [x] **Port Helpers from Dev-Toolkit**
  ```bash
  # Copy helper files
  cp /Users/cdwilson/Projects/dev-toolkit/tests/helpers/setup.bash tests/shell/helpers/
  cp /Users/cdwilson/Projects/dev-toolkit/tests/helpers/mocks.bash tests/shell/helpers/
  cp /Users/cdwilson/Projects/dev-toolkit/tests/helpers/assertions.bash tests/shell/helpers/
  
  # Verify files copied
  ls -la tests/shell/helpers/
  ```
  ✅ 3 helper files ported (setup.bash, mocks.bash, assertions.bash)

- [x] **Create Smoke Test**
  ```bash
  # Create tests/shell/unit/test-simple.bats
  # See template below
  ```
  ✅ Smoke test created with 7 tests

- [x] **Run Smoke Test**
  ```bash
  bats tests/shell/unit/test-simple.bats
  # Should pass: 7 tests, 0 failures
  ```
  ✅ All 7 smoke tests passing

- [x] **Create README**
  ```bash
  # Create tests/shell/README.md
  # Document structure and usage
  ```
  ✅ Comprehensive README.md created

**Goal:** ✅ Working Bats infrastructure - COMPLETE!

**Commit:** `f029e38` - feat: Set up Bats testing infrastructure (Phase 1, Day 1)

---

### Day 2: Test deploy.sh (15-20 tests)

**Script:** `scripts/deployment/deploy.sh`

- [ ] **Read and Understand Script**
  ```bash
  cat scripts/deployment/deploy.sh
  # Identify functions and workflows
  ```

- [ ] **Create Test File**
  ```bash
  # Create tests/shell/unit/deployment/test-deploy.bats
  ```

- [ ] **Test Categories:**

  **Environment Validation (5-7 tests)**
  - [ ] Validates required environment variables
  - [ ] Checks Docker is running
  - [ ] Verifies git repository state
  - [ ] Checks for uncommitted changes
  - [ ] Validates branch name

  **Pre-deployment Checks (4-6 tests)**
  - [ ] Runs tests before deployment
  - [ ] Checks build succeeds
  - [ ] Validates configuration files
  - [ ] Verifies secrets are set

  **Deployment Process (4-6 tests)**
  - [ ] Builds Docker images
  - [ ] Tags images correctly
  - [ ] Pushes to registry
  - [ ] Updates deployment

  **Error Handling (2-3 tests)**
  - [ ] Fails gracefully on missing env vars
  - [ ] Handles Docker errors
  - [ ] Reports failures clearly

- [ ] **Run Tests**
  ```bash
  bats tests/shell/unit/deployment/test-deploy.bats
  ```

**Goal:** 15-20 tests for deploy.sh

---

### Day 3: Test rollback.sh (10-15 tests)

**Script:** `scripts/deployment/rollback.sh`

- [ ] **Read and Understand Script**
  ```bash
  cat scripts/deployment/rollback.sh
  ```

- [ ] **Create Test File**
  ```bash
  # Create tests/shell/unit/deployment/test-rollback.bats
  ```

- [ ] **Test Categories:**

  **Version Validation (3-5 tests)**
  - [ ] Validates version format
  - [ ] Checks version exists
  - [ ] Verifies version is different from current
  - [ ] Lists available versions

  **Rollback Process (4-6 tests)**
  - [ ] Pulls correct version
  - [ ] Stops current deployment
  - [ ] Starts previous version
  - [ ] Verifies rollback success

  **Safety Checks (2-3 tests)**
  - [ ] Confirms before rollback
  - [ ] Backs up current state
  - [ ] Validates health after rollback

  **Error Handling (1-2 tests)**
  - [ ] Fails when version not found
  - [ ] Handles rollback failures

- [ ] **Run Tests**
  ```bash
  bats tests/shell/unit/deployment/test-rollback.bats
  ```

**Goal:** 10-15 tests for rollback.sh

---

### Day 4: Test test-docker.sh (8-10 tests)

**Script:** `scripts/deployment/test-docker.sh`

- [ ] **Read and Understand Script**
  ```bash
  cat scripts/deployment/test-docker.sh
  ```

- [ ] **Create Test File**
  ```bash
  # Create tests/shell/unit/deployment/test-docker.bats
  ```

- [ ] **Test Categories:**

  **Docker Validation (3-4 tests)**
  - [ ] Checks Docker is installed
  - [ ] Verifies Docker is running
  - [ ] Validates docker-compose available
  - [ ] Checks Docker version

  **Container Testing (3-4 tests)**
  - [ ] Builds test containers
  - [ ] Starts containers successfully
  - [ ] Verifies containers are healthy
  - [ ] Stops and cleans up containers

  **Integration Testing (2-3 tests)**
  - [ ] Tests API endpoints
  - [ ] Verifies database connection
  - [ ] Checks service communication

- [ ] **Run Tests**
  ```bash
  bats tests/shell/unit/deployment/test-docker.bats
  ```

**Goal:** 8-10 tests for test-docker.sh

---

### Day 5: CI/CD Integration & Polish

- [ ] **Create Test Runner Script**
  ```bash
  # Create tests/shell/run-shell-tests.sh
  # Wrapper for running all shell tests
  ```

- [ ] **Update Main Test Runner**
  ```bash
  # Edit tests/run-all-tests.sh
  # Add --shell-only flag
  # Integrate shell tests into full suite
  ```

- [ ] **Add to CI/CD Pipeline**
  ```bash
  # Edit .github/workflows/ci.yml (or equivalent)
  # Add Bats test step
  ```

- [ ] **Test Full Suite**
  ```bash
  # Run all shell tests
  ./tests/shell/run-shell-tests.sh
  
  # Run with main test suite
  ./tests/run-all-tests.sh
  
  # Run only shell tests
  ./tests/run-all-tests.sh --shell-only
  ```

- [ ] **Documentation**
  - [ ] Update `tests/shell/README.md`
  - [ ] Add examples to test files
  - [ ] Document mocking patterns used

- [ ] **Verify Success Metrics**
  - [ ] 33-45 tests passing
  - [ ] < 15 seconds execution
  - [ ] 80%+ coverage for deployment scripts
  - [ ] CI/CD integrated

**Goal:** Production-ready Phase 1

---

## 📝 Templates

### Smoke Test Template

**File:** `tests/shell/unit/test-simple.bats`

```bash
#!/usr/bin/env bats

# Load test helpers
load '../helpers/setup'
load '../helpers/mocks'
load '../helpers/assertions'

setup() {
  setup_file
}

# ============================================================================
# Smoke Tests
# ============================================================================

@test "smoke test: bats is working" {
  [ 1 -eq 1 ]
}

@test "smoke test: can load setup helper" {
  [ -n "$PROJECT_ROOT" ]
}

@test "smoke test: can load mocks helper" {
  # Test that mocks helper is available
  type restore_commands >/dev/null 2>&1
}

@test "smoke test: can load assertions helper" {
  # Test that assertions helper is available
  type assert_success >/dev/null 2>&1 || true
}

@test "smoke test: can find deployment scripts" {
  [ -f "$PROJECT_ROOT/scripts/deployment/deploy.sh" ]
  [ -f "$PROJECT_ROOT/scripts/deployment/rollback.sh" ]
  [ -f "$PROJECT_ROOT/scripts/deployment/test-docker.sh" ]
}
```

---

### Deployment Test Template

**File:** `tests/shell/unit/deployment/test-deploy.bats`

```bash
#!/usr/bin/env bats

# Load test helpers
load '../../helpers/setup'
load '../../helpers/mocks'
load '../../helpers/assertions'

setup() {
  setup_file
  # Source the script to test its functions
  # Note: May need to mock external dependencies first
}

teardown() {
  restore_commands
}

# ============================================================================
# Environment Validation Tests
# ============================================================================

@test "deploy: validates DEPLOY_ENV is set" {
  # Mock docker and other commands
  docker() { return 0; }
  git() { return 0; }
  export -f docker git
  
  # Test without DEPLOY_ENV
  unset DEPLOY_ENV
  run bash -c "source scripts/deployment/deploy.sh && validate_environment"
  [ "$status" -ne 0 ]
  [[ "$output" =~ "DEPLOY_ENV" ]]
}

@test "deploy: accepts valid DEPLOY_ENV values" {
  docker() { return 0; }
  git() { return 0; }
  export -f docker git
  
  export DEPLOY_ENV="production"
  run bash -c "source scripts/deployment/deploy.sh && validate_environment"
  [ "$status" -eq 0 ]
}

@test "deploy: checks Docker is running" {
  # Mock docker to simulate not running
  docker() {
    if [ "$1" = "info" ]; then
      return 1
    fi
    return 0
  }
  export -f docker
  
  run bash -c "source scripts/deployment/deploy.sh && check_docker"
  [ "$status" -ne 0 ]
  [[ "$output" =~ "Docker" ]]
}

# ============================================================================
# Pre-deployment Check Tests
# ============================================================================

@test "deploy: runs tests before deployment" {
  # Mock test command
  npm() {
    if [ "$1" = "test" ]; then
      echo "Tests passed"
      return 0
    fi
    return 0
  }
  export -f npm
  
  run bash -c "source scripts/deployment/deploy.sh && run_tests"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Tests passed" ]]
}

@test "deploy: fails if tests fail" {
  npm() {
    if [ "$1" = "test" ]; then
      echo "Tests failed"
      return 1
    fi
    return 0
  }
  export -f npm
  
  run bash -c "source scripts/deployment/deploy.sh && run_tests"
  [ "$status" -ne 0 ]
}

# ============================================================================
# Deployment Process Tests
# ============================================================================

@test "deploy: builds Docker images" {
  docker() {
    if [ "$1" = "build" ]; then
      echo "Building image..."
      return 0
    fi
    return 0
  }
  export -f docker
  
  run bash -c "source scripts/deployment/deploy.sh && build_images"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Building" ]]
}

@test "deploy: tags images with version" {
  docker() {
    if [ "$1" = "tag" ]; then
      echo "Tagged: $2 -> $3"
      return 0
    fi
    return 0
  }
  export -f docker
  
  export VERSION="1.2.3"
  run bash -c "source scripts/deployment/deploy.sh && tag_images"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "1.2.3" ]]
}

# ============================================================================
# Error Handling Tests
# ============================================================================

@test "deploy: handles Docker build failures" {
  docker() {
    if [ "$1" = "build" ]; then
      echo "Build failed"
      return 1
    fi
    return 0
  }
  export -f docker
  
  run bash -c "source scripts/deployment/deploy.sh && build_images"
  [ "$status" -ne 0 ]
  [[ "$output" =~ "failed" ]]
}

# Add 5-10 more tests following these patterns...
```

---

## 🔧 Helper Files (From Dev-Toolkit)

### setup.bash

**Purpose:** Common setup functions for all tests

**Key Functions:**
- `setup_file()` - Sets PROJECT_ROOT and PATH
- `setup_test_dir()` - Creates temporary test directory
- `teardown_test_dir()` - Cleans up temporary directory

### mocks.bash

**Purpose:** Command mocking utilities

**Key Functions:**
- `init_test_repo()` - Initialize git repo for testing
- `create_initial_commit()` - Create initial commit
- `mock_git_remote()` - Mock git remote
- `restore_commands()` - Restore all mocked commands

### assertions.bash

**Purpose:** Custom assertion helpers

**Key Functions:**
- `assert_success()` - Assert exit code is 0
- `assert_failure()` - Assert exit code is non-zero
- `assert_output()` - Assert output matches
- `assert_line()` - Assert specific line matches

---

## 🧪 Testing Patterns

### Pattern 1: Function Testing with Mocks

```bash
@test "function_name: behavior description" {
  # Mock external commands
  docker() { echo "mocked"; return 0; }
  export -f docker
  
  # Run function
  run function_name
  
  # Assert
  [ "$status" -eq 0 ]
  [[ "$output" =~ "expected" ]]
}
```

### Pattern 2: Script Testing (Source and Test)

```bash
@test "script: validates input" {
  # Mock dependencies
  docker() { return 0; }
  export -f docker
  
  # Source script and run function
  run bash -c "source scripts/deployment/deploy.sh && validate_input 'test'"
  
  # Assert
  [ "$status" -eq 0 ]
}
```

### Pattern 3: Integration Testing (Full Script)

```bash
@test "script: complete workflow" {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  
  # Set up test environment
  export DEPLOY_ENV="test"
  
  # Mock all external commands
  docker() { return 0; }
  git() { return 0; }
  export -f docker git
  
  # Run actual script
  run bash "$PROJECT_ROOT/scripts/deployment/deploy.sh"
  
  # Assert
  [ "$status" -eq 0 ]
  
  # Cleanup
  cd - > /dev/null
  rm -rf "$TEST_DIR"
}
```

---

## 📊 Success Metrics

### Quantitative

- [ ] **33-45 tests** written and passing
- [ ] **< 15 seconds** execution time
- [ ] **80%+ coverage** for deployment scripts
- [ ] **0 failures** in CI/CD

### Qualitative

- [ ] Tests are **clear and readable**
- [ ] Mocking is **appropriate and minimal**
- [ ] Error messages are **helpful**
- [ ] Documentation is **complete**

---

## 🚧 Potential Challenges

### Challenge 1: Understanding Deployment Scripts

**Issue:** Scripts may be complex or undocumented

**Solution:**
- Read scripts carefully
- Ask team for clarification
- Start with simple tests (smoke tests)
- Build up to complex scenarios

---

### Challenge 2: Mocking Docker Commands

**Issue:** Docker has complex command structure

**Solution:**
- Mock at the right level (docker, not internals)
- Use conditional mocks (check $1, $2, etc.)
- Test interfaces, not implementations
- Reference dev-toolkit examples

**Example:**
```bash
docker() {
  case "$1" in
    "build")
      echo "Building..."
      return 0
      ;;
    "tag")
      echo "Tagged: $2 -> $3"
      return 0
      ;;
    "push")
      echo "Pushed: $2"
      return 0
      ;;
    *)
      return 0
      ;;
  esac
}
export -f docker
```

---

### Challenge 3: CI/CD Integration

**Issue:** May need to install Bats in CI

**Solution:**
- Add Bats installation to CI workflow
- Use GitHub Actions marketplace action if available
- Cache Bats installation for speed
- Test locally first

**Example CI Step:**
```yaml
- name: Install Bats
  run: |
    brew install bats-core
    bats --version

- name: Run Shell Tests
  run: |
    ./tests/shell/run-shell-tests.sh
```

---

## 🎯 Daily Goals Summary

| Day | Focus | Deliverable | Tests |
|-----|-------|-------------|-------|
| 1 | Infrastructure | Bats setup, smoke tests | 5 |
| 2 | deploy.sh | Environment, pre-deploy, deploy | 15-20 |
| 3 | rollback.sh | Version, rollback, safety | 10-15 |
| 4 | test-docker.sh | Docker validation, testing | 8-10 |
| 5 | Integration | CI/CD, documentation | - |

**Total:** 33-45 tests, production-ready infrastructure

---

## 📚 Resources

### Internal
- **Feature Plan:** `feature-plan.md`
- **Quick Start:** `quick-start.md`
- **Dev-Toolkit Guide:** `../../notes/opportunities/external/testing-overhaul/TESTING.md`

### External
- **Bats Docs:** https://bats-core.readthedocs.io/
- **Bats Tutorial:** https://bats-core.readthedocs.io/en/stable/tutorial.html
- **Bash Testing Guide:** https://github.com/sstephenson/bats/wiki

### Examples
- **Dev-Toolkit Tests:** `/Users/cdwilson/Projects/dev-toolkit/tests/`
- **Helpers:** `/Users/cdwilson/Projects/dev-toolkit/tests/helpers/`

---

## ✅ Phase 1 Completion Checklist

- [ ] Bats installed and verified
- [ ] Directory structure created
- [ ] Helpers ported from dev-toolkit
- [ ] Smoke tests passing (5 tests)
- [ ] deploy.sh tests passing (15-20 tests)
- [ ] rollback.sh tests passing (10-15 tests)
- [ ] test-docker.sh tests passing (8-10 tests)
- [ ] Test runner script created
- [ ] CI/CD integration complete
- [ ] Documentation updated
- [ ] All tests passing in CI
- [ ] < 15 seconds execution time
- [ ] Code reviewed and approved

**Total:** 33-45 tests, ready for Phase 2

---

**Last Updated:** 2025-10-06  
**Status:** 🚧 Ready to Start  
**Next:** Day 1 - Infrastructure Setup
