# kristal-i18n

[![license](https://img.shields.io/badge/license-MIT%2FApache--2.0-blue)](LICENSE-APACHE)
<br>
<img src="https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white" />
<img src="https://img.shields.io/badge/Kristal-FF6B35?style=for-the-badge&logo=love2d&logoColor=white" />

> Current Status: ✅ Stable

![Screenshot](./screenshot.png)

**kristal-i18n** — a multilingual localization library for Kristal `v0.10.x`, modified from Elioze's [LangLib](https://gamebanana.com/mods/627141) on GameBanana, with English and Simplified Chinese resources included.

| English | 简体中文 |
|---------|---------|
| English | [简体中文](./README.md) |

## Introduction

`kristal-i18n` provides multilingual localization for Kristal mods. Text is looked up by stable IDs; a missing ID is rendered as a red error marker instead of silently using an English fallback from code. It also provides UTF-8-safe variable substitution, automatic system language detection, runtime language switching, and per-language asset overrides for fonts, sprites, audio, and video.

Once the library is installed, a mod only needs a language JSON file to achieve full Chinese localization — no game logic changes required.

## Features

- 🌐 Language-ID based text and asset tables with built-in `en` and `zh_hans`
- 🔤 UTF-8-safe `[var:name]` variable substitution
- 👤 `[name:xxx]` name references with a selectable name language
- 🔍 `auto` mode for automatic system language detection and best-match selection
- 🔄 Runtime language switching (the integration mod binds it to F7), persisted to save data
- 📝 `Game:loc(id, vars)`, `cutscene:text(..., {id = "text_id"})`, and `cutscene:choicer(..., {ids = {...}})` for ID-based localization
- 🎨 Language-specific asset overrides: fonts, sprites, audio, music, and video via `lang/<lang>/...` paths
- 🔣 Automatic CJK character spacing adjustment and typewriter speed correction
- 📋 Automatic hooks for text, choices, Tiled NPC/Interactable, items, spells, and menus
- 🖥️ Optional `DarkConfigMenu` integration with a language settings submenu
- 🆓 Dual-licensed (MIT / Apache 2.0)

## Installation

Place the entire directory into your target mod:

```text
mods/your_mod/libraries/kristal-i18n/
```

The directory must include:

```text
lib.json
lib.lua
lang/en.json
lang/zh_hans.json
lang/names.json
scripts/hooks/...
```

## Dependencies

| Library | Description |
|---|---|
| [Kristal](https://github.com/KristalTeam/Kristal) | Game engine, `v0.10.0` or later |

## Configuration

Default configuration is in `lib.json`:

```json
{
    "defaultLanguage": "en",
    "defaultNameLanguage": "en",
    "languages": ["en", "zh_hans"],
    "languageNames": {
        "en": "English",
        "zh_hans": "简体中文"
    }
}
```

Override in your mod's `mod.json`:

```json
"config": {
    "kristalI18n": {
        "defaultLanguage": "auto",
        "languages": ["en", "zh_hans"],
        "languageNames": {
            "en": "English",
            "zh_hans": "简体中文"
        }
    }
}
```

`defaultLanguage` can be a specific language ID or `"auto"`. `"auto"` reads the system language and selects the closest match from the `languages` list; if no match is found, it falls back to the first item or English.

`defaultNameLanguage` accepts a language ID present in the name table, such as `"en"` or `"zh_hans"`. Name language is independent from text language, and the settings menu displays the actual language names instead of an original/translated mode. The Engine Options menu has a separate `Debug Mode Terminology` option for toggling translations of terms such as `wave`, `encounter`, `cutscene`, `legend`, `battle`, `object`, and `debug`; it is independent from the character-name setting. `engine` remains translated as `引擎`.

## Usage

### Language Files

Place your mod's translations in `mods/your_mod/lang/zh_hans.json`. Keys matching those in the library's language table will be overridden.

The following naming conventions are supported:

```text
lang/zh_hans.json
lang/lang_zh_hans.json
lang/zh-hans.json
lang/lang_zh-hans.json
```

### Character Names

All names are kept in:

```text
lang/names.json
```

Each name has one ID with language IDs for its values:

```json
{
    "kris": {
        "en": "Kris",
        "zh_hans": "克里斯"
    },
    "starwalker": {
        "en": "Starwalker",
        "zh_hans": "星之行者"
    }
}
```

Name language mode uses the value for the selected language. If a name does not have that language, it falls back to `en`, then to the name ID.

You can reference names inside regular text so one translation follows the current setting:

```json
{
    "room1.hello": "* 你好，[name:kris]。"
}
```

In code, resolve a name through the normal localization entry point:

```lua
Game:locText("[name:kris]")
Game:setNameLanguage("en")
Game:setNameLanguage("zh_hans")
```

### Text Localization

Call by ID:

```lua
cutscene:text(Game:loc("room1.hello", {name = "Kris"}))
```

Language table:

```json
{
    "room1.hello": "* 你好，[var:name]。"
}
```

The first argument to `Game:loc` is always an ID; English fallback text is no longer accepted. For rich text that intentionally does not belong in a language table, use the explicit `Game:locText(text, vars)` entry point.

You can also resolve the ID directly in `cutscene:text`:

```lua
cutscene:text(Game:loc("room1.hello", {name = "Kris"}), "smile", "ralsei")
```

### Tiled Dialogue

NPCs, Interactables, and Savepoints can define dialogue directly with properties such as `id1` and `id2`:

```text
id1 = room1.hello
id2 = room1.goodbye
```

When IDs are present, they are the only source for both dialogue content and dialogue structure, so matching `text1` and `text2` properties are unnecessary. Objects without IDs can still use Kristal's native `text` properties for raw rich text.

### Choice Localization

```lua
local choice = cutscene:choicer({"Yes", "No"}, {
    ids = {"choice.yes", "choice.no"}
})
```

```json
{
    "choice.yes": "是",
    "choice.no": "否"
}
```

### Asset Localization

When the language is `zh_hans`, asset requests will first look in the language-specific path before falling back:

```lua
Assets.getTexture("ui/title")    -- → lang/zh_hans/ui/title.png
Assets.getFont("main")           -- → lang/zh_hans/main.ttf
Assets.playSound("voice/noelle") -- → lang/zh_hans/voice/noelle.wav
```

Texture overrides also support a name-language layer. For `Assets.getTexture("party/kris/name")`, lookup order is:

```text
lang/zh_hans/zh_hans/party/kris/name.png
lang/zh_hans/party/kris/name.png
party/kris/name.png
```

When `Game:getNameLanguage()` is `"zh_hans"`, the `zh_hans` layer has the highest priority. Selecting `"en"` checks the `en` layer instead, then falls back to the normal language override and the base asset. Put textures that should follow the name language in the matching language layer; keep normal Chinese UI textures in `lang/zh_hans/...`.

### Chinese Fonts

The library includes built-in Chinese fallback fonts. The strategy is:

- English/ASCII characters use the original Kristal fonts to keep English crisp in Chinese mode
- Chinese characters fall back to the bundled CJK fonts

To use custom Chinese fonts, place files with the same paths in your mod to override.

### Runtime Switching

```lua
Game:setLanguage("zh_hans")
Game:setLanguage("en")
```

In this test mod, press F7 to toggle between languages. F6 is reserved by Kristal for debug rendering.

Language and name language settings are persisted to save data:

```lua
data.lang
data.langSelected
data.langNameLanguage
data.langDebugTermsTranslated
```

## Upstream & References

This library is based on [LangLib](https://gamebanana.com/mods/627141) from GameBanana and references the following Chinese localization projects:

The bundled Chinese texture overrides use texture assets from [Goodman 3 Localization Group | UNDERTALE & DELTARUNE Chinese Localization](https://github.com/gm3dr/).

| Project | Author/Organization |
|---------|---------------------|
| [LangLib](https://gamebanana.com/mods/627141) | Elioze |
| Chinese localization references from other Kristal projects | [WasneetPotato](https://space.bilibili.com/1641628190) |
| [DeltaruneChinese](https://github.com/gm3dr/DeltaruneChinese) | [Goodman 3 Localization Group \| UNDERTALE & DELTARUNE Chinese Localization](https://github.com/gm3dr/) |
| Chinese fork | Aik/Codex |

## Contributing

Issues and Pull Requests are welcome.

## License

This project is licensed under either of

- Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE-APACHE) or http://www.apache.org/licenses/LICENSE-2.0)
- MIT license ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)

at your option.
