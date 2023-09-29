<a name="unreleased"></a>
## [Unreleased]


<a name="0.0.1"></a>
## [0.0.1] - 2023-09-29
### Added
- migrate examples to null safety
- migrate to null safety
- update docs
- add tests
- add guard function
- upgrade sdk version
- upgrade freezed dependency
- add flutter_hooks example.
- add docs for state predicates
- updated examples
- removed empty, added stacktrace to error, added predicates
- more documentation to readme
- document public apis & hide constructors
- readme health, usage & maintainer sections
- example in packages/remote_state
- git-chglog configuration
- add script to prepare release
- add publish github action
- add code coverage
- add more tests & coverage
- add github action to build packages
- add bloc example
- add provider example

### Changed
- state notifier hook per suggestions.
- state notifier example
- add name to coverage step
- same text styles in examples
- simplify examples
- rename state notifier example to counter_state_notifier
- move remote_state into packages & example into examples
- remove android & ios generated files
- use StateNotifier instead of ValueNotifier

### Chore
- Renaming the package
- Upgrade deps and sdk, make predicates immutable
- bump version
- upgrade freezed deps
- version bump
- version bump
- update pubspec dart versions
- update dependencies

### Documented
- removed `empty` from docs

### Fixed
- update dependencies & workflow
- version bump
- get current version
- use cider to manage changelog
- meta not defined as dep
- remove insecure links
- added freezed_annotation back to deps
- readme example
- bad documentation
- add gitignore to packages/remote_state
- move changelog and add better package description
- space in publish.yml
- update working directory in github action

### Removed
- flutter dependency remote_state package

### BREAKING CHANGE

empty is no longer supported because it is not considered a valid remote state.


[Unreleased]: https://github.com/chimon2000/remote_state/compare/0.0.1...HEAD
