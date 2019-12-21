# Macroy
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to 
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Can now actually delete todos.
- Now added links to each todo in the index to the todo show page.
- Added sobelow to check for security errors. This can be done by running 
  `mix sobelow`.

### Removed
- Depressing failure message on the front page.

## [1.4.2] - 2019-12-15
### Added
- `Macroy.delete_todo/1`.
- Font awesome 5.

### Changed
- Split up show todo template to allow for a modal card on todo delete with less
  code duplication.

### Fixed
- The broken links in this change log in the last two releases.
- Todo show no longer crashes when trying to load a todo file without an 
  associated org file.

## [1.4.1] - 2019-12-14
### Fixed
- Patched a security vulnerability with a javascript library.

## [1.4.0] - 2019-12-14
### Added
- Todo controller API for create/2, show/2, and new/2.
- `Macroy.get_todo/1`. 
- `Macroy.insert_todo/1`.
- `Macroy.new_todo/1` to allow for datetimes to be set in advance.
- A template for new todos.
- Documentation for `Todo.get_todo_fields_with_types/0`.
- Documentation for `Todo.get_todo_fields_and_timestamps/0`.
- Documentation for `Todo.get_todo_fields/0`.
- A CSRF token for Todo new form.
- `Macroy.update_todo/2` to change todo and provide for realtime validation.
- New todo form now provides realtime validation.
- `Macroy.get_user/1`.
- A show page for individual todos.

### Changed
- Index and new for todo were converted into Live Views.
- Todo index column headers are now sortable.
- Datetime fields on new todo can now be toggled.
- Datetime fields now start at today, and nil for closed_on, by default.
- Added joins and preloads so that `Macroy.get_todo/1` can display user and 
  orgfiles.

## [1.3.2] - 2019-12-02
### Added
- Todo rows in the index are now sortable by column.

### Changed
- Added stipes to todos table.

## [1.3.1] - 2019-12-01
### Added
- Installed Phoenix LiveView.

### Changed
- Converted Todo index to a Phoenix Live View.

### Fixed
- Spelling error with the Phoenix Live View signing salt.


## [1.3.0] - 2019-11-30
### Added
- An owner field in the Todo schema which links a todo to a user.
- A very basic template for Todo index.
- A view for Todos.
- A list todos API, (ie. Macroy.list_todos/1).
- A link in the navbar to Todo index.

### Changed
- `OrgFile.upload_sync/1` has been changed to `OrgFile.upload_sync/2` to 
  allow for the owner id to be inserted.

## [1.2.3] - 2019-11-28
### Fixed
- The flash messages have been reapired, closing out [issue #1](
  https://github.com/brotherjack/macroy/issues/1).

## [1.2.2] - 2019-11-24
### Added 
- Test coverage for MacroyWeb.OrgFileController.new/2.
- Header to sign in page. 
- Test coverage for MacroyWeb.OrgFileController.create/2.
- Every OrgFile must now be owned by a user.

### Changed
- `Macroy.list_org_files/0` ->  `Macroy.list_org_files/1` as index will no 
  longer show orgfiles owned by other users.

### Fixed
- "redirects to login if user not logged in" test for Macroy.OrgFile.new/2,
  as previous test used a matching operator in an assert, where an equality 
  comparison was necessary.

## [1.2.1] - 2019-11-19
### Added
- Test coverage on OrgFile.read/1 will check to see if `todo.is_done` is filled
  in based on whether `todo.closed_on` is found. 
- Test coverage on orgfile_controller.index/2 checks to see if index populates 
  the page with orgfiles in database, if the user is logged in.

### Changed
- OrgFile.read/1 will now check to see if `todo.is_done` is filled in based on
  whether `todo.closed_on` is found.

## [1.2.0] - 2019-11-18
### Added
- Format validation for orgfile path and filename fields.
- Testing components...finally!
- Testing coverage on "/user/new"
- Testing helper for getting flash messages.
- Test coverage on successful user creation.
- User controller now requires an email and a password.
- Test covers invalid email on user creation. 
- Test covers inserting new users.
- Added a testing mock for orgfiles.
- Added @type's for Todo and OrgFile.

### Changed
- Refactored flash messages.
- Content on "/user/new"
- Refactored user model and controller.
- Made `OrgFile.parse/5` private.
- Changed `OrgFile.prep_org_file_stream/1` to `OrgFile.prep_org_file_stream!/1`
  to reflect that the function uses `File.parse!/1`.
- Made `OrgFile.prep_org_file_stream!/1` public so that mock could be used.

### Fixed
- Naming error with `test/macroy_web` directory.
- Minor spelling error in flash message on successful user creation.

## [1.1.0] - 2019-11-11
### Added
- User authentication and login/logout functions.
- Navbar has proper links for login or logout depending on session status.
- Flash messages for logging in/out now 
work, and can be closed.
- Upload/sync functionality for orgfile bound todos.

### Fixed
- Update page for todos.
- Link to version 1.0.0 in this changelog.

### Removed
- All the unnecessary bulma SASS.

## [1.0.0] - 2019-10-19
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

[Unreleased]: https://github.com/brotherjack/macroy/compare/v1.4.2...HEAD
[0.0.1]: https://github.com/brotherjack/macroy/releases/tag/v0.0.1
[0.0.2]: https://github.com/brotherjack/macroy/compare/v0.0.1...v0.0.2
[0.1.0]: https://github.com/brotherjack/macroy/compare/v0.0.2...v0.1.0
[1.0.0]: https://github.com/brotherjack/macroy/compare/v0.1.0...v1.0.0
[1.1.0]: https://github.com/brotherjack/macroy/compare/v1.0.0...v1.1.0
[1.2.0]: https://github.com/brotherjack/macroy/compare/v1.1.0...v1.2.0
[1.2.1]: https://github.com/brotherjack/macroy/compare/v1.2.0...v1.2.1
[1.2.2]: https://github.com/brotherjack/macroy/compare/v1.2.1...v1.2.2
[1.2.3]: https://github.com/brotherjack/macroy/compare/v1.2.2...v1.2.3
[1.3.0]: https://github.com/brotherjack/macroy/compare/v1.2.3...v1.3.0
[1.3.1]: https://github.com/brotherjack/macroy/compare/v1.3.0...v1.3.1
[1.3.2]: https://github.com/brotherjack/macroy/compare/v1.3.1...v1.3.2
[1.4.0]: https://github.com/brotherjack/macroy/compare/v1.3.2...v1.4.0
[1.4.1]: https://github.com/brotherjack/macroy/compare/v1.4.0...v1.4.1
[1.4.2]: https://github.com/brotherjack/macroy/compare/v1.4.1...v1.4.2
