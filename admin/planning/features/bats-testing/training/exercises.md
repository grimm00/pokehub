# Bats Testing Exercises

**Purpose:** Hands-on practice for learning Bats testing  
**Difficulty:** Beginner to Intermediate  
**Time:** 30-60 minutes total

---

## 📋 Setup

### Prerequisites

1. **Install Bats:**
   ```bash
   # macOS
   brew install bats-core
   
   # Verify
   bats --version
   ```

2. **Navigate to project:**
   ```bash
   cd /path/to/pokedex
   ```

3. **Verify test infrastructure:**
   ```bash
   ls tests/shell/helpers/
   # Should see: setup.bash, mocks.bash, assertions.bash
   ```

---

## Exercise 1: Run Existing Tests

**Goal:** Get familiar with running tests  
**Time:** 5 minutes  
**Difficulty:** ⭐ Beginner

### Tasks

1. Run all shell tests
2. Run a specific test file
3. Run tests with verbose output
4. List all available tests
5. Filter tests by pattern

### Commands

```bash
# Run all tests
./tests/shell/run-shell-tests.sh

# Run specific test
./tests/shell/run-shell-tests.sh -t unit/deployment/test-deploy.bats

# Verbose output
./tests/shell/run-shell-tests.sh -v -t unit/deployment/test-deploy.bats

# List all tests
./tests/shell/run-shell-tests.sh -l

# Filter tests
./tests/shell/run-shell-tests.sh -f "deploy"
```

### Expected Results

- All tests should pass
- You should see TAP output
- Duration should be ~29 seconds for all tests

### Questions

1. How many total tests are there?
2. Which category has the most tests?
3. What does the `-f` flag do?

<details>
<summary>Answers</summary>

1. 153 tests
2. Deployment (78 tests)
3. Filters tests by pattern (runs only matching tests)
</details>

---

## Exercise 2: Write a Simple Structure Test

**Goal:** Create your first test file  
**Time:** 10 minutes  
**Difficulty:** ⭐⭐ Beginner

### Scenario

You have a simple greeting script that needs tests.

**Script:** `scripts/example/greet.sh`
```bash
#!/bin/bash
# Simple greeting script

if [ $# -eq 0 ]; then
  echo "Usage: $0 <name>"
  exit 1
fi

NAME="$1"
echo "Hello, $NAME! Welcome to Pokehub."
```

### Tasks

Create a test file at `tests/shell/unit/example/test-greet.bats` with these tests:

1. Script exists and is executable
2. Script has proper shebang (`#!/bin/bash`)
3. Script contains "Welcome to Pokehub" text

### Template

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

@test "greet: script exists and is executable" {
  # YOUR CODE HERE
}

@test "greet: has proper shebang" {
  # YOUR CODE HERE
}

@test "greet: contains welcome message" {
  # YOUR CODE HERE
}
```

### Hints

- Use `assert_file_exists` for file existence
- Use `assert_script_executable` for executable check
- Use `head -1` to get first line (shebang)
- Use `grep` to search for text in file

### Run Your Tests

```bash
# First, create the script
mkdir -p scripts/example
cat > scripts/example/greet.sh << 'EOF'
#!/bin/bash
# Simple greeting script

