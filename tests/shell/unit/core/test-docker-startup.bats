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

@test "docker-startup: script exists and is executable" {
  assert_file_exists "$PROJECT_ROOT/scripts/core/docker-startup.sh"
  assert_script_executable "$PROJECT_ROOT/scripts/core/docker-startup.sh"
}

@test "docker-startup: script has proper shebang" {
  run head -1 "$PROJECT_ROOT/scripts/core/docker-startup.sh"
  assert_output_contains "#!/bin/bash"
}

@test "docker-startup: script uses set -e for error handling" {
  run grep "set -e" "$PROJECT_ROOT/scripts/core/docker-startup.sh"
  [ "$status" -eq 0 ]
}

# ============================================================================
# Redis Startup Tests
# ============================================================================

@test "docker-startup: attempts to start Redis server" {
  run grep "redis-server" "$PROJECT_ROOT/scripts/core/docker-startup.sh"
  [ "$status" -eq 0 ]
  assert_output_contains "redis-server"
}

@test "docker-startup: uses Redis daemonize mode" {
  run grep "redis-server.*daemonize" "$PROJECT_ROOT/scripts/core/docker-startup.sh"
  [ "$status" -eq 0 ]
}

# ============================================================================
# Database Initialization Tests
# ============================================================================

@test "docker-startup: runs database initialization" {
  run grep "db.create_all" "$PROJECT_ROOT/scripts/core/docker-startup.sh"
  [ "$status" -eq 0 ]
}

@test "docker-startup: imports correct database modules" {
  run grep "from backend.database import db" "$PROJECT_ROOT/scripts/core/docker-startup.sh"
  [ "$status" -eq 0 ]
}

# ============================================================================
# Pokemon Seeding Tests
# ============================================================================

@test "docker-startup: uses timeout for Pokemon seeding" {
  run grep "timeout.*python" "$PROJECT_ROOT/scripts/core/docker-startup.sh"
  [ "$status" -eq 0 ]
}

@test "docker-startup: handles seeding timeout gracefully" {
  run grep "seeding timed out" "$PROJECT_ROOT/scripts/core/docker-startup.sh"
  [ "$status" -eq 0 ]
}

@test "docker-startup: continues on seeding failure" {
  run grep "Application will continue without seeded data" "$PROJECT_ROOT/scripts/core/docker-startup.sh"
  [ "$status" -eq 0 ]
}

# ============================================================================
# Service Startup Tests
# ============================================================================

@test "docker-startup: starts Flask in background" {
  run grep "python -m backend.app &" "$PROJECT_ROOT/scripts/core/docker-startup.sh"
  [ "$status" -eq 0 ]
}

@test "docker-startup: starts nginx in foreground" {
  run grep "nginx.*daemon off" "$PROJECT_ROOT/scripts/core/docker-startup.sh"
  [ "$status" -eq 0 ]
}
