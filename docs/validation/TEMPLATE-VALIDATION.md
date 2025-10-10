# Template Validation Guide

**Purpose:** Ensure consistent template usage and structure across all projects  
**Audience:** Developers, Project Managers, Documentation Maintainers  
**Last Updated:** 2025-01-20

---

## 🚀 Quick Start

### Run Template Validation

```bash
# Run locally
./scripts/validate-templates.sh

# Run in CI (automatically triggered)
# Template validation runs as part of the CI workflow for test branches
```

### What Gets Validated

1. **Template Files** - All required templates exist
2. **Template Structure** - Templates have required sections
3. **Project Compliance** - Projects follow template structure
4. **Template Consistency** - Status and priority indicators are consistent

---

## 📋 Prerequisites

### Required Templates

The following templates must exist in `admin/planning/notes/opportunities/external/administration/templates/`:

- `README-template.md` - Project hub template
- `feature-plan-template.md` - Feature planning template
- `phase-template.md` - Phase implementation template
- `ci-plan-template.md` - CI/CD planning template
- `status-and-next-steps-template.md` - Status tracking template
- `quick-start-template.md` - Quick start guide template

### Template Structure Requirements

Each template must have specific required sections:

#### README Template
- **Status:** [🔴 Not Started | 🟡 Planned | 🟠 In Progress | ✅ Complete | ❌ Cancelled]
- **Created:** [Date]
- **Last Updated:** [Date]
- **Priority:** [🔴 Critical | 🟠 High | 🟡 Medium | 🟢 Low]
- **## 📋 Quick Links** - Navigation section
- **## 🎯 Overview** - Project overview

#### Feature Plan Template
- **Status:** [Status indicators]
- **Created:** [Date]
- **Last Updated:** [Date]
- **Priority:** [Priority indicators]
- **Area:** [Frontend | Backend | Main | Infrastructure]
- **## 📋 Overview** - Feature overview
- **### Problem Statement** - What problem this solves
- **### Solution Approach** - How to solve it

#### Phase Template
- **Status:** [Status indicators]
- **Started:** [Date]
- **Completed:** [Date]
- **Duration:** [Estimated: X days | Actual: X days]
- **PR:** [PR number when available]
- **## 📋 Overview** - Phase overview
- **## 🎯 Success Criteria** - What success looks like
- **## 📅 Implementation Plan** - Detailed plan

#### CI Plan Template
- **Status:** [Status indicators]
- **Created:** [Date]
- **Last Updated:** [Date]
- **Priority:** [Priority indicators]
- **## 📋 Overview** - CI plan overview
- **### Problem Statement** - CI problem to solve
- **### Solution Approach** - CI solution approach

#### Status & Next Steps Template
- **Date:** [Date]
- **Status:** [Status indicators]
- **Next:** [Next milestone or phase]
- **## 📊 Current Status** - Current project status
- **## 🚀 Next Steps** - What's next

#### Quick Start Template
- **Purpose:** [How to get started with this project]
- **Audience:** [Users | Developers | Administrators]
- **Last Updated:** [Date]
- **## 🚀 Quick Start** - Getting started section
- **## 📖 Common Tasks** - Common usage patterns

---

## 🔧 Configuration

### Template Validation Script

The validation script (`scripts/validate-templates.sh`) performs the following checks:

1. **Template Existence** - Verifies all required templates exist
2. **Section Validation** - Checks for required sections in each template
3. **Project Compliance** - Validates projects follow template structure
4. **Consistency Checks** - Ensures status and priority indicators are consistent

### CI Integration

Template validation runs automatically in CI for branches that need testing:

```yaml
template-validation:
  runs-on: ubuntu-latest
  needs: [detect-branch-type]
  if: needs.detect-branch-type.outputs.needs-test == 'true'
  
  steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Run template validation
      run: |
        chmod +x scripts/validate-templates.sh
        ./scripts/validate-templates.sh
```

---

## 🧪 Testing

### Run Tests

```bash
# Test template validation locally
./scripts/validate-templates.sh

# Test with specific templates
grep -n "Status:" admin/planning/notes/opportunities/external/administration/templates/*.md
```

### Verify Installation

```bash
# Check script is executable
ls -la scripts/validate-templates.sh

# Check templates directory exists
ls -la admin/planning/notes/opportunities/external/administration/templates/
```

---

## 🆘 Troubleshooting

### Common Issues

#### Template Missing Required Section

**Error:** `❌ Missing section: Status: in template-name.md`

**Solution:** Add the missing section to the template file

```markdown
**Status:** [🔴 Not Started | 🟡 Planned | 🟠 In Progress | ✅ Complete | ❌ Cancelled]
```

#### Project Missing README

**Error:** `❌ Missing README.md in project-name`

**Solution:** Create a README.md file in the project directory using the README template

#### Inconsistent Status Indicators

**Warning:** `⚠ Status indicator not found: 🔴 Not Started`

**Solution:** Ensure all templates use the same status indicators:

- 🔴 Not Started
- 🟡 Planned
- 🟠 In Progress
- ✅ Complete
- ❌ Cancelled

#### Inconsistent Priority Indicators

**Warning:** `⚠ Priority indicator not found: 🔴 Critical`

**Solution:** Ensure all templates use the same priority indicators:

- 🔴 Critical
- 🟠 High
- 🟡 Medium
- 🟢 Low

### Debug Mode

To debug template validation issues:

```bash
# Run with verbose output
bash -x ./scripts/validate-templates.sh

# Check specific template
grep -n "Status:" admin/planning/notes/opportunities/external/administration/templates/README-template.md
```

---

## 📚 Next Steps

### Learn More

- [Hub-and-Spoke Documentation Best Practices](../../admin/planning/notes/opportunities/external/administration/hub-and-spoke-documentation-best-practices.md)
- [Template Directory](../../admin/planning/notes/opportunities/external/administration/templates/README.md)
- [CI Workflow Integration](../../admin/planning/ci/main/ci-workflow-integration/README.md)

### Get Help

- Check the validation script output for specific error messages
- Review template examples in existing projects
- Consult the template directory for reference implementations

---

## 🏷️ Tags

**Type:** Validation  
**Area:** Documentation  
**Priority:** Medium  
**Status:** Complete  
**Dependencies:** Template System, CI Workflow Integration

---

**Last Updated:** 2025-01-20  
**Status:** ✅ Complete  
**Next:** Continue with Phase 4 (Full Integration)
