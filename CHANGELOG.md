# Changelog

All notable changes to this project will be documented in this file.

## [0.4.1](https://github.com/Bli-AIk/kristal-i18n/compare/v0.4.0...v0.4.1) (2026-08-13)


### chore

* force release 0.4.1 ([3d3dbe7](https://github.com/Bli-AIk/kristal-i18n/commit/3d3dbe7b5a5792503eb31f24b1bf777a15b47988))


### Features

* apply startup language from launch args ([7acde54](https://github.com/Bli-AIk/kristal-i18n/commit/7acde54a99001bf61a1b5c0ed37f56bc180dff94))
* apply startup name language from launch args ([cddb190](https://github.com/Bli-AIk/kristal-i18n/commit/cddb1908d82ee3e0fb8ec341dc02c91c17ae7966))
* **cjk:** halve CJK spacing for party titles and descriptions ([c041f8b](https://github.com/Bli-AIk/kristal-i18n/commit/c041f8bba7bf4e9328e74e4a487d77af58d83c9e))
* detect system language via SDL FFI ([e81a4a1](https://github.com/Bli-AIk/kristal-i18n/commit/e81a4a183fc0d2dcbcc47384d9e56863f0f4174e))
* **i18n:** translate power menu joke stats ([5c699d5](https://github.com/Bli-AIk/kristal-i18n/commit/5c699d5b678c12fa1feb40bdd8d1da31031f6556))


### Bug Fixes

* **i18n:** add per-chapter party titles and ACT description ([42c5ea7](https://github.com/Bli-AIk/kristal-i18n/commit/42c5ea76dcaf6d4c81b03d8696b1c82b6b67170f))
* **save:** keep persisted room names ASCII-safe for the main menu ([c57dc31](https://github.com/Bli-AIk/kristal-i18n/commit/c57dc31c8bb13e64654acf22e2eaf5c8d2e25603))

## [0.4.0](https://github.com/Bli-AIk/kristal-i18n/compare/v0.3.3...v0.4.0) (2026-08-11)

### Features

- localize item battle text ([84398fb](https://github.com/Bli-AIk/kristal-i18n/commit/84398fbf6eac8e822d4f50903b33ac95b0f7b8dc))

### Bug Fixes

- simplify missing text errors ([9a172af](https://github.com/Bli-AIk/kristal-i18n/commit/9a172af5d16e41a09e122007d33da18fd1f4abfa))

### Code Refactoring

- make item battle names optional ([7d4482a](https://github.com/Bli-AIk/kristal-i18n/commit/7d4482a281505c1027cf46ad3545677db2dc0a8d))
- replace raw text localization keys ([c924c5a](https://github.com/Bli-AIk/kristal-i18n/commit/c924c5a11a9cb4ff5c66287b492219df6271a747))
- split lib.lua into modules ([6113d93](https://github.com/Bli-AIk/kristal-i18n/commit/6113d9324b66b7576533a8608500d97afc6d90ac))

## [0.3.3](https://github.com/Bli-AIk/kristal-i18n/compare/v0.3.2...v0.3.3) (2026-08-09)

### Bug Fixes

- localize shop item descriptions ([7d13258](https://github.com/Bli-AIk/kristal-i18n/commit/7d13258a21f13e255b48ae7f3245914e4cd6b982))

## [0.3.2](https://github.com/Bli-AIk/kristal-i18n/compare/v0.3.1...v0.3.2) (2026-08-09)

### chore

- force release 0.3.2 ([25cf3e0](https://github.com/Bli-AIk/kristal-i18n/commit/25cf3e04f8637db354500b1878852029eb3dbe2d))

### Features

- localize debug item menu and item text ([27d3ba8](https://github.com/Bli-AIk/kristal-i18n/commit/27d3ba839efd125ba398afdbce2afa8b7f5e8250))

### Bug Fixes

- complete item reaction translations ([2e97b88](https://github.com/Bli-AIk/kristal-i18n/commit/2e97b88f259e1d31c951adf7551f6709c616786a))
- handle CJK wrap punctuation by codepoint ([a622046](https://github.com/Bli-AIk/kristal-i18n/commit/a622046a21c491276844ebaa2ed850f9ad02e51b))
- localize tea reaction and equipment tags ([aacc358](https://github.com/Bli-AIk/kristal-i18n/commit/aacc35808860ffb2a833689e3ab03df16ffda41f))

## [0.3.1](https://github.com/Bli-AIk/kristal-i18n/compare/v0.3.0...v0.3.1) (2026-08-08)

### chore

- force release 0.3.1 ([e2ec07c](https://github.com/Bli-AIk/kristal-i18n/commit/e2ec07cb59672a925a30ecbfea9a348a2f75b6ca))

### Features

- **i18n:** map/tileset texture variants (refreshLocalizedTilesets, lang/ probe hardening, RC2 base-id fix) ([b12da82](https://github.com/Bli-AIk/kristal-i18n/commit/b12da82ab67a3397bcba01f1199e4e80640671c4))

### Bug Fixes

- **i18n:** name language player choice no longer clobbered by config default ([ef7b938](https://github.com/Bli-AIk/kristal-i18n/commit/ef7b93847630d662a105dc92af1c936b2c80a0f5))
- **i18n:** re-evaluate name language at postInit; config defaultNameLanguage takes precedence ([e7d8a5d](https://github.com/Bli-AIk/kristal-i18n/commit/e7d8a5d12f3a67d91fb45ae15a63ca2c855dbaf5))

## [0.3.0](https://github.com/Bli-AIk/kristal-i18n/compare/v0.2.0...v0.3.0) (2026-08-08)

### Features

- **i18n:** raw-string lookup with per-line fallback, CJK wrap, bonus names +7, framework light/dark item keys ([82e8312](https://github.com/Bli-AIk/kristal-i18n/commit/82e8312f096dab9090bba2e6162787da8be3f0d0))

### Bug Fixes

- **i18n:** remove misspelled 'raisel' name entry ([786ecf8](https://github.com/Bli-AIk/kristal-i18n/commit/786ecf8fbffcc038227a43c3653a99ae8063c587))

## [0.2.0](https://github.com/Bli-AIk/kristal-i18n/compare/v0.1.1...v0.2.0) (2026-08-05)

### Features

- **i18n:** add {id} string interpolation syntax ([04080f6](https://github.com/Bli-AIk/kristal-i18n/commit/04080f6df41f579d234b4029930422e13272760f))
- **i18n:** make CJK typesetting and language toggle configurable ([1f33fc0](https://github.com/Bli-AIk/kristal-i18n/commit/1f33fc001828b755078d77025e63be527f75cd7f))

### Bug Fixes

- make localization ids authoritative ([d2b0fcc](https://github.com/Bli-AIk/kristal-i18n/commit/d2b0fcc97095cfb690120243f1a7bc34c883b62b))

### Code Refactoring

- **i18n:** remove loc_id/loc/langAvalable legacy aliases ([08d63fe](https://github.com/Bli-AIk/kristal-i18n/commit/08d63fef5faed19d6b5bc71692e8270cb1707a70))

## [0.1.1](https://github.com/Bli-AIk/kristal-i18n/compare/v0.1.0...v0.1.1) (2026-08-03)

### Bug Fixes

- **i18n:** increase light world UI text spacing ([989d860](https://github.com/Bli-AIk/kristal-i18n/commit/989d860eeb8780e8d1abfc67a69fcbe591ab6e44))
- **i18n:** localize light world item text ([0a92f07](https://github.com/Bli-AIk/kristal-i18n/commit/0a92f077bf93148537d2a7b1afe6b421a2cea2e7))
- **i18n:** localize spare and tired battle text ([f83a579](https://github.com/Bli-AIk/kristal-i18n/commit/f83a579053053fdf900c1e1b68b864fb6faca530))
- use Chinese font for battle speech bubbles ([95ebeba](https://github.com/Bli-AIk/kristal-i18n/commit/95ebebaed38ed27ea484a9ac3873cf6ee2543477))

## [0.1.0] - 2026-07-27

- Initial independent release of kristal-i18n.
