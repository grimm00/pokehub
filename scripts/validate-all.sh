#!/bin/bash

# Comprehensive Validation Script
# Integrates documentation, template, and area validation

# Enable strict mode for better error handling
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
VALIDATION_RESULTS_DIR="validation-results"
TOTAL_ERRORS=0
TOTAL_WARNINGS=0

echo -e "${BLUE}🔍 Comprehensive Validation System${NC}"
echo "======================================"

# Function to log errors
log_error() {
    echo -e "${RED}❌ $1${NC}"
    ((TOTAL_ERRORS++))
}

# Function to log warnings
log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    ((TOTAL_WARNINGS++))
}

# Function to log success
log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Function to log info
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Create results directory
mkdir -p "$VALIDATION_RESULTS_DIR"

echo ""
log_info "Starting comprehensive validation..."

# 1. Template Validation
echo ""
echo -e "${BLUE}📋 Step 1: Template Validation${NC}"
echo "-------------------------------"

if [ -f "scripts/validate-templates.sh" ]; then
    log_info "Running template validation..."
    if ./scripts/validate-templates.sh > "$VALIDATION_RESULTS_DIR/template-validation.txt" 2>&1; then
        log_success "Template validation passed"
    else
        log_error "Template validation failed"
        echo "Template validation errors:" >> "$VALIDATION_RESULTS_DIR/errors.txt"
        cat "$VALIDATION_RESULTS_DIR/template-validation.txt" >> "$VALIDATION_RESULTS_DIR/errors.txt"
    fi
else
    log_warning "Template validation script not found"
fi

# 2. Documentation Structure Validation
echo ""
echo -e "${BLUE}📋 Step 2: Documentation Structure Validation${NC}"
echo "------------------------------------------------"

log_info "Validating documentation structure..."

# Check for required documentation directories
REQUIRED_DOCS=(
    "admin/README.md"
    "admin/planning/README.md"
    "admin/technical/README.md"
    "docs/README.md"
)

for doc in "${REQUIRED_DOCS[@]}"; do
    if [ -f "$doc" ]; then
        log_success "Required documentation exists: $doc"
    else
        log_warning "Missing required documentation: $doc"
    fi
done

# Check for hub-and-spoke structure in planning
log_info "Validating hub-and-spoke structure..."
PLANNING_DIRS=("features" "ci" "releases" "phases")
for dir in "${PLANNING_DIRS[@]}"; do
    if [ -d "admin/planning/$dir" ]; then
        log_success "Planning directory exists: admin/planning/$dir"
        
        # Check for README.md in each subdirectory
        for subdir in "admin/planning/$dir"/*/; do
            if [ -d "$subdir" ]; then
                if [ -f "$subdir/README.md" ]; then
                    log_success "  ✓ README.md exists in $(basename "$subdir")"
                else
                    log_warning "  ⚠ Missing README.md in $(basename "$subdir")"
                fi
            fi
        done
    else
        log_warning "Missing planning directory: admin/planning/$dir"
    fi
done

# 3. Project Area Validation
echo ""
echo -e "${BLUE}📋 Step 3: Project Area Validation${NC}"
echo "------------------------------------"

log_info "Validating project areas..."

# Check for area-specific directories
AREAS=("frontend" "backend" "main")
for area in "${AREAS[@]}"; do
    if [ -d "admin/planning/features/$area" ]; then
        log_success "Feature area exists: $area"
        
        # Check for projects in this area
        project_count=0
        for project_dir in "admin/planning/features/$area"/*/; do
            if [ -d "$project_dir" ]; then
                ((project_count++))
                project_name=$(basename "$project_dir")
                if [ -f "$project_dir/README.md" ]; then
                    log_success "  ✓ Project: $project_name (has README.md)"
                else
                    log_warning "  ⚠ Project: $project_name (missing README.md)"
                fi
            fi
        done
        
        if [ $project_count -eq 0 ]; then
            log_info "  ℹ No projects found in $area area"
        else
            log_info "  ℹ Found $project_count project(s) in $area area"
        fi
    else
        log_warning "Missing feature area: $area"
    fi
done

# 4. Link Validation (Basic)
echo ""
echo -e "${BLUE}📋 Step 4: Basic Link Validation${NC}"
echo "----------------------------------"

log_info "Checking for broken internal links..."

# Check for common broken link patterns
BROKEN_LINK_PATTERNS=(
    "\.\./\.\./\.\./\.\./\.\./"  # Too many ../ patterns
    "\[.*\]\([^)]*\.md\)"        # Markdown links
)

for pattern in "${BROKEN_LINK_PATTERNS[@]}"; do
    if grep -r "$pattern" admin/planning/ --include="*.md" >/dev/null 2>&1; then
        log_info "Found potential links matching pattern: $pattern"
        # Could add more sophisticated link checking here
    fi
done

# 5. Generate Validation Summary
echo ""
echo -e "${BLUE}📊 Validation Summary${NC}"
echo "====================="

# Create summary report
cat > "$VALIDATION_RESULTS_DIR/validation-summary.txt" << EOF
Comprehensive Validation Summary
Generated: $(date)
================================

Template Validation: $([ -f "$VALIDATION_RESULTS_DIR/template-validation.txt" ] && echo "Completed" || echo "Skipped")
Documentation Structure: Completed
Project Area Validation: Completed
Basic Link Validation: Completed

Total Errors: $TOTAL_ERRORS
Total Warnings: $TOTAL_WARNINGS

EOF

if [ $TOTAL_ERRORS -eq 0 ] && [ $TOTAL_WARNINGS -eq 0 ]; then
    log_success "All validations passed with no issues!"
    echo ""
    log_info "Comprehensive validation completed successfully."
    log_info "All documentation structure, templates, and project areas are valid."
    exit 0
elif [ $TOTAL_ERRORS -eq 0 ]; then
    log_success "All validations passed with $TOTAL_WARNINGS warning(s)."
    echo ""
    log_info "Comprehensive validation completed with warnings."
    log_info "Please review warnings above for potential improvements."
    exit 0
else
    log_error "Validation failed with $TOTAL_ERRORS error(s) and $TOTAL_WARNINGS warning(s)."
    echo ""
    log_info "Please fix the errors above before proceeding."
    exit 1
fi
