#!/usr/bin/env bash

# Custom assertion helpers

# Assert that output contains a string
assert_output_contains() {
  local expected="$1"
  if [[ ! "$output" =~ $expected ]]; then
    echo "Expected output to contain: $expected"
    echo "Actual output: $output"
    return 1
  fi
}

# Assert that a variable is set
assert_var_set() {
  local var_name="$1"
  if [ -z "${!var_name}" ]; then
    echo "Expected variable $var_name to be set"
    return 1
  fi
}

# Assert that a variable equals a value
assert_var_equals() {
  local var_name="$1"
  local expected="$2"
  local actual="${!var_name}"
  if [ "$actual" != "$expected" ]; then
    echo "Expected $var_name to equal: $expected"
    echo "Actual value: $actual"
    return 1
  fi
}

# Assert that a file exists
assert_file_exists() {
  local file="$1"
  if [ ! -f "$file" ]; then
    echo "Expected file to exist: $file"
    return 1
  fi
}

# Assert that a directory exists
assert_dir_exists() {
  local dir="$1"
  if [ ! -d "$dir" ]; then
    echo "Expected directory to exist: $dir"
    return 1
  fi
}

# ============================================================================
# Pokehub-Specific Assertions
# ============================================================================

# Assert HTTP status code (requires curl to be available or mocked)
assert_http_status() {
  local url="$1"
  local expected="$2"
  local actual
  
  # Try to get HTTP status
  actual=$(curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null || echo "000")
  
  if [ "$actual" != "$expected" ]; then
    echo "Expected HTTP status $expected for $url, got $actual"
    return 1
  fi
}

# Assert container is running
assert_container_running() {
  local container="$1"
  
  if ! docker ps --filter "name=$container" --format "{{.Names}}" 2>/dev/null | grep -q "$container"; then
    echo "Expected container '$container' to be running"
    return 1
  fi
}

# Assert container is not running
assert_container_not_running() {
  local container="$1"
  
  if docker ps --filter "name=$container" --format "{{.Names}}" 2>/dev/null | grep -q "$container"; then
    echo "Expected container '$container' to NOT be running"
    return 1
  fi
}

# Assert Redis is responding
assert_redis_healthy() {
  local response
  response=$(redis-cli ping 2>/dev/null || echo "FAIL")
  
  if [ "$response" != "PONG" ]; then
    echo "Expected Redis to respond with PONG, got: $response"
    return 1
  fi
}

# Assert API endpoint is accessible
assert_api_accessible() {
  local endpoint="$1"
  
  if ! curl -f -s "$endpoint" >/dev/null 2>&1; then
    echo "Expected API endpoint to be accessible: $endpoint"
    return 1
  fi
}

# Assert service is healthy (Pokehub-specific)
assert_pokehub_service_healthy() {
  local service="$1"
  
  case "$service" in
    "backend")
      if ! curl -f -s "http://localhost/api/v1/health" >/dev/null 2>&1; then
        echo "Backend service is not healthy"
        return 1
      fi
      ;;
    "frontend")
      if ! curl -f -s "http://localhost/" >/dev/null 2>&1; then
        echo "Frontend service is not healthy"
        return 1
      fi
      ;;
    "redis")
      if ! redis-cli ping >/dev/null 2>&1; then
        echo "Redis service is not healthy"
        return 1
      fi
      ;;
    "database")
      if ! psql -c "SELECT 1" >/dev/null 2>&1; then
        echo "Database service is not healthy"
        return 1
      fi
      ;;
    *)
      echo "Unknown service: $service"
      return 1
      ;;
  esac
}

# Assert Pokemon API returns data
assert_pokemon_api_returns_data() {
  local response
  response=$(curl -s "http://localhost/api/v1/pokemon" 2>/dev/null || echo "")
  
  if [ -z "$response" ]; then
    echo "Expected Pokemon API to return data"
    return 1
  fi
  
  # Check if response looks like JSON
  if ! echo "$response" | grep -q "{"; then
    echo "Expected Pokemon API to return JSON data"
    return 1
  fi
}

# Assert script has executable permissions
assert_script_executable() {
  local script="$1"
  
  if [ ! -x "$script" ]; then
    echo "Expected script to be executable: $script"
    return 1
  fi
}

# Assert environment variable is set
assert_env_var_set() {
  local var_name="$1"
  
  if [ -z "${!var_name}" ]; then
    echo "Expected environment variable to be set: $var_name"
    return 1
  fi
}

# Assert environment variable equals value
assert_env_var_equals() {
  local var_name="$1"
  local expected="$2"
  local actual="${!var_name}"
  
  if [ "$actual" != "$expected" ]; then
    echo "Expected $var_name=$expected, got: $actual"
    return 1
  fi
}
