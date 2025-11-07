# Complexity Issues

**Purpose:** Code complexity analysis and simplification opportunities  
**Status:** ✅ Complete  
**Last Updated:** 2025-01-20

---

## 📋 Summary

**High Complexity Functions:** 2  
**Medium Complexity Functions:** 5  
**Code Duplication Issues:** 4  
**Deep Nesting Issues:** 2

---

## 🔴 High Complexity Functions

### 1. `PokemonList.get()` - `routes/pokemon_routes.py`

**Location:** Lines 15-229  
**Lines:** 215 lines  
**Complexity:** VERY HIGH  
**Cyclomatic Complexity:** ~15-20

**Issues:**
- Extremely long method (215 lines, should be < 50)
- Multiple responsibilities:
  - Parameter parsing
  - Cache checking
  - Query building (search, type, generation filters)
  - Sorting logic (8 different sort options)
  - Special favorites sorting (manual sort)
  - Pagination
- Deep nesting (4-5 levels)
- Complex conditional logic
- Duplicate JWT identity retrieval (3 times)

**Refactoring Recommendation:**

```python
class PokemonList(Resource):
    @jwt_required(optional=True)
    def get(self):
        params = self._parse_params()
        
        # Check cache
        cached_result = pokemon_cache.get_pokemon_list(params)
        if cached_result:
            return cached_result
        
        # Build query
        query = self._build_query(params)
        
        # Apply sorting
        query = self._apply_sorting(query, params.get('sort'))
        
        # Handle pagination
        result = self._paginate(query, params, params.get('sort') == 'favorites')
        
        # Cache result
        pokemon_cache.cache_pokemon_list(params, result, ttl=300)
        return result
    
    def _parse_params(self):
        """Extract and validate request parameters"""
        # ... parameter parsing logic
    
    def _build_query(self, params):
        """Build base query with filters"""
        # ... query building logic
    
    def _apply_sorting(self, query, sort_by):
        """Apply sorting to query"""
        # ... sorting logic (except favorites)
    
    def _paginate(self, query, params, is_favorites_sort=False):
        """Handle pagination"""
        # ... pagination logic
```

**Benefits:**
- Each method has single responsibility
- Easier to test
- Easier to maintain
- Reduced complexity

---

### 2. `swagger_spec()` - `app.py`

**Location:** Lines 209-442  
**Lines:** 234 lines  
**Complexity:** HIGH

**Issues:**
- Very long function (234 lines)
- Hardcoded OpenAPI specification
- Deep nesting in schema definitions
- Difficult to maintain

**Refactoring Recommendation:**

1. **Extract to separate file:**
   ```python
   # backend/api/openapi_spec.py
   def generate_openapi_spec():
       return {
           "openapi": "3.0.0",
           # ... spec definition
       }
   ```

2. **Use library:**
   ```python
   from flasgger import Swagger
   swagger = Swagger(app)
   # Auto-generates from docstrings
   ```

3. **Break into helpers:**
   ```python
   def _get_paths_spec():
       # ... paths definition
   
   def _get_components_spec():
       # ... components definition
   ```

---

## 🟠 Medium Complexity Functions

### 3. `AuthProfile.put()` - `routes/auth_routes.py`

**Location:** Lines 132-173  
**Lines:** 42 lines  
**Complexity:** MEDIUM

**Issues:**
- Duplicate validation logic (username/email checks)
- Similar pattern to `UserDetail.put()`

**Refactoring:**
- Extract validation to shared helper
- Reduce duplication

---

### 4. `UserFavorites.get()` - `routes/user_routes.py`

**Location:** Lines 163-202  
**Lines:** 40 lines  
**Complexity:** MEDIUM

**Issues:**
- N+1 query problem (line 180: query inside loop)
- Could use join to fetch all at once

**Refactoring:**
```python
# Current (N+1 queries):
for favorite in favorites:
    pokemon = Pokemon.query.filter_by(pokemon_id=favorite.pokemon_id).first()

# Improved (single query):
favorites_with_pokemon = db.session.query(UserPokemon, Pokemon)\
    .join(Pokemon, UserPokemon.pokemon_id == Pokemon.pokemon_id)\
    .filter(UserPokemon.user_id == user_id)\
    .all()
```

---

### 5. `PokeAPIClient._make_request()` - `services/pokeapi_client.py`

**Location:** Lines 69-124  
**Lines:** 56 lines  
**Complexity:** MEDIUM

**Issues:**
- Multiple nested conditionals
- Error handling could be cleaner

**Status:** ✅ Acceptable, but could be improved

---

### 6. `validate_input()` - `services/security.py`

**Location:** Lines 226-275  
**Lines:** 50 lines  
**Complexity:** MEDIUM

**Issues:**
- Long function handling multiple validation types
- Could be split into smaller validators

