# Shell Script Testing Guide

**Last Updated:** 2025-10-07  
**Status:** ✅ Complete (All 10 Sections)  
**Test Suite:** 153 tests, 29s execution, 100% coverage

---

## 📋 Table of Contents

1. [Overview](#1-overview)
2. [Getting Started](#2-getting-started)
3. [Running Tests](#3-running-tests)
4. [Writing Tests](#4-writing-tests)
5. [Helper Functions](#5-helper-functions)
6. [Mocking](#6-mocking)
7. [Assertions](#7-assertions)
8. [Best Practices](#8-best-practices)
9. [Common Patterns](#9-common-patterns)
10. [Troubleshooting](#10-troubleshooting)

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

## 5. Helper Functions

Our test suite includes three helper files with reusable utilities:

```
tests/shell/helpers/
├── setup.bash       # Setup and teardown functions
├── mocks.bash       # Mock external commands
└── assertions.bash  # Custom assertions
```

### Loading Helpers

Load helpers at the top of each test file:

```bash
#!/usr/bin/env bats

load '../../helpers/setup'
load '../../helpers/mocks'
load '../../helpers/assertions'
```

**Path adjustment:** Use `../../helpers/` for tests in `unit/category/`, adjust as needed.

---

### setup.bash - Setup Functions

#### `setup_file()`

Initializes `PROJECT_ROOT` and `PATH` for all tests in a file.

**Usage:**
```bash
setup() {
  setup_file
}

@test "example" {
  echo "$PROJECT_ROOT"  # /path/to/pokedex
}
```

**What it does:**
- Finds project root (parent of `tests/` directory)
- Exports `PROJECT_ROOT` variable
- Adds `$PROJECT_ROOT/scripts` to `PATH`

---

#### `setup_test_dir()`

Creates a temporary directory for test isolation.

**Usage:**
```bash
setup() {
  setup_file
  setup_test_dir
}

teardown() {
  teardown_test_dir
}

@test "creates files in temp dir" {
  touch test-file.txt
  [ -f test-file.txt ]
}
```

**What it does:**
- Creates temporary directory with `mktemp -d`
- Saves current directory in `ORIGINAL_PWD`
- Changes to temporary directory
- Sets `TEST_DIR` variable

**Important:** Always call `teardown_test_dir()` in teardown to clean up.

---

#### `teardown_test_dir()`

Cleans up temporary directory created by `setup_test_dir()`.

**Usage:**
```bash
teardown() {
  teardown_test_dir
}
```

**What it does:**
- Returns to original directory
- Removes temporary directory
- Cleans up `TEST_DIR` variable

---

#### `init_test_repo()`

Initializes a git repository for testing git-related scripts.

**Usage:**
```bash
setup() {
  setup_file
  setup_test_dir
  init_test_repo
}

@test "git repo is initialized" {
  [ -d .git ]
  run git status
  [ "$status" -eq 0 ]
}
```

**What it does:**
- Runs `git init`
- Sets test user email and name
- Prepares repo for commits

---

#### `create_initial_commit()`

Creates an initial commit in a test repository.

**Usage:**
```bash
setup() {
  setup_file
  setup_test_dir
  init_test_repo
  create_initial_commit
}

@test "has initial commit" {
  run git log --oneline
  [ "$status" -eq 0 ]
  assert_output_contains "Initial commit"
}
```

**What it does:**
- Creates `README.md`
- Adds and commits the file
- Provides a base commit for testing

---

### Complete Setup Example

```bash
#!/usr/bin/env bats

load '../../helpers/setup'
load '../../helpers/mocks'
load '../../helpers/assertions'

setup() {
  setup_file              # Initialize PROJECT_ROOT
  restore_commands        # Restore any mocked commands
  setup_test_dir          # Create temp directory
  init_test_repo          # Initialize git repo
  create_initial_commit   # Create initial commit
}

teardown() {
  restore_commands        # Clean up mocks
  teardown_test_dir       # Remove temp directory
}

@test "complete setup example" {
  # We now have:
  # - PROJECT_ROOT set
  # - Temporary directory
  # - Git repository
  # - Initial commit
  
  [ -n "$PROJECT_ROOT" ]
  [ -d .git ]
  run git log --oneline
  [ "$status" -eq 0 ]
}
```

---

## 6. Mocking

Mocking replaces real commands with test doubles to:
- **Speed up tests** (no real Docker, curl, etc.)
- **Isolate tests** (no external dependencies)
- **Control behavior** (simulate success/failure)
- **Avoid side effects** (no actual deployments)

### Basic Mocking Pattern

```bash
# Define mock function
mock_docker_success() {
  docker() {
    echo "Docker mocked"
    return 0
  }
  export -f docker
}

# Use in test
@test "example" {
  mock_docker_success
  run docker info
  [ "$status" -eq 0 ]
  assert_output_contains "Docker mocked"
}
```

---

### Available Mocks

#### Docker Mocks

**`mock_docker_success()`** - Docker commands succeed

```bash
@test "deploy with Docker" {
  mock_docker_success
  run docker info
  [ "$status" -eq 0 ]
  
  run docker ps
  [ "$status" -eq 0 ]
}
```

**`mock_docker_failure()`** - Docker commands fail

```bash
@test "fails when Docker is down" {
  mock_docker_failure
  run docker info
  [ "$status" -eq 1 ]
}
```

---

#### Curl Mocks

**`mock_curl_success()`** - Curl requests succeed

```bash
@test "health check passes" {
  mock_curl_success
  run curl http://localhost/health
  [ "$status" -eq 0 ]
}
```

**`mock_curl_failure()`** - Curl requests fail

```bash
@test "health check fails" {
  mock_curl_failure
  run curl http://localhost/health
  [ "$status" -eq 1 ]
}
```

---

#### Docker Compose Mocks

**`mock_docker_compose_success()`** - Docker Compose commands succeed

```bash
@test "starts services" {
  mock_docker_compose_success
  run docker-compose up -d
  [ "$status" -eq 0 ]
  assert_output_contains "Starting services"
}
```

---

#### Redis Mocks

**`mock_redis_cli_success()`** - Redis responds with PONG

```bash
@test "Redis is healthy" {
  mock_redis_cli_success
  run redis-cli ping
  [ "$status" -eq 0 ]
  [ "$output" = "PONG" ]
}
```

**`mock_redis_cli_failure()`** - Redis is unavailable

```bash
@test "Redis is down" {
  mock_redis_cli_failure
  run redis-cli ping
  [ "$status" -eq 1 ]
}
```

---

#### Python Mocks

**`mock_python_success()`** - Python commands succeed

```bash
@test "runs Python script" {
  mock_python_success
  run python --version
  [ "$status" -eq 0 ]
  assert_output_contains "Python 3"
}
```

**`mock_python_failure()`** - Python commands fail

```bash
@test "Python not available" {
  mock_python_failure
  run python script.py
  [ "$status" -eq 1 ]
}
```

---

#### NPM Mocks

**`mock_npm_success()`** - NPM commands succeed

```bash
@test "runs npm test" {
  mock_npm_success
  run npm test
  [ "$status" -eq 0 ]
  assert_output_contains "Tests passed"
}
```

**`mock_npm_failure()`** - NPM commands fail

```bash
@test "npm test fails" {
  mock_npm_failure
  run npm test
  [ "$status" -eq 1 ]
}
```

---

#### PostgreSQL Mocks

**`mock_psql_success()`** - PostgreSQL queries succeed

```bash
@test "database query works" {
  mock_psql_success
  run psql -c "SELECT 1"
  [ "$status" -eq 0 ]
}
```

**`mock_psql_failure()`** - PostgreSQL queries fail

```bash
@test "database is down" {
  mock_psql_failure
  run psql -c "SELECT 1"
  [ "$status" -eq 1 ]
}
```

---

#### Git Mocks

**`mock_git_status()`** - Mock git status and branch

```bash
@test "checks git status" {
  mock_git_status
  run git status
  [ "$status" -eq 0 ]
  assert_output_contains "On branch develop"
}
```

**`mock_git_log()`** - Mock git log and commit history

```bash
@test "shows git log" {
  mock_git_log
  run git log --oneline
  [ "$status" -eq 0 ]
  assert_output_contains "feat: Test commit"
}
```

**`mock_git_remote()`** - Mock git remote URL

```bash
@test "gets remote URL" {
  mock_git_remote "https://github.com/user/repo.git"
  run git remote get-url origin
  [ "$status" -eq 0 ]
  [ "$output" = "https://github.com/user/repo.git" ]
}
```

---

#### Composite Mocks

**`mock_pokehub_services_healthy()`** - All Pokehub services healthy

```bash
@test "all services healthy" {
  mock_pokehub_services_healthy
  # Docker, curl, Redis, PostgreSQL all mocked as healthy
  run docker ps
  [ "$status" -eq 0 ]
  run curl http://localhost/health
  [ "$status" -eq 0 ]
  run redis-cli ping
  [ "$status" -eq 0 ]
}
```

**`mock_pokehub_services_unhealthy()`** - All Pokehub services down

```bash
@test "all services down" {
  mock_pokehub_services_unhealthy
  run docker ps
  [ "$status" -eq 1 ]
  run curl http://localhost/health
  [ "$status" -eq 1 ]
}
```

---

#### Utility Mocks

**`mock_sleep()`** - Speed up tests by skipping sleep

```bash
@test "waits for service" {
  mock_sleep
  run bash -c "sleep 60; echo done"
  # Completes instantly instead of waiting 60 seconds
  [ "$status" -eq 0 ]
  assert_output_contains "done"
}
```

---

### Restoring Commands

**Always restore mocked commands** after tests:

```bash
setup() {
  setup_file
  restore_commands  # Restore before each test
}

teardown() {
  restore_commands  # Restore after each test
}
```

**`restore_commands()`** - Unsets all mocked functions

---

### Creating Custom Mocks

**Pattern:**
```bash
mock_my_command() {
  my_command() {
    # Custom behavior
    echo "Mocked output"
    return 0
  }
  export -f my_command
}
```

**Example:**
```bash
mock_aws_cli() {
  aws() {
    case "$1" in
      "s3")
        echo "S3 operation successful"
        return 0
        ;;
      "ec2")
        echo "EC2 operation successful"
        return 0
        ;;
      *)
        return 1
        ;;
    esac
  }
  export -f aws
}
```

---

## 7. Assertions

Assertions verify expected behavior. We have basic Bats assertions and custom Pokehub-specific assertions.

### Basic Bats Assertions

**Exit status:**
```bash
[ "$status" -eq 0 ]      # Success
[ "$status" -eq 1 ]      # Failure
[ "$status" -ne 0 ]      # Any failure
```

**Output matching:**
```bash
[ "$output" = "exact" ]           # Exact match
[[ "$output" =~ "pattern" ]]      # Regex match
[ -z "$output" ]                  # Empty
[ -n "$output" ]                  # Not empty
```

**File checks:**
```bash
[ -f "$file" ]           # File exists
[ -d "$dir" ]            # Directory exists
[ -x "$script" ]         # Executable
[ ! -f "$file" ]         # File doesn't exist
```

---

### Custom Assertions

#### `assert_output_contains()`

Verifies output contains a string.

**Usage:**
```bash
@test "example" {
  run echo "Hello World"
  assert_output_contains "Hello"
  assert_output_contains "World"
}
```

**Benefits:**
- Better error messages
- Regex matching
- Clearer intent

---

#### `assert_file_exists()`

Verifies a file exists.

**Usage:**
```bash
@test "creates config file" {
  run touch config.yml
  assert_file_exists "config.yml"
}
```

---

#### `assert_dir_exists()`

Verifies a directory exists.

**Usage:**
```bash
@test "creates directory" {
  run mkdir -p data/cache
  assert_dir_exists "data"
  assert_dir_exists "data/cache"
}
```

---

#### `assert_script_executable()`

Verifies a script has executable permissions.

**Usage:**
```bash
@test "script is executable" {
  assert_script_executable "$PROJECT_ROOT/scripts/deployment/deploy.sh"
}
```

---

#### `assert_var_set()`

Verifies an environment variable is set.

**Usage:**
```bash
@test "PROJECT_ROOT is set" {
  assert_var_set "PROJECT_ROOT"
}
```

---

#### `assert_var_equals()`

Verifies a variable equals a specific value.

**Usage:**
```bash
@test "environment is staging" {
  export ENVIRONMENT="staging"
  assert_var_equals "ENVIRONMENT" "staging"
}
```

---

### Pokehub-Specific Assertions

#### `assert_http_status()`

Verifies HTTP status code.

**Usage:**
```bash
@test "API returns 200" {
  assert_http_status "http://localhost/api/v1/pokemon" "200"
}

@test "missing page returns 404" {
  assert_http_status "http://localhost/missing" "404"
}
```

---

#### `assert_container_running()`

Verifies a Docker container is running.

**Usage:**
```bash
@test "backend container is running" {
  assert_container_running "pokedex-backend"
}
```

---

#### `assert_container_not_running()`

Verifies a Docker container is NOT running.

**Usage:**
```bash
@test "old container stopped" {
  assert_container_not_running "old-backend"
}
```

---

#### `assert_redis_healthy()`

Verifies Redis responds with PONG.

**Usage:**
```bash
@test "Redis is healthy" {
  assert_redis_healthy
}
```

---

#### `assert_api_accessible()`

Verifies an API endpoint is accessible.

**Usage:**
```bash
@test "Pokemon API is accessible" {
  assert_api_accessible "http://localhost/api/v1/pokemon"
}
```

---

#### `assert_pokehub_service_healthy()`

Verifies a specific Pokehub service is healthy.

**Usage:**
```bash
@test "backend is healthy" {
  assert_pokehub_service_healthy "backend"
}

@test "frontend is healthy" {
  assert_pokehub_service_healthy "frontend"
}

@test "Redis is healthy" {
  assert_pokehub_service_healthy "redis"
}

@test "database is healthy" {
  assert_pokehub_service_healthy "database"
}
```

---

#### `assert_pokemon_api_returns_data()`

Verifies Pokemon API returns valid JSON data.

**Usage:**
```bash
@test "Pokemon API returns data" {
  assert_pokemon_api_returns_data
}
```

---

#### `assert_env_var_set()`

Verifies an environment variable is set (alias for `assert_var_set`).

**Usage:**
```bash
@test "DATABASE_URL is set" {
  assert_env_var_set "DATABASE_URL"
}
```

---

#### `assert_env_var_equals()`

Verifies an environment variable equals a value (alias for `assert_var_equals`).

**Usage:**
```bash
@test "NODE_ENV is production" {
  export NODE_ENV="production"
  assert_env_var_equals "NODE_ENV" "production"
}
```

---

### Assertion Best Practices

**1. Use descriptive assertions:**
```bash
# Good
assert_output_contains "deployment successful"

# Less clear
[[ "$output" =~ "deployment successful" ]]
```

**2. Combine assertions:**
```bash
@test "deploy succeeds" {
  run deploy.sh
  [ "$status" -eq 0 ]
  assert_output_contains "success"
  assert_container_running "backend"
}
```

**3. Use appropriate assertions:**
```bash
# For files
assert_file_exists "config.yml"

# For output
assert_output_contains "expected text"

# For services
assert_pokehub_service_healthy "backend"
```

---

## 8. Best Practices

### Test Organization

**1. Group related tests:**
```bash
# Structure tests
@test "deploy: script exists and is executable" { }
@test "deploy: has proper shebang" { }

# Validation tests
@test "deploy: requires environment argument" { }
@test "deploy: rejects invalid environment" { }

# Functional tests
@test "deploy: deploys to staging" { }
@test "deploy: deploys to production" { }
```

**2. Use clear test names:**
```bash
# Good
@test "deploy: shows usage with environment in output" { }

# Bad
@test "test1" { }
```

**3. One assertion per test (when possible):**
```bash
# Good - focused
@test "deploy: requires environment argument" {
  run deploy.sh
  [ "$status" -eq 1 ]
}

@test "deploy: shows usage when no args" {
  run deploy.sh
  assert_output_contains "Usage"
}

# Acceptable - related assertions
@test "deploy: validates environment" {
  run deploy.sh invalid-env
  [ "$status" -eq 1 ]
  assert_output_contains "Invalid environment"
}
```

---

### Structure Tests vs Functional Tests

**Structure Tests** - Fast, grep-based validation
```bash
@test "deploy: uses correct compose file for staging" {
  run grep "docker-compose.staging.yml" deploy.sh
  [ "$status" -eq 0 ]
}
```

**Functional Tests** - Slower, runtime validation
```bash
@test "deploy: actually deploys to staging" {
  mock_docker_success
  run bash deploy.sh staging latest
  [ "$status" -eq 0 ]
  assert_output_contains "Deployment successful"
}
```

**When to use each:**
- **Structure tests:** Script structure, configuration, patterns
- **Functional tests:** Actual behavior, integration, end-to-end

**Our approach:** Primarily structure tests (fast, reliable), functional tests for critical paths.

---

### Mocking vs Real Execution

**Use mocks when:**
- ✅ Testing script logic
- ✅ External services (Docker, curl, Redis)
- ✅ Slow operations (sleep, network)
- ✅ Dangerous operations (rm, deployment)

**Use real execution when:**
- ✅ Testing simple utilities
- ✅ File operations (in temp dir)
- ✅ Git operations (in test repo)
- ✅ Text processing (grep, sed, awk)

**Example:**
```bash
@test "uses mocks for Docker" {
  mock_docker_success
  run deploy.sh staging latest
  [ "$status" -eq 0 ]
}

@test "uses real execution for text processing" {
  echo "test" > file.txt
  run grep "test" file.txt
  [ "$status" -eq 0 ]
}
```

---

### Test Isolation

**1. Clean up after tests:**
```bash
teardown() {
  restore_commands
  teardown_test_dir
}
```

**2. Use temporary directories:**
```bash
setup() {
  setup_test_dir
}

@test "creates files" {
  touch test.txt  # Created in temp dir
  [ -f test.txt ]
}
# Automatically cleaned up
```

**3. Don't depend on other tests:**
```bash
# Bad - depends on previous test
@test "test1" {
  export SHARED_VAR="value"
}

@test "test2" {
  [ "$SHARED_VAR" = "value" ]  # May fail!
}

# Good - independent
@test "test1" {
  export VAR="value"
  [ "$VAR" = "value" ]
}

@test "test2" {
  export VAR="value"
  [ "$VAR" = "value" ]
}
```

---

### Fast Tests

**1. Use mocks:**
```bash
# Slow (real Docker)
run docker pull nginx:latest

# Fast (mocked)
mock_docker_success
run docker pull nginx:latest
```

**2. Use timeouts:**
```bash
# Prevents hanging
run timeout 2 bash long-running-script.sh
```

**3. Use structure tests:**
```bash
# Fast
run grep "pattern" script.sh

# Slower
run bash script.sh
```

**4. Mock sleep:**
```bash
mock_sleep
run bash script-with-sleep.sh  # Completes instantly
```

---

### Debugging Tests

**1. Use verbose mode:**
```bash
./tests/shell/run-shell-tests.sh -v
```

**2. Add debug output:**
```bash
@test "debug example" {
  run command
  echo "Status: $status" >&3
  echo "Output: $output" >&3
  [ "$status" -eq 0 ]
}
```

**3. Run specific test:**
```bash
./tests/shell/run-shell-tests.sh -t unit/deployment/test-deploy.bats
```

**4. Use Bats directly:**
```bash
bats --verbose-run unit/deployment/test-deploy.bats
```

---

## 9. Common Patterns

### Pattern 1: Testing Script Existence

```bash
@test "script: exists and is executable" {
  assert_file_exists "$PROJECT_ROOT/scripts/deployment/deploy.sh"
  assert_script_executable "$PROJECT_ROOT/scripts/deployment/deploy.sh"
}

@test "script: has proper shebang" {
  run head -1 "$PROJECT_ROOT/scripts/deployment/deploy.sh"
  assert_output_contains "#!/bin/bash"
}
```

---

### Pattern 2: Testing Argument Validation

```bash
@test "script: requires argument" {
  run bash script.sh
  [ "$status" -eq 1 ]
  assert_output_contains "Usage"
}

@test "script: rejects invalid argument" {
  run bash script.sh invalid-value
  [ "$status" -eq 1 ]
  assert_output_contains "Invalid"
}

@test "script: accepts valid argument" {
  mock_dependencies
  run bash script.sh valid-value
  [ "$status" -eq 0 ]
}
```

---

### Pattern 3: Testing Error Handling

```bash
@test "script: fails when Docker is not running" {
  mock_docker_failure
  run bash script.sh
  [ "$status" -eq 1 ]
  assert_output_contains "Docker"
}

@test "script: fails when service is unavailable" {
  mock_curl_failure
  run bash script.sh
  [ "$status" -eq 1 ]
  assert_output_contains "service unavailable"
}
```

---

### Pattern 4: Testing Configuration

```bash
@test "script: uses correct config for staging" {
  run grep "staging" script.sh
  [ "$status" -eq 0 ]
}

@test "script: uses correct config for production" {
  run grep "production" script.sh
  [ "$status" -eq 0 ]
}
```

---

### Pattern 5: Testing Output Format

```bash
@test "script: outputs JSON" {
  run bash script.sh
  assert_output_contains "{"
  assert_output_contains "}"
}

@test "script: includes timestamp" {
  run bash script.sh
  assert_output_contains "$(date +%Y)"
}
```

---

### Pattern 6: Testing with Temporary Files

```bash
setup() {
  setup_file
  setup_test_dir
}

teardown() {
  teardown_test_dir
}

@test "script: creates output file" {
  run bash "$PROJECT_ROOT/scripts/script.sh"
  [ "$status" -eq 0 ]
  assert_file_exists "output.txt"
}
```

---

### Pattern 7: Testing Environment Variables

```bash
@test "script: uses DATABASE_URL" {
  export DATABASE_URL="postgresql://localhost/test"
  run bash script.sh
  [ "$status" -eq 0 ]
  assert_output_contains "postgresql://localhost/test"
}

@test "script: fails without DATABASE_URL" {
  unset DATABASE_URL
  run bash script.sh
  [ "$status" -eq 1 ]
  assert_output_contains "DATABASE_URL"
}
```

---

### Pattern 8: Testing Exit Codes

```bash
@test "script: exits 0 on success" {
  mock_dependencies
  run bash script.sh
  [ "$status" -eq 0 ]
}

@test "script: exits 1 on validation error" {
  run bash script.sh invalid-arg
  [ "$status" -eq 1 ]
}

@test "script: exits 2 on runtime error" {
  mock_docker_failure
  run bash script.sh valid-arg
  [ "$status" -eq 2 ]
}
```

---

## 10. Troubleshooting

### Common Issues

#### Issue: Tests can't find scripts

**Symptom:**
```
bash: scripts/deploy.sh: No such file or directory
```

**Solution:**
```bash
# Use $PROJECT_ROOT
run bash "$PROJECT_ROOT/scripts/deploy.sh"

# Or ensure setup_file is called
setup() {
  setup_file  # Sets PROJECT_ROOT
}
```

---

#### Issue: Mocks not working

**Symptom:**
```
Real Docker command executed instead of mock
```

**Solution:**
```bash
# Ensure restore_commands is called
setup() {
  setup_file
  restore_commands  # Restore before each test
}

teardown() {
  restore_commands  # Restore after each test
}

# Ensure mock is called before command
@test "example" {
  mock_docker_success  # Call mock first
  run docker info      # Then run command
}
```

---

#### Issue: Tests hang or timeout

**Symptom:**
```
Test runs forever, never completes
```

**Solution:**
```bash
# Use timeout
run timeout 2 bash long-script.sh

# Mock sleep
mock_sleep

# Use structure tests instead
run grep "pattern" script.sh
```

---

#### Issue: Temporary directory not cleaned up

**Symptom:**
```
/tmp/ fills up with test directories
```

**Solution:**
```bash
# Always call teardown_test_dir
teardown() {
  teardown_test_dir
}

# Or manually clean up
teardown() {
  if [ -n "$TEST_DIR" ] && [ -d "$TEST_DIR" ]; then
    rm -rf "$TEST_DIR"
  fi
}
```

---

#### Issue: Tests fail in CI but pass locally

**Symptom:**
```
Tests pass on Mac, fail on Linux CI
```

**Solution:**
```bash
# Use portable commands
# Bad (Mac-specific)
run date -r file.txt

# Good (portable)
run stat -c %Y file.txt  # Linux
run stat -f %m file.txt  # Mac

# Or use structure tests
run grep "pattern" file.txt
```

---

#### Issue: Output assertion fails unexpectedly

**Symptom:**
```
Expected output to contain: "success"
Actual output: "Success"
```

**Solution:**
```bash
# Case-insensitive match
[[ "$output" =~ [Ss]uccess ]]

# Or normalize case
run bash script.sh
output_lower=$(echo "$output" | tr '[:upper:]' '[:lower:]')
[[ "$output_lower" =~ "success" ]]
```

---

### Debugging Techniques

**1. Print variables:**
```bash
@test "debug" {
  run command
  echo "Status: $status" >&3
  echo "Output: $output" >&3
  echo "PROJECT_ROOT: $PROJECT_ROOT" >&3
}
```

**2. Run with verbose:**
```bash
./tests/shell/run-shell-tests.sh -v
bats --verbose-run unit/test.bats
```

**3. Run specific test:**
```bash
./tests/shell/run-shell-tests.sh -t unit/deployment/test-deploy.bats
bats --filter "deploy: shows usage" unit/deployment/test-deploy.bats
```

**4. Check test file syntax:**
```bash
bash -n tests/shell/unit/deployment/test-deploy.bats
```

**5. Run test manually:**
```bash
# Extract test logic and run manually
bash -c "
  source tests/shell/helpers/setup.bash
  source tests/shell/helpers/mocks.bash
  setup_file
  mock_docker_success
  bash scripts/deployment/deploy.sh staging latest
"
```

---

### Getting Help

**Resources:**
- **[Bats Documentation](https://bats-core.readthedocs.io/)**
- **[tests/shell/README.md](../../tests/shell/README.md)** - Our test suite docs
- **[TESTING-SHELL.md Part 1](TESTING-SHELL.md)** - Basics and getting started

**Team:**
- Ask in team chat
- Review existing tests for examples
- Pair program on complex tests

**Examples:**
- Look at `tests/shell/unit/deployment/` for deployment test examples
- Look at `tests/shell/unit/core/` for core script examples
- Look at `tests/shell/unit/monitoring/` for monitoring script examples

---

## Quick Reference

### Helper Functions
```bash
setup_file()              # Initialize PROJECT_ROOT
setup_test_dir()          # Create temp directory
teardown_test_dir()       # Clean up temp directory
init_test_repo()          # Initialize git repo
create_initial_commit()   # Create initial commit
restore_commands()        # Restore mocked commands
```

### Common Mocks
```bash
mock_docker_success()              # Docker works
mock_docker_failure()              # Docker fails
mock_curl_success()                # Curl works
mock_curl_failure()                # Curl fails
mock_pokehub_services_healthy()    # All services up
mock_pokehub_services_unhealthy()  # All services down
mock_sleep()                       # Skip sleep
```

### Common Assertions
```bash
assert_output_contains "text"      # Output contains text
assert_file_exists "file"          # File exists
assert_script_executable "script"  # Script is executable
assert_container_running "name"    # Container is running
assert_pokehub_service_healthy "service"  # Service is healthy
```

### Common Commands
```bash
# Run all tests
./tests/shell/run-shell-tests.sh

# Run specific test
./tests/shell/run-shell-tests.sh -t unit/deployment/test-deploy.bats

# Run with verbose
./tests/shell/run-shell-tests.sh -v

# Run with Bats directly
bats --recursive unit/
bats --filter "pattern" unit/test.bats
```

---

## Summary

**You've completed the Shell Testing Guide!** 🎉

**You now know:**
- ✅ How to use helper functions (setup, mocks, assertions)
- ✅ How to mock external dependencies
- ✅ How to write effective assertions
- ✅ Best practices for test organization
- ✅ Common testing patterns
- ✅ How to troubleshoot issues

**Next steps:**
1. Write tests for your scripts
2. Run tests regularly
3. Add tests to CI/CD
4. Share knowledge with team

**Happy testing!** 🧪

---

**Last Updated:** 2025-10-07  
**Status:** ✅ Complete (Sections 5-10)  
**Part:** 2 of 2
