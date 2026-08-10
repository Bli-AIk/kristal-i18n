# Contributing to kristal-i18n

Thank you for wanting to contribute! 🌍

## The hard part is already done

When I built this library, I deliberately did the heavy lifting up front so that localization never becomes a coding problem. The built-in texts are already extracted and fully hooked in **both English and Simplified Chinese**:

- **Every built-in text has been extracted.** All of the vanilla Kristal texts — dialogue, cutscenes, choices, items, weapons, armors, spells, menus, the save screen, the shop, the debug menu, battle results, light/dark world UI — have been pulled out of the engine into `lang/en.json` and `lang/zh_hans.json`, fully hooked and ready to translate.
- **Every hook has already been written.** You don't need to touch a single line of Lua. Every place text shows up is already wired to the localization system.
- **Simplified Chinese is a complete reference implementation.** `lang/zh_hans.json` covers 100% of the hooked texts and ships with the library, so you always have a full example of what a finished translation looks like.

So what does a translator actually need to do? **Only translate.** Copy any existing language file, translate the values into your language, register your language in the config — done. Players will be able to switch to it from the in-game settings menu immediately.

I fully support and welcome pull requests for translations in your language! That's exactly why I created this localization library—to help everyone make games and translate existing ones in their native languages.

> **What this guide covers:** the **framework's built-in texts** — everything the engine itself displays. Translating the vanilla Kristal template content (the demo mod) is the focus of the [kristal-i18n-example contributing guide](https://github.com/Bli-AIk/kristal-i18n-example/blob/main/CONTRIBUTING.md).

## Adding a new language

1. **Pick a starting file.** Copy any existing language file to `lang/<your_language>.json` (e.g. `lang/fr.json` for French, `lang/ja.json` for Japanese). `lang/zh_hans.json` is the most complete reference, but you can start from whichever language you read best.
2. **Translate the values.** Translate every value into your language. Keep the **keys unchanged** — the game looks up text by key, and the keys are shared across all languages.
3. **Register the language.** In `lib.json` (or via `config.kristalI18n` in your mod's `mod.json`), add your language ID to `languages` and its display name to `languageNames`:
   ```json
   "languages": ["en", "zh_hans", "fr"],
   "languageNames": {
       "en": "English",
       "zh_hans": "简体中文",
       "fr": "Français"
   }
   ```
4. **(Optional) Names and assets.** Add character names for your language to `lang/names.json`, and drop texture/font/audio overrides under `lang/<your_language>/...` if your language needs them (see the README's "More Tips" section).
5. **Test in-game.** The demo mod [kristal-i18n-example](https://github.com/Bli-AIk/kristal-i18n-example) exercises every hook — dialogue, battles, shops, save screen, debug menu, light world. Switch languages instantly with the toggle key (default `F7`) to check your work in both directions.
6. **Open a pull request.** 🎉

## Translation guidelines

- **Keys never change — only values.** Renaming a key breaks lookups in every language.
- **Keep placeholders intact.** `{key}` interpolation and `[var:name]` / `[name:kris]` markers must be preserved. You may move them within the sentence to fit your grammar, but don't drop them.
- **Match the tone.** The vanilla Kristal texts are short and typewriter-paced. Keep your translations concise so they read well at the game's typing speed.
- **The `cjk*` config is Chinese-specific.** The spacing and offset settings exist for Chinese typesetting; other languages generally don't need them.
- **Check the context.** Some keys are shared across menus. When a translation feels ambiguous, look at how `lang/zh_hans.json` renders it, or run the demo mod to see it in-game.

## Other ways to contribute

- **Report untranslated text** — if any hooked text shows up raw in-game, file an issue with a screenshot and the steps to reproduce.
- **Improve an existing translation** — wording, tone, or consistency fixes are always welcome.
- **Suggest features** — new hooks, new config options, documentation.
- **Code contributions** — hook coverage, performance, tooling. See the README for the library's design goals first.

## License

By contributing, you agree that your contribution is dual-licensed under the MIT License and the Apache License, Version 2.0 (same as the project).
