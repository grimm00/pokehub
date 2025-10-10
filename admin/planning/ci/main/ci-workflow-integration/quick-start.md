# CI Workflow Integration - Quick Start

**Purpose:** How to implement CI workflow integration for hub-and-spoke documentation  
**Audience:** Developers, CI/CD Engineers  
**Last Updated:** 2025-01-20

---

## 🚀 Quick Start

### Prerequisites

- **GitHub Actions** - CI workflow execution
- **Shell scripting** - For validation scripts
- **Markdown tools** - For link validation
- **Hub-and-spoke system** - Documentation templates and structure

### Installation

```bash
# 1. Navigate to project root
cd /path/to/pokedex

# 2. Check current CI workflow
cat .github/workflows/ci.yml

# 3. Review hub-and-spoke templates
ls admin/planning/notes/opportunities/external/administration/templates/

# 4. Check existing project structure
find admin/planning -name "README.md" | head -10
```

### Basic Usage

```bash
# Test documentation validation locally
./scripts/validate-docs.sh

# Check CI workflow status
gh workflow list

# Run CI workflow manually
gh workflow run ci.yml

# Check CI results
gh run list --workflow=ci.yml
```

---

## 📖 Common Tasks

### Task 1: Add Documentation Validation

**Purpose:** Add documentation validation to existing CI workflow

```bash
# 1. Create validation script
cat > scripts/validate-docs.sh << 'EOF'
#!/bin/bash
set -euo pipefail

echo "🔍 Validating hub-and-spoke documentation structure..."

# Check for README.md hubs in new projects
if git diff --name-only HEAD~1 | grep -q "admin/planning/features/"; then
  echo "📋 New feature detected, validating structure..."
  
  for new_feature in $(git diff --name-only HEAD~1 | grep "admin/planning/features/" | cut -d'/' -f4 | sort -u); do
    if [ -f "admin/planning/features/$new_feature/README.md" ]; then
      echo "✅ $new_feature has README.md hub"
    else
      echo "❌ $new_feature missing README.md hub"
      exit 1
    fi
  done
fi

echo "✅ Documentation structure validation passed"
EOF

# 2. Make script executable
chmod +x scripts/validate-docs.sh

# 3. Test script
./scripts/validate-docs.sh
```

**Expected Output:**
```
🔍 Validating hub-and-spoke documentation structure...
✅ Documentation structure validation passed
```

---

### Task 2: Enhance Branch Detection

**Purpose:** Add area detection (frontend/backend/main) to branch detection

```bash
# 1. Create enhanced branch detection script
cat > scripts/detect-branch-type.sh << 'EOF'
#!/bin/bash
set -euo pipefail

BRANCH_NAME="${1:-$(git branch --show-current)}"

echo "🔍 Detecting branch type for: $BRANCH_NAME"

# Detect area from branch name
if [[ "$BRANCH_NAME" =~ ^feat/frontend/ ]]; then
  echo "area=frontend"
elif [[ "$BRANCH_NAME" =~ ^feat/backend/ ]]; then
  echo "area=backend"
elif [[ "$BRANCH_NAME" =~ ^feat/main/ ]]; then
  echo "area=main"
else
  echo "area=unknown"
fi

# Detect if templates need validation
if [[ "$BRANCH_NAME" =~ ^(feat|ci|docs)/ ]]; then
  echo "needs-templates=true"
else
  echo "needs-templates=false"
fi
EOF

# 2. Make script executable
chmod +x scripts/detect-branch-type.sh

# 3. Test script
./scripts/detect-branch-type.sh feat/frontend/new-feature
```

**Expected Output:**
```
🔍 Detecting branch type for: feat/frontend/new-feature
area=frontend
needs-templates=true
```

---

### Task 3: Validate Templates

**Purpose:** Check template consistency and completeness

```bash
# 1. Create template validation script
cat > scripts/validate-templates.sh << 'EOF'
#!/bin/bash
set -euo pipefail

echo "📋 Validating template consistency..."

TEMPLATES_DIR="admin/planning/notes/opportunities/external/administration/templates"

# Check that all templates have required sections
for template in README-template.md feature-plan-template.md ci-plan-template.md phase-template.md; do
  if grep -q "\[Project Name\]" "$TEMPLATES_DIR/$template"; then
    echo "✅ $template has placeholder structure"
  else
    echo "❌ $template missing placeholder structure"
    exit 1
  fi
done

# Check that all templates use consistent status indicators
for template in "$TEMPLATES_DIR"/*.md; do
  if grep -q "🔴 Not Started" "$template"; then
    echo "✅ $template has consistent status indicators"
  else
    echo "❌ $template missing status indicators"
    exit 1
  fi
done

echo "✅ Template validation passed"
EOF

# 2. Make script executable
chmod +x scripts/validate-templates.sh

# 3. Test script
./scripts/validate-templates.sh
```

**Expected Output:**
```
📋 Validating template consistency...
✅ README-template.md has placeholder structure
✅ feature-plan-template.md has placeholder structure
✅ ci-plan-template.md has placeholder structure
✅ phase-template.md has placeholder structure
✅ README-template.md has consistent status indicators
✅ feature-plan-template.md has consistent status indicators
✅ ci-plan-template.md has consistent status indicators
✅ phase-template.md has consistent status indicators
✅ Template validation passed
```

---

### Task 4: Generate Project Index

**Purpose:** Create automated project index for documentation

