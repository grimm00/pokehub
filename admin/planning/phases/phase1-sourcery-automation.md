# Phase 1: Sourcery Automation

**Status**: 🚧 In Progress  
**Started**: October 5, 2025  
**Target Completion**: October 5, 2025 (same day)  
**Estimated Time**: ~4 hours  
**Branch**: `chore/add-sourcery-automation`

---

## 📋 Overview

Port mature Sourcery automation tools from **REPO-Magic** to **Pokehub** to eliminate manual Sourcery review processing. This will automate the tedious extraction and formatting of Sourcery code reviews while preserving manual priority assessment.

**Key Principle**: Automate extraction, not decision-making. Manual assessment is more thoughtful and context-aware.

---

## 🎯 Goals

1. **Automate Review Extraction**: Parse Sourcery reviews from GitHub PRs programmatically
2. **Generate Clean Templates**: Create structured markdown with priority matrix templates
3. **Streamline Workflow**: Integrate into Git Flow helper for easy access
4. **Maintain Quality**: Preserve manual assessment for priority/impact/effort decisions
5. **Comprehensive Documentation**: Clear guides for using the automation

---

## 🚀 Implementation Plan

### Phase 1.1: Core Infrastructure (30 minutes) ✅ COMPLETE
**Goal**: Establish foundation for Sourcery automation

- [x] Copy `github-utils.sh` from REPO-Magic to `scripts/core/`
- [x] Adapt repository references (grimm00/pokedex)
- [x] Test basic GitHub CLI integration
- [x] Verify color output and status printing functions
- [x] Validate with test commands

**Files**:
- `scripts/core/github-utils.sh` (new)

**Validation**:
```bash
source scripts/core/github-utils.sh
gh_init_github_utils
gh_print_header "Test Header"
gh_print_status "SUCCESS" "Test message"
```

---

### Phase 1.2: Sourcery Review Parser (1 hour)
**Goal**: Enable programmatic extraction of Sourcery reviews

