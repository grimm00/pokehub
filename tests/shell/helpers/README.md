# Bats Test Helpers

**Pokehub-Specific Test Utilities**

This directory contains helper functions for Bats tests, adapted specifically for Pokehub's needs.

---

## 📁 Files

### `setup.bash` - Test Setup & Teardown

**Purpose:** Common setup and teardown functions for all tests.

**Functions:**
- `setup_file()` - Sets `PROJECT_ROOT` and `PATH` (call in `setup()`)
- `setup_test_dir()` - Creates temporary test directory
- `teardown_test_dir()` - Cleans up temporary directory
- `init_test_repo()` - Initializes git repository for testing
- `create_initial_commit()` - Creates initial commit

**Usage:**
```bash
setup() {
  setup_file  # Always call this first
}
```

---

### `mocks.bash` - Command Mocking

**Purpose:** Mock external commands to avoid real execution and speed up tests.

#### Generic Mocks

| Function | Purpose |
|----------|---------|
| `mock_git_remote()` | Mock git remote URL |
| `mock_gh_repo_view()` | Mock GitHub repo view |
| `restore_commands()` | Restore all mocked commands |

#### Docker Mocks

| Function | Purpose |
|----------|---------|
| `mock_docker_success()` | Mock Docker commands (success) |
| `mock_docker_failure()` | Mock Docker commands (failure) |
| `mock_docker_compose_success()` | Mock docker-compose commands |

#### Service Mocks

| Function | Purpose |
|----------|---------|
| `mock_curl_success()` | Mock curl (success) |
| `mock_curl_failure()` | Mock curl (failure) |
| `mock_redis_cli_success()` | Mock redis-cli (PONG) |
| `mock_redis_cli_failure()` | Mock redis-cli (failure) |
| `mock_sleep()` | Mock sleep (instant return) |

#### Pokehub Application Mocks

| Function | Purpose |
|----------|---------|
| `mock_python_success()` | Mock Python/Flask backend |
| `mock_python_failure()` | Mock Python failure |
| `mock_npm_success()` | Mock npm (frontend) |
| `mock_npm_failure()` | Mock npm failure |
| `mock_psql_success()` | Mock PostgreSQL |
| `mock_psql_failure()` | Mock PostgreSQL failure |

#### Composite Mocks

| Function | Purpose |
|----------|---------|
| `mock_pokehub_services_healthy()` | Mock all Pokehub services as healthy |
| `mock_pokehub_services_unhealthy()` | Mock all Pokehub services as unhealthy |

**Usage:**
```bash
@test "deploy: succeeds when services are healthy" {
  mock_pokehub_services_healthy
  
  run deploy_script
  [ "$status" -eq 0 ]
}

teardown() {
  restore_commands  # Always restore in teardown
}
```

---

### `assertions.bash` - Custom Assertions

**Purpose:** Pokehub-specific assertion helpers.

#### Generic Assertions

| Function | Purpose |
|----------|---------|
| `assert_output_contains()` | Assert output contains string |
| `assert_var_set()` | Assert variable is set |
| `assert_var_equals()` | Assert variable equals value |
| `assert_file_exists()` | Assert file exists |
| `assert_dir_exists()` | Assert directory exists |

#### HTTP/API Assertions

| Function | Purpose |
|----------|---------|
| `assert_http_status()` | Assert HTTP status code |
| `assert_api_accessible()` | Assert API endpoint is accessible |
| `assert_pokemon_api_returns_data()` | Assert Pokemon API returns JSON |

#### Container Assertions

| Function | Purpose |
|----------|---------|
| `assert_container_running()` | Assert Docker container is running |
| `assert_container_not_running()` | Assert Docker container is NOT running |

#### Service Health Assertions

| Function | Purpose |
|----------|---------|
| `assert_redis_healthy()` | Assert Redis responds with PONG |
| `assert_pokehub_service_healthy()` | Assert Pokehub service is healthy |

