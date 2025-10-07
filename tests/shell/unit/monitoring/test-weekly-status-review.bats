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

@test "weekly-status-review: script exists and is executable" {
  assert_file_exists "$PROJECT_ROOT/scripts/monitoring/weekly-status-review.sh"
  assert_script_executable "$PROJECT_ROOT/scripts/monitoring/weekly-status-review.sh"
}

@test "weekly-status-review: script has proper shebang" {
  run head -1 "$PROJECT_ROOT/scripts/monitoring/weekly-status-review.sh"
  assert_output_contains "#!/bin/bash"
}

@test "weekly-status-review: defines all required functions" {
  run grep "^check_servers()" "$PROJECT_ROOT/scripts/monitoring/weekly-status-review.sh"
  [ "$status" -eq 0 ]
  
  run grep "^get_pokemon_status()" "$PROJECT_ROOT/scripts/monitoring/weekly-status-review.sh"
  [ "$status" -eq 0 ]
  
  run grep "^check_recent_activity()" "$PROJECT_ROOT/scripts/monitoring/weekly-status-review.sh"
  [ "$status" -eq 0 ]
  
  run grep "^generate_summary()" "$PROJECT_ROOT/scripts/monitoring/weekly-status-review.sh"
  [ "$status" -eq 0 ]
}

# ============================================================================
# Server Check Tests
# ============================================================================

@test "weekly-status-review: check_servers tests backend connectivity" {
  run grep "curl.*localhost:5000" "$PROJECT_ROOT/scripts/monitoring/weekly-status-review.sh"
  [ "$status" -eq 0 ]
}

@test "weekly-status-review: check_servers tests frontend connectivity" {
  run grep "curl.*localhost:3000" "$PROJECT_ROOT/scripts/monitoring/weekly-status-review.sh"
  [ "$status" -eq 0 ]
}

# ============================================================================
# Pokemon Status Tests
# ============================================================================

@test "weekly-status-review: get_pokemon_status gets Pokemon count" {
  run grep -A 5 "get_pokemon_status()" "$PROJECT_ROOT/scripts/monitoring/weekly-status-review.sh"
  [ "$status" -eq 0 ]
  assert_output_contains "pokemon"
}

@test "weekly-status-review: get_pokemon_status validates against 151" {
  run grep "151" "$PROJECT_ROOT/scripts/monitoring/weekly-status-review.sh"
  [ "$status" -eq 0 ]
}

# ============================================================================
# Recent Activity Tests
# ============================================================================

@test "weekly-status-review: check_recent_activity shows current branch" {
  run grep "git.*branch" "$PROJECT_ROOT/scripts/monitoring/weekly-status-review.sh"
  [ "$status" -eq 0 ]
}

@test "weekly-status-review: check_recent_activity shows recent commits" {
  run grep "git.*log" "$PROJECT_ROOT/scripts/monitoring/weekly-status-review.sh"
  [ "$status" -eq 0 ]
}

# ============================================================================
# Report Generation Tests
# ============================================================================

@test "weekly-status-review: generate_summary aggregates status" {
  run grep -A 10 "generate_summary()" "$PROJECT_ROOT/scripts/monitoring/weekly-status-review.sh"
  [ "$status" -eq 0 ]
}

@test "weekly-status-review: script uses colored output" {
  run grep "GREEN=\|RED=\|YELLOW=\|BLUE=" "$PROJECT_ROOT/scripts/monitoring/weekly-status-review.sh"
  [ "$status" -eq 0 ]
}
