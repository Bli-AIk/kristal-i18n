# kristal-i18n

[![license](https://img.shields.io/badge/license-MIT%2FApache--2.0-blue)](LICENSE-APACHE)
<br>
<img src="https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white" />
<img src="https://img.shields.io/badge/Kristal-FF6B35?style=for-the-badge&logo=love2d&logoColor=white" />

> 当前状态：✅ 稳定可用

![效果图](./screenshot.png)

**kristal-i18n** — Kristal `v0.10.x` 的多语言本地化库，基于 GameBanana 上 Elioze 的 [LangLib](https://gamebanana.com/mods/627141) 修改，当前附带英文与简体中文资源。

| 简体中文 | English |
|---------|---------|
| 简体中文 | [English](./README_en.md) |

## 简介

`kristal-i18n` 为 Kristal 模组提供多语言本地化能力。文本通过稳定的 ID 查表，缺失 ID 会显示红色错误标记，而不会把英文 fallback 静默混入代码。库还提供 UTF-8 安全的变量替换、系统语言自动检测、运行时语言切换，以及按语言覆盖字体/贴图/音频/视频的资源系统。

引入本库后，模组只需编写语言表 JSON 文件即可实现完整中文化，无需修改游戏逻辑代码。

## 特性

- 🌐 按语言 ID 管理文本与资源，内置 `en`、`zh_hans`
- 🔤 UTF-8 安全的 `[var:name]` 变量替换
- 👤 `[name:xxx]` 名字引用，支持按语言选择名称
- 🔍 `auto` 模式自动检测系统语言并匹配最佳可用语言
- 🔄 运行时语言切换（由集成模组绑定 F7 快捷键），切换结果写入存档
- 📝 `Game:loc(id, vars)`、`cutscene:text(..., {id = "text_id"})` 和 `cutscene:choicer(..., {ids = {...}})` 按 ID 本地化
- 🎨 资源按语言覆盖：字体、贴图、音频、音乐、视频均可放到 `lang/<语言>/...` 路径
- 🔣 CJK 字符自动字间距调整与打字机速度修正
- 📋 文本、选项、Tiled NPC/Interactable、物品、技能、菜单等常见入口自动 hook
- 🖥️ 可选 `DarkConfigMenu` 集成，设置菜单中出现语言设置子页
- 🆓 双许可证授权（MIT / Apache 2.0）

## 安装

将整个目录放入目标模组：

```text
mods/your_mod/libraries/kristal-i18n/
```

目录中需要包含：

```text
lib.json
lib.lua
lang/en.json
lang/zh_hans.json
lang/names.json
scripts/hooks/...
```

## 依赖

| 库 | 说明 |
|---|---|
| [Kristal](https://github.com/KristalTeam/Kristal) | 游戏引擎，`v0.10.0` 或更高版本 |

## 配置

默认配置在 `lib.json`：

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

也可以在目标模组的 `mod.json` 中覆盖：

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

`defaultLanguage` 可设置为具体语言 ID 或 `"auto"`。`"auto"` 会读取系统语言并从 `languages` 列表中选择最接近的可用语言；匹配不到时回退到列表首项或英文。

`defaultNameLanguage` 接受名称表中的语言 ID，例如 `"en"` 或 `"zh_hans"`。名称语言与文本语言独立，设置菜单显示实际语言名称，切换文本语言不会自动改动名称语言。引擎选项中另有独立的 `Debug Mode Terminology`（调试模式专有名词翻译）选项，用于切换 `wave`、`encounter`、`cutscene`、`legend`、`battle`、`object`、`debug` 等调试术语的翻译；该选项与角色名设置相互独立。`engine` 始终翻译为“引擎”。

## 使用方式

### 语言文件

模组翻译放在 `mods/your_mod/lang/zh_hans.json`，与库语言表同名 key 会被覆盖。

兼容以下命名：

```text
lang/zh_hans.json
lang/lang_zh_hans.json
lang/zh-hans.json
lang/lang_zh-hans.json
```

### 角色名

角色名统一放在：

```text
lang/names.json
```

每个名字只需要一个 ID，再用语言 ID 区分不同语言：

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

名称语言模式直接使用所选语言的值；如果某个名称缺少该语言，则回退到 `en`，最后回退到名称 ID。

正文里可以写名字占位符，让同一条翻译跟随设置切换：

```json
{
    "room1.hello": "* 你好，[name:kris]。"
}
```

代码中通过普通本地化入口解析名字：

```lua
Game:locText("[name:kris]")
Game:setNameLanguage("en")
Game:setNameLanguage("zh_hans")
```

### 文本本地化

通过 ID 调用：

```lua
cutscene:text(Game:loc("room1.hello", {name = "Kris"}))
```

语言表：

```json
{
    "room1.hello": "* 你好，[var:name]。"
}
```

`Game:loc` 的第一个参数始终是 ID，不再接受英文 fallback。需要处理没有进入语言表的原始富文本时，显式使用 `Game:locText(text, vars)`。

也可以在 `cutscene:text` 中直接使用 ID 查表：

```lua
cutscene:text(Game:loc("room1.hello", {name = "Kris"}), "smile", "ralsei")
```

### Tiled 对话

NPC、Interactable 和 Savepoint 支持使用 `id1`、`id2` 等属性直接定义对话：

```text
id1 = room1.hello
id2 = room1.goodbye
```

存在 ID 时，ID 是对话内容和对话结构的唯一来源，不需要再填写对应的 `text1`、`text2`。没有 ID 的对象仍可使用 Kristal 原生的 `text` 属性显示原始富文本。

### 选项本地化

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

### 资源本地化

当语言为 `zh_hans` 时，以下资源请求会优先查找语言覆盖路径，找不到则回退：

```lua
Assets.getTexture("ui/title")    -- → lang/zh_hans/ui/title.png
Assets.getFont("main")           -- → lang/zh_hans/main.ttf
Assets.playSound("voice/noelle") -- → lang/zh_hans/voice/noelle.wav
```

贴图还支持名称语言覆盖层。以 `Assets.getTexture("party/kris/name")` 为例：

```text
lang/zh_hans/zh_hans/party/kris/name.png
lang/zh_hans/party/kris/name.png
party/kris/name.png
```

当 `Game:getNameLanguage()` 为 `"zh_hans"` 时，`zh_hans` 覆盖层优先级最高；选择 `"en"` 时则查找 `en` 覆盖层，找不到会回退到普通语言贴图和本体贴图。需要跟随名称语言设置的贴图应放在对应语言层，普通中文 UI 贴图仍放 `lang/zh_hans/...`。

### 中文字体

库内已内置中文 fallback 字体配置。策略：

- 英文/ASCII 优先使用 Kristal 原版英文字体，避免中文模式下英文变糊
- 中文字符回退到内置中文字体

如需自定义中文字体，在目标模组中放同路径文件即可覆盖。

### 运行时切换

```lua
Game:setLanguage("zh_hans")
Game:setLanguage("en")
```

在本测试模组中按 F7 可直接切换；F6 保留给 Kristal 的调试渲染功能。

语言和名称语言会写入存档：

```lua
data.lang
data.langSelected
data.langNameLanguage
data.langDebugTermsTranslated
```

## 上游来源与参考

本库基于 GameBanana 的 [LangLib](https://gamebanana.com/mods/627141) 改造，并参考了以下汉化项目：

本库内置的中文贴图使用了 [好人汉化组（Goodman 3 Localization Group | UNDERTALE & DELTARUNE Chinese Localization）](https://github.com/gm3dr/) 的贴图。

| 项目 | 作者/组织 |
|------|-----------|
| [LangLib](https://gamebanana.com/mods/627141) | Elioze |
| 若干其他 Kristal 项目的汉化参考 | [WasneetPotato](https://space.bilibili.com/1641628190) |
| [DeltaruneChinese](https://github.com/gm3dr/DeltaruneChinese) | [好人汉化组（Goodman 3 Localization Group \| UNDERTALE & DELTARUNE Chinese Localization）](https://github.com/gm3dr/) |
| 中文 fork | Aik/Codex |

## 参与贡献

欢迎提交 Issue 或 Pull Request。

## 许可证

本项目采用双许可证授权，您可以选择以下任一许可证：

- Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE-APACHE) 或 http://www.apache.org/licenses/LICENSE-2.0)
- MIT license ([LICENSE-MIT](LICENSE-MIT) 或 http://opensource.org/licenses/MIT)
