#!/usr/bin/env bats

# Load test helpers
load '../helpers/setup'
load '../helpers/mocks'
load '../helpers/assertions'

setup() {
  setup_file
}

teardown() {
  restore_commands
}

# ============================================================================
# Script Structure Tests
# ============================================================================

@test "invalidate-cache: script exists and is executable" {
  assert_file_exists "$PROJECT_ROOT/scripts/core/invalidate-cache.sh"
  assert_script_executable "$PROJECT_ROOT/scripts/core/invalidate-cache.sh"
}

@test "invalidate-cache: script has proper shebang" {
  run head -1 "$PROJECT_ROOT/scripts/core/invalidate-cache.sh"
  assert_output_contains "#!/bin/bash"
}

@test "invalidate-cache: script shows timestamp" {
  run grep "date.*%s" "$PROJECT_ROOT/scripts/core/invalidate-cache.sh"
  [ "$status" -eq 0 ]
}

# ============================================================================
# Container Validation Tests
# ============================================================================

@test "invalidate-cache: checks if Docker container is running" {
  run grep "docker ps.*grep.*pokedex" "$PROJECT_ROOT/scripts/core/invalidate-cache.sh"
  [ "$status" -eq 0 ]
}

@test "invalidate-cache: exits if container not running" {
  run grep "exit 1" "$PROJECT_ROOT/scripts/core/invalidate-cache.sh"
  [ "$status" -eq 0 ]
}

# ============================================================================
# Cache Header Testing Tests
# ============================================================================

@test "invalidate-cache: tests static asset cache headers" {
  run grep "static assets" "$PROJECT_ROOT/scripts/core/invalidate-cache.sh"
  [ "$status" -eq 0 ]
}

@test "invalidate-cache: tests HTML file cache headers" {
  run grep "HTML files" "$PROJECT_ROOT/scripts/core/invalidate-cache.sh"
  [ "$status" -eq 0 ]
}

@test "invalidate-cache: tests API endpoint cache headers" {
  run grep "API endpoints" "$PROJECT_ROOT/scripts/core/invalidate-cache.sh"
  [ "$status" -eq 0 ]
}

@test "invalidate-cache: uses curl for cache testing" {
  run grep "curl.*-I" "$PROJECT_ROOT/scripts/core/invalidate-cache.sh"
  [ "$status" -eq 0 ]
}
