# kristal-i18n

[![license](https://img.shields.io/badge/license-MIT%2FApache--2.0-blue)](LICENSE-APACHE) <img src="https://img.shields.io/github/repo-size/Bli-AIk/kristal-i18n.svg"/> <img src="https://img.shields.io/github/last-commit/Bli-AIk/kristal-i18n.svg"/> <img src="https://img.shields.io/github/v/release/Bli-AIk/kristal-i18n.svg"/> <br>
<img src="https://img.shields.io/badge/Deltarune-001225?style=for-the-badge&labelColor=001225&logo=undertale&logoColor=ff0000" /> <img src="https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white" /> <img src="https://img.shields.io/badge/Kristal-FF6B35?style=for-the-badge&logo=love2d&logoColor=white" />

![战斗内展示](./screenshot-battle.png)

<details>
<summary>更多截图（存档页面 / 角色能力 / 调试界面 / 光世界背包）</summary>

![存档页面](./screenshot.png)

![角色能力页面](./screenshot-ability.png)

![调试界面](./screenshot-debug.png)

![光世界背包](./screenshot-light-inventory.png)

</details>

**kristal-i18n** — 简洁强大的 Kristal 多语言全方位本地化库，内置英文与简体中文。

| 简体中文 | English                |
| -------- | ---------------------- |
| 简体中文 | [English](./README.md) |

## Kristal 版本支持

| `kristal`                                                                                                                     | `kristal-i18n` |
| ----------------------------------------------------------------------------------------------------------------------------- | -------------- |
| [v0.11.0-dev](https://github.com/KristalTeam/Kristal/commit/f62afea63ccab02f468c24ac0d096bd8a2c9aa81) (`f62afea`, 2026-08-16) | 0.5.0 - 0.5.2  |
| [v0.10.0](https://github.com/KristalTeam/Kristal/commit/752bc0688ba97ca8a256ba9125b7e05a1ca6edbd) (`752bc068`, 2026-06-23)    | 0.1.0 – 0.4.1  |

## 设计目标

就四个特色：

**1. 简单又强大**

日常用到的**只有 1 个新 API**——`Game:loc`。其余全靠对原版 API 的拓展：任何文本里写 `{key}` 即可翻译，混合文本也只处理花括号内的部分。不用学新框架，不用改数据结构，绝大多数情况下，原版怎么写，本地化就怎么写。

**2. 全方位**

不止翻对话：过场动画、选项、内置物品与法术、光世界/暗世界 UI、存档界面、商店、Debug 菜单、战斗结算……凡是露字的地方都有 hook 覆盖。内置的简体中文本地化已经达成这些目标，可直接当作「全覆盖」的完整范例参考。

**3. 贴图本地化**

把资源放进 `lang/<语言>/...` 路径即可按语言替换原版贴图（字体、音频、视频同理）——中文界面的按钮、图标、标题全部无缝切换，无需改一行代码。

**4. 姓名单独翻译**

对话里的角色名用 `[name:xxx]` 富文本标记，在 `lang/names.json` 里按语言统一维护。

## 怎么用

三步，完事儿：

**1. 把库装上**

以子模块方式安装（建议——库会跟着你的 mod 一起版本管理）：

```sh
git submodule add https://github.com/Bli-AIk/kristal-i18n.git libraries/kristal-i18n
git submodule update --init --recursive
```

或者不用 Git：直接下载 [Release 源码](https://github.com/Bli-AIk/kristal-i18n/releases)（或克隆最新代码做滚动更新），把整个目录放进你的模组：

```text
mods/your_mod/libraries/kristal-i18n/
```

**2. 写 JSON**

在模组里建 `lang/<语言>.json`，把要翻译的文本写上：

```json
{
  "room1.hello": "* 你好！"
}
```

**3. 弄个花括号**

在代码里用 `{key}` 引用它：

```lua
cutscene:text("{room1.hello}")
```

完事儿。玩家可以在游戏内**设置菜单**中切换语言（默认 `en` / `zh_hans`）。

开发时也可以给启动器传 `--lang <语言>`（例如 `--lang en` 或 `--lang zh-hans`），
无需改动存档即可选择本次启动的语言。角色名语言同理，传 `--name-lang <语言>` 即可。

除了花括号，也可以直接调用 `Game:loc`：

```lua
Game:loc("room1.hello")                    -- 查表
Game:loc("room1.hello", {name = "Kris"})   -- 带变量
```

> ⚠️ **API 与原版 LangLib 不兼容**：`Game:loc` 第一个参数永远是 ID，不接受 LangLib 的 `Game:loc("fallback", "id")` 写法。缺失 ID 会显示为 `<id> is missing`。

## 更多技巧

- **角色名**：`lang/names.json` 里按语言给名字，文本中用 `[name:kris]` 引用
- **Tiled 对话**：NPC/Interactable 的 `text1`、`text2` 属性直接写 `{key}`
- **选项**：`cutscene:choicer({"{choice.yes}", "{choice.no}"})`
- **变量**：文本里写 `[var:name]`，调用时传 `Game:loc("key", {name = "Kris"})`
- **混合文本**：`cutscene:text("* {name_susie} threw a punch!")` —— 只有花括号里的部分会被翻译
- **资源覆盖**：字体、贴图、音频放 `lang/<语言>/...` 路径即可自动按语言切换。贴图还支持名称语言层（`lang/<文本语言>/<名称语言>/...`）；名称语言与文本语言不同时，名称语言自身的层（`lang/<名称语言>/<名称语言>/...`，例如内置的中文队员名贴图）依然生效

## 配置

默认配置在 `lib.json`，也可在模组的 `mod.json` 中覆盖：

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

- `defaultLanguage` — 具体语言 ID 或 `"auto"`（自动检测系统语言并匹配最佳可用语言）；名称语言与文本语言独立
- `languageToggleKey` — 快捷切换语言的按键；`false` 可禁用
- `cjk*` — 中文排版微调：字符间固定字间距、对话字间距与垂直偏移、打字机速度倍率。本库为中文特意做了这些调整（英文无需），如需适配其他 CJK 语言或修改观感可覆盖

## 上游来源与参考

本库的 hook 骨架与预置 ID 模式继承自 GameBanana 的 [LangLib](https://gamebanana.com/mods/627141)（API 不兼容，见上文警告），并参考了以下汉化项目：

本库内置的中文贴图使用了 [好人汉化组（Goodman 3 Localization Group | UNDERTALE & DELTARUNE Chinese Localization）](https://github.com/gm3dr/) 的贴图。

| 项目                                                                                                                                                                      | 作者/组织                                                                                                             |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| [LangLib](https://gamebanana.com/mods/627141)                                                                                                                             | Elioze                                                                                                                |
| [DELTARUNE: Frostveil（三角符文：冰封帷幕）](https://www.bilibili.com/video/BV12nQKB9E3V) 和 [Frozen Heart（冰封之心）](https://www.bilibili.com/video/BV18CC4Y6EFo) 汉化 | [WasneetPotato](https://space.bilibili.com/1641628190)                                                                |
| [DeltaruneChinese](https://github.com/gm3dr/DeltaruneChinese)                                                                                                             | [好人汉化组（Goodman 3 Localization Group \| UNDERTALE & DELTARUNE Chinese Localization）](https://github.com/gm3dr/) |
| 中文 fork                                                                                                                                                                 | AIk                                                                                                                   |

## 参与贡献

欢迎提交 Issue 或 Pull Request。

我全力支持并欢迎为你的语言提交翻译 Pull Request！这正是我创建这个本地化库的初衷——让每个人都能用自己的母语制作游戏、翻译现有的游戏。

本库侧重**框架内置所有文本**的翻译。如何贡献翻译，请看 [中文版贡献指南](CONTRIBUTING_zh_hans.md)（英文版：[CONTRIBUTING.md](CONTRIBUTING.md)）；原版模板内容的翻译则请看 [kristal-i18n-example 的贡献指南](https://github.com/Bli-AIk/kristal-i18n-example/blob/main/CONTRIBUTING_zh_hans.md)。

## 许可证

本项目采用双许可证授权，您可以选择以下任一许可证：

- Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE-APACHE) 或 http://www.apache.org/licenses/LICENSE-2.0)
- MIT license ([LICENSE-MIT](LICENSE-MIT) 或 http://opensource.org/licenses/MIT)
