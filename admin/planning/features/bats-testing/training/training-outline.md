# Bats Testing Training Session

**Duration:** 80 minutes  
**Audience:** Development team  
**Prerequisites:** Basic shell scripting knowledge  
**Date:** TBD

---

## 📋 Agenda

### 1. Introduction (10 minutes)
- What is Bats?
- Why we test shell scripts
- Our test suite overview
- Success metrics

### 2. Running Tests (10 minutes)
- Demo: Run all tests
- Demo: Run specific test
- Demo: Verbose mode
- Understanding output
- **Hands-on:** Participants run tests

### 3. Writing Tests (15 minutes)
- Demo: Basic test structure
- Demo: Test file creation
- Demo: Setup and teardown
- Demo: Simple assertions
- **Hands-on:** Write a simple test

### 4. Helpers and Mocks (15 minutes)
- Demo: Using setup helpers
- Demo: Using mocks
- Demo: Custom assertions
- Best practices
- **Hands-on:** Write a test with mocks

### 5. Live Coding Exercise (20 minutes)
- Task: Write tests for a new script
- Analyze the script
- Plan test categories
- Write structure tests
- Write functional tests
- **Group activity**

### 6. Q&A (10 minutes)
- Questions
- Troubleshooting
- Next steps
- Resources

---

## 📚 Materials Needed

### Before Training
- [ ] Ensure all participants have Bats installed
- [ ] Share training repository link
- [ ] Share documentation links
- [ ] Prepare example scripts
- [ ] Set up screen sharing

### During Training
- [ ] Slides or presentation (optional)
- [ ] Terminal for live demos
- [ ] Example scripts for exercises
- [ ] Quick reference handout

### After Training
- [ ] Share recording (if recorded)
- [ ] Share exercise solutions
- [ ] Collect feedback
- [ ] Follow-up resources

---

## 1. Introduction (10 minutes)

### What is Bats?

**Bats** (Bash Automated Testing System) is a TAP-compliant testing framework for Bash scripts.

**Key Points:**
- Simple, readable test syntax
- TAP (Test Anything Protocol) output
- Easy CI/CD integration
- Fast execution
- No complex dependencies

**Show:** Bats GitHub page and documentation

---

### Why Test Shell Scripts?

**The Problem:**
- Shell scripts are critical infrastructure
- Often deploy applications
- Manage services
- Automate workflows
- Can fail silently in production

**The Solution:**
- Catch errors before deployment
- Document expected behavior
- Enable safe refactoring
- Provide fast feedback
- Integrate with CI/CD

**Real Example:**
- Before: Manual testing, occasional production issues
- After: 153 automated tests, 29s execution, 100% coverage

---

### Our Test Suite Overview

**Statistics:**
- **153 tests** across 9 scripts
- **29 seconds** execution time
- **100% coverage** of critical scripts
- **100% pass rate** in CI/CD

**Coverage:**
| Category | Scripts | Tests |
|----------|---------|-------|
| Deployment | 3 | 78 |
| Core | 3 | 33 |
| Monitoring | 3 | 42 |

**Show:** Run `./tests/shell/run-shell-tests.sh -l`

---

### Success Metrics

**What We've Achieved:**
- ✅ Zero shell script failures in production (since tests added)
- ✅ Faster development (instant feedback)
- ✅ Confident refactoring
- ✅ Better documentation (tests as specs)
- ✅ Team knowledge sharing

**Demo:** Show test output

---

## 2. Running Tests (10 minutes)

### Demo: Run All Tests

**Command:**
```bash
./tests/shell/run-shell-tests.sh
```

**What to show:**
- Header and version check
- Test execution (TAP output)
- Summary and duration
- Exit code (0 = pass, 1 = fail)

**Key Points:**
- Fast execution (29s for 153 tests)
- Clear pass/fail indicators
- Helpful error messages

---

### Demo: Run Specific Test

**Command:**
```bash
./tests/shell/run-shell-tests.sh -t unit/deployment/test-deploy.bats
```

