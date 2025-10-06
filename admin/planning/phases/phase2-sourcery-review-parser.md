# Phase 2: Sourcery Review Parser

**Status**: 🚧 In Progress  
**Started**: October 5, 2025  
**Target Completion**: October 5, 2025  
**Estimated Time**: 1 hour  
**Branch**: `chore/add-sourcery-automation`

---

## 📋 Overview

Port the Sourcery review parser from **REPO-Magic** to enable programmatic extraction of Sourcery code reviews from GitHub PRs. This automates the tedious manual copy/paste process while generating clean templates for manual priority assessment.

**Key Principle**: Automate extraction, not decision-making. The parser generates structured markdown with empty priority matrix templates for manual fill-in.

---

## 🎯 Goals

1. **Port Parser Script**: Copy and adapt `sourcery-review-parser.sh` from REPO-Magic
2. **Adapt for Pokehub**: Update paths, imports, and repository references
3. **Test with Real PRs**: Validate with recent Pokehub PRs that have Sourcery reviews
4. **Generate Clean Templates**: Ensure priority matrix templates are easy to fill manually
5. **Validate Output**: Confirm extracted data is accurate and well-formatted

---

## 🚀 Implementation Plan

### Task 1: Copy Parser Script
- [ ] Copy `sourcery-review-parser.sh` from REPO-Magic to `scripts/monitoring/`
- [ ] Make script executable
- [ ] Review script structure and dependencies

### Task 2: Adapt for Pokehub
- [ ] Update script header and description
- [ ] Update import path for `github-utils.sh`
- [ ] Update repository references
- [ ] Verify all paths are correct for Pokehub structure

### Task 3: Test with Recent PRs
- [ ] Identify recent PRs with Sourcery reviews (e.g., #27, #28, #29, #30)
- [ ] Test basic parsing: `./scripts/monitoring/sourcery-review-parser.sh [PR_NUMBER]`
- [ ] Test output to file: `--output review.md`
- [ ] Test think mode: `--think` (shows extraction reasoning)
- [ ] Test rich details: `--rich-details` (structured output)

### Task 4: Validate Output Quality
- [ ] Check extracted location data is accurate
- [ ] Verify issue type extraction
- [ ] Confirm description extraction
- [ ] Validate priority matrix template is clean and easy to fill
- [ ] Ensure markdown formatting is correct

### Task 5: Document Usage
- [ ] Add usage examples to script help
- [ ] Document command-line options
- [ ] Create quick reference for common use cases

---

## 📦 Dependencies

### Required
- ✅ Phase 1 complete (`github-utils.sh` available)
- ✅ GitHub CLI (`gh`) installed and authenticated
- ✅ Bash 4.0+ available
- ✅ Python 3 for JSON parsing

### Optional
- ⚠️ `jq` for advanced JSON processing (nice to have)

---

## ✅ Success Criteria

### Functional Requirements
- [ ] Parser successfully extracts Sourcery reviews from any Pokehub PR
- [ ] Generates clean, structured markdown output
- [ ] Priority matrix templates are empty and ready for manual fill-in
- [ ] All command-line options work correctly
- [ ] Output is accurate and well-formatted

### Quality Requirements
- [ ] Script follows Pokehub conventions
- [ ] Error handling for missing reviews, invalid PRs
- [ ] Clear error messages for common issues
- [ ] No breaking changes to existing workflows

### Validation Requirements
- [ ] Tested with at least 3 different PRs
- [ ] Validated against manual review (spot check)
- [ ] All extraction modes work (default, think, rich-details)

---

## 🧪 Testing Strategy

### Test Cases

#### Test Case 1: Basic Parsing
```bash
./scripts/monitoring/sourcery-review-parser.sh 28
```
**Expected**: Clean markdown output to console with priority matrix template

#### Test Case 2: Output to File
```bash
./scripts/monitoring/sourcery-review-parser.sh 28 --output test-review.md
```
**Expected**: File created with formatted review

#### Test Case 3: Think Mode
```bash
./scripts/monitoring/sourcery-review-parser.sh 28 --think
```
**Expected**: Includes reasoning about field extraction

#### Test Case 4: Rich Details
```bash
./scripts/monitoring/sourcery-review-parser.sh 28 --rich-details
```
**Expected**: Structured code context and suggestions

#### Test Case 5: No Details Mode
```bash
./scripts/monitoring/sourcery-review-parser.sh 28 --no-details
```
**Expected**: Compact output without full comment content

#### Test Case 6: Error Handling
```bash
./scripts/monitoring/sourcery-review-parser.sh 99999  # Invalid PR
./scripts/monitoring/sourcery-review-parser.sh 1      # PR without Sourcery review
```
**Expected**: Clear error messages, graceful failure

---

## ⚠️ Risks & Mitigation

### Risk: Sourcery review format changes
**Impact**: Medium  
**Mitigation**: Parser uses flexible regex patterns; document format assumptions  
**Fallback**: Can update parser if format changes

### Risk: PR doesn't have Sourcery review
**Impact**: Low  
**Mitigation**: Parser detects and reports missing reviews gracefully

### Risk: Extraction accuracy issues
**Impact**: Medium  
**Mitigation**: Validate with multiple PRs; compare with manual review

---

## 📊 Progress Tracking

- [ ] **Started**: October 5, 2025
- [ ] **Completed**: TBD
- **Estimated Time**: 1 hour
- **Actual Time**: TBD

### Milestones
- [ ] Script copied and adapted
- [ ] First successful parse
- [ ] All test cases passing
- [ ] Documentation complete

---

## 🔗 Related Documentation

- **Overall Plan**: `admin/planning/sourcery-automation-plan.md`
- **Previous Phase**: `phase1-core-infrastructure.md` ✅
- **Source**: REPO-Magic `/Users/cdwilson/Projects/Repo-Magic/scripts/monitoring/sourcery-review-parser.sh`
- **Next Phase**: Phase 3 - Manual Assessment Workflow (to be created)

---

## 💡 Lessons Learned

*To be filled in after phase completion*

### What Worked Well
- TBD

### Challenges Encountered
- TBD

### Key Takeaway
- TBD

---

## 📝 Status Updates

### October 5, 2025 - Phase Started
- Created phase plan
- Ready to copy parser script from REPO-Magic
- Phase 1 (Core Infrastructure) complete and available

---

**Last Updated**: October 5, 2025  
**Status**: 🚧 **IN PROGRESS**  
**Next Milestone**: Copy and adapt parser script  
**Blockers**: None