```bash
# 1. Create project index generation script
cat > scripts/generate-project-index.sh << 'EOF'
#!/bin/bash
set -euo pipefail

echo "📚 Generating project index..."

# Generate a comprehensive index of all projects
cat > admin/planning/PROJECT-INDEX.md << 'INDEX_EOF'
# Project Index

**Generated:** $(date)
**Purpose:** Central index of all projects using hub-and-spoke documentation

## Features

### Frontend
INDEX_EOF

# List all frontend features
find admin/planning/features/frontend -name "README.md" -exec basename $(dirname {}) \; | while read feature; do
  echo "- [$feature](features/frontend/$feature/README.md)" >> admin/planning/PROJECT-INDEX.md
done

echo "### Backend" >> admin/planning/PROJECT-INDEX.md

# List all backend features
find admin/planning/features/backend -name "README.md" -exec basename $(dirname {}) \; | while read feature; do
  echo "- [$feature](features/backend/$feature/README.md)" >> admin/planning/PROJECT-INDEX.md
done

echo "### Main" >> admin/planning/PROJECT-INDEX.md

# List all main features
find admin/planning/features/main -name "README.md" -exec basename $(dirname {}) \; | while read feature; do
  echo "- [$feature](features/main/$feature/README.md)" >> admin/planning/PROJECT-INDEX.md
done

echo "✅ Project index generated"
EOF

# 2. Make script executable
chmod +x scripts/generate-project-index.sh

# 3. Test script
./scripts/generate-project-index.sh

# 4. Check generated index
head -20 admin/planning/PROJECT-INDEX.md
```

**Expected Output:**
```
📚 Generating project index...
✅ Project index generated
```

---

## 🔧 Configuration

### Basic Configuration

Add documentation validation to existing CI workflow:

```yaml
# Add to .github/workflows/ci.yml
  docs-validation:
    runs-on: ubuntu-latest
    name: Validate Documentation Structure
    if: github.event_name == 'pull_request'
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      
    - name: Validate hub-and-spoke structure
      run: |
        chmod +x scripts/validate-docs.sh
        ./scripts/validate-docs.sh
```

### Advanced Configuration

Add comprehensive validation with branch detection:

```yaml
# Enhanced CI workflow
  detect-branch-type:
    runs-on: ubuntu-latest
    name: Detect Branch Type
    outputs:
      area: ${{ steps.detect.outputs.area }}
      needs-templates: ${{ steps.detect.outputs.needs-templates }}
    
    steps:
    - name: Detect branch type and requirements
      id: detect
      run: |
        chmod +x scripts/detect-branch-type.sh
        ./scripts/detect-branch-type.sh >> $GITHUB_OUTPUT

  docs-validation:
    runs-on: ubuntu-latest
    name: Validate Documentation Structure
    needs: [detect-branch-type]
    if: needs.detect-branch-type.outputs.needs-templates == 'true'
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      
    - name: Validate documentation
      run: |
        chmod +x scripts/validate-docs.sh
        ./scripts/validate-docs.sh
        
    - name: Validate templates
      run: |
        chmod +x scripts/validate-templates.sh
        ./scripts/validate-templates.sh
        
    - name: Generate project index
      run: |
        chmod +x scripts/generate-project-index.sh
        ./scripts/generate-project-index.sh
```

---

## 🧪 Testing

### Run Tests

```bash
# Test all validation scripts
./scripts/validate-docs.sh
./scripts/detect-branch-type.sh feat/frontend/test
./scripts/validate-templates.sh
./scripts/generate-project-index.sh

# Test CI workflow
gh workflow run ci.yml

# Check CI results
gh run list --workflow=ci.yml
```

### Verify Installation

```bash
# Check that all scripts are executable
ls -la scripts/validate-*.sh scripts/detect-*.sh scripts/generate-*.sh

# Check that CI workflow includes validation
grep -A 10 "docs-validation" .github/workflows/ci.yml

# Check that project index was generated
ls -la admin/planning/PROJECT-INDEX.md
```

---

## 🆘 Troubleshooting

### Common Issues

**Issue 1: Script Permission Denied**

**Problem:** Scripts are not executable

**Solution:** Make scripts executable

```bash
chmod +x scripts/validate-docs.sh
chmod +x scripts/detect-branch-type.sh
chmod +x scripts/validate-templates.sh
chmod +x scripts/generate-project-index.sh
```

---

**Issue 2: CI Workflow Not Running**

**Problem:** Documentation validation not running in CI

**Solution:** Check workflow configuration

```bash
# Check workflow file
cat .github/workflows/ci.yml | grep -A 5 "docs-validation"

# Check workflow status
gh workflow list

# Run workflow manually
gh workflow run ci.yml
```

---

**Issue 3: Template Validation Failing**

**Problem:** Templates don't pass validation

**Solution:** Check template structure

```bash
# Check template files exist
ls -la admin/planning/notes/opportunities/external/administration/templates/

# Check template content
grep -n "\[Project Name\]" admin/planning/notes/opportunities/external/administration/templates/*.md

# Run validation manually
./scripts/validate-templates.sh
```

---

## 📚 Next Steps

### Learn More

- [CI Plan](ci-plan.md) - Detailed implementation plan
- [Status & Next Steps](status-and-next-steps.md) - Current status and recommendations
- [Phase 1](phase-1.md) - Documentation validation implementation

### Get Help

- [Hub-and-Spoke Best Practices](../../notes/opportunities/external/administration/hub-and-spoke-documentation-best-practices.md) - Documentation system
- [Current CI Workflow](../../../../.github/workflows/ci.yml) - Existing workflow
- [Dev-toolkit CI](../../../../admin/planning/notes/opportunities/external/ci/ci.yml) - Advanced CI reference

---

## 🏷️ Tags

**Type:** Quick Start  
**Audience:** Developers, CI/CD Engineers  
**Difficulty:** Intermediate

---

**Last Updated:** 2025-01-20  
**Status:** Ready to Use