if [ $# -eq 0 ]; then
  echo "Usage: $0 <name>"
  exit 1
fi

NAME="$1"
echo "Hello, $NAME! Welcome to Pokehub."
EOF
chmod +x scripts/example/greet.sh

# Create test directory
mkdir -p tests/shell/unit/example

# Create your test file
# (Write your solution here)

# Run your tests
./tests/shell/run-shell-tests.sh -t unit/example/test-greet.bats
```

<details>
<summary>Solution</summary>

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

@test "greet: script exists and is executable" {
  assert_file_exists "$PROJECT_ROOT/scripts/example/greet.sh"
  assert_script_executable "$PROJECT_ROOT/scripts/example/greet.sh"
}

@test "greet: has proper shebang" {
  run head -1 "$PROJECT_ROOT/scripts/example/greet.sh"
  [ "$status" -eq 0 ]
  assert_output_contains "#!/bin/bash"
}

@test "greet: contains welcome message" {
  run grep "Welcome to Pokehub" "$PROJECT_ROOT/scripts/example/greet.sh"
  [ "$status" -eq 0 ]
}
```
</details>

---

## Exercise 3: Write Functional Tests

**Goal:** Test actual script behavior  
**Time:** 15 minutes  
**Difficulty:** ⭐⭐ Intermediate

### Scenario

Continue with the `greet.sh` script from Exercise 2.

### Tasks

Add these functional tests to your test file:

1. Script shows usage when no arguments provided
2. Script exits with code 1 when no arguments
3. Script greets user correctly with name "Alice"
4. Script output contains the provided name

### Template

```bash
@test "greet: shows usage when no arguments" {
  # YOUR CODE HERE
}

@test "greet: exits with code 1 when no arguments" {
  # YOUR CODE HERE
}

@test "greet: greets user with name Alice" {
  # YOUR CODE HERE
}

@test "greet: output contains provided name" {
  # YOUR CODE HERE
}
```

### Hints

- Use `run bash "$PROJECT_ROOT/scripts/example/greet.sh"` to run script
- Check `$status` for exit code
- Check `$output` for script output
- Use `assert_output_contains` for output validation

<details>
<summary>Solution</summary>

```bash
@test "greet: shows usage when no arguments" {
  run bash "$PROJECT_ROOT/scripts/example/greet.sh"
  assert_output_contains "Usage"
}

@test "greet: exits with code 1 when no arguments" {
  run bash "$PROJECT_ROOT/scripts/example/greet.sh"
  [ "$status" -eq 1 ]
}

@test "greet: greets user with name Alice" {
  run bash "$PROJECT_ROOT/scripts/example/greet.sh" "Alice"
  [ "$status" -eq 0 ]
  assert_output_contains "Hello, Alice!"
}

@test "greet: output contains provided name" {
  run bash "$PROJECT_ROOT/scripts/example/greet.sh" "Bob"
  [ "$status" -eq 0 ]
  assert_output_contains "Bob"
}
```
</details>

---

## Exercise 4: Use Mocks and Assertions

**Goal:** Test scripts with external dependencies  
**Time:** 20 minutes  
**Difficulty:** ⭐⭐⭐ Intermediate

### Scenario

You have a deployment script that uses Docker and needs tests.

**Script:** `scripts/example/simple-deploy.sh`
```bash
#!/bin/bash
# Simple deployment script

set -e

ENVIRONMENT="$1"

if [ -z "$ENVIRONMENT" ]; then
  echo "Usage: $0 <environment>"
  exit 1
fi

# Check Docker
if ! docker info > /dev/null 2>&1; then
  echo "Error: Docker is not running"
  exit 1
fi

echo "Deploying to $ENVIRONMENT..."
docker-compose -f "docker-compose.$ENVIRONMENT.yml" up -d
echo "Deployment to $ENVIRONMENT complete!"
```

### Tasks

Create `tests/shell/unit/example/test-simple-deploy.bats` with these tests:

1. Script exists and is executable
2. Script requires environment argument
3. Script fails when Docker is not running
4. Script succeeds when Docker is running (use mocks!)
5. Script shows environment name in output

### Template

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

@test "simple-deploy: script exists and is executable" {
  # YOUR CODE HERE
}

@test "simple-deploy: requires environment argument" {
  # YOUR CODE HERE
}

@test "simple-deploy: fails when Docker is not running" {
  # YOUR CODE HERE
  # Hint: Use mock_docker_failure
}

@test "simple-deploy: succeeds when Docker is running" {
  # YOUR CODE HERE
  # Hint: Use mock_docker_success and mock_docker_compose_success
}

@test "simple-deploy: shows environment in output" {
  # YOUR CODE HERE
}
```

### Setup Script

```bash
# Create the script
mkdir -p scripts/example
cat > scripts/example/simple-deploy.sh << 'EOF'
#!/bin/bash
# Simple deployment script

set -e

ENVIRONMENT="$1"

if [ -z "$ENVIRONMENT" ]; then
  echo "Usage: $0 <environment>"
  exit 1
fi

# Check Docker
if ! docker info > /dev/null 2>&1; then
  echo "Error: Docker is not running"
  exit 1
fi

echo "Deploying to $ENVIRONMENT..."
docker-compose -f "docker-compose.$ENVIRONMENT.yml" up -d
echo "Deployment to $ENVIRONMENT complete!"
EOF
chmod +x scripts/example/simple-deploy.sh
```

### Hints

- Use `mock_docker_failure()` to simulate Docker being down
- Use `mock_docker_success()` to simulate Docker being up
- Use `mock_docker_compose_success()` to mock docker-compose
- Always call mocks BEFORE running the script
- Use `assert_output_contains` to check output

<details>
<parameter name="contents">Summary

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

@test "simple-deploy: script exists and is executable" {
  assert_file_exists "$PROJECT_ROOT/scripts/example/simple-deploy.sh"
  assert_script_executable "$PROJECT_ROOT/scripts/example/simple-deploy.sh"
}

@test "simple-deploy: requires environment argument" {
  run bash "$PROJECT_ROOT/scripts/example/simple-deploy.sh"
  [ "$status" -eq 1 ]
  assert_output_contains "Usage"
}

@test "simple-deploy: fails when Docker is not running" {
  mock_docker_failure
  run bash "$PROJECT_ROOT/scripts/example/simple-deploy.sh" staging
  [ "$status" -eq 1 ]
  assert_output_contains "Docker is not running"
}

@test "simple-deploy: succeeds when Docker is running" {
  mock_docker_success
  mock_docker_compose_success
  run bash "$PROJECT_ROOT/scripts/example/simple-deploy.sh" staging
  [ "$status" -eq 0 ]
}

@test "simple-deploy: shows environment in output" {
  mock_docker_success
  mock_docker_compose_success
  run bash "$PROJECT_ROOT/scripts/example/simple-deploy.sh" production
  [ "$status" -eq 0 ]
  assert_output_contains "production"
}
```
</details>

---

## Exercise 5: Test with Temporary Directories

**Goal:** Test scripts that create files  
**Time:** 15 minutes  
**Difficulty:** ⭐⭐⭐ Intermediate

### Scenario

You have a script that generates a configuration file.

**Script:** `scripts/example/generate-config.sh`
```bash
#!/bin/bash
# Generate configuration file

ENVIRONMENT="${1:-development}"
OUTPUT_FILE="${2:-config.yml}"

cat > "$OUTPUT_FILE" << EOF
environment: $ENVIRONMENT
database:
  host: db-$ENVIRONMENT.example.com
  port: 5432
cache:
  enabled: true
  ttl: 3600
EOF

echo "Configuration written to $OUTPUT_FILE"
```

### Tasks

Create tests that:

1. Script creates output file
2. Output file contains environment name
3. Output file contains database configuration
4. Script uses default filename when not specified
5. Multiple runs don't interfere with each other

### Template

```bash
#!/usr/bin/env bats

load '../../../helpers/setup'
load '../../../helpers/mocks'
load '../../../helpers/assertions'

setup() {
  setup_file
  restore_commands
  setup_test_dir  # Create temp directory
}

teardown() {
  restore_commands
  teardown_test_dir  # Clean up temp directory
}

@test "generate-config: creates output file" {
  # YOUR CODE HERE
}

@test "generate-config: output contains environment" {
  # YOUR CODE HERE
}

@test "generate-config: output contains database config" {
  # YOUR CODE HERE
}

@test "generate-config: uses default filename" {
  # YOUR CODE HERE
}
```

### Hints

- Use `setup_test_dir()` in setup
- Use `teardown_test_dir()` in teardown
- Files created in tests are in temporary directory
- Use `assert_file_exists` to check file creation
- Use `grep` to check file contents

<details>
<summary>Solution</summary>

```bash
#!/usr/bin/env bats

load '../../../helpers/setup'
load '../../../helpers/mocks'
load '../../../helpers/assertions'

setup() {
  setup_file
  restore_commands
  setup_test_dir
}

teardown() {
  restore_commands
  teardown_test_dir
}

@test "generate-config: creates output file" {
  run bash "$PROJECT_ROOT/scripts/example/generate-config.sh" staging output.yml
  [ "$status" -eq 0 ]
  assert_file_exists "output.yml"
}

@test "generate-config: output contains environment" {
  run bash "$PROJECT_ROOT/scripts/example/generate-config.sh" production prod.yml
  [ "$status" -eq 0 ]
  run grep "environment: production" prod.yml
  [ "$status" -eq 0 ]
}

@test "generate-config: output contains database config" {
  run bash "$PROJECT_ROOT/scripts/example/generate-config.sh" staging db.yml
  [ "$status" -eq 0 ]
  run grep "database:" db.yml
  [ "$status" -eq 0 ]
  run grep "host: db-staging.example.com" db.yml
  [ "$status" -eq 0 ]
}

@test "generate-config: uses default filename" {
  run bash "$PROJECT_ROOT/scripts/example/generate-config.sh" development
  [ "$status" -eq 0 ]
  assert_file_exists "config.yml"
}
```
</details>

---

## Bonus Exercise: Create Your Own Test Suite

**Goal:** Apply everything you've learned  
**Time:** 30+ minutes  
**Difficulty:** ⭐⭐⭐⭐ Advanced

### Scenario

Choose one of your own shell scripts (or create a new one) and write a complete test suite for it.

### Requirements

Your test suite should include:

1. **Structure Tests** (at least 3)
   - Script exists and is executable
   - Has proper shebang
   - Contains expected functions/patterns

2. **Validation Tests** (at least 3)
   - Argument validation
   - Input validation
   - Error messages

3. **Functional Tests** (at least 5)
   - Happy path scenarios
   - Error scenarios
   - Edge cases

4. **Use Advanced Features**
   - Mocks (if script uses external commands)
   - Temporary directories (if script creates files)
   - Custom assertions
   - Setup and teardown

### Evaluation Criteria

- ✅ All tests pass
- ✅ Good test names (descriptive, follows pattern)
- ✅ Proper use of helpers and mocks
- ✅ Tests are isolated (don't depend on each other)
- ✅ Good coverage (structure, validation, functional)

### Share Your Work

Share your test suite with the team for review and feedback!

---

## 📚 Additional Resources

### Documentation
- **[TESTING-SHELL.md](../../../docs/testing/TESTING-SHELL.md)** - Complete guide
- **[Quick Reference](quick-reference.md)** - Cheat sheet
- **[Training Outline](training-outline.md)** - Training session

### Examples
- **[test-deploy.bats](../../../../tests/shell/unit/deployment/test-deploy.bats)** - Deployment tests
- **[test-health-check.bats](../../../../tests/shell/unit/core/test-health-check.bats)** - Health check tests
- **[test-automated-status-check.bats](../../../../tests/shell/unit/monitoring/test-automated-status-check.bats)** - Monitoring tests

### Getting Help
- Review existing tests for examples
- Ask team members
- Check Bats documentation
- Use verbose mode for debugging

---

## 🎯 Summary

**You've learned:**
- ✅ How to run tests
- ✅ How to write structure tests
- ✅ How to write functional tests
- ✅ How to use mocks and assertions
- ✅ How to test with temporary directories
- ✅ Best practices for test organization

**Next steps:**
1. Write tests for your own scripts
2. Add tests to new scripts
3. Share knowledge with team
4. Keep practicing!

---

**Last Updated:** 2025-10-07  
**Status:** ✅ Ready for Practice  
**Difficulty:** ⭐ to ⭐⭐⭐⭐
