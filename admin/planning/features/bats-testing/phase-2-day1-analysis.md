# Phase 2 Day 1: Script Analysis

**Date:** 2025-10-07  
**Status:** ✅ Complete  
**Scripts Analyzed:** 3

---

## 📋 Script 1: docker-startup.sh

**Location:** `scripts/core/docker-startup.sh`  
**Lines:** 51  
**Purpose:** Starts the Pokehub application with all services

### Overview
This script orchestrates the complete application startup:
1. Starts Redis server
2. Initializes database tables
3. Seeds Pokemon data (with timeout handling)
4. Starts Flask backend
5. Starts nginx frontend

### Key Features
- **Error Handling:** Uses `set -e` for fail-fast behavior
- **Timeout Protection:** Pokemon seeding has configurable timeout (default 120s)
- **Graceful Degradation:** Continues if seeding fails/times out
- **Dynamic Configuration:** Gets generation range from config
- **Background Processes:** Flask runs in background, nginx in foreground

### Functions/Sections
1. **Redis Startup** (lines 6-8)
   - Starts Redis as daemon
   - No error checking (relies on set -e)

2. **Database Initialization** (lines 10-18)
   - Creates all database tables
   - Uses Python inline script
   - Runs in /app directory

3. **Pokemon Seeding** (lines 20-42)
   - Configurable timeout via `POKEMON_SEEDING_TIMEOUT`
   - Gets generation range dynamically
   - Handles both success and failure
   - Continues on timeout or error

4. **Flask Startup** (lines 44-46)
   - Runs in background (&)
   - Uses Python module syntax

5. **Nginx Startup** (lines 48-50)
   - Runs in foreground (daemon off)
   - Last command (keeps container alive)

### Dependencies
- **External Commands:**
  - `redis-server`
  - `python`
  - `timeout`
  - `nginx`

- **Python Modules:**
  - `backend.app`
  - `backend.database`
  - `backend.utils.pokemon_seeder`
  - `backend.utils.generation_config`

- **Environment Variables:**
  - `POKEMON_SEEDING_TIMEOUT` (optional, default: 120)

### Test Categories (8-12 tests)

