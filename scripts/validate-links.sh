#!/bin/bash

# Link Validation Script
# Validates internal links in markdown files to prevent broken navigation

# Enable strict mode for better error handling (with pipefail disabled for while loops)
set -eu

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

echo -e "${BLUE}🔗 Link Validation System${NC}"
echo "============================="

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
log_info "Starting link validation..."

# 1. Validate Internal Links in Planning Documentation
echo ""
echo -e "${BLUE}📋 Step 1: Planning Documentation Links${NC}"
echo "----------------------------------------"

log_info "Validating internal links in admin/planning/..."

# Check for markdown links in planning documentation
find admin/planning/ -name "*.md" -type f | while read -r file; do
    log_info "Checking $file..."
    
    # Check for internal links (relative paths, .md files, not starting with http(s) or /)
    grep -n '\[[^]]*\]\(([^/)][^)]*\.md([?#][^)]*)?\)' "$file" 2>/dev/null | while read -r line; do
        line_num=$(echo "$line" | cut -d: -f1)
        link=$(echo "$line" | sed -n 's/.*\[[^]]*\](\([^/)][^)]*\.md\([?#][^)]*\)\?)).*/\1/p')
        
        if [ -n "$link" ]; then
            # Convert relative path to absolute path from file location
            file_dir=$(dirname "$file")
            target_file="$file_dir/$link"
            
            # Check if target file exists
            if [ -f "$target_file" ]; then
                log_success "  ✓ Link to $link (line $line_num)"
            else
                log_error "  ❌ Broken link to $link (line $line_num in $file)"
                echo "Broken link: $file:$line_num -> $link" >> "$VALIDATION_RESULTS_DIR/broken-links.txt"
            fi
        fi
    done
done

# 2. Validate Navigation Links in Generated Project Index
echo ""
echo -e "${BLUE}📋 Step 2: Project Index Navigation${NC}"
echo "------------------------------------"

if [ -f "project-index/PROJECT-INDEX.md" ]; then
    log_info "Validating navigation links in project index..."
    
    # Check navigation links
    grep -n '\[.*\](#[^)]*)' "project-index/PROJECT-INDEX.md" 2>/dev/null | while read -r line; do
        line_num=$(echo "$line" | cut -d: -f1)
        anchor=$(echo "$line" | sed -n 's/.*\[[^]]*\](#\([^)]*\)).*/\1/p')
        
        if [ -n "$anchor" ]; then
            # Convert anchor back to heading text for matching
            # e.g., "frontend-projects" -> "Frontend Projects"
            heading_text=$(echo "$anchor" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')
            
            # Handle special cases
            case "$anchor" in
                "maincross-cutting-projects")
                    heading_text="Main/Cross-cutting Projects"
                    ;;
                "cicd-projects")
                    heading_text="CI/CD Projects"
                    ;;
            esac
            
            # Check if anchor exists in the file (look for heading that would generate this anchor)
            if grep -q "^##.*$heading_text\|^###.*$heading_text\|^####.*$heading_text" "project-index/PROJECT-INDEX.md"; then
                log_success "  ✓ Navigation anchor #$anchor (line $line_num)"
            else
                log_warning "  ⚠ Navigation anchor #$anchor not found (line $line_num)"
                echo "Missing anchor: project-index/PROJECT-INDEX.md:$line_num -> #$anchor" >> "$VALIDATION_RESULTS_DIR/missing-anchors.txt"
            fi
        fi
    done
else
    log_warning "Project index not found - run project index generation first"
fi

# 3. Validate Cross-References Between Documents
echo ""
echo -e "${BLUE}📋 Step 3: Cross-Reference Validation${NC}"
echo "------------------------------------"

log_info "Validating cross-references between documents..."

# Check for common cross-reference patterns
find admin/ -name "*.md" -type f | while read -r file; do
    # Check for references to other planning documents
    grep -n '\[.*\]\([^)]*\.md\)' "$file" 2>/dev/null | while read -r line; do
        line_num=$(echo "$line" | cut -d: -f1)
        link=$(echo "$line" | sed -n 's/.*\[[^]]*\](\([^)]*\.md\)).*/\1/p')
        
        if [ -n "$link" ] && [[ "$link" != http* ]]; then
            # Convert relative path to absolute path
            file_dir=$(dirname "$file")
            target_file="$file_dir/$link"
            
            if [ -f "$target_file" ]; then
                log_success "  ✓ Cross-reference to $link (line $line_num in $file)"
            else
                log_error "  ❌ Broken cross-reference to $link (line $line_num in $file)"
                echo "Broken cross-reference: $file:$line_num -> $link" >> "$VALIDATION_RESULTS_DIR/broken-cross-refs.txt"
            fi
        fi
    done
done

# 4. Generate Validation Summary
echo ""
echo -e "${BLUE}📊 Link Validation Summary${NC}"
echo "============================="

# Create summary report
cat > "$VALIDATION_RESULTS_DIR/link-validation-summary.txt" << EOF
Link Validation Summary
Generated: $(date)
========================

Planning Documentation Links: Completed
Project Index Navigation: Completed
Cross-Reference Validation: Completed

Total Errors: $TOTAL_ERRORS
Total Warnings: $TOTAL_WARNINGS

EOF

if [ -f "$VALIDATION_RESULTS_DIR/broken-links.txt" ]; then
    echo "Broken Links:" >> "$VALIDATION_RESULTS_DIR/link-validation-summary.txt"
    cat "$VALIDATION_RESULTS_DIR/broken-links.txt" >> "$VALIDATION_RESULTS_DIR/link-validation-summary.txt"
    echo "" >> "$VALIDATION_RESULTS_DIR/link-validation-summary.txt"
fi

if [ -f "$VALIDATION_RESULTS_DIR/missing-anchors.txt" ]; then
    echo "Missing Anchors:" >> "$VALIDATION_RESULTS_DIR/link-validation-summary.txt"
    cat "$VALIDATION_RESULTS_DIR/missing-anchors.txt" >> "$VALIDATION_RESULTS_DIR/link-validation-summary.txt"
    echo "" >> "$VALIDATION_RESULTS_DIR/link-validation-summary.txt"
fi

if [ -f "$VALIDATION_RESULTS_DIR/broken-cross-refs.txt" ]; then
    echo "Broken Cross-References:" >> "$VALIDATION_RESULTS_DIR/link-validation-summary.txt"
    cat "$VALIDATION_RESULTS_DIR/broken-cross-refs.txt" >> "$VALIDATION_RESULTS_DIR/link-validation-summary.txt"
fi

if [ $TOTAL_ERRORS -eq 0 ] && [ $TOTAL_WARNINGS -eq 0 ]; then
    log_success "All link validations passed with no issues!"
    echo ""
    log_info "Link validation completed successfully."
    log_info "All internal links, navigation anchors, and cross-references are valid."
    exit 0
elif [ $TOTAL_ERRORS -eq 0 ]; then
    log_success "All link validations passed with $TOTAL_WARNINGS warning(s)."
    echo ""
    log_info "Link validation completed with warnings."
    log_info "Please review warnings above for potential improvements."
    exit 0
else
    log_error "Link validation failed with $TOTAL_ERRORS error(s) and $TOTAL_WARNINGS warning(s)."
    echo ""
    log_info "Please fix the broken links above before proceeding."
    exit 1
fi
