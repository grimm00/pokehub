#!/bin/bash

# Project Index Generation Script
# Automatically generates comprehensive project documentation index

# Enable strict mode for better error handling
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
INDEX_OUTPUT_DIR="project-index"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo -e "${BLUE}📚 Project Index Generation${NC}"
echo "============================="

# Function to log info
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Function to log success
log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Create output directory
mkdir -p "$INDEX_OUTPUT_DIR"

log_info "Generating comprehensive project index..."

# 1. Generate Main Project Index
cat > "$INDEX_OUTPUT_DIR/PROJECT-INDEX.md" << 'EOF'
# Project Index

**Generated:** [TIMESTAMP]  
**Purpose:** Comprehensive overview of all projects, features, and documentation

---

## 📋 Quick Navigation

### By Area
- [Frontend Projects](#frontend-projects)
- [Backend Projects](#backend-projects)
- [Main/Cross-cutting Projects](#maincross-cutting-projects)

### By Type
- [Feature Projects](#feature-projects)
- [CI/CD Projects](#cicd-projects)
- [Release Projects](#release-projects)
- [Phase Projects](#phase-projects)

### By Status
- [Active Projects](#active-projects)
- [Completed Projects](#completed-projects)
- [Planned Projects](#planned-projects)

---

## 🎯 Project Overview

EOF

# Replace timestamp placeholder (CI-safe version)
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS sed
    sed -i.bak "s/\[TIMESTAMP\]/$TIMESTAMP/g" "$INDEX_OUTPUT_DIR/PROJECT-INDEX.md" && rm "$INDEX_OUTPUT_DIR/PROJECT-INDEX.md.bak"
else
    # Linux sed
    sed -i "s/\[TIMESTAMP\]/$TIMESTAMP/g" "$INDEX_OUTPUT_DIR/PROJECT-INDEX.md"
fi

# Add project sections to main index
cat >> "$INDEX_OUTPUT_DIR/PROJECT-INDEX.md" << 'EOF'

## Frontend Projects

See [frontend-projects.md](frontend-projects.md) for detailed frontend project information.

## Backend Projects

See [backend-projects.md](backend-projects.md) for detailed backend project information.

## Main/Cross-cutting Projects

See [main-projects.md](main-projects.md) for detailed main/cross-cutting project information.

## Feature Projects

Projects focused on new features and functionality.

## CI/CD Projects

See [ci-projects.md](ci-projects.md) for detailed CI/CD project information.

## Release Projects

Projects focused on releases and deployment.

## Phase Projects

Projects organized by development phases.

## Active Projects

Currently active development projects.

## Completed Projects

Successfully completed projects.

## Planned Projects

Projects planned for future development.

---

## 📊 Project Statistics

See [project-statistics.md](project-statistics.md) for detailed project statistics and metrics.

EOF

# 2. Generate Area-Specific Indexes
generate_area_index() {
 area="$1"
 area_dir="admin/planning/features/$area"
    
    if [ ! -d "$area_dir" ]; then
        return
    fi
    
    log_info "Generating index for $area area..."
    
    cat > "$INDEX_OUTPUT_DIR/${area}-projects.md" << EOF
# $area Projects

**Generated:** $TIMESTAMP  
**Area:** $area  
**Location:** admin/planning/features/$area

---

## 📋 Projects Overview

EOF

 project_count=0
    for project_dir in "$area_dir"/*/; do
        if [ -d "$project_dir" ]; then
 project_name=$(basename "$project_dir")
            ((project_count++))
            
            # Get project status from README if it exists
 status="Unknown"
            if [ -f "$project_dir/README.md" ]; then
                status=$(grep -E "^\*\*Status:\*\*" "$project_dir/README.md" | sed 's/.*\*\*Status:\*\* *//' | head -1 || echo "Unknown")
            fi
            
            # Get project priority from README if it exists
 priority="Unknown"
            if [ -f "$project_dir/README.md" ]; then
                priority=$(grep -E "^\*\*Priority:\*\*" "$project_dir/README.md" | sed 's/.*\*\*Priority:\*\* *//' | head -1 || echo "Unknown")
            fi
            
            cat >> "$INDEX_OUTPUT_DIR/${area}-projects.md" << EOF
### $project_name

- **Status:** $status
- **Priority:** $priority
- **Location:** \`admin/planning/features/$area/$project_name/\`
- **README:** [View]($project_dir/README.md)

EOF
        fi
    done
    
    if [ $project_count -eq 0 ]; then
        echo "No projects found in $area area." >> "$INDEX_OUTPUT_DIR/${area}-projects.md"
    else
        echo "**Total Projects:** $project_count" >> "$INDEX_OUTPUT_DIR/${area}-projects.md"
    fi
    
    log_success "Generated index for $area area ($project_count projects)"
}

# Generate indexes for each area
generate_area_index "frontend"
generate_area_index "backend"
generate_area_index "main"

# 3. Generate CI/CD Projects Index
log_info "Generating CI/CD projects index..."

cat > "$INDEX_OUTPUT_DIR/ci-projects.md" << EOF
# CI/CD Projects

**Generated:** $TIMESTAMP  
**Location:** admin/planning/ci

---

## 📋 CI/CD Projects Overview

EOF

if [ -d "admin/planning/ci" ]; then
    ci_count=0
    for project_dir in "admin/planning/ci"/*/; do
        if [ -d "$project_dir" ]; then
            project_name=$(basename "$project_dir")
            ((ci_count++))
            
 status="Unknown"
            if [ -f "$project_dir/README.md" ]; then
                status=$(grep -E "^\*\*Status:\*\*" "$project_dir/README.md" | sed 's/.*\*\*Status:\*\* *//' | head -1 || echo "Unknown")
            fi
            
            cat >> "$INDEX_OUTPUT_DIR/ci-projects.md" << EOF
### $project_name

- **Status:** $status
- **Location:** \`admin/planning/ci/$project_name/\`
- **README:** [View]($project_dir/README.md)

EOF
        fi
    done
    
    if [ $ci_count -eq 0 ]; then
        echo "No CI/CD projects found." >> "$INDEX_OUTPUT_DIR/ci-projects.md"
    else
        echo "**Total CI/CD Projects:** $ci_count" >> "$INDEX_OUTPUT_DIR/ci-projects.md"
    fi
    
    log_success "Generated CI/CD projects index ($ci_count projects)"
else
    echo "CI/CD planning directory not found." >> "$INDEX_OUTPUT_DIR/ci-projects.md"
fi

# 4. Generate Statistics Summary
log_info "Generating project statistics..."

cat > "$INDEX_OUTPUT_DIR/project-statistics.md" << EOF
# Project Statistics

**Generated:** $TIMESTAMP

---

## 📊 Overview

EOF

# Count projects by area
for area in "frontend" "backend" "main"; do
 count=0
    if [ -d "admin/planning/features/$area" ]; then
        for project_dir in "admin/planning/features/$area"/*/; do
            if [ -d "$project_dir" ]; then
                ((count++))
            fi
        done
    fi
    echo "- **$area Projects:** $count" >> "$INDEX_OUTPUT_DIR/project-statistics.md"
done

# Count CI projects
 ci_count=0
if [ -d "admin/planning/ci" ]; then
    for project_dir in "admin/planning/ci"/*/; do
        if [ -d "$project_dir" ]; then
            ((ci_count++))
        fi
    done
fi
echo "- **CI/CD Projects:** $ci_count" >> "$INDEX_OUTPUT_DIR/project-statistics.md"

# 5. Generate README for index directory
cat > "$INDEX_OUTPUT_DIR/README.md" << EOF
# Project Index Directory

**Generated:** $TIMESTAMP

This directory contains automatically generated project documentation indexes.

## 📋 Files

- **PROJECT-INDEX.md** - Main project index with navigation
- **frontend-projects.md** - Frontend area projects
- **backend-projects.md** - Backend area projects  
- **main-projects.md** - Main/Cross-cutting area projects
- **ci-projects.md** - CI/CD projects
- **project-statistics.md** - Project statistics and counts
- **README.md** - This file

## 🔄 Regeneration

To regenerate these indexes, run:

\`\`\`bash
./scripts/generate-project-index.sh
\`\`\`

## 📝 Notes

- Indexes are generated automatically from existing project documentation
- Project status and priority are extracted from README.md files
- Statistics are calculated from directory structure
- All timestamps reflect generation time

EOF

log_success "Project index generation completed!"
echo ""
log_info "Generated files:"
log_info "  - PROJECT-INDEX.md (main index)"
log_info "  - frontend-projects.md"
log_info "  - backend-projects.md" 
log_info "  - main-projects.md"
log_info "  - ci-projects.md"
log_info "  - project-statistics.md"
log_info "  - README.md"

echo ""
log_info "Project index generation completed successfully."
log_info "All project documentation has been indexed and organized."
