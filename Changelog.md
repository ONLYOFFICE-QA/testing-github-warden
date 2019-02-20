# Changelog
## [0.1.3] - 2019-02-20
### Fixed
    Change commit sorting to reverse because it is real action sorting
## [0.1.2] - 2019-02-05
### Fixed
    Error after merge
    Adding empty elements if action is "do nothing"
## [0.1.1] - 2019-02-07
### Changed
    New config file - allow branches. It need for perfoming actions only on special branches
    Actions will not be performed if bug contain comment with current commit hash
### Fixed
    Error if bugzilla is responsed 404 after getting comments
## [0.0.2] - 2019-01-25
### Changed
    All commits will compare afrer downcase
## [0.0.1] - 2019-01-14
### Changed
    - All actions is executed, if reg.exp. is matched
### Added
    - Changelog and version added