# Shell Script Testing Guide

**Last Updated:** 2025-10-07  
**Status:** ✅ Production Ready  
**Test Suite:** 153 tests, 29s execution, 100% coverage

---

## 📋 Table of Contents

1. [Overview](#1-overview)
2. [Getting Started](#2-getting-started)
3. [Running Tests](#3-running-tests)
4. [Writing Tests](#4-writing-tests)
5. [Helper Functions](#5-helper-functions) *(See Part 2)*
6. [Mocking](#6-mocking) *(See Part 2)*
7. [Assertions](#7-assertions) *(See Part 2)*
8. [Best Practices](#8-best-practices) *(See Part 2)*
9. [Common Patterns](#9-common-patterns) *(See Part 2)*
10. [Troubleshooting](#10-troubleshooting) *(See Part 2)*

---

## 1. Overview

### What is Bats?

**Bats** (Bash Automated Testing System) is a TAP-compliant testing framework for Bash scripts. It provides a simple way to verify that shell scripts behave as expected.

**Key Features:**
- ✅ Simple, readable test syntax
- ✅ TAP (Test Anything Protocol) output
- ✅ Easy integration with CI/CD
- ✅ Support for setup/teardown
- ✅ Parallel test execution
- ✅ Rich assertion library

**Official Documentation:** https://github.com/bats-core/bats-core

---

### Why Shell Script Testing?

Shell scripts are critical infrastructure code that often:
- Deploy applications
- Manage services
- Monitor systems
- Automate workflows

**Without testing, shell scripts can:**
- ❌ Fail silently in production
- ❌ Have hidden edge cases
- ❌ Break when dependencies change
- ❌ Be difficult to refactor safely

**With Bats testing:**
- ✅ Catch errors before deployment
- ✅ Document expected behavior
- ✅ Enable safe refactoring
- ✅ Provide fast feedback (< 30s)
- ✅ Integrate with CI/CD pipelines

---

### Our Test Suite

Pokehub has a comprehensive Bats test suite covering all critical shell scripts:

**Statistics:**
- **153 tests** across 9 scripts
- **29 seconds** execution time
- **100% coverage** of critical scripts
- **100% pass rate** in CI/CD

**Coverage by Category:**

| Category | Scripts | Tests | Coverage |
|----------|---------|-------|----------|
| Deployment | 3 | 78 | 100% |
| Core | 3 | 33 | 100% |
| Monitoring | 3 | 42 | 100% |
| **Total** | **9** | **153** | **100%** |

**Test Distribution:**

```
Deployment Scripts (78 tests)
├── deploy.sh (20 tests)
├── rollback.sh (35 tests)
└── test-docker.sh (23 tests)

Core Scripts (33 tests)
├── docker-startup.sh (12 tests)
├── health-check.sh (12 tests)
└── invalidate-cache.sh (9 tests)

Monitoring Scripts (42 tests)
├── automated-status-check.sh (18 tests)
├── verify-project-status.sh (13 tests)
└── weekly-status-review.sh (11 tests)
```

---

## 2. Getting Started

### Prerequisites

**1. Install Bats**

```bash
# macOS (using Homebrew)
brew install bats-core

# Ubuntu/Debian
sudo apt-get install bats

# From source
git clone https://github.com/bats-core/bats-core.git
cd bats-core
sudo ./install.sh /usr/local

# Verify installation
bats --version
```

**Expected output:**
```
Bats 1.10.0
```

**2. Verify Project Setup**

```bash
# Navigate to project root
cd /path/to/pokedex

# Verify test directory exists
ls tests/shell/

# Expected output:
# helpers/  unit/  run-shell-tests.sh
```

---

### Directory Structure

Our Bats test suite follows a clear, organized structure:

```
tests/shell/
├── helpers/                    # Test utilities
│   ├── setup.bash             # Setup functions
│   ├── mocks.bash             # Mock commands
│   └── assertions.bash        # Custom assertions
│
├── unit/                       # Unit tests
│   ├── deployment/            # Deployment script tests
│   │   ├── test-deploy.bats
│   │   ├── test-rollback.bats
│   │   └── test-test-docker.bats
│   │
│   ├── core/                  # Core script tests
│   │   ├── test-docker-startup.bats
│   │   ├── test-health-check.bats
│   │   └── test-invalidate-cache.bats
│   │
│   └── monitoring/            # Monitoring script tests
│       ├── test-automated-status-check.bats
│       ├── test-verify-project-status.bats
│       └── test-weekly-status-review.bats
│
├── run-shell-tests.sh         # Test runner
└── README.md                  # Documentation
```

**Key Directories:**

- **`helpers/`** - Reusable test utilities (setup, mocks, assertions)
- **`unit/`** - Test files organized by script category
- **`run-shell-tests.sh`** - Convenient test runner with options

---

### Running Your First Test

**1. Run All Tests**

```bash
./tests/shell/run-shell-tests.sh
```

**Expected output:**
```
🧪 Pokehub Shell Test Suite
================================================

✅ Bats found: Bats 1.10.0

Running all shell tests...

 ✓ smoke test: bats is working
 ✓ deploy: shows usage with environment in output
 ✓ deploy: rejects invalid environment
 ...
 ✓ weekly-status-review: generates markdown report

153 tests, 0 failures

================================================
✅ All shell tests passed!
⏱️  Duration: 29s
```

**2. Run a Specific Test File**

```bash
./tests/shell/run-shell-tests.sh -t unit/deployment/test-deploy.bats
```

**3. Run with Verbose Output**

```bash
./tests/shell/run-shell-tests.sh -v
```

**Congratulations!** You've run your first Bats tests. 🎉

---

### Understanding Test Output

Bats uses **TAP (Test Anything Protocol)** output format:

**Success:**
```
 ✓ test name
```

**Failure:**
```
 ✗ test name
   (in test file test-example.bats, line 10)
     `[ "$status" -eq 0 ]' failed
```

**Test Summary:**
```
153 tests, 0 failures
```

**Key Indicators:**
- ✓ (checkmark) - Test passed
- ✗ (cross) - Test failed
- Number of tests and failures at the end

---

## 3. Running Tests

### Basic Commands

**Run all shell tests:**
```bash
./tests/shell/run-shell-tests.sh
```

**Run specific test file:**
```bash
./tests/shell/run-shell-tests.sh -t unit/deployment/test-deploy.bats
```

**Run with verbose output:**
```bash
./tests/shell/run-shell-tests.sh -v
```

**Show help:**
```bash
./tests/shell/run-shell-tests.sh -h
```

---

### Test Runner Options

Our custom test runner (`run-shell-tests.sh`) provides several options:

| Option | Description | Example |
|--------|-------------|---------|
| `-t FILE` | Run specific test file | `-t unit/core/test-health-check.bats` |
| `-v` | Verbose output | `-v` |
| `-h` | Show help message | `-h` |

**Examples:**

```bash
# Run deployment tests only
./tests/shell/run-shell-tests.sh -t unit/deployment/

# Run with verbose output to see all details
./tests/shell/run-shell-tests.sh -v

# Get help
./tests/shell/run-shell-tests.sh -h
```

---

### Using Bats Directly

You can also run Bats directly for more control:

**Run all tests recursively:**
```bash
cd tests/shell
bats --recursive unit/
```

**Run specific test file:**
```bash
bats unit/deployment/test-deploy.bats
```

**Run with verbose output:**
```bash
bats --verbose-run unit/deployment/test-deploy.bats
```

**Run specific test by name:**
```bash
bats --filter "shows usage" unit/deployment/test-deploy.bats
```

**Run with timing:**
```bash
bats --timing unit/deployment/test-deploy.bats
```

---

### Understanding TAP Output

Bats outputs in **TAP (Test Anything Protocol)** format:

**Example output:**
```
1..3
ok 1 deploy: shows usage with environment in output
ok 2 deploy: rejects invalid environment
ok 3 deploy: fails when Docker is not running
```

**TAP Format:**
- `1..N` - Test plan (N = number of tests)
- `ok N` - Test N passed
- `not ok N` - Test N failed

**Verbose TAP output:**
```
# Running test: deploy: shows usage with environment in output
ok 1 deploy: shows usage with environment in output
  # Output:
  # staging
```

---

### CI/CD Integration

Our shell tests are integrated with GitHub Actions CI/CD:

**Workflow:** `.github/workflows/ci.yml`

```yaml
shell-tests:
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v3
    
    - name: Install Bats
      run: |
        sudo apt-get update
        sudo apt-get install -y bats
    
    - name: Run Shell Tests
      run: ./tests/shell/run-shell-tests.sh
    
    - name: Upload Test Results
      if: always()
      uses: actions/upload-artifact@v3
      with:
        name: shell-test-results
        path: tests/shell/results/
```

**CI/CD Features:**
- ✅ Runs on every push and PR
- ✅ Tests run in isolated environment
- ✅ Results uploaded as artifacts
- ✅ Fast feedback (< 30s)

**Viewing Results:**
1. Go to GitHub Actions tab
2. Click on the workflow run
3. Check "shell-tests" job
4. Download artifacts if needed

---

### Performance

Our test suite is optimized for speed:

**Execution Time:**
- **Total:** 29 seconds
- **Per test:** ~0.19 seconds average
- **Target:** < 30 seconds ✅

**Performance Tips:**
- Use mocks instead of real services
- Use structure tests (grep) for fast validation
- Avoid long-running commands
- Use timeouts for safety

**Example timing breakdown:**
```
Deployment tests: ~12s (78 tests)
Core tests: ~8s (33 tests)
Monitoring tests: ~9s (42 tests)
Total: ~29s (153 tests)
```

---

## 4. Writing Tests

### Basic Test Structure

A Bats test file has a simple structure:

```bash
#!/usr/bin/env bats

# Load helpers
load '../../helpers/setup'
load '../../helpers/mocks'
load '../../helpers/assertions'

# Setup function (runs before each test)
setup() {
  setup_file
  restore_commands
}

# Teardown function (runs after each test)
teardown() {
  restore_commands
}

# Test case
@test "description of what is being tested" {
  # Arrange: Set up test conditions
  mock_docker_success
  
  # Act: Run the command
  run bash "$PROJECT_ROOT/scripts/deployment/deploy.sh" staging latest
  
  # Assert: Verify the results
  [ "$status" -eq 0 ]
  assert_output_contains "staging"
}
```

**Key Components:**

1. **Shebang:** `#!/usr/bin/env bats`
2. **Load helpers:** Import reusable utilities
3. **Setup/teardown:** Prepare and clean up test environment
4. **Test cases:** `@test "description" { ... }`
5. **Assertions:** Verify expected behavior

---

### Test File Naming

**Convention:** `test-<script-name>.bats`

**Examples:**
```
test-deploy.bats          # Tests for deploy.sh
test-health-check.bats    # Tests for health-check.sh
test-docker-startup.bats  # Tests for docker-startup.sh
```

**Location:** Match the script's directory structure

```
scripts/deployment/deploy.sh
  → tests/shell/unit/deployment/test-deploy.bats

scripts/core/health-check.sh
  → tests/shell/unit/core/test-health-check.bats
```

---

### Test Naming

**Convention:** `<script>: <what is being tested>`

**Good test names:**
```bash
@test "deploy: shows usage with environment in output" { }
@test "deploy: rejects invalid environment" { }
@test "deploy: fails when Docker is not running" { }
@test "health-check: checks API endpoints with curl" { }
@test "health-check: exits with error on critical failure" { }
```

**Bad test names:**
```bash
@test "test deploy" { }              # Too vague
@test "it works" { }                 # Not descriptive
@test "deploy.sh line 42" { }        # Implementation detail
```

**Tips:**
- Start with script name for easy filtering
- Describe the behavior being tested
- Be specific and descriptive
- Use present tense
- Keep under 80 characters if possible

---

### Setup and Teardown

**Setup functions** run before each test:

```bash
setup() {
  setup_file              # Initialize PROJECT_ROOT
  restore_commands        # Restore any mocked commands
  setup_test_dir          # Create temporary directory (optional)
}
```

**Teardown functions** run after each test:

```bash
teardown() {
  restore_commands        # Clean up mocked commands
  teardown_test_dir       # Remove temporary directory (optional)
}
```

**File-level setup/teardown:**

```bash
setup_file() {
  # Runs once before all tests in the file
  export TEST_VAR="value"
}

teardown_file() {
  # Runs once after all tests in the file
  unset TEST_VAR
}
```

---

### Running Commands

Use the `run` command to execute commands in tests:

```bash
@test "example" {
  run echo "hello"
  [ "$status" -eq 0 ]
  [ "$output" = "hello" ]
}
```

**The `run` command:**
- Captures exit status in `$status`
- Captures output in `$output`
- Captures individual lines in `$lines` array
- Prevents test from exiting on command failure

**Variables available after `run`:**
- `$status` - Exit code (0 = success, non-zero = failure)
- `$output` - Complete output (stdout + stderr)
- `$lines` - Array of output lines

**Example:**
```bash
@test "multi-line output" {
  run bash -c "echo line1; echo line2; echo line3"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "line1" ]
  [ "${lines[1]}" = "line2" ]
  [ "${lines[2]}" = "line3" ]
}
```

---

### Basic Assertions

**Exit status:**
```bash
[ "$status" -eq 0 ]      # Command succeeded
[ "$status" -eq 1 ]      # Command failed
[ "$status" -ne 0 ]      # Command failed (any non-zero)
```

**Output matching:**
```bash
[ "$output" = "exact match" ]           # Exact match
[[ "$output" =~ "pattern" ]]            # Regex match
[ -z "$output" ]                        # Output is empty
[ -n "$output" ]                        # Output is not empty
```

**File checks:**
```bash
[ -f "$file" ]           # File exists
[ -d "$dir" ]            # Directory exists
[ -x "$script" ]         # File is executable
[ ! -f "$file" ]         # File does not exist
```

**String comparisons:**
```bash
[ "$var" = "value" ]     # Equal
[ "$var" != "value" ]    # Not equal
[ -z "$var" ]            # Empty
[ -n "$var" ]            # Not empty
```

---

### When to Write Tests

**Always write tests for:**
- ✅ Deployment scripts (critical path)
- ✅ Scripts that modify system state
- ✅ Scripts with complex logic
- ✅ Scripts that interact with external services
- ✅ Scripts used in CI/CD pipelines

**Consider writing tests for:**
- 🟡 Utility scripts used by other scripts
- 🟡 Scripts with configuration validation
- 🟡 Scripts with error handling

**May skip tests for:**
- ⚪ Simple one-liners
- ⚪ Scripts that only call other tested scripts
- ⚪ Temporary/experimental scripts

**Test Coverage Goal:** 80%+ for critical scripts

---

### Example: Complete Test File

Here's a complete example test file:

```bash
#!/usr/bin/env bats

# Test file for scripts/deployment/deploy.sh

load '../../helpers/setup'
load '../../helpers/mocks'
load '../../helpers/assertions'

setup() {
  setup_file
  restore_commands
}

teardown() {
  restore_commands
}

@test "deploy: script exists and is executable" {
  assert_file_exists "$PROJECT_ROOT/scripts/deployment/deploy.sh"
  assert_script_executable "$PROJECT_ROOT/scripts/deployment/deploy.sh"
}

@test "deploy: shows usage with environment in output" {
  mock_pokehub_services_healthy
  run timeout 2 bash "$PROJECT_ROOT/scripts/deployment/deploy.sh" staging latest
  assert_output_contains "staging"
}

@test "deploy: rejects invalid environment" {
  run bash "$PROJECT_ROOT/scripts/deployment/deploy.sh" invalid-env latest
  [ "$status" -eq 1 ]
  assert_output_contains "Invalid environment"
}

@test "deploy: fails when Docker is not running" {
  setup_test_dir
  touch docker-compose.yml
  mock_docker_failure
  run bash "$PROJECT_ROOT/scripts/deployment/deploy.sh" staging latest
  [ "$status" -eq 1 ]
  assert_output_contains "Docker"
  teardown_test_dir
}

@test "deploy: requires environment argument" {
  run bash "$PROJECT_ROOT/scripts/deployment/deploy.sh"
  [ "$status" -eq 1 ]
  assert_output_contains "Usage"
}

@test "deploy: requires version argument" {
  run bash "$PROJECT_ROOT/scripts/deployment/deploy.sh" staging
  [ "$status" -eq 1 ]
  assert_output_contains "Usage"
}
```

**This test file demonstrates:**
- ✅ Proper structure and organization
- ✅ Loading helpers
- ✅ Setup/teardown
- ✅ Clear test names
- ✅ Multiple test categories (existence, validation, error handling)
- ✅ Using mocks for external dependencies
- ✅ Using custom assertions

---

### Quick Reference

**Test File Template:**
```bash
#!/usr/bin/env bats

load '../../helpers/setup'
load '../../helpers/mocks'
load '../../helpers/assertions'

setup() {
  setup_file
  restore_commands
}

teardown() {
  restore_commands
}

@test "script: description" {
  # Arrange
  mock_something
  
  # Act
  run command
  
  # Assert
  [ "$status" -eq 0 ]
  assert_output_contains "expected"
}
```

**Common Commands:**
```bash
# Run tests
./tests/shell/run-shell-tests.sh
./tests/shell/run-shell-tests.sh -t unit/deployment/test-deploy.bats
./tests/shell/run-shell-tests.sh -v

# Run with Bats directly
bats --recursive unit/
bats --filter "deploy" unit/deployment/test-deploy.bats
```

---

## Next Steps

**You've completed Part 1 (Sections 1-4)!** 🎉

**Continue to Part 2 for:**
- Section 5: Helper Functions
- Section 6: Mocking
- Section 7: Assertions
- Section 8: Best Practices
- Section 9: Common Patterns
- Section 10: Troubleshooting

**Or start writing tests:**
1. Choose a script to test
2. Create a test file using the template
3. Write your first test
4. Run it and iterate

**Need help?** See the [Troubleshooting](#10-troubleshooting) section or ask the team.

---

**Last Updated:** 2025-10-07  
**Status:** ✅ Part 1 Complete (Sections 1-4)  
**Next:** Part 2 (Sections 5-10)