#### 1. Script Structure (3 tests)
- [ ] Script exists and is executable
- [ ] Has proper shebang (#!/bin/bash)
- [ ] Uses set -e for error handling

#### 2. Redis Startup (2 tests)
- [ ] Attempts to start Redis server
- [ ] Uses daemonize mode

#### 3. Database Initialization (2 tests)
- [ ] Runs database creation script
- [ ] Uses correct Python module imports

#### 4. Pokemon Seeding (3 tests)
- [ ] Uses timeout command
- [ ] Handles seeding timeout gracefully
- [ ] Continues on seeding failure

#### 5. Service Startup (2 tests)
- [ ] Starts Flask in background
- [ ] Starts nginx in foreground

### Mocking Strategy
- `mock_redis_server()` - Mock Redis startup
- `mock_python_success()` / `mock_python_failure()` - Mock Python commands
- `timeout` - Mock timeout command
- `nginx` - Mock nginx startup

### Edge Cases
1. Redis fails to start
2. Database initialization fails
3. Pokemon seeding times out
4. Pokemon seeding fails
5. Flask fails to start
6. Nginx fails to start

### Expected Test Count: **10 tests**

---

## 📋 Script 2: health-check.sh

**Location:** `scripts/core/health-check.sh`  
**Lines:** 112  
**Purpose:** Checks health of all Pokehub services

### Overview
Comprehensive health check script that validates:
1. Docker container status
2. API endpoint availability
3. Database connectivity
4. Redis connectivity

### Key Features
- **Colored Output:** Uses ANSI color codes for readability
- **Configurable:** BASE_URL and TIMEOUT via environment variables
- **Modular Functions:** Separate functions for different check types
- **Exit Codes:** Returns proper exit codes for automation
- **Detailed Reporting:** Shows status for each component

### Functions

#### 1. `check_endpoint()` (lines 24-43)
**Purpose:** Check HTTP endpoint availability
**Parameters:**
- `$1` - Name (for display)
- `$2` - URL
- `$3` - Expected HTTP status code

**Logic:**
- Uses curl with timeout
- Checks HTTP status code
- Returns 0 on success, 1 on failure
- Colored output (green/red)

#### 2. `check_service()` (lines 46-64)
**Purpose:** Check Docker container status
**Parameters:**
- `$1` - Service name (for display)
- `$2` - Container name

**Logic:**
- Uses `docker ps` to check container
- Verifies container is running
- Returns 0 on success, 1 on failure
- Colored output (green/yellow/red)

### Workflow

1. **Configuration** (lines 14-21)
   - Sets BASE_URL (default: http://localhost)
   - Sets TIMEOUT (default: 10s)
   - Displays configuration

2. **Docker Service Check** (lines 66-76)
   - Finds pokedex container
   - Checks if running
   - Exits if not found

3. **API Endpoint Checks** (lines 78-84)
   - Root endpoint (/)
   - Health endpoint (/)
   - Pokemon API (/api/v1/pokemon)
   - API docs (/api/docs)

4. **Database Check** (lines 86-92)
   - Uses docker exec
   - Runs Python database connection test
   - Shows connection status

5. **Redis Check** (lines 94-100)
   - Uses docker exec
   - Runs redis-cli ping
   - Checks for PONG response

6. **Final Validation** (lines 102-111)
   - Re-checks root endpoint
   - Exits with error if critical check fails
   - Shows success message

### Dependencies
- **External Commands:**
  - `curl`
  - `docker` (ps, exec)
  - `grep`

- **Environment Variables:**
  - `BASE_URL` (optional, default: http://localhost)
  - `TIMEOUT` (optional, default: 10)

### Test Categories (8-10 tests)

#### 1. Script Structure (3 tests)
- [ ] Script exists and is executable
- [ ] Has proper shebang
- [ ] Uses set -e

#### 2. Configuration (2 tests)
- [ ] Uses BASE_URL environment variable
- [ ] Uses TIMEOUT environment variable

#### 3. check_endpoint() Function (2 tests)
- [ ] Function is defined
- [ ] Handles successful responses
- [ ] Handles failed responses

#### 4. check_service() Function (2 tests)
- [ ] Function is defined
- [ ] Checks Docker container status

#### 5. Integration (2 tests)
- [ ] Checks all expected endpoints
- [ ] Exits with proper status codes

### Mocking Strategy
- `mock_docker_success()` - Mock docker ps/exec
- `mock_curl_success()` / `mock_curl_failure()` - Mock curl
- `mock_redis_cli_success()` - Mock redis-cli

### Edge Cases
1. Docker container not found
2. API endpoints unreachable
3. Database connection fails
4. Redis connection fails
5. Curl timeout
6. Invalid BASE_URL

### Expected Test Count: **9 tests**

---

## 📋 Script 3: invalidate-cache.sh

**Location:** `scripts/core/invalidate-cache.sh`  
**Lines:** 51  
**Purpose:** Tests and validates cache headers for different resource types

### Overview
This script is actually a **cache testing/validation script**, not a cache invalidation script. It:
1. Checks if Docker container is running
2. Tests cache headers for static assets
3. Tests cache headers for HTML files
4. Tests cache headers for API endpoints
5. Provides tips for cache invalidation

### Key Features
- **Container Validation:** Checks Docker container before testing
- **Cache Header Testing:** Tests different resource types
- **Educational Output:** Shows expected cache behavior
- **User Tips:** Provides browser cache clearing instructions

### Workflow

1. **Timestamp Display** (lines 9-11)
   - Shows current timestamp
   - For reference/logging

2. **Container Check** (lines 13-19)
   - Checks if pokedex container is running
   - Exits if not running
   - Hardcoded container name: `pokedex-pokedex-app-1`

3. **Static Assets Test** (lines 26-28)
   - Tests JS file cache headers
   - Should be cached for 1 year
   - Uses curl -I (HEAD request)

4. **HTML Files Test** (lines 30-33)
   - Tests root HTML cache headers
   - Should not be cached
   - Uses curl -I

5. **API Endpoints Test** (lines 35-38)
   - Tests Pokemon API cache headers
   - Should not be cached
   - Checks for x-api-version header

6. **Summary & Tips** (lines 40-50)
   - Shows expected cache behavior
   - Provides browser tips
   - Educational output

### Dependencies
- **External Commands:**
  - `docker` (ps)
  - `curl`
  - `grep`
  - `date`

- **Assumptions:**
  - Container name: `pokedex-pokedex-app-1`
  - Base URL: http://localhost
  - Specific asset path exists

### Test Categories (6-8 tests)

#### 1. Script Structure (3 tests)
- [ ] Script exists and is executable
- [ ] Has proper shebang
- [ ] Shows timestamp

#### 2. Container Validation (2 tests)
- [ ] Checks if Docker container is running
- [ ] Exits if container not found

#### 3. Cache Header Testing (3 tests)
- [ ] Tests static asset headers
- [ ] Tests HTML file headers
- [ ] Tests API endpoint headers

### Mocking Strategy
- `mock_docker_success()` / `mock_docker_failure()` - Mock docker ps
- `mock_curl_success()` - Mock curl for header checks
- `date` - Can mock for consistent timestamp

### Edge Cases
1. Docker container not running
2. Curl fails (connection refused)
3. Expected assets don't exist
4. Headers not present

### Expected Test Count: **8 tests**

---

## 📊 Summary

### Total Analysis

| Script | Lines | Functions | Tests | Complexity |
|--------|-------|-----------|-------|------------|
| docker-startup.sh | 51 | 0 (sections) | 10 | Medium |
| health-check.sh | 112 | 2 | 9 | Medium |
| invalidate-cache.sh | 51 | 0 | 8 | Low |
| **Total** | **214** | **2** | **27** | **Medium** |

### Key Insights

1. **docker-startup.sh**
   - Most critical script (starts entire app)
   - Good error handling with timeouts
   - Graceful degradation on seeding failure
   - Tests should focus on error paths

2. **health-check.sh**
   - Well-structured with functions
   - Comprehensive health checking
   - Good for integration testing
   - Tests should mock Docker and curl

3. **invalidate-cache.sh**
   - Simplest script (mostly testing/validation)
   - Misnamed (doesn't actually invalidate cache)
   - Educational purpose
   - Tests should focus on container check and curl

### Shared Dependencies
- **Docker:** All scripts depend on Docker
- **curl:** 2 scripts use curl
- **Python:** 1 script uses Python
- **Redis:** 2 scripts interact with Redis

### Common Patterns
1. Container name checking
2. Error handling with exit codes
3. Colored output for user feedback
4. Environment variable configuration

---

## 🎯 Testing Strategy

### Approach
1. **CLI Interface Testing** - Test scripts without sourcing
2. **Structure Testing** - Verify script content
3. **Mock External Commands** - Use Phase 1 helpers
4. **Fast Execution** - Keep tests under 10 seconds

### Helpers Available (From Phase 1)
✅ `mock_docker_success()` / `mock_docker_failure()`
✅ `mock_curl_success()` / `mock_curl_failure()`
✅ `mock_redis_cli_success()` / `mock_redis_cli_failure()`
✅ `mock_python_success()` / `mock_python_failure()`
✅ `assert_output_contains()`
✅ `assert_script_executable()`
✅ `assert_file_exists()`

### New Mocks Needed
❌ None! All required mocks already exist from Phase 1

---

## 📋 Test Plan Summary

### Day 2: docker-startup.sh (10 tests)
**File:** `tests/shell/unit/core/test-docker-startup.bats`

**Categories:**
1. Script Structure (3 tests)
2. Redis Startup (2 tests)
3. Database Initialization (2 tests)
4. Pokemon Seeding (3 tests)

**Focus:** Error handling, timeout behavior, graceful degradation

---

### Day 3: health-check.sh (9 tests)
**File:** `tests/shell/unit/core/test-health-check.bats`

**Categories:**
1. Script Structure (3 tests)
2. Configuration (2 tests)
3. Functions (2 tests)
4. Integration (2 tests)

**Focus:** Function definitions, endpoint checking, exit codes

---

### Day 4: invalidate-cache.sh (8 tests)
**File:** `tests/shell/unit/test-invalidate-cache.bats`

**Categories:**
1. Script Structure (3 tests)
2. Container Validation (2 tests)
3. Cache Header Testing (3 tests)

**Focus:** Container checking, curl usage, output validation

---

## ✅ Day 1 Completion Checklist

- [x] ✅ Read docker-startup.sh (51 lines, 0 functions)
- [x] ✅ Read health-check.sh (112 lines, 2 functions)
- [x] ✅ Read invalidate-cache.sh (51 lines, 0 functions)
- [x] ✅ Identified all dependencies
- [x] ✅ Documented test categories
- [x] ✅ Planned mocking strategy
- [x] ✅ Identified edge cases
- [x] ✅ Confirmed no new helpers needed
- [x] ✅ Created test plan for each script

**Total Planned Tests:** 27 tests (within 20-30 target range)

---

## 🚀 Ready for Day 2

**Next Steps:**
1. Create `tests/shell/unit/core/` directory
2. Start with `test-docker-startup.bats`
3. Implement 10 tests for docker-startup.sh
4. Use existing Phase 1 helpers

**All analysis complete - ready to start implementation!** ✅

---

**Last Updated:** 2025-10-07  
**Status:** ✅ Day 1 Complete  
**Next:** Day 2 - Test docker-startup.sh