**What to show:**
- Runs only one test file
- Faster for development
- Same output format

**Use Case:**
- Testing specific script changes
- Debugging failing tests
- Iterative development

---

### Demo: Verbose Mode

**Command:**
```bash
./tests/shell/run-shell-tests.sh -v -t unit/deployment/test-deploy.bats
```

**What to show:**
- Detailed output
- Test execution steps
- Useful for debugging

---

### Demo: Other Flags

**List tests:**
```bash
./tests/shell/run-shell-tests.sh -l
```

**Filter tests:**
```bash
./tests/shell/run-shell-tests.sh -f "deploy"
```

**Quiet mode:**
```bash
./tests/shell/run-shell-tests.sh -q
```

---

### Understanding Output

**TAP Format:**
```
1..3
ok 1 deploy: shows usage with environment in output
ok 2 deploy: rejects invalid environment
ok 3 deploy: fails when Docker is not running
```

**Key Elements:**
- `1..N` - Test plan (N tests)
- `ok N` - Test N passed
- `not ok N` - Test N failed

**Show:** Example of passing and failing test

---

### Hands-On: Participants Run Tests

**Task:** (5 minutes)

1. Navigate to project root
2. Run all shell tests
3. Run a specific test file
4. Try verbose mode
5. List all tests

**Commands:**
```bash
cd /path/to/pokedex
./tests/shell/run-shell-tests.sh
./tests/shell/run-shell-tests.sh -t unit/deployment/test-deploy.bats
./tests/shell/run-shell-tests.sh -v -t unit/deployment/test-deploy.bats
./tests/shell/run-shell-tests.sh -l
```

**Instructor:** Walk around, help with issues

---

## 3. Writing Tests (15 minutes)

### Demo: Basic Test Structure

**Show:** `tests/shell/unit/deployment/test-deploy.bats`

**Key Components:**
```bash
#!/usr/bin/env bats

# Load helpers
load '../../../helpers/setup'
load '../../../helpers/mocks'
load '../../../helpers/assertions'

# Setup (runs before each test)
setup() {
  setup_file
  restore_commands
}

# Teardown (runs after each test)
teardown() {
  restore_commands
}

# Test case
@test "deploy: shows usage with environment in output" {
  mock_pokehub_services_healthy
  run timeout 2 bash "$PROJECT_ROOT/scripts/deployment/deploy.sh" staging latest
  assert_output_contains "staging"
}
```

**Explain:**
1. Shebang
2. Load helpers
3. Setup/teardown
4. Test syntax (`@test`)
5. Assertions

---

### Demo: Test File Creation

**Live Demo:** Create a new test file

**Steps:**
1. Create file: `tests/shell/unit/example/test-example.bats`
2. Add shebang: `#!/usr/bin/env bats`
3. Load helpers
4. Add setup/teardown
5. Write first test

**Example:**
```bash
#!/usr/bin/env bats

load '../../../helpers/setup'
load '../../../helpers/mocks'
load '../../../helpers/assertions'

setup() {
  setup_file
  restore_commands
}

teardown() {
  restore_commands
}

@test "example: script exists" {
  assert_file_exists "$PROJECT_ROOT/scripts/example.sh"
}
```

---

### Demo: Setup and Teardown

**Explain:**
- `setup()` runs before each test
- `teardown()` runs after each test
- `setup_file()` runs once per file
- `teardown_file()` runs once per file

**Common Setup:**
```bash
setup() {
  setup_file              # Initialize PROJECT_ROOT
  restore_commands        # Restore mocked commands
  setup_test_dir          # Create temp directory (optional)
}

teardown() {
  restore_commands        # Clean up mocks
  teardown_test_dir       # Remove temp directory (optional)
}
```

---

### Demo: Simple Assertions

