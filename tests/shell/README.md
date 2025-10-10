# Shell Script Testing with Bats

**Pokehub Shell Script Test Suite**

This directory contains Bats (Bash Automated Testing System) tests for Pokehub's shell scripts.

---

## 🚀 Quick Start

### Run All Shell Tests
```bash
# Using the test runner (recommended)
./tests/shell/run-shell-tests.sh

# Or use bats directly
bats --recursive tests/shell/unit/

# Run specific test file
bats tests/shell/unit/test-simple.bats
```

### Run Specific Test Directory
```bash
# Deployment tests only
bats tests/shell/unit/deployment/

# Or use the runner with specific test
./tests/shell/run-shell-tests.sh -t unit/deployment/test-deploy.bats
```

### Test Runner Options
```bash
# Verbose output
./tests/shell/run-shell-tests.sh -v

# Help
./tests/shell/run-shell-tests.sh -h
```

---

## 📁 Directory Structure

```
tests/shell/
├── README.md                  # This file
├── helpers/                   # Shared test utilities (from dev-toolkit)
│   ├── setup.bash            # Common setup functions
│   ├── mocks.bash            # Command mocking utilities
│   └── assertions.bash       # Custom assertions
├── unit/                     # Unit tests for shell scripts
│   ├── test-simple.bats      # Smoke tests
│   ├── deployment/           # Deployment script tests
│   │   ├── test-deploy.bats
│   │   ├── test-rollback.bats
│   │   └── test-docker.bats
│   ├── core/                 # Core script tests
│   │   ├── test-docker-startup.bats
│   │   ├── test-health-check.bats
│   │   └── test-invalidate-cache.bats
│   └── monitoring/           # Monitoring script tests
│       ├── test-status-check.bats
│       ├── test-verify-status.bats
│       └── test-weekly-review.bats
└── integration/              # Integration tests (if needed)
```

---

## 🧪 Test Coverage

### Current Status

| Category | Scripts | Tests | Status |
|----------|---------|-------|--------|
| **Smoke Tests** | - | 7 | ✅ Complete |
| **Deployment** | 3 | 71 | ✅ Complete |
| **Core** | 3 | 0 | ⏳ Planned (Phase 2) |
| **Monitoring** | 3 | 0 | ⏳ Planned (Phase 3) |

**Total:** 78 tests passing in < 25 seconds

### Deployment Scripts (Phase 1 Complete ✅)

| Script | Tests | Coverage |
|--------|-------|----------|
| `deploy.sh` | 20 | Environment validation, Docker checks, script structure |
| `rollback.sh` | 28 | Rollback process, safety features, compose file handling |
| `test-docker.sh` | 23 | Docker setup, health checks, user instructions |

---

## ✍️ Writing Tests

### Basic Test Structure

```bash
#!/usr/bin/env bats

# Load test helpers
load '../helpers/setup'
load '../helpers/mocks'
load '../helpers/assertions'

setup() {
  setup_file  # Sets PROJECT_ROOT and PATH
}

teardown() {
  restore_commands  # Restore mocked commands
}

@test "script_name: behavior description" {
  # Arrange
  local expected="value"
  
  # Act
  run some_command
  
  # Assert
  [ "$status" -eq 0 ]
  [ "$output" = "$expected" ]
}
```

### Using Pokehub-Specific Helpers

```bash
@test "deploy: works with healthy services" {
  # Use composite mock for all Pokehub services
  mock_pokehub_services_healthy
  
  # Run script
  run bash "$PROJECT_ROOT/scripts/deployment/deploy.sh" staging latest
  
  # Use custom assertions
  assert_output_contains "staging"
  assert_file_exists "$PROJECT_ROOT/scripts/deployment/deploy.sh"
}
```

### Available Mocks (from `helpers/mocks.bash`)

**Docker & Compose:**
- `mock_docker_success()` / `mock_docker_failure()`
- `mock_docker_compose_success()`
- `mock_curl_success()` / `mock_curl_failure()`

