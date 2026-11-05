# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [7.0.1] - 2026-11-05

### Changed

- Adopt the plugin template's CI and release tooling: `npm run release:*` scripts and preflight, `DEVELOPMENT.md`, a `t/00-load.t` smoke test and the GitHub Actions workflow (regenerated from the template).
- Remove the legacy zip-based release tooling and committed build artefacts (`.DS_Store`, `Koha/.DS_Store`, `Koha/Plugin/.DS_Store`, `checkVersionNumber.js`, `koha-plugin-addbdscovers.kpz`, `release_kpz.sh`); KPZ files are now built by CI on release tags.
- Normalise the plugin version `7.0` to semantic version `7.0.0` (the same ordering under Perl `version` comparison) so the release tooling can bump it.

[Unreleased]: https://github.com/openfifth/koha-plugin-addBDSCovers/compare/v7.0.1...HEAD
[7.0.1]: https://github.com/openfifth/koha-plugin-addBDSCovers/compare/v7.0.0...v7.0.1