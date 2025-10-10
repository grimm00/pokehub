#!/usr/bin/env bats

# Load test helpers
load '../../helpers/setup'
load '../../helpers/mocks'
load '../../helpers/assertions'

setup() {
  setup_file
}

teardown() {
  restore_commands
}

# ============================================================================
# Script Structure Tests
# ============================================================================

@test "health-check: script exists and is executable" {
  assert_file_exists "$PROJECT_ROOT/scripts/core/health-check.sh"
  assert_script_executable "$PROJECT_ROOT/scripts/core/health-check.sh"
}

@test "health-check: script has proper shebang" {
  run head -1 "$PROJECT_ROOT/scripts/core/health-check.sh"
  assert_output_contains "#!/bin/bash"
}

@test "health-check: script uses set -e for error handling" {
  run grep "set -e" "$PROJECT_ROOT/scripts/core/health-check.sh"
  [ "$status" -eq 0 ]
}

# ============================================================================
# Configuration Tests
# ============================================================================

@test "health-check: uses BASE_URL environment variable" {
  run grep "BASE_URL=" "$PROJECT_ROOT/scripts/core/health-check.sh"
  [ "$status" -eq 0 ]
  assert_output_contains "BASE_URL"
}

@test "health-check: uses TIMEOUT environment variable" {
  run grep "TIMEOUT=" "$PROJECT_ROOT/scripts/core/health-check.sh"
  [ "$status" -eq 0 ]
  assert_output_contains "TIMEOUT"
}

# ============================================================================
# Function Definition Tests
# ============================================================================

@test "health-check: defines check_endpoint function" {
  run grep "check_endpoint()" "$PROJECT_ROOT/scripts/core/health-check.sh"
  [ "$status" -eq 0 ]
}

@test "health-check: defines check_service function" {
  run grep "check_service()" "$PROJECT_ROOT/scripts/core/health-check.sh"
  [ "$status" -eq 0 ]
}

# ============================================================================
# Health Check Coverage Tests
# ============================================================================

@test "health-check: checks Docker container status" {
  run grep "docker ps" "$PROJECT_ROOT/scripts/core/health-check.sh"
  [ "$status" -eq 0 ]
}

@test "health-check: checks API endpoints with curl" {
  run grep "curl.*url" "$PROJECT_ROOT/scripts/core/health-check.sh"
  [ "$status" -eq 0 ]
}

@test "health-check: checks database connectivity" {
  run grep "Database connection" "$PROJECT_ROOT/scripts/core/health-check.sh"
  [ "$status" -eq 0 ]
}

@test "health-check: checks Redis connectivity" {
  run grep "redis-cli ping" "$PROJECT_ROOT/scripts/core/health-check.sh"
  [ "$status" -eq 0 ]
}

# ============================================================================
# Exit Code Tests
# ============================================================================

@test "health-check: exits with error on critical failure" {
  run grep "exit 1" "$PROJECT_ROOT/scripts/core/health-check.sh"
  [ "$status" -eq 0 ]
}
