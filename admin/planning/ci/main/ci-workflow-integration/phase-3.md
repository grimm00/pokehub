# Phase 3: Template Validation

**Status:** 🟡 Planned  
**Started:** [Date]  
**Completed:** [Date]  
**Duration:** [Estimated: 1 day | Actual: X days]  
**PR:** [PR number when available]

---

## 📋 Overview

Add template validation to ensure all projects use consistent, complete templates with required sections and proper structure.

### Phase Goals

1. **Create Template Validation** - Validate template consistency and completeness
2. **Check Required Sections** - Ensure all templates have required sections
3. **Enforce Template Compliance** - Prevent non-compliant projects
4. **Test Template Validation** - Ensure validation works with existing templates

### Success Definition

A CI workflow that automatically validates template consistency, ensures all projects use complete templates, and prevents non-compliant projects from being merged.

---

## 🎯 Success Criteria

- [ ] Template validation catches inconsistencies
- [ ] All templates pass validation
- [ ] Template compliance is enforced in CI
- [ ] Validation works with existing templates
- [ ] Template validation provides clear feedback

**Progress:** 0/5 complete (0%)

---

## 📅 Implementation Plan

### Day 1: Template Validation Implementation [Status]

**Status:** 🟡 Planned  
**Duration:** 1 day

**Goals:**
- Create template validation script
- Add template validation to CI workflow
- Test template validation with existing templates

**Tasks:**
- [ ] Create `scripts/validate-templates.sh` script
- [ ] Add template validation to CI workflow
- [ ] Test with existing templates
- [ ] Document template validation requirements

**Deliverables:**
- Template validation script
- Enhanced CI workflow
- Test results for template validation

**Success Criteria:**
- [ ] Script validates template consistency
- [ ] Script checks required sections
- [ ] CI workflow includes template validation

**Result:** [Summary of what was achieved]

---

## 🔧 Technical Implementation

### Architecture Changes

Add template validation as part of the documentation validation process.

### New Components

1. **Template Validation Script** - Validates template consistency and completeness
2. **Template Compliance Checking** - Ensures projects follow template structure
3. **Template Requirements** - Defines required sections and structure

### Modified Components

1. **ci.yml** - Add template validation to docs-validation job
2. **Validation Scripts** - Integrate template validation with documentation validation

### Dependencies

- [ ] **Phase 1** - Documentation validation foundation
- [ ] **Hub-and-spoke templates** - Templates to validate
- [ ] **Template requirements** - Required sections and structure

---

## 🧪 Testing Strategy

### Unit Tests

- [ ] Test template validation with consistent templates
- [ ] Test template validation with inconsistent templates
- [ ] Test template validation with missing sections
- [ ] Test template validation with extra sections

### Integration Tests

- [ ] Test CI workflow with template validation
- [ ] Test template validation with existing projects
- [ ] Test template validation with new projects
- [ ] Test template validation with mixed projects

### End-to-End Tests

- [ ] Create test PR with inconsistent templates
- [ ] Verify CI catches template issues
- [ ] Create test PR with consistent templates
- [ ] Verify CI passes template validation

### Performance Tests

- [ ] Measure CI execution time with template validation
- [ ] Ensure template validation doesn't slow CI
- [ ] Test template validation with large number of templates

---

## 📊 Metrics & Results

### Template Validation - TARGET vs ACTUAL

**Target:**
- Template consistency: 100%
- Template compliance: 100%
- Validation coverage: 100%

**Actual Results:**
- ✅ Template consistency: [Actual value]
- ✅ Template compliance: [Actual value]
- ✅ Validation coverage: [Actual value]

### Performance Impact

**Before Phase:**
- CI execution time: [Before value]
- Template validation: [Before value]

**After Phase:**
- CI execution time: [After value]
- Template validation: [After value]

**Change:**
- CI execution time: [Change description]
- Template validation: [Change description]

---

## 🎊 Key Achievements

1. **Template Consistency Enforcement** - All projects use consistent templates
2. **Template Compliance Checking** - Ensures projects follow template structure
3. **Automated Template Validation** - CI automatically validates template usage
4. **Clear Template Requirements** - Well-defined template structure and requirements

---

## 🚧 Challenges & Solutions

### Challenge 1: Template Evolution

**Problem:** Templates might evolve over time, breaking existing validation

**Solution:** Version templates and provide migration paths for existing projects

**Lessons Learned:** Template versioning is important for long-term maintenance

---

### Challenge 2: Template Flexibility

**Problem:** Strict template validation might prevent legitimate customization

**Solution:** Allow optional sections and provide clear guidelines for customization

**Lessons Learned:** Balance consistency with flexibility

---

## 🚀 Next Steps

### Immediate (Next Phase)

1. Implement Phase 4 (Full Integration)
2. Integrate all validation jobs
3. Add project index generation

### Short-term (Next Sprint)

1. Monitor template validation effectiveness
2. Gather feedback on template requirements
3. Optimize template validation performance

### Long-term (Future Phases)

1. Add template versioning
2. Add template migration tools
3. Expand template validation features

---

## 📚 Related Documents

### Planning
- [README](../README.md) - Project overview
- [CI Plan](ci-plan.md) - Overall plan
- [Status & Next Steps](status-and-next-steps.md) - Current status

### Implementation
- [Phase 2](phase-2.md) - Branch detection enhancement
- [Phase 4](phase-4.md) - Full integration
- [Quick Start](quick-start.md) - Implementation guide

### External
- [Hub-and-Spoke Templates](../../../notes/opportunities/external/administration/templates/README.md) - Templates to validate
- [Template Requirements](../../../notes/opportunities/external/administration/hub-and-spoke-documentation-best-practices.md) - Template standards

---

## 🏷️ Tags

**Type:** Phase  
**Area:** Main  
**Priority:** Medium  
**Status:** Planned  
**Dependencies:** Phase 1 (Documentation Validation), Phase 2 (Branch Detection Enhancement)

---

**Last Updated:** 2025-01-20  
**Status:** 🟡 Planned  
**Next:** Create template validation script and test with existing templates