**Refactoring:**
```python
def validate_input(data, rules):
    errors = []
    for field, rule in rules.items():
        field_errors = _validate_field(data.get(field), field, rule)
        errors.extend(field_errors)
    return errors

def _validate_field(value, field, rule):
    """Validate a single field"""
    errors = []
    if rule.get('required') and not value:
        errors.append({'field': field, 'message': f'{field} is required'})
    if value:
        errors.extend(_validate_type(value, field, rule))
        errors.extend(_validate_length(value, field, rule))
        errors.extend(_validate_pattern(value, field, rule))
    return errors
```

---

### 7. Audit Log Helper Functions - `models/audit_log.py`

**Location:** Lines 106-162  
**Lines:** 57 lines (3 functions)  
**Complexity:** MEDIUM (due to duplication)

**Issues:**
- Three similar functions with duplicate code
- `log_user_action`, `log_system_event`, `log_security_event`
- Same pattern repeated 3 times

**Refactoring:**
```python
def _create_audit_log(action, user_id=None, resource=None, resource_id=None, details=None, request=None):
    """Common logic for creating audit logs"""
    audit_log = AuditLog(
        user_id=user_id,
        action=action,
        resource=resource,
        resource_id=resource_id,
        details=details or {}
    )
    
    if request:
        audit_log.ip_address = request.remote_addr
        audit_log.user_agent = request.headers.get('User-Agent')
        audit_log.endpoint = request.endpoint
        audit_log.method = request.method
    
    db.session.add(audit_log)
    db.session.commit()
    return audit_log

def log_user_action(user_id, action, resource=None, resource_id=None, details=None, request=None):
    """Log a user action"""
    return _create_audit_log(action, user_id=user_id, resource=resource, 
                            resource_id=resource_id, details=details, request=request)

def log_system_event(action, details=None, request=None):
    """Log a system event"""
    return _create_audit_log(action, details=details, request=request)

def log_security_event(action, user_id=None, details=None, request=None):
    """Log a security-related event"""
    return _create_audit_log(action, user_id=user_id, details=details, request=request)
```

---

## 🔄 Code Duplication

### 1. JWT Identity Retrieval

**Location:** `routes/pokemon_routes.py` lines 30, 112, 140  
**Issue:** Same code repeated 3 times

```python
# Repeated 3 times:
from flask_jwt_extended import get_jwt_identity
try:
    user_id = get_jwt_identity()
    # ... use user_id
except Exception:
    # ... fallback
```

**Fix:** Extract to helper method

---

### 2. Username/Email Existence Checks

**Location:** Multiple route files  
**Issue:** Same validation pattern repeated

**Fix:** Extract to shared validation function

---

### 3. Access Control Logic

**Location:** `routes/user_routes.py` multiple methods  
**Issue:** Same access control pattern repeated

```python
# Repeated pattern:
if current_user_id != user_id and not current_user.is_admin:
    return {'message': 'Access denied'}, 403
```

**Fix:** Extract to decorator or helper function

---

### 4. Database Path Resolution

**Location:** `app.py` lines 27-41  
**Issue:** Complex nested conditionals

**Fix:** Extract to helper function (see app-analysis.md)

---

## 📊 Complexity Metrics

| File | Max Function Length | Avg Function Length | Max Nesting | Complexity Score |
|------|---------------------|---------------------|-------------|------------------|
| `app.py` | 234 | 92 | 4 | HIGH |
| `routes/pokemon_routes.py` | 215 | 98 | 5 | VERY HIGH |
| `routes/auth_routes.py` | 42 | 35 | 3 | MEDIUM |
| `routes/user_routes.py` | 40 | 28 | 3 | MEDIUM |
| `services/pokeapi_client.py` | 56 | 30 | 3 | MEDIUM |
| `services/security.py` | 50 | 25 | 3 | MEDIUM |

**Targets:**
- Max function length: < 50 lines
- Max nesting: < 3 levels
- Avg function length: < 30 lines

---

## ✅ Recommendations Priority

### High Priority
1. **Refactor `PokemonList.get()`** - Break into smaller methods
2. **Extract `swagger_spec()`** - Move to separate file/module

### Medium Priority
3. **Refactor audit log helpers** - Reduce duplication
4. **Fix N+1 query in UserFavorites.get()** - Use join
5. **Extract JWT identity retrieval** - Reduce duplication

### Low Priority
6. **Refactor `validate_input()`** - Split into smaller functions
7. **Extract access control logic** - Create decorator
8. **Extract validation logic** - Share between routes

---

## 📚 Related Documents

- [Routes Analysis](../module-analysis/routes-analysis.md) - Detailed routes analysis
- [App Analysis](../module-analysis/app-analysis.md) - App.py analysis
- [Models Analysis](../module-analysis/models-analysis.md) - Models analysis
- [Recommendations](../recommendations.md) - Prioritized recommendations

---

**Last Updated:** 2025-01-20  
**Status:** ✅ Complete

