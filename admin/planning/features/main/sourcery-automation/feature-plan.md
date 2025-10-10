# Sourcery Automation Implementation Plan

**Branch**: `chore/add-sourcery-automation`  
**Created**: October 4, 2025  
**Status**: 🚧 **IN PROGRESS**

---

## 🎯 Objective

Port the mature Sourcery automation tools from **REPO-Magic** to **Pokehub** to eliminate manual Sourcery review processing and enable automated priority matrix analysis.

---

## 📋 Current State Analysis

### REPO-Magic (Source)
✅ **Production-ready monitoring scripts**:
- `scripts/monitoring/sourcery-review-parser.sh` - Extracts Sourcery reviews programmatically
- `scripts/monitoring/sourcery-priority-matrix.sh` - Automated priority analysis
- `scripts/monitoring/pr-feedback.sh` - PR feedback handling
- `scripts/monitoring/project-status.sh` - Project status monitoring
- `scripts/core/github-utils.sh` - Shared GitHub utilities

✅ **Comprehensive documentation**:
- `docs/reference/sourcery-review-parser.md` - Parser documentation
- `docs/reference/sourcery-priority-matrix.md` - Priority matrix guide
- `docs/feedback/sourcery-reviews-pr*.md` - Example outputs

### Pokehub (Target)
⚠️ **Basic monitoring scripts**:
- `scripts/monitoring/automated-status-check.sh` - Health checks (backend/frontend/data)
- `scripts/monitoring/verify-project-status.sh` - Manual verification
- `scripts/monitoring/weekly-status-review.sh` - Manual review process

❌ **Manual Sourcery workflow**:
- Currently manually copying Sourcery feedback from GitHub PRs
- Manually updating `admin/docs/sourcery-future-improvements.md`
- No structured review extraction
- Manual priority assessment (which we want to keep!)

✅ **What we want to automate**:
- Extract Sourcery reviews programmatically
- Generate clean markdown with priority matrix templates
- Export to docs folder for manual assessment

❌ **What we DON'T want to automate**:
- Priority/impact/effort scoring (manual is more thoughtful)
- Automated recommendations (context matters)

---

## 🚀 Implementation Plan

### Phase 1: Core Infrastructure Setup
**Goal**: Establish foundation for Sourcery automation

#### Task 1.1: Port GitHub Utilities
- [ ] Copy `scripts/core/github-utils.sh` from REPO-Magic
- [ ] Adapt for Pokehub repository structure
- [ ] Update repository references (grimm00/pokedex or grimm00/pokehub)
- [ ] Test basic GitHub CLI integration
- [ ] Verify color output and status printing functions

**Files to create/modify**:
- `scripts/core/github-utils.sh` (new)

**Dependencies**:
- GitHub CLI (`gh`) must be installed and authenticated
- Bash 4.0+ for array handling

**Validation**:
```bash
# Test GitHub utilities
source scripts/core/github-utils.sh
gh_init_github_utils
gh_print_header "Test Header"
gh_print_status "SUCCESS" "Test message"
```

---

### Phase 2: Sourcery Review Parser
**Goal**: Enable programmatic extraction of Sourcery reviews

#### Task 2.1: Port Review Parser Script
- [ ] Copy `scripts/monitoring/sourcery-review-parser.sh` from REPO-Magic
- [ ] Update script paths and imports
- [ ] Adapt for Pokehub's PR structure
- [ ] Test with recent Pokehub PRs that have Sourcery reviews

