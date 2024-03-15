# Changelog

## master (unreleased)

### New Features

* Add `markdownlint` checks to CI
* Add `rubocop` support
* Add `dependabot` config
* Add `.gitignore` file
* Add `document-server-integration` repo
* Add `yamllint` check in CI
* Add dependabot check for base docker image updates
* Add support for GitLab's `HTTP_X_GITLAB_TOKEN` header
* Add config for AVS repos
* Add support for `simplecov` test coverage reports
* Add `dependabot` check for `GitHub Actions`

### Changes

* Major refactoring of Executioner, add new tests for it
* Use GitHub Actions instead of TravisCI
* Sort alphabetically list of repos in default config
* Log any error which happened during bug handling
* Major refactoring in handling `allowed_branches.yml`.
  New class `AllowedBranchesParser`
* Remove unused `Repository#check_name` method
* Minor refactoring in `Repository` class
* Add unit test for `Author`, `Commit`, `GithubResponceObjects`
  `Repository` classes
* Remove useless `Commit#timestamp` parsing
* Remove useless `GithubResponceObjects#compare` parsing
* Refactor `Dockerfile`'s placement
* Add more detailed log for checking is bug already commented
* Check `dependabot` at 8:00 Moscow time daily
* Changes from `rubocop-rspec` update to 2.9.0
* Use `alpine` as base image for executioner
* Minor refactoring in diagnostics
* Fix `rubocop-1.28.1` code issues
* Increase unit-test coverage
* Split tests on `unit` and `integration`
* Increase test coverage

### Fixes

* Fix endless loop if commit contains non-existing bug number
* Fix outdated version of `nodejs` in CI checks

## 0.1.3 (2019-02-20)

### Fixes

* Change commit sorting to reverse because it is real action sorting

## 0.1.2 (2019-02-05)

### Fixes

* Error after merge
* Adding empty elements if action is "do nothing"

## 0.1.1 (2019-02-07)

### Changes

* New config file - allow branches.
  It need for perfoming actions only on special branches
* Actions will not be performed if bug contain comment with current commit hash

### Fixes

* Error if bugzilla is responsed 404 after getting comments

## 0.0.2 (2019-01-25)

### Changes

* All commits will compare afrer downcase

## 0.0.1 (2019-01-14)

### New Features

* Changelog and version added

### Changes

* All actions is executed, if reg.exp. is matched