**Basic Assertions:**
```bash
# Exit status
[ "$status" -eq 0 ]      # Success
[ "$status" -eq 1 ]      # Failure

# Output
[ "$output" = "exact" ]           # Exact match
[[ "$output" =~ "pattern" ]]      # Regex match

# Files
[ -f "$file" ]           # File exists
[ -x "$script" ]         # Executable
```

**Custom Assertions:**
```bash
assert_output_contains "text"
assert_file_exists "file"
assert_script_executable "script"
```

---

### Hands-On: Write a Simple Test

**Task:** (10 minutes)

Create a test file for a simple script.

**Script to test:** `scripts/example-hello.sh`
```bash
#!/bin/bash
echo "Hello, $1!"
```

**Your test:** `tests/shell/unit/example/test-hello.bats`

**Write tests for:**
1. Script exists and is executable
2. Script has proper shebang
3. Script outputs "Hello, World!" when given "World"
4. Script requires an argument

**Solution provided after exercise**

---

## 4. Helpers and Mocks (15 minutes)

### Demo: Using Setup Helpers

**Available Helpers:**
```bash
setup_file()              # Initialize PROJECT_ROOT
setup_test_dir()          # Create temp directory
teardown_test_dir()       # Clean up temp directory
init_test_repo()          # Initialize git repo
create_initial_commit()   # Create initial commit
```

**Example:**
```bash
setup() {
  setup_file
  setup_test_dir
  init_test_repo
  create_initial_commit
}

teardown() {
  teardown_test_dir
}

@test "example with temp dir" {
  touch test-file.txt
  [ -f test-file.txt ]
}
```

---

### Demo: Using Mocks

**Why Mock?**
- Speed up tests (no real Docker, curl, etc.)
- Isolate tests (no external dependencies)
- Control behavior (simulate success/failure)
- Avoid side effects (no actual deployments)

**Available Mocks:**
```bash
mock_docker_success()
mock_docker_failure()
mock_curl_success()
mock_curl_failure()
mock_pokehub_services_healthy()
mock_pokehub_services_unhealthy()
mock_sleep()
```

**Example:**
```bash
@test "deploy fails when Docker is down" {
  mock_docker_failure
  run bash "$PROJECT_ROOT/scripts/deployment/deploy.sh" staging latest
  [ "$status" -eq 1 ]
  assert_output_contains "Docker"
}
```

---

### Demo: Custom Assertions

**Available Assertions:**
```bash
# Basic
assert_output_contains "text"
assert_file_exists "file"
assert_script_executable "script"

# Pokehub-specific
assert_container_running "name"
assert_pokehub_service_healthy "backend"
assert_http_status "url" "200"
```

**Example:**
```bash
@test "backend is healthy" {
  assert_pokehub_service_healthy "backend"
}
```

---

### Best Practices

**1. Test Organization:**
- Group related tests
- Use clear test names
- One assertion per test (when possible)

**2. Mocking:**
- Mock external dependencies
- Use structure tests for speed
- Restore commands in teardown

**3. Test Isolation:**
- Don't depend on other tests
- Clean up after tests
- Use temporary directories

**4. Fast Tests:**
- Use mocks
- Use timeouts
- Use structure tests

---

### Hands-On: Write a Test with Mocks

**Task:** (10 minutes)

Write tests for a deployment script that uses Docker.

**Script:** `scripts/example-deploy.sh`
```bash
#!/bin/bash
if ! docker info > /dev/null 2>&1; then
  echo "Docker is not running"
  exit 1
fi
echo "Deploying to $1"
docker-compose up -d
```

**Your tests:**
1. Fails when Docker is not running
2. Succeeds when Docker is running
3. Shows environment in output

**Use mocks to avoid real Docker commands!**

**Solution provided after exercise**

---

## 5. Live Coding Exercise (20 minutes)

### Task: Write Tests for a New Script

**Scenario:** We have a new monitoring script that needs tests.

