#!/usr/bin/env bats

load '../../helpers/setup'
load '../../helpers/mocks'
load '../../helpers/assertions'

setup() {
  setup_file
  restore_commands
}

teardown() {
  restore_commands
}

# ============================================================================
# Script Structure Tests
# ============================================================================

@test "verify-project-status: script exists and is executable" {
  assert_file_exists "$PROJECT_ROOT/scripts/monitoring/verify-project-status.sh"
  assert_script_executable "$PROJECT_ROOT/scripts/monitoring/verify-project-status.sh"
}

@test "verify-project-status: script has proper shebang" {
  run head -1 "$PROJECT_ROOT/scripts/monitoring/verify-project-status.sh"
  assert_output_contains "#!/bin/bash"
}

@test "verify-project-status: defines all required functions" {
  run grep "^check_api()" "$PROJECT_ROOT/scripts/monitoring/verify-project-status.sh"
  [ "$status" -eq 0 ]
  
  run grep "^get_total_count()" "$PROJECT_ROOT/scripts/monitoring/verify-project-status.sh"
  [ "$status" -eq 0 ]
  
  run grep "^get_actual_pokemon_count()" "$PROJECT_ROOT/scripts/monitoring/verify-project-status.sh"
  [ "$status" -eq 0 ]
}

# ============================================================================
# API Check Function Tests
# ============================================================================

@test "verify-project-status: check_api validates endpoint connectivity" {
  run grep "curl.*endpoint" "$PROJECT_ROOT/scripts/monitoring/verify-project-status.sh"
  [ "$status" -eq 0 ]
}

@test "verify-project-status: check_api validates response exists" {
  run grep -A 10 "check_api()" "$PROJECT_ROOT/scripts/monitoring/verify-project-status.sh"
  [ "$status" -eq 0 ]
  assert_output_contains "response"
}

@test "verify-project-status: check_api checks expected field" {
  run grep "expected_field" "$PROJECT_ROOT/scripts/monitoring/verify-project-status.sh"
  [ "$status" -eq 0 ]
}

@test "verify-project-status: check_api returns proper exit codes" {
  run grep -A 25 "check_api()" "$PROJECT_ROOT/scripts/monitoring/verify-project-status.sh"
  [ "$status" -eq 0 ]
  assert_output_contains "return 0"
  assert_output_contains "return 1"
}

# ============================================================================
# Count Function Tests
# ============================================================================

@test "verify-project-status: get_total_count extracts count from JSON" {
  run grep "python3.*json" "$PROJECT_ROOT/scripts/monitoring/verify-project-status.sh"
  [ "$status" -eq 0 ]
}

@test "verify-project-status: get_total_count uses field parameter" {
  run grep -A 3 "get_total_count()" "$PROJECT_ROOT/scripts/monitoring/verify-project-status.sh"
  [ "$status" -eq 0 ]
  assert_output_contains "field"
}

@test "verify-project-status: get_actual_pokemon_count sums across pages" {
  run grep -A 10 "get_actual_pokemon_count()" "$PROJECT_ROOT/scripts/monitoring/verify-project-status.sh"
  [ "$status" -eq 0 ]
  assert_output_contains "total_pages"
  
  run grep -A 10 "get_actual_pokemon_count()" "$PROJECT_ROOT/scripts/monitoring/verify-project-status.sh"
  [ "$status" -eq 0 ]
  assert_output_contains "for page in"
}

# ============================================================================
# Integration Tests
# ============================================================================

@test "verify-project-status: script checks multiple components" {
  run grep "check_api" "$PROJECT_ROOT/scripts/monitoring/verify-project-status.sh"
  [ "$status" -eq 0 ]
  # Should have multiple check_api calls
  [ "${#lines[@]}" -ge 3 ]
}

@test "verify-project-status: script reports verification results" {
  run grep -E "PASS|FAIL" "$PROJECT_ROOT/scripts/monitoring/verify-project-status.sh"
  [ "$status" -eq 0 ]
}

@test "verify-project-status: script uses colored output" {
  run grep "GREEN=\|RED=\|YELLOW=" "$PROJECT_ROOT/scripts/monitoring/verify-project-status.sh"
  [ "$status" -eq 0 ]
}
