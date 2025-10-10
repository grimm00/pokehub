#!/bin/bash

# Template Validation Script
# Validates template consistency and completeness across the project

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
TEMPLATES_DIR="admin/planning/notes/opportunities/external/administration/templates"
PROJECTS_DIR="admin/planning"
VALIDATION_ERRORS=0

echo -e "${BLUE}🔍 Template Validation Script${NC}"
echo "=================================="

# Function to log errors
log_error() {
    echo -e "${RED}❌ $1${NC}"
    ((VALIDATION_ERRORS++))
}

# Function to log warnings
log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Function to log success
log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Function to log info
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if templates directory exists
if [ ! -d "$TEMPLATES_DIR" ]; then
    log_error "Templates directory not found: $TEMPLATES_DIR"
    exit 1
fi

# Check if projects directory exists
if [ ! -d "$PROJECTS_DIR" ]; then
    log_error "Projects directory not found: $PROJECTS_DIR"
    exit 1
fi

echo ""
log_info "Validating template structure and consistency..."

# 1. Validate template files exist and have required sections
echo ""
echo -e "${BLUE}📋 Step 1: Validating Template Files${NC}"
echo "----------------------------------------"

# Required templates
REQUIRED_TEMPLATES=(
    "README-template.md"
    "feature-plan-template.md"
    "phase-template.md"
    "ci-plan-template.md"
    "status-and-next-steps-template.md"
    "quick-start-template.md"
)

# Check each required template exists
for template in "${REQUIRED_TEMPLATES[@]}"; do
    template_path="$TEMPLATES_DIR/$template"
    if [ -f "$template_path" ]; then
        log_success "Template exists: $template"
    else
        log_error "Missing required template: $template"
    fi
done

# 2. Validate template structure (required sections)
echo ""
echo -e "${BLUE}📋 Step 2: Validating Template Structure${NC}"
echo "--------------------------------------------"

# Function to check required sections in a template
check_template_sections() {
    local template_file="$1"
    local template_name=$(basename "$template_file")
    
    echo "Checking $template_name..."
    
    # Common required sections for all templates
    local required_sections=(
        "Status:"
        "Created:"
        "Last Updated:"
        "Priority:"
        "## 📋"
        "## 🎯"
    )
    
    # Template-specific required sections
    case "$template_name" in
        "README-template.md")
            required_sections+=("## 📋 Quick Links" "## 🎯 Overview")
            ;;
        "feature-plan-template.md")
            required_sections+=("## 📋 Overview" "### Problem Statement" "### Solution Approach")
            ;;
        "phase-template.md")
            # Phase template uses different date fields
            required_sections=("Status:" "Started:" "Completed:" "Duration:" "PR:" "## 📋" "## 🎯")
            required_sections+=("## 📋 Overview" "## 🎯 Success Criteria" "## 📅 Implementation Plan")
            ;;
        "ci-plan-template.md")
            required_sections+=("## 📋 Overview" "### Problem Statement" "### Solution Approach")
            ;;
        "status-and-next-steps-template.md")
            # Status template uses different date field
            required_sections=("Status:" "Date:" "Next:" "## 📊" "## 🎯")
            required_sections+=("## 📊 Current Status" "## 🚀 Next Steps")
            ;;
        "quick-start-template.md")
            # Quick start template uses different fields
            required_sections=("Purpose:" "Audience:" "Last Updated:" "## 🚀" "## 📖")
            required_sections+=("## 🚀 Quick Start" "## 📖 Common Tasks")
            ;;
    esac
    
    # Check each required section
    for section in "${required_sections[@]}"; do
        if grep -q "$section" "$template_file"; then
            log_success "  ✓ Section found: $section"
        else
            log_error "  ✗ Missing section: $section in $template_name"
        fi
    done
}

# Check each template file
for template in "${REQUIRED_TEMPLATES[@]}"; do
    template_path="$TEMPLATES_DIR/$template"
    if [ -f "$template_path" ]; then
        check_template_sections "$template_path"
    fi
done

# 3. Validate project structure compliance
echo ""
echo -e "${BLUE}📋 Step 3: Validating Project Structure Compliance${NC}"
echo "------------------------------------------------"

# Function to check if a project follows template structure
check_project_compliance() {
    local project_dir="$1"
    local project_name=$(basename "$project_dir")
    
    echo "Checking project: $project_name"
    
    # Check for README.md (required for all projects)
    if [ -f "$project_dir/README.md" ]; then
        log_success "  ✓ README.md exists"
        
        # Check README has required sections
        local readme_sections=("Status:" "Created:" "Last Updated:" "Priority:" "## 📋" "## 🎯")
        for section in "${readme_sections[@]}"; do
            if grep -q "$section" "$project_dir/README.md"; then
                log_success "    ✓ README section: $section"
            else
                log_warning "    ⚠ Missing README section: $section"
            fi
        done
    else
        log_error "  ✗ Missing README.md in $project_name"
    fi
    
    # Check for other common files
    local common_files=("feature-plan.md" "status-and-next-steps.md" "quick-start.md")
    for file in "${common_files[@]}"; do
        if [ -f "$project_dir/$file" ]; then
            log_success "  ✓ $file exists"
        else
            log_info "  ℹ $file not found (optional)"
        fi
    done
}

# Check projects in features directory
if [ -d "$PROJECTS_DIR/features" ]; then
    for project_dir in "$PROJECTS_DIR/features"/*/; do
        if [ -d "$project_dir" ]; then
            check_project_compliance "$project_dir"
        fi
    done
fi

# Check projects in ci directory
if [ -d "$PROJECTS_DIR/ci" ]; then
    for project_dir in "$PROJECTS_DIR/ci"/*/; do
        if [ -d "$project_dir" ]; then
            check_project_compliance "$project_dir"
        fi
    done
fi

# 4. Validate template consistency
echo ""
echo -e "${BLUE}📋 Step 4: Validating Template Consistency${NC}"
echo "--------------------------------------------"

# Check that all templates use consistent status indicators
echo "Checking status indicator consistency..."
status_indicators=("🔴 Not Started" "🟡 Planned" "🟠 In Progress" "✅ Complete" "❌ Cancelled")
for indicator in "${status_indicators[@]}"; do
    if grep -q "$indicator" "$TEMPLATES_DIR"/*.md; then
        log_success "  ✓ Status indicator found: $indicator"
    else
        log_warning "  ⚠ Status indicator not found: $indicator"
    fi
done

# Check that all templates use consistent priority indicators
echo "Checking priority indicator consistency..."
priority_indicators=("🔴 Critical" "🟠 High" "🟡 Medium" "🟢 Low")
for indicator in "${priority_indicators[@]}"; do
    if grep -q "$indicator" "$TEMPLATES_DIR"/*.md; then
        log_success "  ✓ Priority indicator found: $indicator"
    else
        log_warning "  ⚠ Priority indicator not found: $indicator"
    fi
done

# 5. Summary
echo ""
echo -e "${BLUE}📊 Validation Summary${NC}"
echo "====================="

if [ $VALIDATION_ERRORS -eq 0 ]; then
    log_success "All template validations passed!"
    echo ""
    log_info "Template validation completed successfully."
    log_info "All templates are consistent and projects follow the expected structure."
    exit 0
else
    log_error "Template validation failed with $VALIDATION_ERRORS error(s)."
    echo ""
    log_info "Please fix the errors above before proceeding."
    exit 1
fi