**Script:** `scripts/monitoring/check-status.sh`
```bash
#!/bin/bash

# Check if service is running
check_service() {
  local service="$1"
  if docker ps | grep -q "$service"; then
    echo "$service is running"
    return 0
  else
    echo "$service is not running"
    return 1
  fi
}

# Main
if [ $# -eq 0 ]; then
  echo "Usage: $0 <service-name>"
  exit 1
fi

check_service "$1"
```

---

### Step 1: Analyze the Script (5 minutes)

**Group Discussion:**
- What does this script do?
- What are the inputs?
- What are the outputs?
- What can go wrong?
- What should we test?

**Instructor:** Lead discussion, write on board

---

### Step 2: Plan Test Categories (5 minutes)

**Test Categories:**
1. **Structure Tests**
   - Script exists and is executable
   - Has proper shebang
   - Defines check_service function

2. **Validation Tests**
   - Requires service name argument
   - Shows usage when no args

3. **Functional Tests**
   - Reports running service correctly
   - Reports stopped service correctly
   - Uses Docker ps command

**Instructor:** Explain categorization

---

### Step 3: Write Structure Tests (5 minutes)

**Live Coding:**
```bash
#!/usr/bin/env bats

load '../../../helpers/setup'
load '../../../helpers/mocks'
load '../../../helpers/assertions'

setup() {
  setup_file
  restore_commands
}

teardown() {
  restore_commands
}

@test "check-status: script exists and is executable" {
  assert_file_exists "$PROJECT_ROOT/scripts/monitoring/check-status.sh"
  assert_script_executable "$PROJECT_ROOT/scripts/monitoring/check-status.sh"
}

@test "check-status: has proper shebang" {
  run head -1 "$PROJECT_ROOT/scripts/monitoring/check-status.sh"
  assert_output_contains "#!/bin/bash"
}

@test "check-status: defines check_service function" {
  run grep "check_service()" "$PROJECT_ROOT/scripts/monitoring/check-status.sh"
  [ "$status" -eq 0 ]
}
```

---

### Step 4: Write Functional Tests (5 minutes)

**Live Coding:**
```bash
@test "check-status: requires service name argument" {
  run bash "$PROJECT_ROOT/scripts/monitoring/check-status.sh"
  [ "$status" -eq 1 ]
  assert_output_contains "Usage"
}

@test "check-status: reports running service" {
  mock_docker_success
  run bash "$PROJECT_ROOT/scripts/monitoring/check-status.sh" "backend"
  [ "$status" -eq 0 ]
  assert_output_contains "backend is running"
}

@test "check-status: reports stopped service" {
  mock_docker_failure
  run bash "$PROJECT_ROOT/scripts/monitoring/check-status.sh" "backend"
  [ "$status" -eq 1 ]
  assert_output_contains "backend is not running"
}
```

**Run tests:** Show passing tests

---

## 6. Q&A (10 minutes)

### Common Questions

**Q: How do I test scripts that modify files?**
**A:** Use `setup_test_dir()` to create a temporary directory, run your script there, then clean up with `teardown_test_dir()`.

**Q: Should I test every line of code?**
**A:** Focus on critical paths, error handling, and edge cases. Structure tests are fast and cover a lot.

**Q: How do I debug failing tests?**
**A:** Use verbose mode (`-v`), add debug output (`echo "Debug: $var" >&3`), or run tests manually.

**Q: Can I test scripts that require sudo?**
**A:** Mock the commands that require sudo instead of running them with real sudo.

**Q: How often should I run tests?**
**A:** Run tests before committing, in CI/CD, and when making changes to scripts.

---

### Troubleshooting

**Issue: Tests can't find scripts**
**Solution:** Use `$PROJECT_ROOT` and ensure `setup_file()` is called.

**Issue: Mocks not working**
**Solution:** Call `restore_commands()` in setup and teardown.

**Issue: Tests hang**
**Solution:** Use `timeout` command or mock slow operations.

---

### Next Steps

**For Everyone:**
1. Review documentation: `docs/testing/TESTING-SHELL.md`
2. Practice writing tests
3. Add tests for new scripts
4. Share knowledge with team

