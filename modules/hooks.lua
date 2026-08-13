--- Framework, battle, and item/spell localization hooks.
---@param ctx table Shared module context.
---@return table Hooks module.
return function(ctx)
    local M = {}
    local kristalI18n = ctx.library
    local runtime = ctx.runtime
    local text = ctx.text
    local assets = ctx.assets

    local tableCopy = runtime.tableCopy
    local localizeStaticTextValue = text.localizeStaticTextValue
    local localizeDynamicStaticTextValue = text.localizeDynamicStaticTextValue
    local localizeRawItemText = text.localizeRawItemText
    local localizeItemField = text.localizeItemField
    local getItemTextLocalizationKey = text.getItemTextLocalizationKey
    local isClassInstance = text.isClassInstance
    local isColorTable = text.isColorTable
    local isTextDescriptor = text.isTextDescriptor
    local resolveTextInput = text.resolveTextInput
    local normalizeCutsceneTextArgs = text.normalizeCutsceneTextArgs
    local normalizeChoices = text.normalizeChoices
    local normalizeTextChoiceArgs = text.normalizeTextChoiceArgs
    local mergeTextOptions = text.mergeTextOptions
    local resolveDisplayText
    local refreshDebugOptionDescriptions = text.refreshDebugOptionDescriptions
    local refreshConsoleStartupHistory = text.refreshConsoleStartupHistory
    local shouldPrintWithCjkSpacing = text.shouldPrintWithCjkSpacing
    local getCjkPrintedTextWidth = text.getCjkPrintedTextWidth
    local getPrintedTextWidth = text.getPrintedTextWidth
    local localizeMapName = assets.localizeMapName

    local POWER_STAT_LABELS = {
        ["Guts:"] = "guts_stat",
        ["Rudeness"] = "rudeness_stat",
        ["Fluffiness"] = "fluffiness_stat",
        ["Coldness"] = "coldness_stat",
        ["Boldness"] = "boldness_stat",
        ["Kindness"] = "kindness_stat",
        ["Dogness"] = "dogness_stat",
        ["Crudeness"] = "crudeness_stat",
        ["Purple"] = "purple_stat",
        ["Sweetness"] = "sweetness_stat",
        -- Susie's chapter 2 joke value next to "Purple".
        ["Yes"] = "yes",
    }

    local ITEM_BONUS_NAMES = {
        ["GrazeTime"] = "graze_time_bonus",
        ["Money Earned UP"] = "bonus_money_up",
        ["Spookiness UP"] = "bonus_spookiness_up",
        ["Defense"] = "bonus_defense",
        ["Festive"] = "bonus_festive",
        ["Annoying"] = "bonus_annoying",
        ["SlayDark"] = "bonus_slaydark",
        ["BadIdea"] = "bonus_badidea",
        ["Attack"] = "bonus_attack",
        ["Buster TP DOWN"] = "bonus_buster_tp_down",
        ["Cuteness"] = "bonus_cuteness",
        ["Dark/Star"] = "bonus_dark_star",
        ["Elec/Holy"] = "bonus_elec_holy",
        ["Elegance"] = "bonus_elegance",
        ["Failure"] = "bonus_failure",
        ["Fluffiness UP"] = "bonus_fluffiness_up",
        ["GrazeArea"] = "bonus_graze_area",
        ["Guts Up"] = "bonus_guts_up",
        ["Heal+"] = "bonus_heal",
        ["Prickly"] = "bonus_prickly",
        ["Smiley"] = "bonus_smiley",
        ["TPGain"] = "bonus_tp_gain",
        ["Trance"] = "bonus_trance",
        ["Vampire"] = "bonus_vampire",
        ["$ +5%"] = "bonus_money_5",
    }

    local NOELLE_SPECIAL_TITLE_KEYS = {
        ["Ice Trancer"] = "chara_noelle_title_ice_trancer",
        ["Frostmancer"] = "chara_noelle_title_frostmancer",
    }

    local localizeVictoryText
    local localizeBattleText

    local function hookPowerStatLabels(party_member)
        if not party_member or party_member.__langlib_zh_power_stats_hooked then
            return
        end

        party_member.__langlib_zh_power_stats_hooked = true
        HookSystem.hook(party_member, "drawPowerStat", function(orig, self, index, x, y, menu)
            if Game:getLanguage() ~= "zh_hans" then
                return orig(self, index, x, y, menu)
            end

            local original_print = love.graphics.print
            love.graphics.print = function(value, ...)
                local key = POWER_STAT_LABELS[value]
                if key then
                    value = Game:loc(key)
                end
                return original_print(value, ...)
            end

            local ok, result = xpcall(function()
                return orig(self, index, x, y, menu)
            end, debug.traceback)
            love.graphics.print = original_print

            if not ok then
                error(result)
            end
            return result
        end)
    end

    localizeVictoryText = function(value)
        if Game:getLanguage() ~= "zh_hans" or type(value) ~= "string" then
            return value
        end

        local xp, money, currency = value:match("^%* You won!\n%* Got (.-) EXP and (.-) (.-)%.$")
        if xp then
            return Game:loc("battle_victory_with_exp", {
                xp = xp,
                money = money,
                currency = currency,
            })
        end

        local stronger_money, stronger_currency, stronger = value:match("^%* You won!\n%* Got (.-) (.-)%.\n%* (.-) became stronger%.$")
        if stronger_money then
            if stronger == "You" then
                stronger = "你"
            end
            return Game:loc("battle_victory_stronger", {
                money = stronger_money,
                currency = stronger_currency,
                stronger = stronger,
            })
        end

        return value
    end

    localizeBattleText = function(value)
        if Game:getLanguage() ~= "zh_hans" or type(value) ~= "string" then
            return value
        end

        local battler_name, enemy_name = value:match("^%* (.-) spared (.-)!$")
        if battler_name then
            return Game:loc("battle_spare_success", {
                battlerName = battler_name,
                enemyName = enemy_name,
            })
        end

        battler_name = value:match("^%* (.-) spared!$")
        if battler_name then
            return Game:loc("battle_spare_no_enemy", { battlerName = battler_name })
        end

        battler_name, enemy_name = value:match("^%* (.-) spared (.-)!\n%* But its name wasn't %[color:yellow%]YELLOW%[color:reset%]%.%.%.$")
        if battler_name then
            return Game:loc("battle_spare_not_yellow", {
                battlerName = battler_name,
                enemyName = enemy_name,
            })
        end

        local party_name, spell_name = value:match("^%* %(Try using (.-)'s %[color:blue%](.-)%[color:reset%]!%)$")
        if party_name then
            return Game:loc("battle_spare_try_spell", {
                partyName = party_name,
                spellName = spell_name,
            })
        end

        if value == "* (Try using [color:blue]ACTs[color:reset]!)" then
            return Game:loc("battle_spare_try_act")
        end

        return value
    end

    local function localizeBattleTextValue(value)
        if type(value) == "table" then
            if isClassInstance(value) or isColorTable(value) then
                return value
            end

            local out = {}
            for key, item in pairs(value) do
                out[key] = localizeBattleTextValue(item)
            end
            return out
        end
        return localizeBattleText(value)
    end

    resolveDisplayText = function(value, options)
        if value == nil then
            return nil
        end
        return localizeStaticTextValue(resolveTextInput(value, options))
    end

    local function localizeDebugItemOption(name, description)
        if not Game or Game.lang ~= "zh_hans" then
            return resolveDisplayText(name), localizeDynamicStaticTextValue(description)
        end

        local raw_name
        if type(name) == "string" then
            raw_name = name:match("^(.*) %(Light Item%)$") or name
        end

        -- Descriptions distinguish framework items that intentionally share a name.
        local item_id
        if type(description) == "string" then
            local _, description_id = getItemTextLocalizationKey(description, "description")
            item_id = description_id
        end
        if not item_id and raw_name then
            local _, name_id = getItemTextLocalizationKey(raw_name, "name")
            item_id = name_id
        end

        if not item_id then
            return resolveDisplayText(name), localizeDynamicStaticTextValue(description)
        end

        local localized_name = raw_name and localizeRawItemText(raw_name, "name", item_id) or nil
        if localized_name and raw_name ~= name then
            localized_name = Game:loc("debug_light_item_suffix", { name = localized_name })
        end
        localized_name = localized_name or resolveDisplayText(name)

        local localized_description = localizeRawItemText(description, "description", item_id)
            or localizeStaticTextValue(description)
        return localized_name, localizeDynamicStaticTextValue(localized_description)
    end

    local function resolveTextLines(value)
        value = resolveDisplayText(value)
        if type(value) ~= "table" then
            return { value }
        end
        return value
    end

    local function resolveTextList(value)
        if value == nil then
            return nil
        end
        if type(value) ~= "table" or isTextDescriptor(value) then
            return resolveDisplayText(value)
        end

        local out = {}
        for key, item in pairs(value) do
            out[key] = resolveDisplayText(item)
        end
        return out
    end

    -- Finds a localization key whose translated value equals the given string.
    -- Prefers the library's default map_* keys, then any key ending in "name",
    -- then any other matching key.
    local function findRoomNameKeyInTable(value, lang_table)
        if type(value) ~= "string" or type(lang_table) ~= "table" then
            return nil
        end

        local fallback
        for key, translated in pairs(lang_table) do
            if type(key) == "string" and type(translated) == "string" and translated == value then
                if key:match("^map_") then
                    return key
                end
                if not fallback or (not fallback:match("name$") and key:match("name$")) then
                    fallback = key
                end
            end
        end
        return fallback
    end

    -- Save files created before the library stored room_name_key: infer the
    -- localization key from the currently loaded language tables when the stored
    -- room name matches one of the localized map name values.
    local function findRoomNameKey(value)
        local key = findRoomNameKeyInTable(value, Game and Game.langStr)
        if key then
            return key
        end
        return findRoomNameKeyInTable(value, Game and Game.langBaseStr)
    end

    local function resolveFileData(value)
        if type(value) ~= "table" or isClassInstance(value) then
            return value
        end

        local result = tableCopy(value)

        -- The save name is player input; never run it through static-text
        -- localization (a name like "Save" must stay exactly as entered).
        result.name = value.name

        -- Keep the raw room name in the save file (the engine's main-menu file
        -- select reads save data straight from disk via Kristal.loadData,
        -- bypassing this hook), and re-localize it here for in-game display.
        local room_key = result.room_name_key
        if type(room_key) ~= "string" or room_key == "" then
            room_key = findRoomNameKey(result.room_name)
            if room_key then
                result.room_name_key = room_key
            end
        end

        if type(room_key) == "string" and room_key ~= ""
            and Game and Game.hasStr and Game:hasStr(room_key)
        then
            result.room_name = Game:loc(room_key)
        else
            result.room_name = resolveDisplayText(value.room_name)
        end

        return result
    end

    local function resolveListMenuValues(list)
        if isTextDescriptor(list) then
            return { resolveDisplayText(list) }
        end
        if type(list) ~= "table" or isClassInstance(list) or isColorTable(list) then
            return list
        end

        local result = {}
        for key, value in pairs(list) do
            result[key] = type(key) == "number" and resolveDisplayText(value) or value
        end
        return result
    end

    local function resolveShopItemOptions(options)
        if type(options) ~= "table" or isClassInstance(options) then
            return options
        end

        local result = tableCopy(options)
        result.name = resolveDisplayText(options.name)
        result.description = resolveDisplayText(options.description)
        return result
    end

    local function resolveGonerChoice(choice)
        if isTextDescriptor(choice) then
            return { resolveDisplayText(choice), 0, 0 }
        end
        if type(choice) ~= "table" or isClassInstance(choice) then
            return choice
        end

        local result = tableCopy(choice)
        result[1] = resolveDisplayText(choice[1])
        return result
    end

    local function resolveGonerChoices(choices)
        if type(choices) ~= "table" or isClassInstance(choices) then
            return choices
        end

        local result = {}
        for y, row in ipairs(choices) do
            if type(row) == "table" and not isClassInstance(row) then
                result[y] = {}
                for x, choice in ipairs(row) do
                    result[y][x] = resolveGonerChoice(choice)
                end
            else
                result[y] = row
            end
        end
        return result
    end

    local function resolveConsoleLines(value)
        if isTextDescriptor(value) then
            local resolved = resolveDisplayText(value)
            return type(resolved) == "table" and resolved or { resolved }
        end
        if type(value) ~= "table" or isClassInstance(value) then
            return value
        end

        local result = {}
        for index, line in ipairs(value) do
            if isColorTable(line) then
                result[index] = line
            else
                result[index] = resolveDisplayText(line)
            end
        end
        return result
    end

    local function resolveFileNamerOptions(options)
        if type(options) ~= "table" or isClassInstance(options) then
            return options
        end

        local result = tableCopy(options)
        local mod = options.mod
        if type(mod) == "table" and not isClassInstance(mod) then
            result.mod = tableCopy(mod)
        end

        local name_text = options.name_text
        if name_text == nil and result.mod then
            name_text = result.mod.nameText
        end
        if name_text ~= nil then
            result.name_text = resolveDisplayText(name_text)
        end

        local confirm_text = options.confirm_text
        if confirm_text == nil and result.mod then
            confirm_text = result.mod.confirmText
        end
        if confirm_text ~= nil then
            result.confirm_text = resolveDisplayText(confirm_text)
        end

        return result
    end

    local function hookMethod(target, name, hook)
        if target and type(target[name]) == "function" then
            HookSystem.hook(target, name, hook)
        end
    end

    local function hookDebugSystemLocalization()
        if kristalI18n.debug_system_localization_hooked or not DebugSystem then
            return
        end

        kristalI18n.debug_system_localization_hooked = true

        HookSystem.hook(DebugSystem, "registerOption", function(orig, self, menu, name, description, func, visible_func, color)
            if menu == "give_item" then
                name, description = localizeDebugItemOption(name, description)
            else
                name = resolveDisplayText(name)
                description = localizeDynamicStaticTextValue(description)
            end
            return orig(
                self,
                menu,
                name,
                description,
                func,
                visible_func,
                color
            )
        end)

        hookMethod(DebugSystem, "registerMenu", function(orig, self, id, name, type)
            return orig(self, id, resolveDisplayText(name), type)
        end)

        HookSystem.hook(DebugSystem, "appendBool", function(orig, self, desc, bool)
            if Game.lang == "zh_hans" then
                return Game:loc("debug_bool_suffix", {
                    desc = resolveDisplayText(desc),
                    state = Game:loc(bool and "on" or "off")
                })
            end
            return orig(self, resolveDisplayText(desc), bool)
        end)

        HookSystem.hook(DebugSystem, "printShadow", function(orig, self, value, ...)
            return orig(self, resolveDisplayText(value), ...)
        end)
    end

    local function hookFrameworkLocalization()
        if kristalI18n.framework_localization_hooked then
            return
        end

        kristalI18n.framework_localization_hooked = true

        -- In-game save menus read save summaries through Kristal.getSaveFile;
        -- re-localize the stored raw room name there. The engine's main-menu
        -- file select uses Kristal.loadData directly, so it keeps the raw,
        -- ASCII-safe value from the save file.
        if Kristal and Kristal.getSaveFile then
            HookSystem.hook(Kristal, "getSaveFile", function(orig, id, path)
                return resolveFileData(orig(id, path))
            end)
        end

        HookSystem.hook(Item, "getBonusName", function(orig, item, ...)
            local bonus_name = orig(item, ...)
            if Game:getLanguage() ~= "zh_hans" then
                return bonus_name
            end

            local key = ITEM_BONUS_NAMES[bonus_name]
            return key and Game:loc(key) or bonus_name
        end)

        if LightEquipItem then
            HookSystem.hook(LightEquipItem, "showEquipText", function(orig, item, ...)
                if Game:getLanguage() ~= "zh_hans" then
                    return orig(item, ...)
                end

                Game.world:showText(Game:loc("item_equip", {name = item:getName()}))
            end)
        end

        HookSystem.hook(Battle, "battleText", function(orig, battle, value, ...)
            value = resolveDisplayText(value)
            return orig(battle, localizeBattleTextValue(localizeVictoryText(value)), ...)
        end)

        HookSystem.hook(Battle, "shortActText", function(orig, battle, value)
            return orig(battle, resolveTextLines(value))
        end)

        HookSystem.hook(Battle, "infoText", function(orig, battle, value)
            return orig(battle, resolveDisplayText(value))
        end)

        HookSystem.hook(Battle, "setEncounterText", function(orig, battle, options, instant)
            options = tableCopy(options or {})
            options.text, options = resolveTextInput(options.text, options)
            options.text = localizeStaticTextValue(options.text)
            return orig(battle, options, instant)
        end)

        hookMethod(Battle, "registerXAction", function(orig, battle, party, name, description, tp)
            return orig(
                battle,
                party,
                resolveDisplayText(name),
                resolveDisplayText(description),
                tp
            )
        end)

        if EnemyBattler then
            hookMethod(EnemyBattler, "registerAct", function(orig, battler, name, description, ...)
                return orig(battler, resolveDisplayText(name), resolveDisplayText(description), ...)
            end)
            hookMethod(EnemyBattler, "registerShortAct", function(orig, battler, name, description, ...)
                return orig(battler, resolveDisplayText(name), resolveDisplayText(description), ...)
            end)
            hookMethod(EnemyBattler, "registerActFor", function(orig, battler, char, name, description, ...)
                return orig(battler, char, resolveDisplayText(name), resolveDisplayText(description), ...)
            end)
            hookMethod(EnemyBattler, "registerShortActFor", function(orig, battler, char, name, description, ...)
                return orig(battler, char, resolveDisplayText(name), resolveDisplayText(description), ...)
            end)
        end

        local noelle = Registry.getPartyMember("noelle")
        if noelle then
            HookSystem.hook(noelle, "getTitle", function(orig, self, ...)
                local title = orig(self, ...)
                if Game:getLanguage() ~= "zh_hans" or type(title) ~= "string" then
                    return title
                end

                for english_title, key in pairs(NOELLE_SPECIAL_TITLE_KEYS) do
                    if title:find(english_title, 1, true) then
                        return Game:loc("chara_getTitle", {
                            lv = self:getLevel(),
                            title = Game:loc(key),
                        })
                    end
                end
                return title
            end)
        end

        for _, id in ipairs({"kris", "susie", "ralsei", "noelle"}) do
            hookPowerStatLabels(Registry.getPartyMember(id))
        end

        if Interactable then
            HookSystem.hook(Interactable, "onInteract", function(orig, self, ...)
                if type(self.text) == "table" and self.text[1] == "* (It's frozen solid...)" then
                    self.text[1] = "{frozen_enemy_text}"
                end
                return orig(self, ...)
            end)
        end

        if World then
            hookMethod(World, "heal", function(orig, self, target, amount, value)
                return orig(self, target, amount, resolveDisplayText(value))
            end)

            hookMethod(World, "registerCall", function(orig, self, name, scene)
                return orig(self, resolveDisplayText(name), scene)
            end)

            hookMethod(World, "replaceCall", function(orig, self, name, index, scene)
                return orig(self, resolveDisplayText(name), index, scene)
            end)

            HookSystem.hook(World, "setupMap", function(orig, self, ...)
                local result = orig(self, ...)
                localizeMapName(self.map)
                return result
            end)

            HookSystem.hook(World, "showText", function(orig, self, value, after)
                if isTextDescriptor(value) then
                    value = { value }
                end
                return orig(self, value, after)
            end)

            HookSystem.hook(World, "partyReact", function(orig, self, party_member, value, display_time)
                return orig(self, party_member, resolveDisplayText(value), display_time)
            end)
        end

        if Battler then
            HookSystem.hook(Battler, "spawnSpeechBubble", function(orig, self, value, options)
                value, options = resolveTextInput(value, options)
                return orig(self, localizeStaticTextValue(value), options)
            end)
        end

        if SpeechBubble then
            HookSystem.hook(SpeechBubble, "init", function(orig, self, value, x, y, options, speaker)
                value, options = resolveTextInput(value, options)
                return orig(self, localizeStaticTextValue(value), x, y, options, speaker)
            end)

            HookSystem.hook(SpeechBubble, "setText", function(orig, self, value, callback, line_callback)
                value = resolveTextInput(value)
                return orig(self, localizeStaticTextValue(value), callback, line_callback)
            end)
        end

        if Textbox then
            HookSystem.hook(Textbox, "setText", function(orig, self, value, callback)
                value = resolveTextInput(value)
                return orig(self, localizeStaticTextValue(value), callback)
            end)

            HookSystem.hook(Textbox, "addReaction", function(orig, self, id, value, x, y, face, actor)
                return orig(self, id, resolveDisplayText(value), x, y, face, actor)
            end)
        end

        if Choicebox then
            HookSystem.hook(Choicebox, "addChoice", function(orig, self, name)
                name = resolveTextInput(name)
                return orig(self, localizeStaticTextValue(name))
            end)
        end

        if TextChoicebox then
            HookSystem.hook(TextChoicebox, "addChoice", function(orig, self, name)
                name = resolveTextInput(name)
                return orig(self, localizeStaticTextValue(name))
            end)

            HookSystem.hook(TextChoicebox, "setText", function(orig, self, value, callback)
                value = resolveTextInput(value)
                return orig(self, localizeStaticTextValue(value), callback)
            end)
        end

        if Shop then
            hookMethod(Shop, "getVoicedText", function(orig, self, value)
                return orig(self, resolveDisplayText(value))
            end)
            hookMethod(Shop, "setDialogueText", function(orig, self, value, no_voice)
                return orig(self, resolveDisplayText(value), no_voice)
            end)
            hookMethod(Shop, "setRightText", function(orig, self, value, no_voice)
                return orig(self, resolveDisplayText(value), no_voice)
            end)

            local function hookShopConfirmationDraw(method, field)
                hookMethod(Shop, method, function(orig, self, ...)
                    local original_text = self[field]
                    self[field] = resolveDisplayText(original_text)

                    local draw_args = {...}
                    local unpack_args = table.unpack or unpack
                    local ok, result = xpcall(function()
                        return orig(self, unpack_args(draw_args))
                    end, debug.traceback)
                    self[field] = original_text

                    if not ok then
                        error(result)
                    end
                    return result
                end)
            end

            hookShopConfirmationDraw("drawBuyConfirm", "buy_confirmation_text")
            hookShopConfirmationDraw("drawSellConfirm", "sell_confirmation_text")

            hookMethod(Shop, "registerItem", function(orig, self, item, options)
                return orig(self, item, resolveShopItemOptions(options))
            end)

            hookMethod(Shop, "replaceItem", function(orig, self, index, item, options)
                local result = orig(self, index, item, resolveShopItemOptions(options))
                local entry = self.items and self.items[index]
                if result and entry and entry.options then
                    entry.options.name = resolveDisplayText(entry.options.name)
                    entry.options.description = resolveDisplayText(entry.options.description)
                end
                return result
            end)

            hookMethod(Shop, "registerTalk", function(orig, self, talk, color)
                return orig(self, resolveDisplayText(talk), color)
            end)

            hookMethod(Shop, "replaceTalk", function(orig, self, talk, index, color)
                return orig(self, resolveDisplayText(talk), index, color)
            end)

            hookMethod(Shop, "registerTalkAfter", function(orig, self, talk, index, flag, value, color)
                return orig(self, resolveDisplayText(talk), index, flag, value, color)
            end)
        end

        if OverworldActionBox then
            hookMethod(OverworldActionBox, "react", function(orig, self, value, display_time)
                return orig(self, resolveDisplayText(value), display_time)
            end)
        end
    end

    local function applyItemLocalizationPatch(item)
        if not item or item.__langlib_zh_localized then
            return item
        end

        item.__langlib_zh_localized = true

        -- Some framework items override getShopDescription, so localize those
        -- overrides through the same per-item shop keys as the base Item method.
        local original_get_shop_description = item.getShopDescription
        if original_get_shop_description then
            function item:getShopDescription()
                local key = "item_" .. self.id .. "_shopDesc"
                if Game and Game.hasStr and Game:hasStr(key) then
                    local shop_name_key = "item_" .. self.id .. "_shopName"
                    local shop_name = self.shop
                    if Game:hasStr(shop_name_key) then
                        shop_name = Game:loc(shop_name_key)
                    end
                    return Game:loc(key, {
                        typeName = self:getTypeName(),
                        shopName = shop_name,
                    })
                end
                return original_get_shop_description(self)
            end
        end

        if item.id == "dark_candy" then
            local original_get_name = item.getName
            local original_get_description = item.getDescription

            function item:getName()
                if Game and Game.lang == "zh_hans" then
                    return localizeItemField(self, "name")
                end
                return original_get_name(self)
            end

            function item:getDescription()
                if Game and Game.lang == "zh_hans" then
                    return localizeItemField(self, "description")
                end
                return original_get_description(self)
            end
        end

        if item.id == "glowshard" then
            local original_get_battle_text = item.getBattleText
            function item:getBattleText(user, target)
                if Game.battle and Game.battle.encounter and Game.battle.encounter.onGlowshardUse then
                    return original_get_battle_text(self, user, target)
                end
                return {
                    Game:loc("item_glowshard_battleText", {
                        charaName = user.chara:getName(),
                        useName = self:getUseName()
                    }),
                    Game:loc("item_glowshard_battleNothing")
                }
            end
        elseif item.id == "cell_phone" then
            function item:onWorldUse()
                Game.world:startCutscene(function(cutscene)
                    Assets.playSound("phone", 0.7)
                    cutscene:text(Game:loc("item_cell_phone_call_try"), nil, nil, {advance = false})
                    cutscene:wait(40/30)

                    local was_playing = Game.world.music:isPlaying()
                    if was_playing then
                        Game.world.music:pause()
                    end

                    Assets.playSound("smile")
                    cutscene:wait(200/30)

                    if was_playing then
                        Game.world.music:resume()
                    end

                    if Game.chapter == 1 then
                        cutscene:text(Game:loc("item_cell_phone_call_not_working"))
                    else
                        cutscene:text(Game:loc("item_cell_phone_call_garbage_noise"))
                    end
                end)
            end
        elseif item.id == "shadowcrystal" then
            function item:getDescription()
                local desc = Game:loc("item_shadowcrystal_description")
                if self:getCollected() > 0 then
                    desc = desc .. "\n" .. Game:loc("item_shadowcrystal_collected", {
                        count = self:getCollected()
                    })
                end
                return desc
            end

            function item:onWorldUse()
                if Kristal.callEvent(KRISTAL_EVENT.onShadowCrystal, self, false) then
                    return
                elseif not self:getFlag("used_none") then
                    self:setFlag("used_none", true)

                    Game.world:showText({
                        Game:loc("item_shadowcrystal_use_1"),
                        Game:loc("item_shadowcrystal_use_2")
                    })
                else
                    Game.world:showText(Game:loc("item_shadowcrystal_use_again"))
                end
            end
        elseif item.id == "light/glass" then
            function item:onWorldUse()
                if Kristal.callEvent("onShadowCrystal", self, true) then
                    return
                elseif not self:getFlag("used_lw_no_party") and #Game.party == 1 and #Game.temp_followers == 0 then
                    self:setFlag("used_lw_no_party", true)

                    Game.world:showText({
                        Game:loc("item_light/glass_use_alone_1"),
                        Game:loc("item_light/glass_use_alone_2"),
                        Game:loc("item_light/glass_use_alone_3"),
                    })
                elseif not self:getFlag("used_none") then
                    self:setFlag("used_none", true)

                    Game.world:showText({
                        Game:loc("item_light/glass_use_1"),
                        Game:loc("item_light/glass_use_2"),
                    })
                else
                    Game.world:showText(Game:loc("item_light/glass_use_again"))
                end
                return false
            end

            function item:onCheck()
                Game.world:showText({
                    Game:loc("item_light/glass_check_1"),
                    Game:loc("item_light/glass_check_2"),
                })
            end

            function item:onToss()
                Game.world:showText({
                    Game:loc("item_light/glass_toss_1"),
                    Game:loc("item_light/glass_toss_2"),
                })
                return false
            end
        end

        return item
    end

    local applySpellLocalizationPatch

    local function hookRegistryItemCreation()
        if kristalI18n.registry_item_creation_hooked then
            return
        end

        kristalI18n.registry_item_creation_hooked = true

        HookSystem.hook(Registry, "createItem", function(orig, id, ...)
            return applyItemLocalizationPatch(orig(id, ...))
        end)

        HookSystem.hook(Registry, "createSpell", function(orig, id, ...)
            return applySpellLocalizationPatch(orig(id, ...))
        end)
    end

    applySpellLocalizationPatch = function(spell)
        if not spell or spell.__langlib_zh_localized then
            return spell
        end

        spell.__langlib_zh_localized = true

        if spell.id == "rude_buster" then
            function spell:getCastMessage(user, target)
                return Game:loc("spell_rude_buster_castMessage", {
                    userName = user.chara:getName(),
                    castName = self:getCastName()
                })
            end
        elseif spell.id == "pacify" then
            function spell:getCastMessage(user, target)
                local message = Game:loc("spell_castMessage", {
                    userName = user.chara:getName(),
                    castName = self:getCastName()
                })
                if target.tired then
                    return message
                elseif target.mercy < 100 then
                    return message .. "\n[wait:0.25s]" .. Game:loc("spell_pacify_not_tired_enemy")
                else
                    return message .. "\n[wait:0.25s]" .. Game:loc("spell_pacify_not_tired_foe_spare")
                end
            end
        end

        return spell
    end

    M.hookDebugSystemLocalization = hookDebugSystemLocalization
    M.hookFrameworkLocalization = hookFrameworkLocalization
    M.hookRegistryItemCreation = hookRegistryItemCreation
    M.hookMethod = hookMethod
    M.applyItemLocalizationPatch = applyItemLocalizationPatch
    M.applySpellLocalizationPatch = applySpellLocalizationPatch
    M.resolveDisplayText = resolveDisplayText
    M.resolveGonerChoice = resolveGonerChoice
    M.resolveGonerChoices = resolveGonerChoices
    M.resolveTextList = resolveTextList
    M.resolveTextLines = resolveTextLines
    M.findRoomNameKeyInTable = findRoomNameKeyInTable
    M.findRoomNameKey = findRoomNameKey
    M.resolveFileData = resolveFileData
    M.resolveShopItemOptions = resolveShopItemOptions
    M.resolveFileNamerOptions = resolveFileNamerOptions
    M.resolveListMenuValues = resolveListMenuValues
    M.resolveConsoleLines = resolveConsoleLines
    return M
end
