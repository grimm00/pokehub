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
  # Use mock helpers
  mock_docker_success
  mock_curl_success
  
  run timeout 2 bash "$PROJECT_ROOT/scripts/deployment/deploy.sh" staging latest
  # Should at least show it's deploying to staging
  [[ "$output" =~ "staging" ]] || [[ "$output" =~ "Deploying" ]]
}

@test "deploy: rejects invalid environment" {
  run bash "$PROJECT_ROOT/scripts/deployment/deploy.sh" invalid-env latest
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Invalid environment" ]]
}

@test "deploy: accepts development environment" {
  mock_docker_failure  # Fail fast on docker check
  
  run bash "$PROJECT_ROOT/scripts/deployment/deploy.sh" development latest
  [[ "$output" =~ "development" ]]
}

@test "deploy: accepts staging environment" {
  mock_docker_failure  # Fail fast on docker check
  
  run bash "$PROJECT_ROOT/scripts/deployment/deploy.sh" staging latest
  [[ "$output" =~ "staging" ]]
}

@test "deploy: accepts production environment" {
  mock_docker_failure  # Fail fast on docker check
  
  run bash "$PROJECT_ROOT/scripts/deployment/deploy.sh" production latest
  [[ "$output" =~ "production" ]]
}

@test "deploy: shows version in output" {
  mock_docker_failure  # Fail fast on docker check
  
  run bash "$PROJECT_ROOT/scripts/deployment/deploy.sh" staging v1.2.3
  [[ "$output" =~ "v1.2.3" ]] || [[ "$output" =~ "Version" ]]
}

@test "deploy: fails when Docker is not running" {
  mock_docker_failure
  
  run bash "$PROJECT_ROOT/scripts/deployment/deploy.sh" staging latest
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Docker" ]]
}

@test "deploy: checks for compose file" {
  # Create temp directory without compose file
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  
  mock_docker_success
  
  run bash "$PROJECT_ROOT/scripts/deployment/deploy.sh" staging latest
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Compose file" ]] || [[ "$output" =~ "not found" ]]
  
  # Cleanup
  cd - > /dev/null
  rm -rf "$TEST_DIR"
}

@test "deploy: script exists and is executable" {
  [ -f "$PROJECT_ROOT/scripts/deployment/deploy.sh" ]
  [ -x "$PROJECT_ROOT/scripts/deployment/deploy.sh" ]
}

@test "deploy: script has proper shebang" {
  run head -1 "$PROJECT_ROOT/scripts/deployment/deploy.sh"
  [[ "$output" =~ "#!/bin/bash" ]]
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