- [ ] Copy `sourcery-review-parser.sh` from REPO-Magic to `scripts/monitoring/`
- [ ] Update script paths and imports for Pokehub structure
- [ ] Adapt for Pokehub's PR structure
- [ ] Test with recent PRs (#27, #28, #29, #30)
- [ ] Validate extracted data (location, type, description)
- [ ] Ensure priority matrix templates are clean and easy to fill

**Files**:
- `scripts/monitoring/sourcery-review-parser.sh` (new)

**Validation**:
```bash
# Test parser with recent PR
./scripts/monitoring/sourcery-review-parser.sh 28
./scripts/monitoring/sourcery-review-parser.sh 28 --output test-review.md
./scripts/monitoring/sourcery-review-parser.sh 28 --think
./scripts/monitoring/sourcery-review-parser.sh 28 --rich-details
```

---

### Phase 1.3: Manual Assessment Workflow (45 minutes)
**Goal**: Streamline manual priority assessment with better templates

- [ ] Enhance parser output for manual assessment
- [ ] Add helpful context (location, type, description)
- [ ] Create manual assessment workflow guide
- [ ] Document process for filling out priority matrix templates
- [ ] Create examples of completed assessments
- [ ] Add guidelines for priority/impact/effort decisions

**Files**:
- `admin/docs/guides/manual-assessment-workflow.md` (new)

**Note**: Intentionally **NOT** including automated priority scoring. Manual assessment is more thoughtful.

---

### Phase 1.4: Workflow Integration (1 hour)
**Goal**: Integrate Sourcery automation into Git Flow workflow

- [ ] Add `sourcery-parse` alias to workflow helper
- [ ] Add `sourcery-export` alias for exporting to docs
- [ ] Update workflow helper documentation
- [ ] Test aliases with real PRs
- [ ] Verify integration with existing Git Flow commands

**Files**:
- `scripts/workflow-helper.sh` (modify)
- `scripts/core/git-flow-utils.sh` (modify - add Sourcery functions)

**New Aliases**:
```bash
sourcery-parse [PR_NUMBER]     # Parse Sourcery review to markdown with template
sourcery-export [PR_NUMBER]    # Export parsed review to docs folder
```

---

### Phase 1.5: Documentation & Testing (1 hour)
**Goal**: Comprehensive documentation and validation

- [ ] Create `admin/docs/guides/sourcery-automation-guide.md`
- [ ] Document end-to-end workflow
- [ ] Add troubleshooting section
- [ ] Include examples from Pokehub PRs
- [ ] Update `admin/docs/sourcery-future-improvements.md` header
- [ ] Add note about automated parsing capability
- [ ] Document how to manually override automated priorities
- [ ] Test complete workflow with real PR

**Files**:
- `admin/docs/guides/sourcery-automation-guide.md` (new)
- `admin/docs/sourcery-future-improvements.md` (modify)

---

## 📦 Dependencies

### Required Tools
- ✅ GitHub CLI (`gh`) - Already installed and authenticated
- ✅ Bash 4.0+ - Available on macOS
- ✅ Python 3 - For JSON parsing
- ⚠️ `jq` - Optional, for advanced JSON processing
- ✅ Standard Unix tools - `grep`, `sed`, `awk`

### Repository Requirements
- ✅ Git Flow workflow established
- ✅ Workflow helper in place
- ✅ GitHub authentication configured
- ✅ Sourcery reviews enabled on PRs

---

## ✅ Success Criteria

### Functional Requirements
- [ ] Can extract Sourcery reviews from any Pokehub PR
- [ ] Can generate clean markdown with priority matrix templates
- [ ] Can export reviews to docs folder for manual assessment
- [ ] Integrated into Git Flow workflow helper
- [ ] Comprehensive documentation available
- [ ] Manual assessment workflow is clear and easy to follow

### Quality Requirements
- [ ] Scripts follow existing Pokehub conventions
- [ ] All scripts have error handling
- [ ] All scripts are tested with real PRs
- [ ] Documentation is clear and complete
- [ ] No breaking changes to existing workflows

### Performance Requirements
- [ ] Parser completes in < 5 seconds for typical PR
- [ ] No rate limiting issues with GitHub API

---

## 🧪 Testing Strategy

### Unit Testing
1. Test `github-utils.sh` functions individually
2. Test parser with various PR formats
3. Test workflow helper aliases

### Integration Testing
1. Test complete workflow: PR → Parse → Manual Assessment → Export
2. Test with recent PRs that have Sourcery reviews
3. Test error handling (missing reviews, invalid PR numbers)

### User Acceptance Testing
1. Verify templates are easy to fill out manually
2. Confirm workflow is faster than manual copy/paste
3. Validate documentation is clear and helpful

---

## ⚠️ Risks & Mitigation

### Risk: Sourcery review format changes
**Impact**: Medium  
**Mitigation**: Parser uses flexible regex patterns; document format assumptions

### Risk: GitHub API rate limiting
**Impact**: Low  
**Mitigation**: Use `gh` CLI which handles auth and rate limits

### Risk: Breaking existing workflows
**Impact**: High  
**Mitigation**: Add new commands only, don't modify existing ones; test thoroughly

---

## 📊 Progress Tracking

### Phase 1.1: Core Infrastructure
- [x] Started: October 5, 2025
- [x] Completed: October 5, 2025 ✅

### Phase 1.2: Review Parser
- [ ] Started: TBD
- [ ] Completed: TBD

### Phase 1.3: Manual Assessment Workflow
- [ ] Started: TBD
- [ ] Completed: TBD

### Phase 1.4: Workflow Integration
- [ ] Started: TBD
- [ ] Completed: TBD

### Phase 1.5: Documentation & Testing
- [ ] Started: TBD
- [ ] Completed: TBD

---

## 🔗 Related Documentation

- **Implementation Plan**: `admin/planning/sourcery-automation-plan.md`
- **Current Sourcery Tracking**: `admin/docs/sourcery-future-improvements.md`
- **Git Flow Helper**: `scripts/workflow-helper.sh`
- **REPO-Magic Source**: `/Users/cdwilson/Projects/Repo-Magic/scripts/monitoring/`

---

## 💡 Lessons Learned (Post-Completion)

*To be filled in after phase completion*

### What Worked Well
- TBD

### Challenges Encountered
- TBD

### Areas for Improvement
- TBD

---

## 📝 Status Updates

### October 5, 2025 - Phase Started
- Created phase plan
- Cleaned up admin directory structure
- Archived completed phases
- Ready to begin Phase 1.1: Core Infrastructure

### October 5, 2025 - Phase 1.1 Complete ✅
- Copied `github-utils.sh` from REPO-Magic
- Adapted for Pokehub (project name, repo, config file)
- Tested all core functions successfully
- Validated color output, status printing, configuration
- Time taken: ~20 minutes (faster than estimated 30 min)
- Ready to begin Phase 1.2: Review Parser

---

**Last Updated**: October 5, 2025  
**Next Milestone**: Complete Phase 1.2 (Review Parser)  
**Blockers**: None
