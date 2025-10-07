# Bats Testing Suite Setup Review

**Date:** 2025-10-06  
**Status:** 🔍 Audit & Adaptation

---

## 🎯 Purpose

Review and adapt the Bats testing suite for **Pokehub's specific needs**, not just copy dev-toolkit blindly.

---

## ✅ What We Have (Current State)

### Helper Files

1. **`helpers/setup.bash`** (57 lines)
   - ✅ `setup_file()` - Sets PROJECT_ROOT
   - ✅ `setup_test_dir()` - Creates temp directories
   - ✅ `teardown_test_dir()` - Cleanup
   - ✅ `init_test_repo()` - Git repo for testing
   - ✅ `create_initial_commit()` - Initial commit
   - ⚠️ **FIXED:** Removed `DT_ROOT` (dev-toolkit specific)
   - ⚠️ **FIXED:** Changed `bin/` to `scripts/` for Pokehub

2. **`helpers/mocks.bash`** (107 lines)
   - ✅ `mock_git_remote()` - Mock git remote URL
   - ✅ `mock_gh_repo_view()` - Mock GitHub repo view
   - ✅ **ADDED:** `mock_docker_success()` - Mock Docker commands
   - ✅ **ADDED:** `mock_docker_failure()` - Mock Docker failures
   - ✅ **ADDED:** `mock_curl_success()` - Mock curl success
   - ✅ **ADDED:** `mock_curl_failure()` - Mock curl failures
   - ✅ **ADDED:** `mock_sleep()` - Speed up tests
   - ✅ `restore_commands()` - Cleanup mocks

3. **`helpers/assertions.bash`** (53 lines)
   - ✅ `assert_output_contains()` - Check output
   - ✅ `assert_var_set()` - Check variable is set
   - ✅ `assert_var_equals()` - Check variable value
   - ✅ `assert_file_exists()` - Check file exists
   - ✅ `assert_dir_exists()` - Check directory exists

### Test Files

1. **`unit/test-simple.bats`** (7 tests) ✅
   - Smoke tests for infrastructure
   - All passing

2. **`unit/deployment/test-deploy.bats`** (20 tests) ✅
   - Deploy script tests
   - All passing
   - Fast execution (< 5 seconds)

**Total:** 27 tests, 100% passing

---

## 🔍 What's Good (Keep As-Is)

### ✅ Helpers are Useful

1. **setup.bash** - Core functionality we need:
   - PROJECT_ROOT detection works
   - Temp directory management useful
   - Git repo initialization (for future git-related tests)

2. **mocks.bash** - Pokehub-adapted:
   - Docker mocks (for deployment/core scripts)
   - curl mocks (for health checks)
   - sleep mocks (speed up tests)
   - Git/gh mocks (for future use)

3. **assertions.bash** - Generic and useful:
   - Output checking
   - File/directory existence
   - Variable validation

### ✅ Test Structure is Good

```
tests/shell/
├── helpers/          # Reusable utilities
├── unit/            # Unit tests
│   ├── deployment/  # Deployment scripts
│   ├── core/        # Core scripts (future)
│   └── monitoring/  # Monitoring scripts (future)
└── integration/     # Integration tests (future)
```

---

## 🚨 What Needs Attention

### 1. Missing Pokehub-Specific Mocks

**What we're testing:**
- Deployment scripts (deploy.sh, rollback.sh, test-docker.sh)
- Core scripts (docker-startup.sh, health-check.sh, invalidate-cache.sh)
- Monitoring scripts (status-check.sh, verify-status.sh, weekly-review.sh)

**Additional mocks we might need:**

```bash
# For docker-compose operations
mock_docker_compose_success() {
  docker-compose() {
    case "$1" in
      "up") echo "Starting services..."; return 0 ;;
      "down") echo "Stopping services..."; return 0 ;;
      "ps") echo "SERVICE   STATUS"; return 0 ;;
      *) return 0 ;;
    esac
  }
  export -f docker-compose
}

# For Redis operations (health-check.sh)
mock_redis_cli_success() {
  redis-cli() {
    if [ "$1" = "ping" ]; then
      echo "PONG"
      return 0
    fi
    return 0
  }
  export -f redis-cli
}

# For Python/Flask operations
mock_python_success() {
  python() {
    echo "Python 3.9.0"
    return 0
  }
  export -f python
}

# For npm operations
mock_npm_success() {
  npm() {
    case "$1" in
      "test") echo "Tests passed"; return 0 ;;
      "run") echo "Running..."; return 0 ;;
      *) return 0 ;;
    esac
  }
  export -f npm
}
```

