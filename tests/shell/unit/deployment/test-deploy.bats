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
# Simple CLI Interface Tests (Fast - No Sourcing)
# ============================================================================

@test "deploy: shows usage with environment in output" {
  mock_pokehub_services_healthy  # Use composite mock!
  
  run timeout 2 bash "$PROJECT_ROOT/scripts/deployment/deploy.sh" staging latest
  assert_output_contains "staging"
}

@test "deploy: rejects invalid environment" {
  run bash "$PROJECT_ROOT/scripts/deployment/deploy.sh" invalid-env latest
  [ "$status" -eq 1 ]
  assert_output_contains "Invalid environment"
}

@test "deploy: accepts development environment" {
  mock_docker_failure  # Fail fast on docker check
  
  run bash "$PROJECT_ROOT/scripts/deployment/deploy.sh" development latest
  assert_output_contains "development"
}

@test "deploy: accepts staging environment" {
  mock_docker_failure  # Fail fast on docker check
  
  run bash "$PROJECT_ROOT/scripts/deployment/deploy.sh" staging latest
  assert_output_contains "staging"
}

@test "deploy: accepts production environment" {
  mock_docker_failure  # Fail fast on docker check
  
  run bash "$PROJECT_ROOT/scripts/deployment/deploy.sh" production latest
  assert_output_contains "production"
}

@test "deploy: shows version in output" {
  mock_docker_failure  # Fail fast on docker check
  
  run bash "$PROJECT_ROOT/scripts/deployment/deploy.sh" staging v1.2.3
  assert_output_contains "v1.2.3"
}

@test "deploy: fails when Docker is not running" {
  # Create temp directory with compose file so we get to Docker check
  setup_test_dir
  touch docker-compose.yml
  
  mock_docker_failure
  
  run bash "$PROJECT_ROOT/scripts/deployment/deploy.sh" staging latest
  [ "$status" -eq 1 ]
  assert_output_contains "Docker"
  
  teardown_test_dir
}

@test "deploy: checks for compose file" {
  setup_test_dir  # Use helper!
  
  mock_docker_success
  
  run bash "$PROJECT_ROOT/scripts/deployment/deploy.sh" staging latest
  [ "$status" -eq 1 ]
  assert_output_contains "Compose file"
  
  teardown_test_dir  # Use helper!
}

@test "deploy: script exists and is executable" {
  assert_file_exists "$PROJECT_ROOT/scripts/deployment/deploy.sh"
  assert_script_executable "$PROJECT_ROOT/scripts/deployment/deploy.sh"
}

@test "deploy: script has proper shebang" {
  run head -1 "$PROJECT_ROOT/scripts/deployment/deploy.sh"
  assert_output_contains "#!/bin/bash"
}

@test "deploy: script uses set -e for error handling" {
  run grep "set -e" "$PROJECT_ROOT/scripts/deployment/deploy.sh"
  [ "$status" -eq 0 ]
}

@test "deploy: script defines check_docker function" {
  run grep "check_docker()" "$PROJECT_ROOT/scripts/deployment/deploy.sh"
  [ "$status" -eq 0 ]
}

@test "deploy: script defines pull_image function" {
  run grep "pull_image()" "$PROJECT_ROOT/scripts/deployment/deploy.sh"
  [ "$status" -eq 0 ]
}

@test "deploy: script defines stop_container function" {
  run grep "stop_container()" "$PROJECT_ROOT/scripts/deployment/deploy.sh"
  [ "$status" -eq 0 ]
}

@test "deploy: script defines start_container function" {
  run grep "start_container()" "$PROJECT_ROOT/scripts/deployment/deploy.sh"
  [ "$status" -eq 0 ]
}

@test "deploy: script defines wait_for_health function" {
  run grep "wait_for_health()" "$PROJECT_ROOT/scripts/deployment/deploy.sh"
  [ "$status" -eq 0 ]
}

@test "deploy: script defines run_smoke_tests function" {
  run grep "run_smoke_tests()" "$PROJECT_ROOT/scripts/deployment/deploy.sh"
  [ "$status" -eq 0 ]
}

@test "deploy: script defines show_status function" {
  run grep "show_status()" "$PROJECT_ROOT/scripts/deployment/deploy.sh"
  [ "$status" -eq 0 ]
}

@test "deploy: script validates environment with regex" {
  run grep "development|staging|production" "$PROJECT_ROOT/scripts/deployment/deploy.sh"
  [ "$status" -eq 0 ]
}

@test "deploy: script has main function" {
  run grep "main()" "$PROJECT_ROOT/scripts/deployment/deploy.sh"
  [ "$status" -eq 0 ]
}
