--- Text localization: language tables, descriptors, menus, and printed text.
---@param ctx table Shared module context.
---@return table Text module.
return function(ctx)
    local M = {}
    local runtime = ctx.runtime
    local cjk = ctx.cjk
    local constants = ctx.constants
    local data = ctx.data
    local library = ctx.library

    local DEFAULT_LANGUAGE = constants.DEFAULT_LANGUAGE
    local FALLBACK_LANGUAGE = constants.FALLBACK_LANGUAGE
    local ID_INTERP_PATTERN = constants.ID_INTERP_PATTERN

    local STATIC_TEXT_IDS = data.STATIC_TEXT_IDS
    local GAMEOVER_PARTY_TEXT_IDS = data.GAMEOVER_PARTY_TEXT_IDS
    local CONSOLE_STARTUP_MESSAGES = data.CONSOLE_STARTUP_MESSAGES

    local getConfig = runtime.getConfig
    local tableCopy = runtime.tableCopy
    local listContains = runtime.listContains
    local normalizeLanguageId = runtime.normalizeLanguageId
    local normalizeNameId = runtime.normalizeNameId
    local normalizeNameLanguage = runtime.normalizeNameLanguage
    local getStartupLanguage = runtime.getStartupLanguage
    local getStartupNameLanguage = runtime.getStartupNameLanguage
    local applyOriginalDebugTermReplacements = runtime.applyOriginalDebugTermReplacements
    local matchAvailableLanguage = runtime.matchAvailableLanguage
    local resolveLanguageId = runtime.resolveLanguageId
    local getDefaultLanguage = runtime.getDefaultLanguage
    local isCjkCodepoint = cjk.isCjkCodepoint
    local hasCjkText = cjk.hasCjkText
    local hasMultipleCodepoints = cjk.hasMultipleCodepoints

    local localizeTextValue
    local resolveTextInput

    local function getTextId(value)
        if type(value) ~= "table" then
            return nil
        end

        return value.id
    end

    local function isClassInstance(value)
        return type(value) == "table" and type(isClass) == "function" and isClass(value)
    end

    local function isColorTable(value)
        if type(value) ~= "table" or type(value[1]) ~= "number" then
            return false
        end

        for index = 2, 4 do
            if value[index] ~= nil and type(value[index]) ~= "number" then
                return false
            end
        end

        return value[5] == nil
    end

    local function isTextDescriptor(value)
        if type(value) ~= "table" or isClassInstance(value) or isColorTable(value) then
            return false
        end

        return getTextId(value) ~= nil or (value.text ~= nil and value[1] == nil)
    end

    local localizeDebugPatternText

    -- The debug item menu receives raw item fields instead of calling the Item
    -- accessors. Keep a lookup for those fields so framework items use the same
    -- translations as the inventory and battle menus.
    local itemTextLookup = {}
    local itemTextLookupBuilt = false
    local itemTextLookupRegistry = nil
    local itemTextLookupCount = 0

    local function getItemTextVariantSuffix(item)
        if item and item.id == "dark_candy" and item.name == "Darker Candy" then
            return "_darker"
        end
        return ""
    end

    local function addItemTextLookup(value, id, field, suffix)
        if type(value) ~= "string" or value == "" then
            return
        end

        local entries = itemTextLookup[value]
        if not entries then
            entries = {}
            itemTextLookup[value] = entries
        end

        for _, entry in ipairs(entries) do
            if entry.id == id and entry.field == field and entry.suffix == suffix then
                return
            end
        end

        table.insert(entries, {
            id = id,
            field = field,
            suffix = suffix,
        })
    end

    local function buildItemTextLookup()
        if not Registry or type(Registry.items) ~= "table" then
            return
        end

        local item_count = 0
        for _ in pairs(Registry.items) do
            item_count = item_count + 1
        end

        if itemTextLookupBuilt
            and itemTextLookupRegistry == Registry.items
            and itemTextLookupCount == item_count
        then
            return
        end

        itemTextLookup = {}
        itemTextLookupBuilt = item_count > 0
        itemTextLookupRegistry = Registry.items
        itemTextLookupCount = item_count

        for registry_id, item_data in pairs(Registry.items) do
            -- Registry entries are usually callable class tables, though
            -- extensions may register plain factory functions as well.
            if type(item_data) == "function" or type(item_data) == "table" then
                local ok, item = pcall(item_data)
                if ok and item then
                    local id = tostring(item.id or registry_id)
                    local suffix = getItemTextVariantSuffix(item)
                    addItemTextLookup(item.name, id, "name", suffix)
                    addItemTextLookup(item.description, id, "description", suffix)
                end
            end
        end
    end

    local function getItemTextLocalizationKey(text, field, preferred_id)
        if type(text) ~= "string" or type(field) ~= "string" or not Game then
            return nil
        end

        buildItemTextLookup()

        local entries = itemTextLookup[text]
        if not entries then
            return nil
        end

        local function findKey(entry)
            if entry.field ~= field or (preferred_id and entry.id ~= preferred_id) then
                return nil
            end

            local base = "item_" .. entry.id .. "_" .. field
            local chapter = tostring(Game.chapter or "")
            local suffix = entry.suffix or ""

            if chapter ~= "" and suffix ~= "" then
                local key = base .. "_chapter_" .. chapter .. suffix
                if Game:hasStr(key) then
                    return key, entry.id
                end
            end

            if chapter ~= "" then
                local key = base .. "_chapter_" .. chapter
                if Game:hasStr(key) then
                    return key, entry.id
                end
            end

            if suffix ~= "" then
                local key = base .. suffix
                if Game:hasStr(key) then
                    return key, entry.id
                end
            end

            if Game:hasStr(base) then
                return base, entry.id
            end

            return nil
        end

        if preferred_id then
            for _, entry in ipairs(entries) do
                local key = findKey(entry)
                if key then
                    return key, entry.id
                end
            end
        end

        for _, entry in ipairs(entries) do
            local key = findKey(entry)
            if key then
                return key, entry.id
            end
        end
    end

    local function localizeRawItemText(text, field, preferred_id)
        local key = getItemTextLocalizationKey(text, field, preferred_id)
        return key and Game:loc(key) or nil
    end

    local function localizeItemField(item, field)
        if not item then
            return nil
        end

        local raw = item[field]
        if type(raw) ~= "string" then
            return raw
        end

        return localizeRawItemText(raw, field, item.id) or raw
    end

    local function localizeStaticText(text)
        if type(text) ~= "string" or not Game or Game.lang ~= "zh_hans" then
            return text
        end

        local localized
        local id = STATIC_TEXT_IDS[text]
        if id then
            localized = Game:loc(id)
        else
            local space = text:match("^Space:(%d+)$")
            if space then
                localized = Game:loc("shop_space", { space = space })
            else
                local held_space = text:match("^HELD SPACE: (%d+)$")
                if held_space then
                    localized = Game:loc("shop_held_space", { space = held_space })
                else
                    local storage_space = text:match("^STORAGE SPACE: (%d+)$")
                    if storage_space then
                        localized = Game:loc("shop_storage_space", { space = storage_space })
                    else
                        local prefix, gameover_party_text = text:match("^(%[speed:0%.5%]%[spacing:%d+%]%[voice:[^%]]+%])(.*)$")
                        id = gameover_party_text and GAMEOVER_PARTY_TEXT_IDS[gameover_party_text]
                        if id then
                            localized = prefix .. Game:loc(id)
                        else
                            local slot = text:match("^Overwrite Slot (%d+)%?$")
                            if slot then
                                localized = Game:loc("save_menu_overwrite_slot", { slot = slot })
                            elseif localizeDebugPatternText then
                                localized = localizeDebugPatternText(text)
                            end
                        end
                    end
                end
            end
        end

        if not localized then
            localized = localizeRawItemText(text, "name")
                or localizeRawItemText(text, "description")
        end

        return runtime.applyOriginalDebugTermReplacements(localized or text)
    end

    local function localizeDebugTypeName(value)
        return localizeStaticText(tostring(value or ""))
    end

    localizeDebugPatternText = function(text)
        local state = text:match("^State: (.+)$")
        if state then
            return Game:loc("debug_battle_state", { state = state })
        end

        local substate = text:match("^Substate: (.+)$")
        if substate then
            return Game:loc("debug_battle_substate", { substate = substate })
        end

        local desc, state = text:match("^(.*) %((ON)%)$")
        if not desc then
            desc, state = text:match("^(.*) %((OFF)%)$")
        end
        if desc and state then
            return Game:loc("debug_bool_suffix", {
                desc = localizeStaticText(desc),
                state = Game:loc(state == "ON" and "on" or "off")
            })
        end

        local fps_text = text:match("^Set the target FPS%. %((.+)%)$")
        if fps_text then
            return Game:loc("debug_target_fps_current", {
                fps = localizeStaticText(fps_text)
            })
        end

        local fps = text:match("^Set the target FPS to ([%d%.]+)%.$")
        if fps then
            return Game:loc("debug_set_target_fps_value", { fps = fps })
        end

        local speed = text:match("^Set the fast forward speed to (x[%d%.]+) multiplier%.$")
        if speed then
            return Game:loc("debug_set_fast_forward_speed", {
                speed = speed
            })
        end

        local item_name = text:match("^(.*) %(Light Item%)$")
        if item_name then
            return Game:loc("debug_light_item_suffix", {
                name = localizeRawItemText(item_name, "name") or item_name
            })
        end

        local wave_count = text:match("^Remove this wave from the selected group%. (%(.+%))$")
        if wave_count then
            return Game:loc("debug_remove_wave_from_group", {
                count = wave_count
            })
        end

        wave_count = text:match("^Add this wave to the selected group%. (%(.+%))$")
        if wave_count then
            return Game:loc("debug_add_wave_to_group", {
                count = wave_count
            })
        end

        local member = text:match("^Give Spell to (.+)$")
        if member then
            return Game:loc("debug_give_spell_to", { member = member })
        end

        member = text:match("^Give this spell to (.+)%.$")
        if member then
            return Game:loc("debug_give_this_spell_to", { member = member })
        end

        member = text:match("^Take this spell from (.+)%.$")
        if member then
            return Game:loc("debug_take_this_spell_from", { member = member })
        end

        local border = text:match("^Switch to the border \"(.+)\"%.$")
        if border then
            return Game:loc("debug_switch_border", { border = border })
        end

        local flag_type = text:match("^Shows only ([%w_]+) flags%.$")
        if flag_type then
            return Game:loc("debug_show_only_flag_type", {
                type = localizeDebugTypeName(flag_type)
            })
        end

        local filter_action = text:match("^Filters to (hide) flags whose names match to\nthe FILTER QUERY$")
            or text:match("^Filters to (show) flags whose names match to\nthe FILTER QUERY$")
        if filter_action then
            return Game:loc("debug_filter_mode_match_description", {
                action = Game:loc(filter_action == "hide" and "debug_filter_action_hide" or "debug_filter_action_show")
            })
        end

        filter_action = text:match("^Filters to (hide) flags whose names start with\nthe FILTER QUERY$")
            or text:match("^Filters to (show) flags whose names start with\nthe FILTER QUERY$")
        if filter_action then
            return Game:loc("debug_filter_mode_starts_with_description", {
                action = Game:loc(filter_action == "hide" and "debug_filter_action_hide" or "debug_filter_action_show")
            })
        end

        local flag_kind, flag_name = text:match("^Edit Flag %(([%w_]+)%) %- \"(.+)\"$")
        if flag_kind and flag_name then
            return Game:loc("debug_edit_flag_title", {
                type = localizeDebugTypeName(flag_kind),
                name = flag_name
            })
        end

        local selected = text:match("^Selected: (.+)$")
        if selected then
            return Game:loc("debug_selected_object", { object = selected })
        end

        local x, y = text:match("^Mouse: %((%-?%d+), (%-?%d+)%)$")
        if x and y then
            return Game:loc("debug_mouse_position", { x = x, y = y })
        end

        x, y = text:match("^Position: %((%-?%d+), (%-?%d+)%)$")
        if x and y then
            return Game:loc("debug_object_position", { x = x, y = y })
        end

        x, y = text:match("^Screen Pos: %((%-?%d+), (%-?%d+)%)$")
        if x and y then
            return Game:loc("debug_object_screen_position", { x = x, y = y })
        end

        local world_id = text:match("^World ID: (.+)$")
        if world_id then
            return Game:loc("debug_world_id", { id = world_id })
        end

        return nil
    end

    local function localizeStaticTextValue(value)
        if type(value) == "table" then
            if isClassInstance(value) or isColorTable(value) then
                return value
            end

            if isTextDescriptor(value) then
                return localizeStaticTextValue(resolveTextInput(value))
            end

            local out = {}
            for key, item in pairs(value) do
                out[key] = localizeStaticTextValue(item)
            end
            return out
        end
        local static = localizeStaticText(value)
        if type(static) == "string" and Game and Game.lang == "zh_hans" then
            -- Combined messages are resolved line by line only when their
            -- source text has an explicit built-in mapping.
            if static:find("\n", 1, true) then
                local out = {}
                local matched = false
                for line in static:gmatch("[^\n]+") do
                    local trimmed_line = line:gsub("%s+$", "")
                    local localized = localizeStaticTextValue(trimmed_line)
                    if localized ~= trimmed_line then
                        matched = true
                    end
                    out[#out + 1] = localized
                end
                if matched then
                    return table.concat(out, "\n")
                end
            end
            local recovered = static:match("^%* You recovered (%d+) HP!$")
            if recovered then
                return Game:loc("heal_recovered", { amount = recovered })
            end
        end
        return static
    end

    local LIGHT_MENU_STATIC_TEXT_IDS = {
        ["ITEM"] = "light_menu_item",
        ["STAT"] = "light_menu_stat",
        ["CELL"] = "light_menu_cell",
        ["USE"] = "light_item_use",
        ["INFO"] = "light_item_info",
        ["DROP"] = "light_item_drop",
    }

    local function escapeLuaPattern(value)
        return (tostring(value):gsub("([^%w])", "%%%1"))
    end

    local function localizeLightMenuText(text)
        if isTextDescriptor(text) then
            text = resolveTextInput(text)
        end

        if type(text) ~= "string" or Game.lang ~= "zh_hans" then
            return text
        end

        local id = LIGHT_MENU_STATIC_TEXT_IDS[text]
        if id then
            return Game:loc(id)
        end

        local value = text:match("^AT  (.+)$")
        if value then
            return Game:loc("light_stat_attack", { value = value })
        end

        value = text:match("^DF  (.+)$")
        if value then
            return Game:loc("light_stat_defense", { value = value })
        end

        value = text:match("^EXP: (.+)$")
        if value then
            return Game:loc("light_stat_exp", { value = value })
        end

        value = text:match("^NEXT: (.+)$")
        if value then
            return Game:loc("light_stat_next", { value = value })
        end

        value = text:match("^WEAPON: (.+)$")
        if value then
            value = value == "None" and Game:loc("light_none") or value
            return Game:loc("light_stat_weapon", { value = value })
        end

        value = text:match("^ARMOR: (.+)$")
        if value then
            value = value == "None" and Game:loc("light_none") or value
            return Game:loc("light_stat_armor", { value = value })
        end

        local currency = tostring(Game:getConfig("lightCurrency") or ""):upper()
        if currency ~= "" then
            value = text:match("^" .. escapeLuaPattern(currency) .. ": (.+)$")
            if value then
                return Game:loc("light_stat_money", { value = value })
            end
        end

        return text
    end

    local function hookLightMenuDraw(menu_class)
        if not menu_class then
            return
        end

        HookSystem.hook(menu_class, "draw", function(orig, self, ...)
            local original_print = love.graphics.print
            love.graphics.print = function(text, ...)
                return original_print(localizeLightMenuText(text), ...)
            end

            local draw_args = {...}
            local unpack_args = table.unpack or unpack
            local ok, result = xpcall(function()
                return orig(self, unpack_args(draw_args))
            end, debug.traceback)
            love.graphics.print = original_print

            if not ok then
                error(result)
            end
            return result
        end)
    end

    local SHOP_STATIC_TEXT_IDS = {
        ["Buy"] = "shop_buy",
        ["Sell"] = "shop_sell",
        ["Talk"] = "shop_talk",
        ["Exit"] = "shop_exit",
        ["Return"] = "shop_return",
        ["Yes"] = "shop_yes",
        ["No"] = "shop_no",
        ["Sell Items"] = "shop_sell_items",
        ["Sell Weapons"] = "shop_sell_weapons",
        ["Sell Armor"] = "shop_sell_armor",
        ["Sell Pocket Items"] = "shop_sell_pocket_items",
    }

    local function localizeShopText(text)
        if isTextDescriptor(text) then
            text = resolveTextInput(text)
        end

        if type(text) ~= "string" or Game.lang ~= "zh_hans" then
            return text
        end

        local id = SHOP_STATIC_TEXT_IDS[text]
        if id then
            return Game:loc(id)
        end

        if text == "--SOLD OUT--" then
            return "--" .. Game:loc("shop_sold_out") .. "--"
        end

        return localizeStaticTextValue(resolveTextInput(text))
    end

    local function hookShopDraw(shop_class)
        if not shop_class then
            return
        end

        HookSystem.hook(shop_class, "draw", function(orig, self, ...)
            local original_print = love.graphics.print
            love.graphics.print = function(text, ...)
                return original_print(localizeShopText(text), ...)
            end

            local draw_args = {...}
            local unpack_args = table.unpack or unpack
            local ok, result = xpcall(function()
                return orig(self, unpack_args(draw_args))
            end, debug.traceback)
            love.graphics.print = original_print

            if not ok then
                error(result)
            end
            return result
        end)
    end

    local function localizeDynamicStaticTextValue(value)
        if type(value) == "function" then
            return function(...)
                return localizeStaticTextValue(resolveTextInput(value(...)))
            end
        elseif value ~= nil then
            return function()
                return localizeStaticTextValue(resolveTextInput(value))
            end
        end
        return value
    end

    local function refreshDebugOptionDescriptions()
        if not Kristal or not Kristal.DebugSystem or not Kristal.DebugSystem.menus then
            return
        end

        for _, menu in pairs(Kristal.DebugSystem.menus) do
            for _, option in ipairs(menu.options or {}) do
                if option.description and not option.__langlib_zh_description_wrapped then
                    option.description = localizeDynamicStaticTextValue(option.description)
                    option.__langlib_zh_description_wrapped = true
                end
            end
        end
    end

    local function getConsoleHistoryPlainText(line)
        if type(line) ~= "table" then
            return tostring(line or "")
        end

        local result = {}
        for _, part in ipairs(line) do
            if type(part) == "string" then
                table.insert(result, part)
            end
        end
        return table.concat(result)
    end

    local function parseConsoleHistoryLines(console, text)
        local history = console.history
        console.history = {}
        console:push(text)
        local parsed = console.history
        console.history = history
        return parsed
    end

    local function refreshConsoleStartupHistory()
        if not Kristal or not Kristal.Console or not Kristal.Console.history then
            return
        end

        local console = Kristal.Console
        if not console.__langlib_zh_startup_localized then
            local first = CONSOLE_STARTUP_MESSAGES[1]
            if getConsoleHistoryPlainText(console.history[first.index]) ~= first.plain then
                return
            end
        elseif not console.history[1] then
            return
        end

        for _, message in ipairs(CONSOLE_STARTUP_MESSAGES) do
            if console.history[message.index] then
                local parsed = parseConsoleHistoryLines(console, Game:loc(message.id))
                console.history[message.index] = parsed[1] or { "" }
            end
        end

        console.__langlib_zh_startup_localized = true
    end

    local function shouldPrintWithCjkSpacing(text)
        return type(text) == "string"
            and Game.lang == "zh_hans"
            and hasCjkText(text)
            and hasMultipleCodepoints(text)
    end

    local function getCjkPrintedTextWidth(font, text)
        local width = 0
        for _, codepoint in utf8.codes(text) do
            local char = utf8.char(codepoint)
            width = width + font:getWidth(char)
            if isCjkCodepoint(codepoint) then
                width = width + cjk.settings.cjkFixedTextSpacing
            end
        end
        return width
    end

    local function getPrintedLineWidth(font, text)
        text = tostring(text or "")
        if shouldPrintWithCjkSpacing(text) then
            return getCjkPrintedTextWidth(font, text)
        end
        return font:getWidth(text)
    end

    local function getPrintedTextWidth(font, text)
        local width = 0
        for line in (tostring(text or "") .. "\n"):gmatch("(.-)\n") do
            width = math.max(width, getPrintedLineWidth(font, line))
        end
        return width
    end

    local function printCjkTextWithSpacing(orig, text, x, y, r, sx, sy, ox, oy, kx, ky)
        text = localizeStaticTextValue(resolveTextInput(text))

        if not shouldPrintWithCjkSpacing(text) then
            return orig(text, x, y, r, sx, sy, ox, oy, kx, ky)
        end

        local font = love.graphics.getFont()
        local cursor_x = 0
        local cursor_y = 0

        love.graphics.push()
        love.graphics.translate(x or 0, y or 0)
        if r then
            love.graphics.rotate(r)
        end
        love.graphics.scale(sx or 1, sy or sx or 1)
        if kx or ky then
            love.graphics.shear(kx or 0, ky or 0)
        end
        love.graphics.translate(-(ox or 0), -(oy or 0))

        for _, codepoint in utf8.codes(text) do
            local char = utf8.char(codepoint)
            if char == "\n" then
                cursor_x = 0
                cursor_y = cursor_y + font:getHeight()
            else
                orig(char, cursor_x, cursor_y)
                cursor_x = cursor_x + font:getWidth(char)
                if isCjkCodepoint(codepoint) then
                    cursor_x = cursor_x + cjk.settings.cjkFixedTextSpacing
                end
            end
        end

        love.graphics.pop()
    end

    local function printfCjkTextWithSpacing(print_orig, printf_orig, text, x, y, limit, align, r, sx, sy, ox, oy, kx, ky)
        text = localizeStaticTextValue(resolveTextInput(text))

        if not shouldPrintWithCjkSpacing(text) or text:find("\n", 1, true) then
            return printf_orig(text, x, y, limit, align, r, sx, sy, ox, oy, kx, ky)
        end

        local font = love.graphics.getFont()
        local text_width = getCjkPrintedTextWidth(font, text)
        local print_x = x or 0
        limit = limit or text_width

        if align == "center" then
            print_x = print_x + ((limit - text_width) / 2)
        elseif align == "right" then
            print_x = print_x + limit - text_width
        end

        return printCjkTextWithSpacing(print_orig, text, print_x, y, r, sx, sy, ox, oy, kx, ky)
    end

    local function getLanguageList()
        local configured = getConfig("languages")
        local result = {}

        if type(configured) == "table" then
            for _, lang in ipairs(configured) do
                table.insert(result, normalizeLanguageId(lang))
            end
        end

        if #result == 0 then
            result = { "en", "zh_hans" }
        end

        if not listContains(result, FALLBACK_LANGUAGE) then
            table.insert(result, 1, FALLBACK_LANGUAGE)
        end

        return result
    end

    local function getLanguageName(lang)
        local names = getConfig("languageNames", true, true) or {}
        return names[lang] or names[normalizeLanguageId(lang)] or lang
    end

    local function collectNameLanguages(language_set, lang_table)
        if type(lang_table) ~= "table" or type(lang_table.names) ~= "table" then
            return
        end

        for _, entry in pairs(lang_table.names) do
            if type(entry) == "table" then
                for language, value in pairs(entry) do
                    if type(value) == "string" then
                        language_set[normalizeLanguageId(language)] = true
                    end
                end
            end
        end
    end

    local function getNameLanguageList()
        local available = {}
        collectNameLanguages(available, Game.langBaseStr)
        collectNameLanguages(available, Game.langStr)

        local configured = getConfig("nameLanguages")
        if type(configured) ~= "table" then
            configured = getLanguageList()
        end

        local result = {}
        local seen = {}
        local function add(language)
            language = normalizeLanguageId(language)
            if available[language] and not seen[language] then
                table.insert(result, language)
                seen[language] = true
            end
        end

        for _, language in ipairs(configured) do
            add(language)
        end

        local remaining = {}
        for language in pairs(available) do
            if not seen[language] then
                table.insert(remaining, language)
            end
        end
        table.sort(remaining)
        for _, language in ipairs(remaining) do
            table.insert(result, language)
        end

        if #result == 0 then
            table.insert(result, FALLBACK_LANGUAGE)
        end
        return result
    end

    local function getDefaultNameLanguage(available)
        local configured = getConfig("defaultNameLanguage")
        configured = configured or (Game and Game.lang) or FALLBACK_LANGUAGE

        return matchAvailableLanguage(normalizeNameLanguage(configured, Game and Game.lang), available)
            or matchAvailableLanguage(Game and Game.lang or FALLBACK_LANGUAGE, available)
            or matchAvailableLanguage(FALLBACK_LANGUAGE, available)
            or available[1]
            or FALLBACK_LANGUAGE
    end

    local function getNameLanguageIndex(language)
        for index, available in ipairs(Game.langNameLanguages or {}) do
            if available == language then
                return index
            end
        end
        return 1
    end

    local function ensureNameLanguageGlobals()
        Game.langNameLanguages = getNameLanguageList()
        -- A player's saved or selected language takes precedence over config.
        local requested = getStartupNameLanguage()
            or Game.langNameLanguage
            or getConfig("defaultNameLanguage")
            or Game.lang
        Game.langNameLanguage = matchAvailableLanguage(
            normalizeNameLanguage(requested, Game.lang),
            Game.langNameLanguages
        ) or getDefaultNameLanguage(Game.langNameLanguages)
        Game.langNameLanguageSelected = getNameLanguageIndex(Game.langNameLanguage)
    end

    local function ensureLanguageGlobals()
        Game.langAvailable = getLanguageList()

        Game.lang = resolveLanguageId(getStartupLanguage() or Game.lang or getConfig("defaultLanguage") or DEFAULT_LANGUAGE, Game.langAvailable)
            or getDefaultLanguage(Game.langAvailable)
        if Game.langDebugTermsTranslated == nil then
            Game.langDebugTermsTranslated = true
        end

        Game.langSelected = Game.langSelected or 1
        for index, lang in ipairs(Game.langAvailable) do
            if lang == Game.lang then
                Game.langSelected = index
                break
            end
        end

        ensureNameLanguageGlobals()
    end

    local function readJsonIfExists(path)
        if love.filesystem.getInfo(path) then
            local raw = love.filesystem.read(path)
            if raw and raw ~= "" then
                return JSON.decode(raw)
            end
        end
        return nil
    end

    local function langFileCandidates(base_path, lang)
        return {
            base_path .. "/lang/" .. lang .. ".json",
            base_path .. "/lang/lang_" .. lang .. ".json",
            base_path .. "/lang/" .. lang:gsub("_", "-") .. ".json",
            base_path .. "/lang/lang_" .. lang:gsub("_", "-") .. ".json",
        }
    end

    local function nameFileCandidates(base_path)
        return {base_path .. "/lang/names.json"}
    end

    local function mergeLangTable(merged, lang_data)
        for key, value in pairs(lang_data or {}) do
            merged[key] = value
        end
    end

    local function mergeNameTable(merged, name_data)
        if type(name_data) ~= "table" then
            return
        end

        merged.names = merged.names or {}
        for raw_id, languages in pairs(name_data) do
            local id = normalizeNameId(raw_id)
            if type(languages) == "table" then
                local entry = merged.names[id] or {}
                for language, value in pairs(languages) do
                    if type(value) == "string" then
                        entry[normalizeLanguageId(language)] = value
                    end
                end
                merged.names[id] = entry
            end
        end
    end

    local function loadLangTable(lang)
        local merged = {}
        local bases = {}

        if library.info and library.info.path then
            table.insert(bases, library.info.path)
        end
        if Mod and Mod.info and Mod.info.path then
            table.insert(bases, Mod.info.path)
        end

        for _, base in ipairs(bases) do
            for _, path in ipairs(langFileCandidates(base, lang)) do
                local lang_data = readJsonIfExists(path)
                if type(lang_data) == "table" then
                    mergeLangTable(merged, lang_data)
                    break
                end
            end

            for _, path in ipairs(nameFileCandidates(base)) do
                local name_data = readJsonIfExists(path)
                if type(name_data) == "table" then
                    mergeNameTable(merged, name_data)
                    break
                end
            end
        end

        return merged
    end

    local function getNameEntry(lang_table, id)
        if type(lang_table) ~= "table" or type(lang_table.names) ~= "table" then
            return nil
        end

        local normalized_id = normalizeNameId(id)
        return lang_table.names[id] or lang_table.names[normalized_id]
    end

    local function getNameEntryValue(entry, primary_language, fallback_language)
        if type(entry) == "table" then
            return entry[primary_language] or entry[fallback_language]
        end
        return nil
    end

    local function getNameFromTable(lang_table, id, primary_language, fallback_language)
        return getNameEntryValue(getNameEntry(lang_table, id), primary_language, fallback_language)
    end

    local function resolveName(id, default)
        ensureLanguageGlobals()

        id = normalizeNameId(id)
        local primary_language = Game.langNameLanguage or FALLBACK_LANGUAGE
        local fallback_language = FALLBACK_LANGUAGE

        return getNameFromTable(Game.langStr, id, primary_language, fallback_language)
            or getNameFromTable(Game.langBaseStr, id, primary_language, fallback_language)
            or tostring(default or id) .. " is missing"
    end

    local function replaceNameReferences(str)
        return (str:gsub("%[name:([^:%]]+)%]", function(id)
            return resolveName(id, id)
        end))
    end

    local function resolveIdInterpolation(text, var)
        if type(text) ~= "string" or not text:find("{", 1, true) then
            return text
        end
        return (text:gsub(ID_INTERP_PATTERN, function(id)
            return Game:loc(id, var)
        end))
    end

    localizeTextValue = function(value, id, var)
        if isClassInstance(value) or isColorTable(value) then
            return value
        end

        if isTextDescriptor(value) then
            local descriptor_id = getTextId(value)
            if descriptor_id ~= nil then
                id = descriptor_id
            end
            local descriptor_options = value.options or {}
            if descriptor_options.var ~= nil then
                var = descriptor_options.var
            elseif value.var ~= nil then
                var = value.var
            end
            value = value.text
        end

        if type(id) == "table" then
            local out = {}
            if type(value) == "table" then
                for key, item in pairs(value) do
                    out[key] = localizeTextValue(item, id[key], var)
                end
            else
                for key, child_id in pairs(id) do
                    out[key] = localizeTextValue(nil, child_id, var)
                end
            end
            return out
        end

        -- A single ID describes the complete value, including a list of lines.
        if id ~= nil then
            return Game:loc(id, var)
        end

        if type(value) == "table" then
            local out = {}
            for key, item in pairs(value) do
                out[key] = localizeTextValue(item, nil, var)
            end
            return out
        end

        if value == nil then
            return ""
        end
        return Game:locText(value, var)
    end

    local function mergeTextOptions(base, override)
        local result = tableCopy(base)
        for key, value in pairs(override or {}) do
            result[key] = value
        end
        return result
    end

    local function extractTextDescriptor(value, options)
        if not isTextDescriptor(value) then
            return value, options or {}
        end

        local descriptor_options = tableCopy(options)
        for key, item in pairs(value.options or {}) do
            descriptor_options[key] = item
        end
        for key, item in pairs(value) do
            if key ~= "text" and key ~= "options" and type(key) ~= "number"
                and key ~= "choices" and key ~= "ids"
            then
                descriptor_options[key] = item
            end
        end

        if value.ids ~= nil then
            descriptor_options.ids = value.ids
        end
        return value.text, descriptor_options
    end

    local function stripTextOptions(options)
        local result = {}
        for key, value in pairs(options or {}) do
            if key ~= "id" and key ~= "ids" and key ~= "var"
            then
                result[key] = value
            end
        end
        return result
    end

    resolveTextInput = function(value, options)
        value, options = extractTextDescriptor(value, options)

        if isClassInstance(value) or isColorTable(value) then
            return value, stripTextOptions(options)
        end

        local id = getTextId(options)
        if id ~= nil then
            value = localizeTextValue(value, id, options.var)
        elseif type(value) == "table" or options.var ~= nil then
            value = localizeTextValue(value, nil, options.var)
        elseif value == nil then
            value = ""
        end

        if type(value) == "string" then
            value = resolveIdInterpolation(value, options.var)
        end

        return value, stripTextOptions(options)
    end

    local function normalizeCutsceneTextArgs(text, portrait, actor, options)
        if type(actor) == "table" and not isClassInstance(actor) then
            options = mergeTextOptions(actor, options)
            actor = nil
        end
        if type(portrait) == "table" and not isClassInstance(portrait) then
            options = mergeTextOptions(portrait, options)
            portrait = nil
        end

        text, options = resolveTextInput(text, options)
        return text, portrait, actor, options
    end

    local function getListLength(value)
        local length = 0
        for key in pairs(value or {}) do
            if type(key) == "number" and key > length then
                length = key
            end
        end
        return length
    end

    local function normalizeChoices(choices, options)
        options = options or {}

        if type(choices) == "table" and (choices.choices ~= nil
            or choices.ids ~= nil)
        then
            local descriptor_options = {}
            for key, value in pairs(choices) do
                if key ~= "choices" and key ~= "ids"
                    and type(key) ~= "number"
                then
                    descriptor_options[key] = value
                end
            end
            descriptor_options.ids = choices.ids
            options = mergeTextOptions(descriptor_options, options)
            choices = choices.choices
        elseif isTextDescriptor(choices) then
            choices = { choices }
        end

        if type(choices) ~= "table" then
            choices = choices == nil and {} or { choices }
        end

        local ids = options.ids
        if type(ids) == "string" then
            ids = { ids }
        end

        local count = math.max(getListLength(choices), getListLength(ids))
        local localized = {}
        for index = 1, count do
            local id = ids and ids[index]
            if id ~= nil then
                if isTextDescriptor(id) then
                    localized[index] = resolveTextInput(id, { var = options.var })
                else
                    localized[index] = Game:loc(id, options.var)
                end
            elseif choices[index] ~= nil then
                localized[index] = resolveTextInput(choices[index], { var = options.var })
            end
        end

        return localized, stripTextOptions(options)
    end

    local function normalizeTextChoiceArgs(text, choices, portrait, actor, options)
        if type(actor) == "table" and not isClassInstance(actor) then
            options = mergeTextOptions(actor, options)
            actor = nil
        end
        if type(portrait) == "table" and not isClassInstance(portrait) then
            options = mergeTextOptions(portrait, options)
            portrait = nil
        end

        local descriptor_choices
        if type(text) == "table" and choices == nil then
            descriptor_choices = text.choices
        end

        local text_options
        text, text_options = extractTextDescriptor(text, options)
        choices = choices or descriptor_choices or {}
        local localized_text = resolveTextInput(text, text_options)
        local localized_choices, clean_options = normalizeChoices(choices, text_options)
        return localized_text, localized_choices, portrait, actor, clean_options
    end

    M.getTextId = getTextId
    M.isClassInstance = isClassInstance
    M.isColorTable = isColorTable
    M.isTextDescriptor = isTextDescriptor
    M.getItemTextLocalizationKey = getItemTextLocalizationKey
    M.localizeRawItemText = localizeRawItemText
    M.localizeItemField = localizeItemField
    M.localizeStaticText = localizeStaticText
    M.localizeStaticTextValue = localizeStaticTextValue
    M.localizeDynamicStaticTextValue = localizeDynamicStaticTextValue
    M.localizeTextValue = localizeTextValue
    M.resolveTextInput = resolveTextInput
    M.mergeTextOptions = mergeTextOptions
    M.normalizeCutsceneTextArgs = normalizeCutsceneTextArgs
    M.normalizeChoices = normalizeChoices
    M.normalizeTextChoiceArgs = normalizeTextChoiceArgs
    M.hookLightMenuDraw = hookLightMenuDraw
    M.hookShopDraw = hookShopDraw
    M.refreshDebugOptionDescriptions = refreshDebugOptionDescriptions
    M.refreshConsoleStartupHistory = refreshConsoleStartupHistory
    M.shouldPrintWithCjkSpacing = shouldPrintWithCjkSpacing
    M.getCjkPrintedTextWidth = getCjkPrintedTextWidth
    M.getPrintedTextWidth = getPrintedTextWidth
    M.printCjkTextWithSpacing = printCjkTextWithSpacing
    M.printfCjkTextWithSpacing = printfCjkTextWithSpacing
    M.getLanguageList = getLanguageList
    M.getLanguageName = getLanguageName
    M.getNameLanguageList = getNameLanguageList
    M.getDefaultNameLanguage = getDefaultNameLanguage
    M.getNameLanguageIndex = getNameLanguageIndex
    M.ensureNameLanguageGlobals = ensureNameLanguageGlobals
    M.ensureLanguageGlobals = ensureLanguageGlobals
    M.loadLangTable = loadLangTable
    M.resolveName = resolveName
    M.replaceNameReferences = replaceNameReferences
    M.resolveIdInterpolation = resolveIdInterpolation
    return M
end
