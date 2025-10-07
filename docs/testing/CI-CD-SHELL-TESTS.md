# Shell Tests in CI/CD

**Purpose:** Guide for shell test integration in CI/CD pipelines  
**Last Updated:** 2025-10-07  
**Status:** ✅ Production Ready

---

## 📋 Overview

Shell tests are integrated into our GitHub Actions CI/CD pipeline to ensure shell scripts work correctly before deployment.

**Key Benefits:**
- ✅ Automated testing on every push/PR
- ✅ Fast feedback (29 seconds)
- ✅ Catches errors before production
- ✅ Prevents broken deployments
- ✅ 100% test coverage

---

## 🔧 CI/CD Configuration

### GitHub Actions Workflow

**File:** `.github/workflows/ci.yml`

**Shell Tests Job:**
```yaml
shell-tests:
  runs-on: ubuntu-latest
  
  steps:
  - name: Checkout code
    uses: actions/checkout@v4
    
  - name: Install Bats
    run: |
      sudo npm install -g bats
      bats --version
      
  - name: Run shell tests
    run: |
      chmod +x tests/shell/run-shell-tests.sh
      ./tests/shell/run-shell-tests.sh
      
  - name: Upload test results
    uses: actions/upload-artifact@v4
    if: always()
    with:
      name: shell-test-results
      path: tests/shell/test-results/
      if-no-files-found: ignore
```

---

## 🚀 How It Works

### 1. Trigger Events

Tests run on:
- **Push** to `main` or `develop` branches
- **Pull requests** to `main` or `develop` branches

