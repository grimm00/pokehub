# Bats Testing Quick Reference

**Purpose:** Quick lookup for common Bats testing tasks  
**Audience:** Developers writing shell script tests  
**Last Updated:** 2025-10-07

---

## 🚀 Running Tests

### Basic Commands

```bash
# Run all shell tests
./tests/shell/run-shell-tests.sh

# Run specific test file
./tests/shell/run-shell-tests.sh -t unit/deployment/test-deploy.bats

# Run with verbose output
./tests/shell/run-shell-tests.sh -v

# Run quietly (minimal output)
./tests/shell/run-shell-tests.sh -q

# Filter tests by pattern
./tests/shell/run-shell-tests.sh -f "deploy"

# List all available tests
./tests/shell/run-shell-tests.sh -l

# Show help
./tests/shell/run-shell-tests.sh -h
```

### Using Bats Directly

```bash
# Run all tests recursively
cd tests/shell
bats --recursive unit/

# Run specific test
bats unit/deployment/test-deploy.bats

# Run with verbose output
bats --verbose-run unit/deployment/test-deploy.bats

# Filter by test name
bats --filter "deploy: shows usage" unit/deployment/test-deploy.bats

# Show timing
bats --timing unit/deployment/test-deploy.bats
```

---

## 📝 Test File Template

```bash
#!/usr/bin/env bats

# Load helpers
load '../../../helpers/setup'
load '../../../helpers/mocks'
load '../../../helpers/assertions'

# Setup (runs before each test)
setup() {
  setup_file              # Initialize PROJECT_ROOT
  restore_commands        # Restore mocked commands
}

# Teardown (runs after each test)
teardown() {
  restore_commands        # Clean up mocks
}

# Test case
@test "script: description of what is being tested" {
  # Arrange: Set up test conditions
  mock_docker_success
  
  # Act: Run the command
  run bash "$PROJECT_ROOT/scripts/script.sh" arg1 arg2
  
  # Assert: Verify the results
  [ "$status" -eq 0 ]
  assert_output_contains "expected output"
}
```

---

## 🔧 Helper Functions

### Setup Helpers

```bash
setup_file()              # Initialize PROJECT_ROOT and PATH
setup_test_dir()          # Create temporary directory
teardown_test_dir()       # Clean up temporary directory
init_test_repo()          # Initialize git repository
create_initial_commit()   # Create initial commit
restore_commands()        # Restore mocked commands
```

### Usage Example

```bash
setup() {
  setup_file              # Always call this
  restore_commands        # Restore mocks
  setup_test_dir          # If you need temp directory
  init_test_repo          # If you need git repo
  create_initial_commit   # If you need initial commit
}

teardown() {
  restore_commands        # Always call this
  teardown_test_dir       # If you used setup_test_dir
}
```

---

## 🎭 Mock Functions

### Docker Mocks

```bash
mock_docker_success()              # Docker commands succeed
mock_docker_failure()              # Docker commands fail
mock_docker_compose_success()      # Docker Compose succeeds
```

### Network Mocks

```bash
mock_curl_success()                # Curl requests succeed
mock_curl_failure()                # Curl requests fail
```

### Service Mocks

```bash
mock_redis_cli_success()           # Redis responds with PONG
mock_redis_cli_failure()           # Redis is unavailable
mock_python_success()              # Python commands succeed
mock_python_failure()              # Python commands fail
mock_npm_success()                 # NPM commands succeed
mock_npm_failure()                 # NPM commands fail
mock_psql_success()                # PostgreSQL queries succeed
mock_psql_failure()                # PostgreSQL queries fail
```

### Git Mocks

```bash
mock_git_status()                  # Mock git status and branch
mock_git_log()                     # Mock git log and history
mock_git_remote "url"              # Mock git remote URL
```

### Composite Mocks

```bash
mock_pokehub_services_healthy()    # All Pokehub services healthy
mock_pokehub_services_unhealthy()  # All Pokehub services down
```

### Utility Mocks

```bash
mock_sleep()                       # Skip sleep (speeds up tests)
```

### Mock Usage Example

