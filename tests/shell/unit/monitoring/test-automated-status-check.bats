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

@test "automated-status-check: script exists and is executable" {
  assert_file_exists "$PROJECT_ROOT/scripts/monitoring/automated-status-check.sh"
  assert_script_executable "$PROJECT_ROOT/scripts/monitoring/automated-status-check.sh"
}

@test "automated-status-check: script has proper shebang" {
  run head -1 "$PROJECT_ROOT/scripts/monitoring/automated-status-check.sh"
  assert_output_contains "#!/bin/bash"
}

@test "automated-status-check: defines all required functions" {
  run grep "^check_backend()" "$PROJECT_ROOT/scripts/monitoring/automated-status-check.sh"
  [ "$status" -eq 0 ]
  
  run grep "^check_frontend()" "$PROJECT_ROOT/scripts/monitoring/automated-status-check.sh"
  [ "$status" -eq 0 ]
  
  run grep "^check_data()" "$PROJECT_ROOT/scripts/monitoring/automated-status-check.sh"
  [ "$status" -eq 0 ]
  
  run grep "^check_documentation()" "$PROJECT_ROOT/scripts/monitoring/automated-status-check.sh"
  [ "$status" -eq 0 ]
  
  run grep "^check_structure()" "$PROJECT_ROOT/scripts/monitoring/automated-status-check.sh"
  [ "$status" -eq 0 ]
  
  run grep "^generate_report()" "$PROJECT_ROOT/scripts/monitoring/automated-status-check.sh"
  [ "$status" -eq 0 ]
}

# ============================================================================
# Backend Checks Tests
# ============================================================================

@test "automated-status-check: check_backend tests API connectivity" {
  run grep "curl.*localhost:5000/api/v1/pokemon" "$PROJECT_ROOT/scripts/monitoring/automated-status-check.sh"
  [ "$status" -eq 0 ]
}

@test "automated-status-check: check_backend tests multiple endpoints" {
  run grep -c "http://localhost:5000/api/v1/pokemon" "$PROJECT_ROOT/scripts/monitoring/automated-status-check.sh"
  [ "$status" -eq 0 ]
  # Should find at least 3 endpoint references
  [ "$output" -ge 3 ]
}

@test "automated-status-check: check_backend sets backend_issues on failure" {
  run grep "backend_issues=1" "$PROJECT_ROOT/scripts/monitoring/automated-status-check.sh"
  [ "$status" -eq 0 ]
}

# ============================================================================
# Frontend Checks Tests
# ============================================================================

@test "automated-status-check: check_frontend tests frontend connectivity" {
  run grep "curl.*localhost:3000" "$PROJECT_ROOT/scripts/monitoring/automated-status-check.sh"
  [ "$status" -eq 0 ]
}

@test "automated-status-check: check_frontend validates HTML response" {
  run grep "<!doctype html>" "$PROJECT_ROOT/scripts/monitoring/automated-status-check.sh"
  [ "$status" -eq 0 ]
}

# ============================================================================
# Data Checks Tests
# ============================================================================

@test "automated-status-check: check_data counts Pokemon across pages" {
  run grep "for page in" "$PROJECT_ROOT/scripts/monitoring/automated-status-check.sh"
  [ "$status" -eq 0 ]
}

@test "automated-status-check: check_data validates Pokemon count" {
  run grep "pokemon_count.*151" "$PROJECT_ROOT/scripts/monitoring/automated-status-check.sh"
  [ "$status" -eq 0 ]
}

@test "automated-status-check: check_data checks first Pokemon" {
  run grep "bulbasaur" "$PROJECT_ROOT/scripts/monitoring/automated-status-check.sh"
  [ "$status" -eq 0 ]
}

# ============================================================================
# Documentation Checks Tests
# ============================================================================

@test "automated-status-check: check_documentation checks key docs" {
  run grep -A 5 "key_docs=" "$PROJECT_ROOT/scripts/monitoring/automated-status-check.sh"
  [ "$status" -eq 0 ]
  assert_output_contains "README.md"
}

@test "automated-status-check: check_documentation sets doc_issues on missing" {
  run grep "doc_issues=1" "$PROJECT_ROOT/scripts/monitoring/automated-status-check.sh"
  [ "$status" -eq 0 ]
}

# ============================================================================
# Structure Checks Tests
# ============================================================================

@test "automated-status-check: check_structure checks key files" {
  run grep -A 5 "key_files=" "$PROJECT_ROOT/scripts/monitoring/automated-status-check.sh"
  [ "$status" -eq 0 ]
  assert_output_contains "backend/app.py"
}

@test "automated-status-check: check_structure sets backend_issues on missing" {
  run grep -A 25 "check_structure()" "$PROJECT_ROOT/scripts/monitoring/automated-status-check.sh"
  [ "$status" -eq 0 ]
  assert_output_contains "backend_issues"
}

# ============================================================================
# Report Generation Tests
# ============================================================================

@test "automated-status-check: generate_report exits 0 on all pass" {
  run grep "exit 0" "$PROJECT_ROOT/scripts/monitoring/automated-status-check.sh"
  [ "$status" -eq 0 ]
}

@test "automated-status-check: generate_report exits with issue count on failure" {
  run grep "exit.*total_issues" "$PROJECT_ROOT/scripts/monitoring/automated-status-check.sh"
  [ "$status" -eq 0 ]
}

@test "automated-status-check: generate_report provides issue summary" {
  run grep "ISSUES DETECTED" "$PROJECT_ROOT/scripts/monitoring/automated-status-check.sh"
  [ "$status" -eq 0 ]
}