**Supported services:**
- `backend` - Checks `/api/v1/health`
- `frontend` - Checks `/`
- `redis` - Checks `redis-cli ping`
- `database` - Checks `psql -c "SELECT 1"`

#### Script Assertions

| Function | Purpose |
|----------|---------|
| `assert_script_executable()` | Assert script has execute permissions |
| `assert_env_var_set()` | Assert environment variable is set |
| `assert_env_var_equals()` | Assert environment variable equals value |

**Usage:**
```bash
@test "backend: is healthy" {
  mock_curl_success
  
  run assert_pokehub_service_healthy "backend"
  [ "$status" -eq 0 ]
}
```

---

## 🎯 Common Patterns

### Pattern 1: Basic Test with Mocks

```bash
#!/usr/bin/env bats

load '../helpers/setup'
load '../helpers/mocks'
load '../helpers/assertions'

setup() {
  setup_file
}

teardown() {
  restore_commands
}

@test "script: succeeds with mocked services" {
  mock_docker_success
  mock_curl_success
  
  run my_script
  [ "$status" -eq 0 ]
  assert_output_contains "Success"
}
```

### Pattern 2: Test with Temporary Directory

```bash
@test "script: creates config file" {
  setup_test_dir
  
  run my_script --init
  
  assert_file_exists "config.yml"
  
  teardown_test_dir
}
```

### Pattern 3: Test All Services Healthy

```bash
@test "health-check: all services healthy" {
  mock_pokehub_services_healthy
  
  run health_check_script
  [ "$status" -eq 0 ]
  assert_output_contains "All services healthy"
}
```

### Pattern 4: Test Service Failure

```bash
@test "health-check: detects Redis failure" {
  mock_docker_success
  mock_curl_success
  mock_redis_cli_failure  # Only Redis fails
  
  run health_check_script
  [ "$status" -eq 1 ]
  assert_output_contains "Redis"
}
```

### Pattern 5: Test Environment Variables

```bash
@test "deploy: requires ENVIRONMENT variable" {
  unset ENVIRONMENT
  
  run deploy_script
  [ "$status" -eq 1 ]
  assert_output_contains "ENVIRONMENT"
}
```

---

## 🚀 Quick Reference

### Always Do This

```bash
# In setup()
setup() {
  setup_file  # Sets PROJECT_ROOT
}

# In teardown()
teardown() {
  restore_commands  # Restore mocked commands
}
```

### Mock All Pokehub Services

```bash
# One command to mock everything
mock_pokehub_services_healthy
```

### Test Script Exists

```bash
assert_file_exists "$PROJECT_ROOT/scripts/my-script.sh"
assert_script_executable "$PROJECT_ROOT/scripts/my-script.sh"
```

### Test Service Health

```bash
assert_pokehub_service_healthy "backend"
assert_pokehub_service_healthy "frontend"
assert_pokehub_service_healthy "redis"
```

---

## 💡 Tips

1. **Mock Early, Mock Often**
   - Mock external services to avoid real execution
   - Use composite mocks (`mock_pokehub_services_healthy`) for convenience

2. **Always Restore**
   - Call `restore_commands()` in `teardown()`
   - Prevents test pollution

3. **Use Assertions**
   - More descriptive than raw `[ ]` checks
   - Better error messages

4. **Keep Tests Fast**
   - Mock `sleep` to speed up retry loops
   - Use timeouts for potentially hanging tests

5. **Test One Thing**
   - Each test should verify one behavior
   - Use descriptive test names

---

## 📚 Examples

See test files for usage examples:
- `tests/shell/unit/test-simple.bats` - Basic smoke tests
- `tests/shell/unit/deployment/test-deploy.bats` - Deployment script tests

---

**Last Updated:** 2025-10-06  
**Status:** Pokehub-Adapted & Ready to Use  
**Total Functions:** 30+ mocks, 15+ assertions
