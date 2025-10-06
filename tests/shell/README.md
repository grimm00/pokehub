# Shell Script Testing with Bats

**Pokehub Shell Script Test Suite**

This directory contains Bats (Bash Automated Testing System) tests for Pokehub's shell scripts.

---

## 🚀 Quick Start

### Run All Shell Tests
```bash
# From project root
bats tests/shell/

# Or run specific test file
bats tests/shell/unit/test-simple.bats
```

### Run Specific Test Directory
```bash
# Deployment tests only
bats tests/shell/unit/deployment/

# Core tests only
bats tests/shell/unit/core/

# Monitoring tests only
bats tests/shell/unit/monitoring/
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
| **Deployment** | 3 | 0 | 🚧 In Progress |
| **Core** | 3 | 0 | ⏳ Planned |
| **Monitoring** | 3 | 0 | ⏳ Planned |

**Total:** 7 tests passing

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

### Mocking External Commands

```bash
@test "deploy: calls docker command" {
  # Mock docker command
  docker() {
    echo "mocked docker"
    return 0
  }
  export -f docker
  
  # Run function
  run deploy_function
  
  # Assert
  [ "$status" -eq 0 ]
  [[ "$output" =~ "mocked" ]]
}
```

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

**Last Updated:** 2025-10-06  
**Test Count:** 7 smoke tests  
**Status:** Phase 1 Day 1 Complete - Infrastructure Setup ✅
