# kristal-i18n

[![license](https://img.shields.io/badge/license-MIT%2FApache--2.0-blue)](LICENSE-APACHE)
<br>
<img src="https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white" />
<img src="https://img.shields.io/badge/Kristal-FF6B35?style=for-the-badge&logo=love2d&logoColor=white" />

![In battle](./screenshot-battle.png)

<details>
<summary>More screenshots (save screen / ability / debug / light world inventory)</summary>

![Save screen](./screenshot.png)

![Ability screen](./screenshot-ability.png)

![Debug screen](./screenshot-debug.png)

![Light world inventory](./screenshot-light-inventory.png)

</details>

**kristal-i18n** — a multilingual localization library for Kristal, with English and Simplified Chinese built in.

| English | 简体中文 |
|---------|---------|
| English | [简体中文](./README_zh_hans.md) |

## Design Goals

Four features:

**1. Simple yet powerful**

There is only **one new API** to use day-to-day — `Game:loc`. Everything else is an extension of the vanilla API: write `{key}` in any text and it gets translated; in mixed text, only the braced parts are processed. No new framework to learn, no data structures to restructure — in the vast majority of cases, write it the vanilla way, localize it the same way.

**2. Comprehensive coverage**

Dialogue, cutscenes, choices, built-in items and spells, light/dark world UI, save screen, shop, debug menu, battle... every place text shows up is hooked. The bundled Simplified Chinese localization already achieves all of this, and serves as a complete reference to look at.

**3. Texture localization**

Drop resources under `lang/<language>/...` paths and they replace the vanilla assets per language — sprites, fonts, audio and video alike. Chinese buttons, icons and titles switch over seamlessly, with zero code changes.

**4. Selective name translation**

Mark character names in dialogue with `[name:xxx]` rich text and maintain them per language in `lang/names.json`.

## How to Use

Three steps, done:

**1. Install the library**

Drop the whole `libraries/kristal-i18n` folder into your mod:

```text
mods/your_mod/libraries/kristal-i18n/
```

**2. Write a JSON**

Create `lang/<language>.json` in your mod and write the text you want to translate:

```json
{
    "room1.hello": "* Hello there!"
}
```

**3. Use curly braces**

Reference it with `{key}` in your code:

```lua
cutscene:text("{room1.hello}")
```

Done. Players can switch languages in the in-game **settings menu** (default `en` / `zh_hans`).

For development, pass `--lang <language>` to the launcher (for example `--lang en`
or `--lang zh-hans`) to select the startup language without changing the save file.

Besides curly braces, you can also call `Game:loc` directly:

```lua
Game:loc("room1.hello")                    -- ID lookup
Game:loc("room1.hello", {name = "Kris"})   -- with variables
```

> ⚠️ **API is NOT compatible with the original LangLib**: the first argument of `Game:loc` is always an ID; LangLib's `Game:loc("fallback", "id")` form is not accepted. Missing IDs render as `<id> is missing`.

## More Tips

- **Names**: define per-language names in `lang/names.json`, reference them with `[name:kris]` in text
- **Tiled dialogue**: write `{key}` directly in the `text1`/`text2` properties of NPCs/Interactables
- **Choices**: `cutscene:choicer({"{choice.yes}", "{choice.no}"})`
- **Variables**: write `[var:name]` in text, pass values via `Game:loc("key", {name = "Kris"})`
- **Mixed text**: `cutscene:text("* {name_susie} threw a punch!")` — only the braced parts are translated
- **Asset overrides**: put fonts, sprites, and audio under `lang/<language>/...` paths for automatic per-language switching

## Configuration

Defaults live in `lib.json`; override them in your mod's `mod.json`:

```json
"config": {
    "kristalI18n": {
        "defaultLanguage": "auto",
        "languages": ["en", "zh_hans"],
        "languageNames": {
            "en": "English",
            "zh_hans": "简体中文"
        },
        "languageToggleKey": "f7",
        "cjkFixedTextSpacing": 4,
        "cjkDialogueTextSpacing": 4,
        "cjkDialogueYOffset": -1,
        "cjkTypewriterSpeedMultiplier": 1
    }
}
```

- `defaultLanguage` — a specific language ID or `"auto"` (detects the system language and picks the best match); the name language is independent from the text language
- `languageToggleKey` — the key that quickly toggles the language; set to `false` to disable
- `cjk*` — fine-tuning for Chinese typesetting: fixed character spacing, dialogue spacing and vertical offset, and typewriter speed multiplier. These adjustments exist specifically for Chinese (not needed for English); override them to fit other CJK languages or tweak the look

## Upstream & References

This library's hook skeleton and preset ID patterns are inherited from [LangLib](https://gamebanana.com/mods/627141) on GameBanana (API-incompatible, see the warning above), and references the following Chinese localization projects:

The bundled Chinese texture overrides use texture assets from [Goodman 3 Localization Group | UNDERTALE & DELTARUNE Chinese Localization](https://github.com/gm3dr/).

| Project | Author/Organization |
|---------|---------------------|
| [LangLib](https://gamebanana.com/mods/627141) | Elioze |
| [DELTARUNE: Frostveil](https://www.bilibili.com/video/BV12nQKB9E3V) and [Frozen Heart](https://www.bilibili.com/video/BV18CC4Y6EFo) localization | [WasneetPotato](https://space.bilibili.com/1641628190) |
| [DeltaruneChinese](https://github.com/gm3dr/DeltaruneChinese) | [Goodman 3 Localization Group \| UNDERTALE & DELTARUNE Chinese Localization](https://github.com/gm3dr/) |
| Chinese fork | AIk |

## Contributing

Issues and Pull Requests are welcome.

I fully support and welcome pull requests for translations in your language! That's exactly why I created this localization library—to help everyone make games and translate existing ones in their native languages.

This library focuses on the **framework's built-in texts**. For a step-by-step guide on adding a new language, see the [English guide](CONTRIBUTING.md) or the [简体中文指南](CONTRIBUTING_zh_hans.md). To translate the vanilla template content (the demo mod), see the [kristal-i18n-example contributing guide](https://github.com/Bli-AIk/kristal-i18n-example/blob/main/CONTRIBUTING.md).

## License

Dual-licensed under either of:

- Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE-APACHE) or http://www.apache.org/licenses/LICENSE-2.0)
- MIT license ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)
