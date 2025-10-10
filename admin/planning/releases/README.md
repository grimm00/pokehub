# Release Management

This directory tracks Pokehub releases, including planning, checklists, and release notes.

## Structure

### Release Directories
Each release gets its own directory:
```
v1.0.0/
├── checklist.md      # Pre-release checklist
└── release-notes.md  # User-facing release notes
```

### Supporting Files
- `history.md` - Complete release history
- `README.md` - This file

## Release Process

### 1. Planning Phase
- Create `vX.Y.Z/` directory
- Copy checklist template
- Identify features and fixes

### 2. Development
- Track progress in checklist
- Update release notes as features complete
- Test thoroughly

### 3. Release
- Complete all checklist items
- Finalize release notes
- Tag release in git
- Update history.md

### 4. Post-Release
- Document lessons learned
- Archive release directory
- Plan next release

## Version Numbering

We follow [Semantic Versioning](https://semver.org/):
- **MAJOR** (X.0.0) - Breaking changes
- **MINOR** (0.X.0) - New features, backwards compatible
- **PATCH** (0.0.X) - Bug fixes, backwards compatible

## Current Status

- **Latest Release:** TBD
- **Next Release:** v1.0.0 (planned)

---

*This structure follows the proven pattern from dev-toolkit v0.2.0*
