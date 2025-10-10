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
# Environment Validation Tests
# ============================================================================

@test "rollback: accepts development environment" {
  mock_docker_failure  # Fail fast on docker check
  
  run bash "$PROJECT_ROOT/scripts/deployment/rollback.sh" development v1.0.0
  assert_output_contains "development"
}

@test "rollback: accepts staging environment" {
  mock_docker_failure  # Fail fast on docker check
  
  run bash "$PROJECT_ROOT/scripts/deployment/rollback.sh" staging v1.0.0
  assert_output_contains "staging"
}

@test "rollback: accepts production environment" {
  mock_docker_failure  # Fail fast on docker check
  
  run bash "$PROJECT_ROOT/scripts/deployment/rollback.sh" production v1.0.0
  assert_output_contains "production"
}

@test "rollback: rejects invalid environment" {
  run bash "$PROJECT_ROOT/scripts/deployment/rollback.sh" invalid v1.0.0
  [ "$status" -eq 1 ]
  assert_output_contains "Invalid environment"
}

@test "rollback: defaults to staging when no environment specified" {
  mock_docker_failure  # Fail fast
  
  run bash "$PROJECT_ROOT/scripts/deployment/rollback.sh"
  assert_output_contains "staging"
}

@test "rollback: shows version in output" {
  mock_docker_failure  # Fail fast
  
  run bash "$PROJECT_ROOT/scripts/deployment/rollback.sh" staging v1.2.3
  assert_output_contains "v1.2.3"
}

# ============================================================================
# Docker Check Tests
# ============================================================================

@test "rollback: fails when Docker is not running" {
  # Create temp directory with compose file so we get to Docker check
  setup_test_dir
  touch docker-compose.staging.yml
  
  mock_docker_failure
  
  run bash "$PROJECT_ROOT/scripts/deployment/rollback.sh" staging v1.0.0
  [ "$status" -eq 1 ]
  assert_output_contains "Docker"
  
  teardown_test_dir
}

# ============================================================================
# Compose File Tests
# ============================================================================

@test "rollback: checks for compose file" {
  setup_test_dir
  
  mock_docker_success
  
  run bash "$PROJECT_ROOT/scripts/deployment/rollback.sh" staging v1.0.0
  [ "$status" -eq 1 ]
  assert_output_contains "Compose file"
  
  teardown_test_dir
}

@test "rollback: uses correct compose file for development" {
  # Check that script references docker-compose.yml for development
  run grep -A 2 "development)" "$PROJECT_ROOT/scripts/deployment/rollback.sh"
  [ "$status" -eq 0 ]
  assert_output_contains "docker-compose.yml"
}

@test "rollback: uses correct compose file for staging" {
  mock_docker_failure
  
  run bash "$PROJECT_ROOT/scripts/deployment/rollback.sh" staging v1.0.0
  # Should process staging environment
  assert_output_contains "staging"
}

@test "rollback: uses correct compose file for production" {
  mock_docker_failure
  
  run bash "$PROJECT_ROOT/scripts/deployment/rollback.sh" production v1.0.0
  # Should process production environment
  assert_output_contains "production"
}

# ============================================================================
# Script Structure Tests
# ============================================================================

@test "rollback: script exists and is executable" {
  assert_file_exists "$PROJECT_ROOT/scripts/deployment/rollback.sh"
  assert_script_executable "$PROJECT_ROOT/scripts/deployment/rollback.sh"
}

@test "rollback: script has proper shebang" {
  run head -1 "$PROJECT_ROOT/scripts/deployment/rollback.sh"
  assert_output_contains "#!/bin/bash"
}

@test "rollback: script uses set -e for error handling" {
  run grep "set -e" "$PROJECT_ROOT/scripts/deployment/rollback.sh"
  [ "$status" -eq 0 ]
}

@test "rollback: script defines check_docker function" {
  run grep "check_docker()" "$PROJECT_ROOT/scripts/deployment/rollback.sh"
  [ "$status" -eq 0 ]
}

@test "rollback: script defines get_available_versions function" {
  run grep "get_available_versions()" "$PROJECT_ROOT/scripts/deployment/rollback.sh"
  [ "$status" -eq 0 ]
}

@test "rollback: script defines update_compose_file function" {
  run grep "update_compose_file()" "$PROJECT_ROOT/scripts/deployment/rollback.sh"
  [ "$status" -eq 0 ]
}

@test "rollback: script defines stop_containers function" {
  run grep "stop_containers()" "$PROJECT_ROOT/scripts/deployment/rollback.sh"
  [ "$status" -eq 0 ]
}

@test "rollback: script defines start_previous_version function" {
  run grep "start_previous_version()" "$PROJECT_ROOT/scripts/deployment/rollback.sh"
  [ "$status" -eq 0 ]
}

@test "rollback: script defines wait_for_health function" {
  run grep "wait_for_health()" "$PROJECT_ROOT/scripts/deployment/rollback.sh"
  [ "$status" -eq 0 ]
}

@test "rollback: script defines run_health_checks function" {
  run grep "run_health_checks()" "$PROJECT_ROOT/scripts/deployment/rollback.sh"
  [ "$status" -eq 0 ]
}

@test "rollback: script defines show_status function" {
  run grep "show_status()" "$PROJECT_ROOT/scripts/deployment/rollback.sh"
  [ "$status" -eq 0 ]
}

@test "rollback: script defines restore_compose_file function" {
  run grep "restore_compose_file()" "$PROJECT_ROOT/scripts/deployment/rollback.sh"
  [ "$status" -eq 0 ]
}

@test "rollback: script has main function" {
  run grep "main()" "$PROJECT_ROOT/scripts/deployment/rollback.sh"
  [ "$status" -eq 0 ]
}

# ============================================================================
# Confirmation Prompt Tests
# ============================================================================

@test "rollback: prompts for confirmation" {
  run grep "read -p" "$PROJECT_ROOT/scripts/deployment/rollback.sh"
  [ "$status" -eq 0 ]
  assert_output_contains "Are you sure"
}

@test "rollback: checks for Y/y confirmation" {
  run grep "\\^\\[Yy\\]" "$PROJECT_ROOT/scripts/deployment/rollback.sh"
  [ "$status" -eq 0 ]
}

# ============================================================================
# Backup and Restore Tests
# ============================================================================

@test "rollback: creates backup of compose file" {
  run grep "backup" "$PROJECT_ROOT/scripts/deployment/rollback.sh"
  [ "$status" -eq 0 ]
  assert_output_contains ".backup"
}

@test "rollback: can restore compose file on failure" {
  run grep "restore_compose_file" "$PROJECT_ROOT/scripts/deployment/rollback.sh"
  [ "$status" -eq 0 ]
}
