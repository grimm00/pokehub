#!/usr/bin/env bats

# Load test helpers
load '../helpers/setup'
load '../helpers/mocks'
load '../helpers/assertions'

setup() {
  setup_file
}

# ============================================================================
# Smoke Tests
# ============================================================================

@test "smoke test: bats is working" {
  [ 1 -eq 1 ]
}

@test "smoke test: can load setup helper" {
  [ -n "$PROJECT_ROOT" ]
}

@test "smoke test: can load mocks helper" {
  # Test that mocks helper is available
  type restore_commands >/dev/null 2>&1
}

@test "smoke test: can load assertions helper" {
  # Test that assertions helper is available (may not have custom assertions yet)
  [ -f "$PROJECT_ROOT/tests/shell/helpers/assertions.bash" ]
}

@test "smoke test: can find deployment scripts" {
  [ -f "$PROJECT_ROOT/scripts/deployment/deploy.sh" ]
  [ -f "$PROJECT_ROOT/scripts/deployment/rollback.sh" ]
  [ -f "$PROJECT_ROOT/scripts/deployment/test-docker.sh" ]
}

@test "smoke test: can find core scripts" {
  [ -f "$PROJECT_ROOT/scripts/core/docker-startup.sh" ]
  [ -f "$PROJECT_ROOT/scripts/core/health-check.sh" ]
  [ -f "$PROJECT_ROOT/scripts/core/invalidate-cache.sh" ]
}

@test "smoke test: can find monitoring scripts" {
  [ -f "$PROJECT_ROOT/scripts/monitoring/automated-status-check.sh" ]
  [ -f "$PROJECT_ROOT/scripts/monitoring/verify-project-status.sh" ]
  [ -f "$PROJECT_ROOT/scripts/monitoring/weekly-status-review.sh" ]
}
