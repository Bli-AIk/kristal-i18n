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
| English | [简体中文](./README.md) |

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

Besides curly braces, you can also call `Game:loc` directly:

```lua
Game:loc("room1.hello")                    -- ID lookup
Game:loc("room1.hello", {name = "Kris"})   -- with variables
```

> ⚠️ **API is NOT compatible with the original LangLib**: the first argument of `Game:loc` is always an ID; LangLib's `Game:loc("fallback", "id")` form is not accepted. Missing IDs render as red error markers.

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

## License

Dual-licensed under either of:

- Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE-APACHE) or http://www.apache.org/licenses/LICENSE-2.0)
- MIT license ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)