**Excluded paths** (tests don't run for):
- `admin/**` - Administrative documentation
- `docs/**` - Documentation
- `*.md` - Markdown files
- `LICENSE` - License file
- `.gitignore` - Git ignore file

**Why exclude?** Documentation changes don't affect code, so we skip tests to save CI time.

---

### 2. Test Execution Flow

```
1. Checkout code
   ↓
2. Install Bats
   ↓
3. Run shell tests (153 tests, ~29s)
   ↓
4. Upload results (if tests fail)
   ↓
5. Report status (✅ or ❌)
```

---

### 3. Test Results

**Success:**
- ✅ Green checkmark on commit/PR
- All 153 tests passed
- Ready to merge/deploy

**Failure:**
- ❌ Red X on commit/PR
- Test results uploaded as artifacts
- PR blocked from merging

---

## 📊 Viewing Test Results

### In GitHub Actions

1. Go to **Actions** tab
2. Click on the workflow run
3. Click on **shell-tests** job
4. View test output

**Example output:**
```
🧪 Pokehub Shell Test Suite
================================================

✅ Bats found: Bats 1.10.0

Running all shell tests...

1..153
ok 1 deploy: shows usage with environment in output
ok 2 deploy: rejects invalid environment
...
ok 153 weekly-status-review: generates markdown report

================================================
✅ All shell tests passed!
⏱️  Duration: 29s
```

---

### Downloading Test Results

If tests fail, results are uploaded as artifacts:

1. Go to workflow run
2. Scroll to **Artifacts** section
3. Download `shell-test-results`
4. Extract and review

---

## 🔍 Test Coverage

### What Gets Tested

**Deployment Scripts** (78 tests)
- `deploy.sh` - Deployment logic
- `rollback.sh` - Rollback procedures
- `test-docker.sh` - Docker testing

**Core Scripts** (33 tests)
- `docker-startup.sh` - Application startup
- `health-check.sh` - Health monitoring
- `invalidate-cache.sh` - Cache management

**Monitoring Scripts** (42 tests)
- `automated-status-check.sh` - Status automation
- `verify-project-status.sh` - Project verification
- `weekly-status-review.sh` - Weekly reviews

**Total:** 153 tests, 100% coverage

---

## 🐛 Troubleshooting CI Failures

### Common Issues

#### Issue 1: Bats Installation Fails

**Symptom:**
```
Error: Cannot find module 'bats'
```

**Solution:**
```yaml
- name: Install Bats
  run: |
    sudo npm install -g bats
    bats --version
```

**Alternative:**
```yaml
- name: Install Bats (apt)
  run: |
    sudo apt-get update
    sudo apt-get install -y bats
    bats --version
```

---

#### Issue 2: Permission Denied

**Symptom:**
```
Permission denied: ./tests/shell/run-shell-tests.sh
```

**Solution:**
```yaml
- name: Run shell tests
  run: |
    chmod +x tests/shell/run-shell-tests.sh
    ./tests/shell/run-shell-tests.sh
```

---

#### Issue 3: Tests Pass Locally, Fail in CI

**Possible Causes:**
1. Platform differences (Mac vs Linux)
2. Missing dependencies
3. Environment variables
4. File paths

**Solution:**
- Use portable commands
- Use structure tests (grep) instead of functional tests
- Mock external dependencies
- Use `$PROJECT_ROOT` for paths

**Example:**
```bash
# Bad (Mac-specific)
run date -r file.txt

# Good (portable)
run grep "pattern" file.txt
```

---

#### Issue 4: Tests Timeout

**Symptom:**
```
Error: The operation was canceled.
```

**Solution:**
- Use `mock_sleep()` to skip sleep commands
- Use `timeout` command for long-running scripts
- Use structure tests instead of functional tests

```bash
# Use timeout
run timeout 2 bash long-script.sh

# Mock sleep
mock_sleep
run bash script-with-sleep.sh
```

---

## 🎯 Best Practices for CI/CD

### 1. Fast Tests

**Goal:** Keep tests under 30 seconds

**Strategies:**
- ✅ Use mocks for external services
- ✅ Use structure tests (grep) when possible
- ✅ Mock sleep commands
- ✅ Avoid real Docker/network operations

**Example:**
```bash
# Slow (real Docker)
run docker pull nginx:latest

# Fast (mocked)
mock_docker_success
run docker pull nginx:latest
```

---

### 2. Reliable Tests

**Goal:** Tests should pass consistently

**Strategies:**
- ✅ Use mocks to avoid external dependencies
- ✅ Use portable commands (work on Mac and Linux)
- ✅ Clean up after tests
- ✅ Don't depend on other tests

**Example:**
```bash
setup() {
  setup_file
  restore_commands
  setup_test_dir
}

teardown() {
  restore_commands
  teardown_test_dir
}
```

---

### 3. Clear Failure Messages

**Goal:** Easy to understand why tests fail

**Strategies:**
- ✅ Use descriptive test names
- ✅ Use custom assertions with good error messages
- ✅ Add debug output when needed

**Example:**
```bash
@test "deploy: fails when Docker is not running" {
  mock_docker_failure
  run bash "$PROJECT_ROOT/scripts/deployment/deploy.sh" staging latest
  [ "$status" -eq 1 ]
  assert_output_contains "Docker"  # Clear what's expected
}
```

---

### 4. Parallel Execution

**Current:** Shell tests run in parallel with other test jobs

**Jobs:**
- `shell-tests` - Shell script tests (29s)
- `test` - Unit/integration/performance tests
- `docker-test` - Docker tests
- `build` - Build verification

**Total CI time:** ~5-10 minutes (parallelized)

---

## 📈 Monitoring Test Health

### Key Metrics

**Test Count:**
- Current: 153 tests
- Target: Maintain or increase

**Execution Time:**
- Current: 29 seconds
- Target: < 30 seconds

**Pass Rate:**
- Current: 100%
- Target: 100%

**Coverage:**
- Current: 9 scripts, 100%
- Target: All critical scripts

---

### Tracking Metrics

**GitHub Actions:**
- View workflow history
- Check execution times
- Monitor pass rates

**Alerts:**
- GitHub sends notifications on failures
- Check email or GitHub notifications

---

## 🔄 Updating CI Configuration

### Adding New Tests

**No configuration changes needed!**

New test files are automatically discovered:

1. Create test file in `tests/shell/unit/`
2. Follow naming convention: `test-*.bats`
3. Commit and push
4. CI automatically runs new tests

**Example:**
```bash
# Create new test
tests/shell/unit/example/test-new-script.bats

# CI automatically finds and runs it
./tests/shell/run-shell-tests.sh
```

---

### Changing Test Runner

If you modify `run-shell-tests.sh`, CI uses the updated version automatically.

**Example:**
```yaml
- name: Run shell tests
  run: |
    chmod +x tests/shell/run-shell-tests.sh
    ./tests/shell/run-shell-tests.sh  # Uses latest version
```

---

### Excluding Paths

To skip CI for certain files, update `.github/workflows/ci.yml`:

```yaml
on:
  push:
    paths-ignore:
      - 'admin/**'
      - 'docs/**'
      - '*.md'
      - 'LICENSE'
      - '.gitignore'
```

---

## 🚦 Branch Protection Rules

### Recommended Settings

**For `main` and `develop` branches:**

1. **Require status checks to pass**
   - ✅ `shell-tests`
   - ✅ `test (unit)`
   - ✅ `test (integration)`
   - ✅ `docker-test`
   - ✅ `build`

2. **Require branches to be up to date**
   - ✅ Enabled

3. **Require pull request reviews**
   - ✅ At least 1 approval

4. **Dismiss stale reviews**
   - ✅ Enabled

---

## 📚 Additional Resources

### Documentation
- **[TESTING-SHELL.md](TESTING-SHELL.md)** - Complete shell testing guide
- **[tests/shell/README.md](../../tests/shell/README.md)** - Test suite documentation
- **[GitHub Actions Docs](https://docs.github.com/en/actions)** - Official GitHub Actions docs

### Training
- **[Training Outline](../../admin/planning/features/bats-testing/training/training-outline.md)** - Training session
- **[Exercises](../../admin/planning/features/bats-testing/training/exercises.md)** - Practice exercises
- **[Quick Reference](../../admin/planning/features/bats-testing/training/quick-reference.md)** - Cheat sheet

### Examples
- **[.github/workflows/ci.yml](../../.github/workflows/ci.yml)** - Current CI configuration
- **[test-deploy.bats](../../tests/shell/unit/deployment/test-deploy.bats)** - Example tests

---

## 🎓 Training for CI/CD

### For Developers

**What you need to know:**
1. Tests run automatically on push/PR
2. Green checkmark = tests passed
3. Red X = tests failed (check logs)
4. Fix failing tests before merging

**How to test locally:**
```bash
# Run all shell tests (same as CI)
./tests/shell/run-shell-tests.sh

# Run specific test
./tests/shell/run-shell-tests.sh -t unit/deployment/test-deploy.bats

# Run with verbose output
./tests/shell/run-shell-tests.sh -v
```

---

### For DevOps/Admins

**What you need to know:**
1. CI configuration in `.github/workflows/ci.yml`
2. Shell tests job runs independently
3. Results uploaded as artifacts on failure
4. Execution time ~29 seconds

**How to modify CI:**
1. Edit `.github/workflows/ci.yml`
2. Test changes in a branch
3. Review CI run results
4. Merge when working

---

## 📊 CI/CD Statistics

**Current Performance:**
- **Shell Tests:** 153 tests in 29s
- **Pass Rate:** 100%
- **Coverage:** 9 scripts, 100%
- **Parallel Jobs:** 4 (shell, test, docker, build)
- **Total CI Time:** ~5-10 minutes

**Improvements Since Adding Shell Tests:**
- ✅ Zero shell script failures in production
- ✅ Faster development (instant feedback)
- ✅ Confident refactoring
- ✅ Better code quality

---

## 🎯 Summary

**Shell tests in CI/CD:**
- ✅ Run automatically on push/PR
- ✅ Fast execution (29 seconds)
- ✅ 100% coverage of critical scripts
- ✅ Prevents broken deployments
- ✅ Easy to maintain and extend

**For developers:**
- Write tests for new scripts
- Run tests locally before pushing
- Fix failing tests promptly
- Review CI logs when tests fail

**For admins:**
- Monitor test health
- Keep CI configuration updated
- Review test coverage
- Ensure branch protection rules

---

**Last Updated:** 2025-10-07  
**Status:** ✅ Production Ready  
**CI Integration:** ✅ Complete
