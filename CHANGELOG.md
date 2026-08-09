# Changelog

All notable changes to this project will be documented in this file.

## [0.3.2](https://github.com/Bli-AIk/kristal-i18n/compare/v0.3.3...v0.3.2) (2026-08-09)


### ⚠ BREAKING CHANGES

* launch kristal-i18n 0.1.0

### chore

* force release 0.3.1 ([561ab83](https://github.com/Bli-AIk/kristal-i18n/commit/561ab83e9a8691f6ac0bb689939167fcc812ed2c))
* force release 0.3.2 ([a8f33b4](https://github.com/Bli-AIk/kristal-i18n/commit/a8f33b41cc5bafc2e877c07d022112d8d7dbb6d3))


### Features

* **debug:** add battle debug controls and wave terminology updates ([1233fd4](https://github.com/Bli-AIk/kristal-i18n/commit/1233fd4a040642c6f8f78b927b76790620010cd8))
* **debug:** add debug mode terminology toggle ([c6538d6](https://github.com/Bli-AIk/kristal-i18n/commit/c6538d6441c3374355cb4d964f2f36f52039ffa4))
* **i18n:** add {id} string interpolation syntax ([5968a1a](https://github.com/Bli-AIk/kristal-i18n/commit/5968a1a43d6a243694ca68047a461d8a2944e490))
* **i18n:** make CJK typesetting and language toggle configurable ([383917a](https://github.com/Bli-AIk/kristal-i18n/commit/383917a92b4499044255ebe6ba34c6e2dc2b98e4))
* **i18n:** map/tileset texture variants (refreshLocalizedTilesets, lang/ probe hardening, RC2 base-id fix) ([cb19032](https://github.com/Bli-AIk/kristal-i18n/commit/cb19032c95da0708b80f92e3674fcad3346022d6))
* **i18n:** raw-string lookup with per-line fallback, CJK wrap, bonus names +7, framework light/dark item keys ([e845f6a](https://github.com/Bli-AIk/kristal-i18n/commit/e845f6a454753c72968401950169d43c2b587aad))
* **i18n:** select name language directly ([b029f31](https://github.com/Bli-AIk/kristal-i18n/commit/b029f311db1957e959653f349a27621e1a41bfdd))
* **i18n:** simplify localized name references ([306b1a5](https://github.com/Bli-AIk/kristal-i18n/commit/306b1a5a7aeb37a052bba03ac5815e31303b1288))
* launch kristal-i18n 0.1.0 ([0692f14](https://github.com/Bli-AIk/kristal-i18n/commit/0692f14a82acd30d4fdc63846c4290ac9bbab379))
* **localization:** add auto-language detection from system locale ([67932cd](https://github.com/Bli-AIk/kristal-i18n/commit/67932cd90071c5909f027358739f3d359955f5d6))
* **localization:** add game over translations ([40e55a4](https://github.com/Bli-AIk/kristal-i18n/commit/40e55a4d40aa4a07cae2ac7a4bde86b4c8a98aa9))
* **localization:** add name style settings ([4bade23](https://github.com/Bli-AIk/kristal-i18n/commit/4bade2365d6a9dda4567a380196050b6c4fe7a75))
* localize debug item menu and item text ([611de3d](https://github.com/Bli-AIk/kristal-i18n/commit/611de3d95c589201d743d7ae4d837c60496e3c3a))


### Bug Fixes

* adjust CJK text spacing ([faf9d5e](https://github.com/Bli-AIk/kristal-i18n/commit/faf9d5ec076d369fa3bf2e31f4d5eadd2d72d169))
* complete item reaction translations ([f3ef5dd](https://github.com/Bli-AIk/kristal-i18n/commit/f3ef5dda98e5737d8d08f06dddd2a9b400e67faa))
* handle CJK wrap punctuation by codepoint ([3cfa9ab](https://github.com/Bli-AIk/kristal-i18n/commit/3cfa9ab11a11123b3f6b9070800d7ae1f075a8fa))
* **i18n:** align language translations ([352bcfb](https://github.com/Bli-AIk/kristal-i18n/commit/352bcfbaf2a24a4679c07492437f77ea87964b39))
* **i18n:** increase light world UI text spacing ([989d860](https://github.com/Bli-AIk/kristal-i18n/commit/989d860eeb8780e8d1abfc67a69fcbe591ab6e44))
* **i18n:** localize light world item text ([0a92f07](https://github.com/Bli-AIk/kristal-i18n/commit/0a92f077bf93148537d2a7b1afe6b421a2cea2e7))
* **i18n:** localize spare and tired battle text ([f83a579](https://github.com/Bli-AIk/kristal-i18n/commit/f83a579053053fdf900c1e1b68b864fb6faca530))
* **i18n:** name language player choice no longer clobbered by config default ([707e2ab](https://github.com/Bli-AIk/kristal-i18n/commit/707e2ab4cb3e4fcf688e297d5fd03b7698ae64dd))
* **i18n:** re-evaluate name language at postInit; config defaultNameLanguage takes precedence ([949645f](https://github.com/Bli-AIk/kristal-i18n/commit/949645f899c658c31cb3f258f6235aec2e70261c))
* **i18n:** remove misspelled 'raisel' name entry ([bd89f05](https://github.com/Bli-AIk/kristal-i18n/commit/bd89f05fe4d0c15b167c41a4f87cde9d907472fc))
* **lang:** correct zh_hans translations ([a07a831](https://github.com/Bli-AIk/kristal-i18n/commit/a07a8313e2b2bc0b60b69981f19c23fe12922f50))
* **lang:** 提前注册物品本地化钩子 ([8c777a8](https://github.com/Bli-AIk/kristal-i18n/commit/8c777a83c683b1e66c8de3cf989e8d3f966a286d))
* **lang:** 移除武器丢弃文本中的多余标记 ([a79ad6b](https://github.com/Bli-AIk/kristal-i18n/commit/a79ad6b51fd0bc7fb8ab000fabd1961015c76804))
* **localization:** remove project-specific vessel names ([add76c9](https://github.com/Bli-AIk/kristal-i18n/commit/add76c99fe15b1e3b17073ef6697d1688722d56a))
* localize shop item descriptions ([f6d6c1f](https://github.com/Bli-AIk/kristal-i18n/commit/f6d6c1ffe379a73731b9cb929e51800e7a078fb7))
* localize tea reaction and equipment tags ([c56d699](https://github.com/Bli-AIk/kristal-i18n/commit/c56d699b9751e6941aa6e3d201eac3115e182730))
* make localization ids authoritative ([fe1161a](https://github.com/Bli-AIk/kristal-i18n/commit/fe1161a2745652c86593dca52cafee86dda47ecd))
* use Chinese font for battle speech bubbles ([95ebeba](https://github.com/Bli-AIk/kristal-i18n/commit/95ebebaed38ed27ea484a9ac3873cf6ee2543477))


### Code Refactoring

* **i18n:** centralize Kristal translations ([3e0c3a5](https://github.com/Bli-AIk/kristal-i18n/commit/3e0c3a5f1cb2c8c12ee753a3b898fea1d6407ce6))
* **i18n:** remove loc_id/loc/langAvalable legacy aliases ([abcd34b](https://github.com/Bli-AIk/kristal-i18n/commit/abcd34b3c510b4231c5735da6d7f3107cff646a1))

## [0.3.3](https://github.com/Bli-AIk/kristal-i18n/compare/v0.3.2...v0.3.3) (2026-08-09)


### Bug Fixes

* localize shop item descriptions ([7d13258](https://github.com/Bli-AIk/kristal-i18n/commit/7d13258a21f13e255b48ae7f3245914e4cd6b982))

## [0.3.2](https://github.com/Bli-AIk/kristal-i18n/compare/v0.3.1...v0.3.2) (2026-08-09)


### chore

* force release 0.3.2 ([25cf3e0](https://github.com/Bli-AIk/kristal-i18n/commit/25cf3e04f8637db354500b1878852029eb3dbe2d))


### Features

* localize debug item menu and item text ([27d3ba8](https://github.com/Bli-AIk/kristal-i18n/commit/27d3ba839efd125ba398afdbce2afa8b7f5e8250))


### Bug Fixes

* complete item reaction translations ([2e97b88](https://github.com/Bli-AIk/kristal-i18n/commit/2e97b88f259e1d31c951adf7551f6709c616786a))
* handle CJK wrap punctuation by codepoint ([a622046](https://github.com/Bli-AIk/kristal-i18n/commit/a622046a21c491276844ebaa2ed850f9ad02e51b))
* localize tea reaction and equipment tags ([aacc358](https://github.com/Bli-AIk/kristal-i18n/commit/aacc35808860ffb2a833689e3ab03df16ffda41f))

## [0.3.1](https://github.com/Bli-AIk/kristal-i18n/compare/v0.3.0...v0.3.1) (2026-08-08)


### chore

* force release 0.3.1 ([e2ec07c](https://github.com/Bli-AIk/kristal-i18n/commit/e2ec07cb59672a925a30ecbfea9a348a2f75b6ca))


### Features

* **i18n:** map/tileset texture variants (refreshLocalizedTilesets, lang/ probe hardening, RC2 base-id fix) ([b12da82](https://github.com/Bli-AIk/kristal-i18n/commit/b12da82ab67a3397bcba01f1199e4e80640671c4))


### Bug Fixes

* **i18n:** name language player choice no longer clobbered by config default ([ef7b938](https://github.com/Bli-AIk/kristal-i18n/commit/ef7b93847630d662a105dc92af1c936b2c80a0f5))
* **i18n:** re-evaluate name language at postInit; config defaultNameLanguage takes precedence ([e7d8a5d](https://github.com/Bli-AIk/kristal-i18n/commit/e7d8a5d12f3a67d91fb45ae15a63ca2c855dbaf5))

## [0.3.0](https://github.com/Bli-AIk/kristal-i18n/compare/v0.2.0...v0.3.0) (2026-08-08)


### Features

* **i18n:** raw-string lookup with per-line fallback, CJK wrap, bonus names +7, framework light/dark item keys ([82e8312](https://github.com/Bli-AIk/kristal-i18n/commit/82e8312f096dab9090bba2e6162787da8be3f0d0))


### Bug Fixes

* **i18n:** remove misspelled 'raisel' name entry ([786ecf8](https://github.com/Bli-AIk/kristal-i18n/commit/786ecf8fbffcc038227a43c3653a99ae8063c587))

## [0.2.0](https://github.com/Bli-AIk/kristal-i18n/compare/v0.1.1...v0.2.0) (2026-08-05)


### Features

* **i18n:** add {id} string interpolation syntax ([04080f6](https://github.com/Bli-AIk/kristal-i18n/commit/04080f6df41f579d234b4029930422e13272760f))
* **i18n:** make CJK typesetting and language toggle configurable ([1f33fc0](https://github.com/Bli-AIk/kristal-i18n/commit/1f33fc001828b755078d77025e63be527f75cd7f))


### Bug Fixes

* make localization ids authoritative ([d2b0fcc](https://github.com/Bli-AIk/kristal-i18n/commit/d2b0fcc97095cfb690120243f1a7bc34c883b62b))


### Code Refactoring

* **i18n:** remove loc_id/loc/langAvalable legacy aliases ([08d63fe](https://github.com/Bli-AIk/kristal-i18n/commit/08d63fef5faed19d6b5bc71692e8270cb1707a70))

## [0.1.1](https://github.com/Bli-AIk/kristal-i18n/compare/v0.1.0...v0.1.1) (2026-08-03)


### Bug Fixes

* **i18n:** increase light world UI text spacing ([989d860](https://github.com/Bli-AIk/kristal-i18n/commit/989d860eeb8780e8d1abfc67a69fcbe591ab6e44))
* **i18n:** localize light world item text ([0a92f07](https://github.com/Bli-AIk/kristal-i18n/commit/0a92f077bf93148537d2a7b1afe6b421a2cea2e7))
* **i18n:** localize spare and tired battle text ([f83a579](https://github.com/Bli-AIk/kristal-i18n/commit/f83a579053053fdf900c1e1b68b864fb6faca530))
* use Chinese font for battle speech bubbles ([95ebeba](https://github.com/Bli-AIk/kristal-i18n/commit/95ebebaed38ed27ea484a9ac3873cf6ee2543477))

## [0.1.0] - 2026-07-27

- Initial independent release of kristal-i18n.
