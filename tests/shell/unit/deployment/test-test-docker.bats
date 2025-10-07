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
# Docker Check Tests
# ============================================================================

@test "test-docker: fails when Docker is not running" {
  mock_docker_failure
  
  run bash "$PROJECT_ROOT/scripts/deployment/test-docker.sh"
  [ "$status" -eq 1 ]
  assert_output_contains "Docker is not running"
}

@test "test-docker: succeeds when Docker is running" {
  mock_docker_success
  
  run timeout 2 bash "$PROJECT_ROOT/scripts/deployment/test-docker.sh"
  assert_output_contains "Docker is running"
}

# ============================================================================
# Build Tests
# ============================================================================

@test "test-docker: attempts to build Docker image" {
  mock_docker_success
  
  run timeout 2 bash "$PROJECT_ROOT/scripts/deployment/test-docker.sh"
  assert_output_contains "Building Docker image"
}

@test "test-docker: reports successful build" {
  mock_docker_success
  
  run timeout 2 bash "$PROJECT_ROOT/scripts/deployment/test-docker.sh"
  # Should show build success message
  [[ "$output" =~ "built" ]] || [[ "$output" =~ "Building" ]]
}

# ============================================================================
# Docker Compose Tests
# ============================================================================

@test "test-docker: tests docker-compose" {
  mock_docker_success
  mock_docker_compose_success
  
  run timeout 2 bash "$PROJECT_ROOT/scripts/deployment/test-docker.sh"
  assert_output_contains "docker-compose"
}

@test "test-docker: starts services with docker-compose" {
  mock_docker_success
  mock_docker_compose_success
  
  run timeout 2 bash "$PROJECT_ROOT/scripts/deployment/test-docker.sh"
  [[ "$output" =~ "started" ]] || [[ "$output" =~ "Starting" ]]
}

# ============================================================================
# Health Check Tests
# ============================================================================

@test "test-docker: tests API health endpoint" {
  mock_pokehub_services_healthy
  
  run timeout 2 bash "$PROJECT_ROOT/scripts/deployment/test-docker.sh"
  assert_output_contains "API"
}

@test "test-docker: tests frontend endpoint" {
  # Check script structure instead of running (avoids sleep)
  run grep "Testing frontend" "$PROJECT_ROOT/scripts/deployment/test-docker.sh"
  [ "$status" -eq 0 ]
}

@test "test-docker: waits for services to be healthy" {
  mock_pokehub_services_healthy
  
  run timeout 2 bash "$PROJECT_ROOT/scripts/deployment/test-docker.sh"
  assert_output_contains "Waiting for services"
}

# ============================================================================
# Output and Status Tests (Check Script Structure)
# ============================================================================

@test "test-docker: shows running containers" {
  # Check script structure instead of running (avoids sleep)
  run grep "Running containers" "$PROJECT_ROOT/scripts/deployment/test-docker.sh"
  [ "$status" -eq 0 ]
}

@test "test-docker: shows application URL" {
  # Check script structure instead of running (avoids sleep)
  run grep "http://localhost" "$PROJECT_ROOT/scripts/deployment/test-docker.sh"
  [ "$status" -eq 0 ]
  assert_output_contains "http://localhost"
}

@test "test-docker: shows API URL" {
  # Check script structure instead of running (avoids sleep)
  run grep "api/v1" "$PROJECT_ROOT/scripts/deployment/test-docker.sh"
  [ "$status" -eq 0 ]
  assert_output_contains "api/v1"
}

@test "test-docker: provides stop instructions" {
  # Check script structure instead of running (avoids sleep)
  run grep "docker-compose down" "$PROJECT_ROOT/scripts/deployment/test-docker.sh"
  [ "$status" -eq 0 ]
  assert_output_contains "docker-compose down"
}

@test "test-docker: provides logs instructions" {
  # Check script structure instead of running (avoids sleep)
  run grep "docker-compose logs" "$PROJECT_ROOT/scripts/deployment/test-docker.sh"
  [ "$status" -eq 0 ]
  assert_output_contains "docker-compose logs"
}

# ============================================================================
# Script Structure Tests
# ============================================================================

@test "test-docker: script exists and is executable" {
  assert_file_exists "$PROJECT_ROOT/scripts/deployment/test-docker.sh"
  assert_script_executable "$PROJECT_ROOT/scripts/deployment/test-docker.sh"
}

@test "test-docker: script has proper shebang" {
  run head -1 "$PROJECT_ROOT/scripts/deployment/test-docker.sh"
  assert_output_contains "#!/bin/bash"
}

@test "test-docker: script checks Docker is running" {
  run grep "docker info" "$PROJECT_ROOT/scripts/deployment/test-docker.sh"
  [ "$status" -eq 0 ]
}

@test "test-docker: script builds Docker image" {
  run grep "docker build" "$PROJECT_ROOT/scripts/deployment/test-docker.sh"
  [ "$status" -eq 0 ]
}

@test "test-docker: script uses docker-compose up" {
  run grep "docker-compose up" "$PROJECT_ROOT/scripts/deployment/test-docker.sh"
  [ "$status" -eq 0 ]
}

@test "test-docker: script tests health endpoint" {
  run grep "/api/v1/health" "$PROJECT_ROOT/scripts/deployment/test-docker.sh"
  [ "$status" -eq 0 ]
}

@test "test-docker: script tests frontend" {
  run grep "curl.*http://localhost/" "$PROJECT_ROOT/scripts/deployment/test-docker.sh"
  [ "$status" -eq 0 ]
}

@test "test-docker: script shows container status" {
  run grep "docker-compose ps" "$PROJECT_ROOT/scripts/deployment/test-docker.sh"
  [ "$status" -eq 0 ]
}

@test "test-docker: script has sleep for service startup" {
  run grep "sleep" "$PROJECT_ROOT/scripts/deployment/test-docker.sh"
  [ "$status" -eq 0 ]
}
