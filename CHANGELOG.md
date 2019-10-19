
# Macroy
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to 
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0]
### Added
- Now with a Navbar!

### Changed
- Parse line in OrgFile read will now return a keyword with nothing, on no
  match.
- Changed CSS frame work from Milligram to Bulma.
- Improved look of OrgFile editing pages.
- Moved from an umbrella app to a mono one.

### Removed
- Antiquated back links.

## [0.1.0] - 2019-09-28
### Added
- Show specific OrgFile 
- Link to each specific OrgFile from index.
- Link from specific OrgFile to OrgFile index.
- Can add new orgfiles.
- Now ignores .org files.
- Link on front page to new OrgFile creation page.
- Error message now displayed on error in OrgFile creation.
- Navigational links for OrgFile CRUD.
- Edit/update capacity for OrgFiles.
- Installed Ex-Machina for creating test data.

### Changed
- Clicking on the banner now redirects you back to /.
- Moved orgfile functions from Todo.Task to Todo.OrgFiles
- Refactored OrgFile parsing for readability and maintance.

## [0.0.2] - 2019-09-09
### Added
- Added a header for the OrgFile index.

### Fixed
- Copy/paste Errors in CHANGELOG links.
- Removed stray '>' from OrgFile index.
- Fixed security vulnerabilites in webpack libraries.

## [0.0.1] - 2019-09-08
### Added
- Link from OrgFile index to home.
- Link from home to OrgFile index.

[Unreleased]: https://github.com/brotherjack/macroy/compare/v1.0.0...HEAD
[0.0.1]: https://github.com/brotherjack/macroy/releases/tag/v0.0.1
[0.0.2]: https://github.com/brotherjack/macroy/compare/v0.0.1...v0.0.2
[0.1.0]: https://github.com/brotherjack/macroy/compare/v0.0.2...v0.1.0
[1.0.0]: https://github.com/brotherjack/macroy/compare/v0.1.0....v1.0.0