**Pokehub Services:**
- `mock_redis_cli_success()` / `mock_redis_cli_failure()`
- `mock_python_success()` / `mock_python_failure()`
- `mock_npm_success()` / `mock_npm_failure()`
- `mock_psql_success()` / `mock_psql_failure()`

**Composite Mocks:**
- `mock_pokehub_services_healthy()` - All services healthy
- `mock_pokehub_services_unhealthy()` - All services down

### Available Assertions (from `helpers/assertions.bash`)

**General:**
- `assert_output_contains "text"`
- `assert_file_exists "/path/to/file"`
- `assert_script_executable "/path/to/script"`

**Pokehub-Specific:**
- `assert_http_status "url" 200`
- `assert_container_running "container-name"`
- `assert_redis_healthy()`
- `assert_pokehub_service_healthy "backend|frontend|redis|database"`
- `assert_pokemon_api_returns_data()`

See `tests/shell/helpers/README.md` for complete documentation.

### Testing Error Conditions

```bash
@test "script: fails when required arg missing" {
  run script_command
  [ "$status" -ne 0 ]
  [[ "$output" =~ "error" ]]
}
```

---

## 📚 Resources

### Internal Documentation
- **Feature Plan:** `admin/planning/features/bats-testing/feature-plan.md`
- **Phase 1 Plan:** `admin/planning/features/bats-testing/phase-1.md`
- **Quick Start:** `admin/planning/features/bats-testing/quick-start.md`
- **Dev-Toolkit Guide:** `admin/planning/notes/opportunities/external/testing-overhaul/TESTING.md`

### External Resources
- **Bats Documentation:** https://bats-core.readthedocs.io/
- **Bats GitHub:** https://github.com/bats-core/bats-core
- **Bats Tutorial:** https://bats-core.readthedocs.io/en/stable/tutorial.html

### Examples
- **Dev-Toolkit Tests:** `/Users/cdwilson/Projects/dev-toolkit/tests/`
- **Smoke Tests:** `tests/shell/unit/test-simple.bats`

---

## 🎯 Testing Patterns

### Pattern 1: Pure Function Testing
Test functions with no external dependencies.

### Pattern 2: Command Mocking
Mock external commands (docker, git, curl, etc.).

### Pattern 3: Error Condition Testing
Test both success and failure paths.

### Pattern 4: Integration Testing
Test complete workflows end-to-end.

See `admin/planning/notes/opportunities/external/testing-overhaul/TESTING.md` for detailed patterns and examples.

---

## 🐛 Troubleshooting

### Tests Not Found
```bash
# Use bats directly with path
bats tests/shell/unit/test-simple.bats

# Or use find
find tests/shell/ -name "*.bats" | xargs bats
```

### PROJECT_ROOT Not Set
Ensure `setup_file` is called in `setup()`:
```bash
setup() {
  setup_file  # This sets PROJECT_ROOT
}
```

### Mocks Not Working
Ensure you export the function:
```bash
my_function() { echo "mocked"; }
export -f my_function  # Don't forget this!
```

---

## ✅ Best Practices

1. **Descriptive Test Names**
   - Use format: `script_name: behavior description`
   - Example: `deploy: validates environment variables`

2. **Test Both Success and Failure**
   - Always test error conditions
   - Verify error messages

3. **Use Arrange-Act-Assert Pattern**
   - Arrange: Set up test data
   - Act: Run the function
   - Assert: Verify results

4. **Keep Tests Fast**
   - Mock external commands
   - Avoid real network calls
   - Use temporary directories

5. **Make Tests Independent**
   - Each test should work in isolation
   - Use setup/teardown properly
   - Don't rely on test execution order

---

**Last Updated:** 2025-10-07  
**Test Count:** 78 tests (7 smoke + 71 deployment)  
**Execution Time:** < 25 seconds  
**Status:** Phase 1 Complete - Deployment Scripts ✅