#### Task 2.2: Test Parser with Historical PRs
- [ ] Identify recent PRs with Sourcery reviews (e.g., PR #27, #28)
- [ ] Run parser against each PR
- [ ] Validate extracted data (location, type, description)
- [ ] Compare with manual review to ensure accuracy

#### Task 2.3: Create Parser Documentation
- [ ] Port `docs/reference/sourcery-review-parser.md` from REPO-Magic
- [ ] Adapt examples for Pokehub
- [ ] Add Pokehub-specific usage examples
- [ ] Document integration with existing workflow

**Files to create/modify**:
- `scripts/monitoring/sourcery-review-parser.sh` (new)
- `admin/docs/guides/sourcery-review-parser.md` (new)

**Validation**:
```bash
# Test parser with recent PR
./scripts/monitoring/sourcery-review-parser.sh 28
./scripts/monitoring/sourcery-review-parser.sh 28 --output test-review.md
./scripts/monitoring/sourcery-review-parser.sh 28 --think
./scripts/monitoring/sourcery-review-parser.sh 28 --rich-details
```

---

### Phase 3: Manual Assessment Workflow (SIMPLIFIED)
**Goal**: Streamline manual priority assessment with better templates

> **Note**: Automated priority scoring is intentionally **NOT** included. Manual assessment is more thoughtful and context-aware. We only automate the extraction and template generation.

#### Task 3.1: Enhance Parser Output for Manual Assessment
- [ ] Ensure parser generates clean priority matrix templates
- [ ] Add helpful context for manual assessment (location, type, description)
- [ ] Test template quality with recent PRs
- [ ] Validate that templates are easy to fill out manually

#### Task 3.2: Create Manual Assessment Workflow
- [ ] Document process for filling out priority matrix templates
- [ ] Create examples of completed assessments
- [ ] Add guidelines for priority/impact/effort decisions
- [ ] Test workflow with real Sourcery reviews

#### Task 3.3: Integration with Existing Tracking
- [ ] Review current `admin/docs/sourcery-future-improvements.md` structure
- [ ] Document how to transfer manual assessments to tracking doc
- [ ] Create workflow for archiving completed assessments
- [ ] Test integration with existing recommendations

**Files to create/modify**:
- `scripts/monitoring/sourcery-review-parser.sh` (already in Phase 2)
- `admin/docs/guides/manual-assessment-workflow.md` (new)

**Validation**:
```bash
# Parser should generate clean templates for manual assessment
./scripts/monitoring/sourcery-review-parser.sh 28 --output review.md
# Then manually fill out the priority matrix in review.md
```

**Intentionally Excluded**:
- ❌ `sourcery-priority-matrix.sh` - Automated scoring not needed
- ❌ Automated priority/impact/effort assignment
- ❌ Automated recommendation generation

---

### Phase 4: Workflow Integration
**Goal**: Integrate Sourcery automation into Git Flow workflow

#### Task 4.1: Add Sourcery Commands to Workflow Helper
- [ ] Add `sourcery-parse` alias to workflow helper (extract review to markdown)
- [ ] Add `sourcery-export` for exporting to docs folder
- [ ] Update workflow helper documentation
- [ ] **Note**: No `sourcery-analyze` - manual assessment only

#### Task 4.2: Create Automated PR Review Workflow
- [ ] Create script to automatically parse Sourcery reviews on PR creation
- [ ] Integrate with Git Flow cleanup process
- [ ] Add option to auto-export to `admin/docs/sourcery-future-improvements.md`
- [ ] Test with new PR creation

#### Task 4.3: Update Git Flow Documentation
- [ ] Document new Sourcery automation commands
- [ ] Add Sourcery workflow to `CONTRIBUTING.md`
- [ ] Update `README.md` with Sourcery automation section
- [ ] Create quick reference guide

**Files to create/modify**:
- `scripts/workflow-helper.sh` (modify)
- `scripts/core/git-flow-utils.sh` (modify - add Sourcery functions)
- `CONTRIBUTING.md` (modify)
- `README.md` (modify)

**New aliases**:
```bash
# Proposed workflow helper aliases
sourcery-parse [PR_NUMBER]     # Parse Sourcery review to markdown with template
sourcery-export [PR_NUMBER]    # Export parsed review to docs folder
# Note: No sourcery-analyze - manual assessment is intentional
```

---

### Phase 5: Documentation & Testing
**Goal**: Comprehensive documentation and validation

#### Task 5.1: Create Comprehensive Guide
- [ ] Create `admin/docs/guides/sourcery-automation-guide.md`
- [ ] Document end-to-end workflow
- [ ] Add troubleshooting section
- [ ] Include examples from Pokehub PRs

#### Task 5.2: Update Existing Documentation
- [ ] Update `admin/docs/sourcery-future-improvements.md` header
- [ ] Add note about automated parsing capability
- [ ] Document how to manually override automated priorities
- [ ] Add link to automation guide

#### Task 5.3: Test Complete Workflow
- [ ] Create test PR with intentional Sourcery issues
- [ ] Run complete automation workflow
- [ ] Validate all outputs
- [ ] Document any issues or improvements

**Files to create/modify**:
- `admin/docs/guides/sourcery-automation-guide.md` (new)
- `admin/docs/sourcery-future-improvements.md` (modify)

---

### Phase 6: Optional Enhancements
**Goal**: Advanced features for future consideration

#### Task 6.1: PR Feedback Automation (Optional)
- [ ] Port `scripts/monitoring/pr-feedback.sh` if needed
- [ ] Integrate with PR review process
- [ ] Test feedback collection

#### Task 6.2: Project Status Integration (Optional)
- [ ] Port `scripts/monitoring/project-status.sh` if needed
- [ ] Integrate with existing status dashboard
- [ ] Add Sourcery metrics to project status

#### Task 6.3: CI/CD Integration (Optional)
- [ ] Add Sourcery parsing to CI/CD workflow
- [ ] Automatically comment on PRs with priority analysis
- [ ] Create GitHub Action for Sourcery automation

---

## 📊 Success Criteria

### Functional Requirements
- ✅ Can extract Sourcery reviews from any Pokehub PR
- ✅ Can generate clean markdown with priority matrix templates
- ✅ Can export reviews to docs folder for manual assessment
- ✅ Integrated into Git Flow workflow helper
- ✅ Comprehensive documentation available
- ✅ Manual assessment workflow is clear and easy to follow

### Quality Requirements
- ✅ Scripts follow existing Pokehub conventions
- ✅ All scripts have error handling
- ✅ All scripts are tested with real PRs
- ✅ Documentation is clear and complete
- ✅ No breaking changes to existing workflows

### Performance Requirements
- ✅ Parser completes in < 5 seconds for typical PR
- ✅ Priority matrix analysis completes in < 10 seconds
- ✅ No rate limiting issues with GitHub API

---

## 🎯 Implementation Order

**Recommended sequence**:
1. **Phase 1** (Core Infrastructure) - Foundation for everything else
2. **Phase 2** (Review Parser) - Most immediate value
3. **Phase 3** (Priority Matrix) - Builds on parser
4. **Phase 4** (Workflow Integration) - Makes it easy to use
5. **Phase 5** (Documentation) - Ensures maintainability
6. **Phase 6** (Enhancements) - Future improvements

**Estimated Timeline**:
- Phase 1: 30 minutes (Core Infrastructure)
- Phase 2: 1 hour (Review Parser)
- Phase 3: 45 minutes (Manual Assessment Workflow - simplified, no automation)
- Phase 4: 1 hour (Workflow Integration - simplified, no analyze command)
- Phase 5: 1 hour (Documentation & Testing)
- **Total**: ~4 hours (reduced from 5 hours due to simplified scope)

---

## 🔧 Dependencies

### Required Tools
- ✅ GitHub CLI (`gh`) - Already installed
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

## 📝 Notes

### Key Differences Between REPO-Magic and Pokehub
1. **Repository names**: REPO-Magic vs. Pokehub (pokedex)
2. **Project structure**: REPO-Magic is a mod manager, Pokehub is a web app
3. **Existing monitoring**: Pokehub has basic health checks, REPO-Magic has full suite
4. **Documentation location**: REPO-Magic uses `docs/`, Pokehub uses `admin/docs/`

### Adaptation Strategy
- Keep core logic identical where possible
- Adapt paths and repository references
- Maintain consistency with existing Pokehub conventions
- Preserve REPO-Magic's proven patterns

### Future Considerations
- Could this become a shared library between projects?
- Should we create a standalone `sourcery-automation` package?
- How to keep REPO-Magic and Pokehub scripts in sync?

---

## 🚀 Getting Started

To begin implementation:

```bash
# Ensure you're on the correct branch
git checkout chore/add-sourcery-automation

# Start with Phase 1
cd /Users/cdwilson/Projects/pokedex
mkdir -p scripts/core

# Copy github-utils.sh from REPO-Magic
cp /Users/cdwilson/Projects/Repo-Magic/scripts/core/github-utils.sh scripts/core/

# Begin adaptation...
```

---

**Last Updated**: October 4, 2025  
**Status**: Ready to begin Phase 1  
**Next Action**: Port `github-utils.sh` from REPO-Magic
