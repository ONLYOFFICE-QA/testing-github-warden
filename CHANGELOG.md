# Changelog

## master (unreleased)

### New Features

* Add `markdownlint` checks to CI
* Add `rubocop` support
* Add `dependabot` config
* Add `.gitignore` file

### Changes

* Use GitHub Actions instead of TravisCI
* Sort alphabetically list of repos in default config

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