```bash
@test "deploy: fails when Docker is down" {
  mock_docker_failure              # Mock Docker as unavailable
  run bash "$PROJECT_ROOT/scripts/deployment/deploy.sh" staging latest
  [ "$status" -eq 1 ]              # Should fail
  assert_output_contains "Docker"  # Should mention Docker
}

@test "deploy: succeeds when services are healthy" {
  mock_pokehub_services_healthy    # Mock all services as healthy
  run bash "$PROJECT_ROOT/scripts/deployment/deploy.sh" staging latest
  [ "$status" -eq 0 ]              # Should succeed
}
```

---

## ✅ Assertion Functions

### Basic Bats Assertions

```bash
# Exit status
[ "$status" -eq 0 ]                # Command succeeded
[ "$status" -eq 1 ]                # Command failed
[ "$status" -ne 0 ]                # Command failed (any non-zero)

# Output matching
[ "$output" = "exact match" ]      # Exact match
[[ "$output" =~ "pattern" ]]       # Regex match
[ -z "$output" ]                   # Output is empty
[ -n "$output" ]                   # Output is not empty

# File checks
[ -f "$file" ]                     # File exists
[ -d "$dir" ]                      # Directory exists
[ -x "$script" ]                   # File is executable
[ ! -f "$file" ]                   # File doesn't exist

# String comparisons
[ "$var" = "value" ]               # Equal
[ "$var" != "value" ]              # Not equal
[ -z "$var" ]                      # Empty
[ -n "$var" ]                      # Not empty
```

### Custom Assertions

```bash
# Output and variables
assert_output_contains "text"      # Output contains text
assert_var_set "VAR_NAME"          # Variable is set
assert_var_equals "VAR" "value"    # Variable equals value

# Files and directories
assert_file_exists "file"          # File exists
assert_dir_exists "dir"            # Directory exists
assert_script_executable "script"  # Script is executable

# Environment variables
assert_env_var_set "VAR"           # Environment variable is set
assert_env_var_equals "VAR" "val"  # Environment variable equals value
```

### Pokehub-Specific Assertions

```bash
# HTTP and API
assert_http_status "url" "200"     # HTTP status code
assert_api_accessible "url"        # API endpoint is accessible
assert_pokemon_api_returns_data()  # Pokemon API returns JSON

# Docker containers
assert_container_running "name"    # Container is running
assert_container_not_running "name" # Container is NOT running

# Services
assert_redis_healthy()             # Redis responds with PONG
assert_pokehub_service_healthy "backend"    # Service is healthy
assert_pokehub_service_healthy "frontend"   # Service is healthy
assert_pokehub_service_healthy "redis"      # Service is healthy
assert_pokehub_service_healthy "database"   # Service is healthy
```

### Assertion Usage Example

```bash
@test "script: validates input and runs successfully" {
  run bash "$PROJECT_ROOT/scripts/script.sh" valid-input
  [ "$status" -eq 0 ]                    # Exit code is 0
  assert_output_contains "success"       # Output contains "success"
  assert_file_exists "output.txt"        # Created output file
  assert_container_running "backend"     # Backend container is running
}
```

---

## 🎯 Common Test Patterns

### Pattern 1: Test Script Existence

```bash
@test "script: exists and is executable" {
  assert_file_exists "$PROJECT_ROOT/scripts/script.sh"
  assert_script_executable "$PROJECT_ROOT/scripts/script.sh"
}

@test "script: has proper shebang" {
  run head -1 "$PROJECT_ROOT/scripts/script.sh"
  assert_output_contains "#!/bin/bash"
}
```

### Pattern 2: Test Argument Validation

```bash
@test "script: requires argument" {
  run bash "$PROJECT_ROOT/scripts/script.sh"
  [ "$status" -eq 1 ]
  assert_output_contains "Usage"
}

@test "script: rejects invalid argument" {
  run bash "$PROJECT_ROOT/scripts/script.sh" invalid
  [ "$status" -eq 1 ]
  assert_output_contains "Invalid"
}
```

### Pattern 3: Test Error Handling

```bash
@test "script: fails when Docker is not running" {
  mock_docker_failure
  run bash "$PROJECT_ROOT/scripts/script.sh"
  [ "$status" -eq 1 ]
  assert_output_contains "Docker"
}

@test "script: fails when service is unavailable" {
  mock_curl_failure
  run bash "$PROJECT_ROOT/scripts/script.sh"
  [ "$status" -eq 1 ]
  assert_output_contains "service unavailable"
}
```