**Resources:**
- [TESTING-SHELL.md](../../../docs/testing/TESTING-SHELL.md) - Complete guide
- [tests/shell/README.md](../../../../tests/shell/README.md) - Test suite docs
- [Quick Reference](quick-reference.md) - Cheat sheet
- [Exercises](exercises.md) - Practice exercises

---

### Feedback

**Please provide feedback:**
- What was helpful?
- What was confusing?
- What would you like to learn more about?
- Suggestions for improvement?

**Feedback form:** [Link to form]

---

## 📝 Exercise Solutions

### Exercise 1: Simple Test (Section 3)

**File:** `tests/shell/unit/example/test-hello.bats`

```bash
#!/usr/bin/env bats

load '../../../helpers/setup'
load '../../../helpers/mocks'
load '../../../helpers/assertions'

setup() {
  setup_file
  restore_commands
}

teardown() {
  restore_commands
}

@test "hello: script exists and is executable" {
  assert_file_exists "$PROJECT_ROOT/scripts/example-hello.sh"
  assert_script_executable "$PROJECT_ROOT/scripts/example-hello.sh"
}

@test "hello: has proper shebang" {
  run head -1 "$PROJECT_ROOT/scripts/example-hello.sh"
  assert_output_contains "#!/bin/bash"
}

@test "hello: outputs Hello, World!" {
  run bash "$PROJECT_ROOT/scripts/example-hello.sh" "World"
  [ "$status" -eq 0 ]
  assert_output_contains "Hello, World!"
}

@test "hello: requires an argument" {
  run bash "$PROJECT_ROOT/scripts/example-hello.sh"
  [ "$status" -eq 0 ]  # Script doesn't validate, so it passes
  assert_output_contains "Hello, !"  # But output is empty
}
```

---

### Exercise 2: Test with Mocks (Section 4)

**File:** `tests/shell/unit/example/test-deploy.bats`

```bash
#!/usr/bin/env bats

load '../../../helpers/setup'
load '../../../helpers/mocks'
load '../../../helpers/assertions'

setup() {
  setup_file
  restore_commands
}

teardown() {
  restore_commands
}

@test "deploy: fails when Docker is not running" {
  mock_docker_failure
  run bash "$PROJECT_ROOT/scripts/example-deploy.sh" staging
  [ "$status" -eq 1 ]
  assert_output_contains "Docker is not running"
}

@test "deploy: succeeds when Docker is running" {
  mock_docker_success
  mock_docker_compose_success
  run bash "$PROJECT_ROOT/scripts/example-deploy.sh" staging
  [ "$status" -eq 0 ]
}

@test "deploy: shows environment in output" {
  mock_docker_success
  mock_docker_compose_success
  run bash "$PROJECT_ROOT/scripts/example-deploy.sh" staging
  assert_output_contains "staging"
}
```

---

## 📚 Additional Resources

### Documentation
- **[TESTING-SHELL.md](../../../docs/testing/TESTING-SHELL.md)** - Complete shell testing guide
- **[tests/shell/README.md](../../../../tests/shell/README.md)** - Test suite documentation
- **[Bats Documentation](https://bats-core.readthedocs.io/)** - Official Bats docs

### Examples
- **[test-deploy.bats](../../../../tests/shell/unit/deployment/test-deploy.bats)** - Deployment tests
- **[test-health-check.bats](../../../../tests/shell/unit/core/test-health-check.bats)** - Health check tests
- **[test-automated-status-check.bats](../../../../tests/shell/unit/monitoring/test-automated-status-check.bats)** - Monitoring tests

### Tools
- **[run-shell-tests.sh](../../../../tests/shell/run-shell-tests.sh)** - Test runner
- **[helpers/](../../../../tests/shell/helpers/)** - Test helpers

---

**Last Updated:** 2025-10-07  
**Status:** ✅ Ready for Training  
**Duration:** 80 minutes