### 2. Missing Pokehub-Specific Assertions

**What we might need:**

```bash
# Assert HTTP status code
assert_http_status() {
  local url="$1"
  local expected="$2"
  local actual=$(curl -s -o /dev/null -w "%{http_code}" "$url")
  if [ "$actual" != "$expected" ]; then
    echo "Expected HTTP $expected, got $actual"
    return 1
  fi
}

# Assert container is running
assert_container_running() {
  local container="$1"
  if ! docker ps --filter "name=$container" --format "{{.Names}}" | grep -q "$container"; then
    echo "Expected container $container to be running"
    return 1
  fi
}

# Assert service is healthy
assert_service_healthy() {
  local service="$1"
  # Pokehub-specific health check logic
}
```

### 3. Test Coverage Strategy

**Current:** Testing CLI interface and script structure (good start!)

**Missing:**
- Function-level testing (test individual functions)
- Integration testing (test full workflows)
- Error condition coverage (more failure scenarios)

**Recommendation:** Keep current approach for now (CLI + structure tests), add function tests later if needed.

---

## 📋 Action Items

### Immediate (Now) ✅ COMPLETE

- [x] ✅ Fix setup.bash (remove DT_ROOT, fix paths)
- [x] ✅ Add Docker/curl/sleep mocks to mocks.bash
- [x] ✅ Verify all tests pass (27/27 ✅)
- [x] ✅ Add Pokehub-specific mocks (docker-compose, redis-cli, Python, npm, psql)
- [x] ✅ Add Pokehub-specific assertions (HTTP, containers, services, Pokemon API)
- [x] ✅ Document what each helper does (helpers/README.md)

### Short-term (This Week)

- [ ] Test rollback.sh (10-15 tests)
- [ ] Test test-docker.sh (8-10 tests)
- [ ] Add more deployment test scenarios
- [ ] Create test runner script

### Long-term (Next Weeks)

- [ ] Test core scripts (Phase 2)
- [ ] Test monitoring scripts (Phase 3)
- [ ] Add integration tests
- [ ] CI/CD integration

---

## 🎯 Recommended Approach

### Keep It Simple & Practical

1. **Test the Interface, Not Implementation**
   - Test CLI arguments and outputs
   - Test error messages
   - Test exit codes
   - Don't over-mock internals

2. **Focus on What Matters**
   - Deployment scripts (CRITICAL)
   - Core scripts (HIGH)
   - Monitoring scripts (MEDIUM)
   - Skip low-value tests

3. **Fast Tests Win**
   - Mock external services
   - Use timeouts
   - Avoid real Docker/network calls
   - Current: 27 tests in < 5 seconds ✅

4. **Adapt, Don't Copy**
   - Use dev-toolkit as inspiration
   - Adapt for Pokehub's needs
   - Don't blindly copy patterns

---

## ✅ Current Status: GOOD!

**What's Working:**
- ✅ Infrastructure set up correctly
- ✅ Helpers adapted for Pokehub
- ✅ 27 tests passing
- ✅ Fast execution
- ✅ Good test structure

**What's Next:**
- Add Pokehub-specific mocks/assertions
- Continue with rollback.sh and test-docker.sh
- Keep adapting as we go

---

## 🚀 Verdict

**The setup is good!** We've adapted the basics from dev-toolkit and made them Pokehub-specific. Now we should:

1. **Add more Pokehub-specific utilities as needed** (don't pre-build everything)
2. **Continue testing deployment scripts** (rollback.sh, test-docker.sh)
3. **Keep tests simple and fast** (current approach is working)
4. **Iterate and improve** (add helpers when we need them)

**Don't overthink it** - we're on the right track!

---

**Last Updated:** 2025-10-06  
**Status:** ✅ Setup is good, continue with Day 2-3  
**Next:** Add Pokehub-specific mocks, test rollback.sh