### Pattern 4: Test with Temporary Files

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

### Pattern 5: Test Environment Variables

```bash
@test "script: uses DATABASE_URL" {
  export DATABASE_URL="postgresql://localhost/test"
  run bash "$PROJECT_ROOT/scripts/script.sh"
  [ "$status" -eq 0 ]
  assert_output_contains "postgresql://localhost/test"
}

@test "script: fails without DATABASE_URL" {
  unset DATABASE_URL
  run bash "$PROJECT_ROOT/scripts/script.sh"
  [ "$status" -eq 1 ]
  assert_output_contains "DATABASE_URL"
}
```

---

## 🐛 Debugging Tests

### Add Debug Output

```bash
@test "debug example" {
  run command
  echo "Status: $status" >&3
  echo "Output: $output" >&3
  echo "PROJECT_ROOT: $PROJECT_ROOT" >&3
  [ "$status" -eq 0 ]
}
```

### Run with Verbose Mode

```bash
./tests/shell/run-shell-tests.sh -v -t unit/test.bats
bats --verbose-run unit/test.bats
```

### Run Specific Test

```bash
./tests/shell/run-shell-tests.sh -t unit/deployment/test-deploy.bats
bats --filter "deploy: shows usage" unit/deployment/test-deploy.bats
```

### Check Test File Syntax

```bash
bash -n tests/shell/unit/deployment/test-deploy.bats
```

### Run Test Manually

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

## 🔍 Common Issues & Solutions

### Issue: Tests can't find scripts

**Solution:**
```bash
# Use $PROJECT_ROOT
run bash "$PROJECT_ROOT/scripts/script.sh"

# Ensure setup_file is called
setup() {
  setup_file  # Sets PROJECT_ROOT
}
```

### Issue: Mocks not working

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

### Issue: Tests hang or timeout

**Solution:**
```bash
# Use timeout
run timeout 2 bash long-script.sh

# Mock sleep
mock_sleep

# Use structure tests instead
run grep "pattern" script.sh
```

### Issue: Temporary directory not cleaned up

**Solution:**
```bash
# Always call teardown_test_dir
teardown() {
  teardown_test_dir
}
```

---

## 📚 Quick Links

### Documentation
- **[TESTING-SHELL.md](../../../docs/testing/TESTING-SHELL.md)** - Complete guide (all 10 sections)
- **[tests/shell/README.md](../../../../tests/shell/README.md)** - Test suite docs
- **[Bats Documentation](https://bats-core.readthedocs.io/)** - Official Bats docs

### Training Materials
- **[Training Outline](training-outline.md)** - 80-minute training session
- **[Exercises](exercises.md)** - Hands-on practice exercises

### Examples
- **[test-deploy.bats](../../../../tests/shell/unit/deployment/test-deploy.bats)** - Deployment tests (20 tests)
- **[test-health-check.bats](../../../../tests/shell/unit/core/test-health-check.bats)** - Health check tests (12 tests)
- **[test-automated-status-check.bats](../../../../tests/shell/unit/monitoring/test-automated-status-check.bats)** - Monitoring tests (18 tests)

---

## 📊 Our Test Suite Stats

- **Total Tests:** 153
- **Test Files:** 10
- **Execution Time:** 29 seconds
- **Coverage:** 100% (9 critical scripts)
- **Pass Rate:** 100%

**Categories:**
- Deployment: 78 tests
- Core: 33 tests
- Monitoring: 42 tests

---

## 💡 Best Practices

1. **Test Organization**
   - Group related tests
   - Use clear, descriptive test names
   - One assertion per test (when possible)

2. **Mocking**
   - Mock external dependencies
   - Use structure tests for speed
   - Restore commands in teardown

3. **Test Isolation**
   - Don't depend on other tests
   - Clean up after tests
   - Use temporary directories

4. **Fast Tests**
   - Use mocks
   - Use timeouts
   - Use structure tests
   - Mock sleep

5. **Test Naming**
   - Format: `script: what is being tested`
   - Be specific and descriptive
   - Use present tense

---

**Last Updated:** 2025-10-07  
**Status:** ✅ Ready for Use  
**Print this for quick reference!**
