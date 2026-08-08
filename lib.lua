local kristalI18n = {}

local DEFAULT_LANGUAGE = "en"
local FALLBACK_LANGUAGE = "en"
local AUTO_LANGUAGE = "auto"
local CJK_FIXED_TEXT_SPACING = 4
local CJK_DIALOGUE_TEXT_SPACING = 4
local CJK_DIALOGUE_Y_OFFSET = -1
local CJK_TYPEWRITER_SPEED_MULTIPLIER = 1 --0.85

-- Runtime CJK layout values, overridable via config (see loadCjkConfig).
local cjkFixedTextSpacing = CJK_FIXED_TEXT_SPACING
local cjkDialogueTextSpacing = CJK_DIALOGUE_TEXT_SPACING
local cjkDialogueYOffset = CJK_DIALOGUE_Y_OFFSET
local cjkTypewriterSpeedMultiplier = CJK_TYPEWRITER_SPEED_MULTIPLIER
local DEFAULT_LANGUAGE_TOGGLE_KEY = "f7"
local ID_INTERP_PATTERN = "%{([%w_./]*[a-zA-Z][%w_./]*)%}"

local STATIC_TEXT_IDS = {
    ["~ KRISTAL DEBUG ~"] = "debug_menu_title",
    ["Welcome to [color:cyan]KRISTAL[color:reset]! This is the debug console."] = "console_welcome",
    ["You can enter Lua here to be ran! Use [color:gray]clear()[color:reset] to clear the console."] = "console_lua_hint",
    ["Engine Options"] = "debug_engine_options",
    ["Show FPS"] = "debug_show_fps",
    ["Toggle the FPS display."] = "debug_toggle_fps_display",
    ["Target FPS"] = "debug_target_fps",
    ["VSync"] = "debug_vsync",
    ["Toggle Vsync."] = "debug_toggle_vsync",
    ["Frame Skip"] = "debug_frame_skip",
    ["Toggle frame skipping."] = "debug_toggle_frame_skip",
    ["Print Performance"] = "debug_print_performance",
    ["Show performance in the console."] = "debug_show_performance",
    ["Force GC"] = "debug_force_gc",
    ["Force a garbage collection."] = "debug_force_gc_description",
    ["Force Crash"] = "debug_force_crash",
    ["Force a crash."] = "debug_force_crash_description",
    ["Back"] = "debug_back",
    ["Go back to the previous menu."] = "debug_back_description",
    ["Unlimited"] = "debug_unlimited",
    ["Set the target FPS to unlimited."] = "debug_set_target_fps_unlimited",
    ["Custom"] = "debug_custom",
    ["Set the target FPS to a custom value."] = "debug_set_target_fps_custom",
    ["Enter FPS"] = "debug_enter_fps",
    ["Enter the target FPS youd like."] = "debug_enter_fps_description",
    ["Fast Forward"] = "debug_fast_forward",
    ["[Toggle]"] = "debug_toggle",
    ["Speed up the engine."] = "debug_speed_up_engine",
    ["Give Item"] = "debug_give_item",
    ["Select Map"] = "debug_select_map",
    ["Teleport to this map."] = "debug_teleport_to_map",
    ["Encounter Select"] = "debug_encounter_select",
    ["Start this encounter."] = "debug_start_this_encounter",
    ["Enter Shop"] = "debug_enter_shop",
    ["Enter this shop."] = "debug_enter_this_shop",
    ["Cutscene Select"] = "debug_cutscene_select",
    ["[Stop Current Cutscene]"] = "debug_stop_current_cutscene",
    ["Stop the current playing cutscene."] = "debug_stop_current_cutscene_description",
    ["Start this cutscene."] = "debug_start_this_cutscene",
    ["Legend Select"] = "debug_legend_select",
    ["[Stop Current Legend]"] = "debug_stop_current_legend",
    ["Stop the current playing Legend."] = "debug_stop_current_legend_description",
    ["Start this legend."] = "debug_start_this_legend",
    ["Wave Select"] = "debug_wave_select",
    ["[Stop Current Wave]"] = "debug_stop_current_wave",
    ["Stop the current playing wave."] = "debug_stop_current_wave_description",
    ["Start this wave."] = "debug_start_this_wave",
    ["Multiple Wave Select"] = "debug_multiple_wave_select",
    ["[Start Waves]"] = "debug_start_waves",
    ["Start the selected waves."] = "debug_start_selected_waves",
    ["[Clear Selection]"] = "debug_clear_selection",
    ["Clear the currently selected waves."] = "debug_clear_selected_waves",
    ["Sound Test"] = "debug_sound_test",
    ["Play this sound."] = "debug_play_this_sound",
    ["Music Test"] = "debug_music_test",
    ["Play this music track."] = "debug_play_this_music",
    ["Change Party"] = "debug_change_party",
    ["Add or remove this party member from the party."] = "debug_change_party_description",
    ["Give Spell"] = "debug_give_spell",
    ["Give a spell to this party member."] = "debug_give_spell_to_member",
    ["Border Test"] = "debug_border_test",
    ["Configure various noningame options."] = "debug_engine_options_description",
    ["Selection Timestop"] = "debug_selection_timestop",
    ["Pauses the game when the object selection menu is opened."] = "debug_selection_timestop_description",
    ["Debug Rendering"] = "debug_rendering",
    ["Draw debug information."] = "debug_rendering_description",
    ["Debug Mode Terminology"] = "debug_terminology",
    ["Translate debug mode terminology."] = "debug_translate_terminology",
    ["- KEYS -"] = "debug_battle_keys",
    ["CTRL+H - heal party"] = "debug_battle_heal_party",
    ["CTRL+Y - win battle"] = "debug_battle_win_battle",
    ["CTRL+M - pause/resume music"] = "debug_battle_pause_resume_music",
    ["CTRL+F - end current wave"] = "debug_battle_end_current_wave",
    ["CTRL+B - kill party"] = "debug_battle_kill_party",
    ["CTRL+K - fill tension"] = "debug_battle_fill_tension",
    ["CTRL+N - toggle noclip"] = "debug_battle_toggle_noclip",
    ["~ OBJECT SELECTION ~"] = "debug_object_selection_title",
    ["Hotswap"] = "debug_hotswap",
    ["Swap out code from the files. Might be unstable."] = "debug_hotswap_description",
    ["Reload"] = "debug_reload",
    ["Reload the mod."] = "debug_reload_mod",
    ["Reload (tempsave)"] = "debug_reload_tempsave",
    ["Reload the mod, creating a temporary save."] = "debug_reload_tempsave_description",
    ["Reload (from save)"] = "debug_reload_from_save",
    ["Reload the mod from your current save."] = "debug_reload_from_save_description",
    ["Reload the engine."] = "debug_reload_engine",
    ["Noclip"] = "debug_noclip",
    ["Toggle interaction with solids."] = "debug_noclip_description",
    ["Give an item."] = "debug_give_item_description",
    ["Give Money"] = "debug_give_money",
    ["Give an amount of money."] = "debug_give_money_description",
    ["Enter Money"] = "debug_enter_money",
    ["Enter the money amount you'd like."] = "debug_enter_money_description",
    ["Portrait Viewer"] = "debug_portrait_viewer",
    ["Enter the portrait viewer menu."] = "debug_portrait_viewer_description",
    ["Flag Editor"] = "debug_flag_editor",
    ["Enter the flag editor menu."] = "debug_flag_editor_description",
    ["Enter the sound test menu."] = "debug_sound_test_description",
    ["Enter the music test menu."] = "debug_music_test_description",
    ["Enter the party change menu."] = "debug_change_party_menu_description",
    ["Enter the border test menu."] = "debug_border_test_description",
    ["Give a spell to a party member."] = "debug_give_spell_description",
    ["Switch to a new map."] = "debug_switch_map_description",
    ["Start Encounter"] = "debug_start_encounter",
    ["Start an encounter."] = "debug_start_encounter_description",
    ["Enter a shop."] = "debug_enter_shop_description",
    ["Play Cutscene"] = "debug_play_cutscene",
    ["Play a cutscene."] = "debug_play_cutscene_description",
    ["Play Legend"] = "debug_play_legend",
    ["Play a legend cutscene."] = "debug_play_legend_description",
    ["Start Wave"] = "debug_start_wave",
    ["Start a wave."] = "debug_start_wave_description",
    ["Start Multiple Waves"] = "debug_start_multiple_waves",
    ["Start multiple waves at once."] = "debug_start_multiple_waves_description",
    ["End Battle"] = "debug_end_battle",
    ["Instantly complete a battle."] = "debug_end_battle_description",
    ["Press CONFIRM to search"] = "debug_press_confirm_search",
    ["~ PORTRAIT VIEWER ~"] = "debug_portrait_viewer_title",
    ["Press CONFIRM to go back."] = "debug_press_confirm_back",
    ["Copied to clipboard!"] = "debug_copied_to_clipboard",
    ["~ FLAG EDITOR ~"] = "debug_flag_editor_title",
    ["Press CANCEL to go back."] = "debug_press_cancel_back",
    ["Set a filter to customise what flags are shown."] = "debug_filter_settings_description",
    ["Filter Settings"] = "debug_filter_settings",
    ["~ FLAG EDITOR - FILTER SETTINGS ~"] = "debug_flag_filter_title",
    ["Flag type:"] = "debug_flag_type_label",
    ["Filter query:"] = "debug_filter_query_label",
    ["Filter Mode:"] = "debug_filter_mode_label",
    ["Reset Filter"] = "debug_reset_filter",
    ["Save and Return"] = "debug_save_and_return",
    ["Press CANCEL to go back without saving."] = "debug_press_cancel_back_no_save",
    ["Shows all flag types."] = "debug_show_all_flag_types",
    ["A query to filter flags by.\nSet FILTER MODE to change how this value is used."] = "debug_filter_query_description",
    ["Resets the filter to it's default settings."] = "debug_reset_filter_description",
    ["Enter a new value for this flag."] = "debug_enter_flag_value",
    ["any"] = "debug_flag_type_any",
    ["boolean"] = "debug_flag_type_boolean",
    ["string"] = "debug_flag_type_string",
    ["number"] = "debug_flag_type_number",
    ["pattern"] = "debug_filter_mode_pattern",
    ["invert_pattern"] = "debug_filter_mode_invert_pattern",
    ["startsWith"] = "debug_filter_mode_starts_with",
    ["invert_startsWith"] = "debug_filter_mode_invert_starts_with",
    ["Debug"] = "debug_context_title",
    ["Teleport"] = "debug_context_teleport",
    ["Teleport the player to\nthe current position."] = "debug_context_teleport_description",
    ["Spawn player"] = "debug_context_spawn_player",
    ["Spawn the player at the\ncurrent position."] = "debug_context_spawn_player_description",
    ["Paste"] = "debug_context_paste",
    ["Paste the copied object."] = "debug_context_paste_description",
    ["Select object"] = "debug_context_select_object",
    ["Select an object by name."] = "debug_context_select_object_description",
    ["Select Object"] = "debug_window_select_object",
    ["Enter the name of the object to select."] = "debug_window_select_object_description",
    ["Delete"] = "debug_context_delete",
    ["Delete this object"] = "debug_context_delete_description",
    ["Clone"] = "debug_context_clone",
    ["Clone this object"] = "debug_context_clone_description",
    ["Copy"] = "debug_context_copy",
    ["Copy this object to paste it later"] = "debug_context_copy_description",
    ["Cut"] = "debug_context_cut",
    ["Cut this object to paste it later"] = "debug_context_cut_description",
    ["Paste Into"] = "debug_context_paste_into",
    ["Paste the copied object into this one"] = "debug_context_paste_into_description",
    ["Hide"] = "debug_context_hide",
    ["Hide this object."] = "debug_context_hide_description",
    ["Show"] = "debug_context_show",
    ["Show this object."] = "debug_context_show_description",
    ["Explode"] = "debug_context_explode",
    ["'cuz it's funny"] = "debug_context_explode_description",
    ["Toggle force run"] = "debug_context_toggle_force_run",
    ["Toggle if the player is forced to run or not"] = "debug_context_toggle_force_run_description",
    ["Toggle force walk"] = "debug_context_toggle_force_walk",
    ["Toggle if the player is forced to walk or not"] = "debug_context_toggle_force_walk_description",
    ["Toggle force climb"] = "debug_context_toggle_force_climb",
    ["Toggle if the player is forced to climb or not"] = "debug_context_toggle_force_climb_description",
    ["Start climbing"] = "debug_context_start_climbing",
    ["Start climbing where the player currently is."] = "debug_context_start_climbing_description",
    ["Start walking"] = "debug_context_start_walking",
    ["Start walking where the player currently is."] = "debug_context_start_walking_description",
    ["Start sliding"] = "debug_context_start_sliding",
    ["Start sliding where the player currently is."] = "debug_context_start_sliding_description",
    ["Change"] = "debug_context_change",
    ["Change this portrait to a different one"] = "debug_context_change_portrait_description",
    ["Message Box"] = "debug_window_message_box",
    ["Cancel"] = "debug_window_cancel",
    ["OK"] = "debug_window_ok",
    ["Save"] = "save_menu_save",
    ["Return"] = "save_menu_return",
    ["Storage"] = "save_menu_storage",
    ["STORAGE"] = "storage_storage",
    ["(Tired)"] = "battle_tired_comment",
    ["MERCY"] = "battle_mercy_label",
    ["NO SPACE"] = "shop_no_space",
    ["Recruits"] = "save_menu_recruits",
    ["File Saved"] = "save_menu_file_saved",
    ["File saved."] = "save_menu_file_saved_period",
    ["New File"] = "save_menu_new_file",
    ["Return to Title"] = "save_menu_return_to_title",
    ["Really return to title?"] = "save_menu_really_return_to_title",
    ["* You re-applied the bandage."] = "item_light/bandage_use",
    ["* You looked at the junk ball in\nadmiration.[wait:5]\n* Nothing happened."] = "item_light/ball_of_junk_use",
    ["* You really didn't want to throw\nit away."] = "item_light/ball_of_junk_toss_chapter_1",
    ["* You took it from your pocket.[wait:5]\n* You have a [color:yellow]very,[wait:5] very,[wait:5] bad\nfeeling[color:reset] about throwing it away."] = "item_light/ball_of_junk_toss_intro",
    ["* Throw it away anyway?"] = "item_light/ball_of_junk_toss_confirm",
    ["* Hand shaking,[wait:5] you dropped the\nball of junk on the ground."] = "item_light/ball_of_junk_toss_drop",
    ["* It broke into pieces."] = "item_light/ball_of_junk_toss_broken",
    ["* You felt bitter."] = "item_light/ball_of_junk_toss_bitter",
    ["* You felt a feeling of relief."] = "item_light/ball_of_junk_toss_relief",
    ["Yes"] = "yes",
    ["No"] = "no",
    ["YES"] = "yes",
    ["NO"] = "no",
    ["CONTINUE"] = "gameover_continue",
    ["GIVE UP"] = "gameover_give_up",
    ["[speed:0.5][spacing:8][voice:none]IT APPEARS YOU\nHAVE REACHED[wait:30]\n\n   AN END."] = "gameover_end",
    ["[speed:0.5][spacing:8][voice:none]WILL YOU TRY AGAIN?"] = "gameover_try_again",
    ["[speed:0.5][spacing:8][voice:none]WILL YOU PERSIST?"] = "gameover_persist",
    ["[noskip][speed:0.5][spacing:8][voice:none] THEN, THE FUTURE\n IS IN YOUR HANDS."] = "gameover_future",
    ["[noskip][speed:0.5][spacing:8][voice:none] THEN THE WORLD[wait:30] \n WAS COVERED[wait:30] \n IN DARKNESS."] = "gameover_darkness",
    ["Useless\nanalysis"] = "act_check_useless_analysis",
    ['Whether the "Check" act in battle says "Useless analysis" or not'] = "mod_config_check_act_description_description",
}

local GAMEOVER_PARTY_TEXT_IDS = {
    ["  Come on,[wait:5]\n  that all you got!?"] = "gameover_susie_challenge",
    ["  Kris,[wait:5]\n  get up...!"] = "gameover_susie_get_up",
    ["  This is not\n  your fate...!"] = "gameover_ralsei_fate",
    ["  Please,[wait:5]\n  don't give up!"] = "gameover_ralsei_dont_give_up",
}

local CONSOLE_STARTUP_MESSAGES = {
    {
        index = 1,
        plain = "Welcome to KRISTAL! This is the debug console.",
        id = "console_welcome",
    },
    {
        index = 2,
        plain = "You can enter Lua here to be ran! Use clear() to clear the console.",
        id = "console_lua_hint",
    },
}

local function getConfig(key, merge, deep_merge)
    if Kristal and Kristal.getLibConfig then
        local ok, value = pcall(Kristal.getLibConfig, "kristalI18n", key, merge, deep_merge)
        if ok and value ~= nil then
            return value
        end
    end
end

local function loadCjkConfig()
    cjkFixedTextSpacing = getConfig("cjkFixedTextSpacing") or CJK_FIXED_TEXT_SPACING
    cjkDialogueTextSpacing = getConfig("cjkDialogueTextSpacing") or CJK_DIALOGUE_TEXT_SPACING
    cjkDialogueYOffset = getConfig("cjkDialogueYOffset") or CJK_DIALOGUE_Y_OFFSET
    cjkTypewriterSpeedMultiplier = getConfig("cjkTypewriterSpeedMultiplier") or CJK_TYPEWRITER_SPEED_MULTIPLIER
end

local function tableCopy(tbl)
    local out = {}
    for k, v in pairs(tbl or {}) do
        out[k] = v
    end
    return out
end

local function deepMerge(target, source)
    for key, value in pairs(source or {}) do
        if type(value) == "table" and type(target[key]) == "table" then
            deepMerge(target[key], value)
        else
            target[key] = value
        end
    end
    return target
end

local function listContains(list, value)
    for _, item in ipairs(list or {}) do
        if item == value then
            return true
        end
    end
    return false
end

local function normalizeLanguageId(lang)
    lang = tostring(lang or DEFAULT_LANGUAGE)
    lang = lang:lower()
    lang = lang:gsub("-", "_")
    lang = lang:gsub("%..*$", "")
    lang = lang:gsub("@.*$", "")
    return lang
end

local function normalizeNameId(id)
    id = tostring(id or "")
    id = id:lower()
    id = id:gsub("-", "_")
    return id
end

local function normalizeNameLanguage(language, fallback_language)
    return normalizeLanguageId(language or fallback_language or FALLBACK_LANGUAGE)
end

local ORIGINAL_TERM_REPLACEMENTS = {
    { translated = "传说过场", original = "legend cutscene" },
    { translated = "波次", original = "wave" },
    { translated = "遭遇战", original = "encounter" },
    { translated = "过场", original = "cutscene" },
    { translated = "传说", original = "legend" },
    { translated = "战斗", original = "battle" },
    { translated = "对象", original = "object" },
    { translated = "调试", original = "debug" },
}

local function applyOriginalDebugTermReplacements(value)
    if type(value) ~= "string"
        or not Game
        or Game.lang ~= "zh_hans"
        or Game.langDebugTermsTranslated ~= false
    then
        return value
    end

    for _, term in ipairs(ORIGINAL_TERM_REPLACEMENTS) do
        value = value:gsub(term.translated, term.original)
    end
    return value
end

local function addLanguageCandidate(candidates, seen, lang)
    lang = normalizeLanguageId(lang)
    if lang ~= "" and not seen[lang] then
        table.insert(candidates, lang)
        seen[lang] = true
    end
end

local function getLocaleCandidates(locale)
    local candidates = {}
    local seen = {}
    local normalized = normalizeLanguageId(locale)

    addLanguageCandidate(candidates, seen, normalized)

    local base = normalized:match("^([a-z]+)")
    if base == "zh" then
        if normalized:find("hant") or normalized:find("_tw") or normalized:find("_hk") or normalized:find("_mo") then
            addLanguageCandidate(candidates, seen, "zh_hant")
        else
            addLanguageCandidate(candidates, seen, "zh_hans")
        end
    end

    if base then
        addLanguageCandidate(candidates, seen, base)
    end

    return candidates
end

local function matchAvailableLanguage(lang, available)
    local normalized = normalizeLanguageId(lang)

    for _, candidate in ipairs(getLocaleCandidates(normalized)) do
        if listContains(available, candidate) then
            return candidate
        end
    end

    local base = normalized:match("^([a-z]+)")
    if base then
        for _, available_lang in ipairs(available or {}) do
            if available_lang:match("^" .. base .. "_") then
                return available_lang
            end
        end
    end

    return nil
end

local function addLocale(locales, value)
    if type(value) == "string" then
        for locale in value:gmatch("[^:]+") do
            if locale ~= "" and locale ~= "C" and locale ~= "POSIX" then
                table.insert(locales, locale)
            end
        end
    elseif type(value) == "table" then
        for _, locale in ipairs(value) do
            addLocale(locales, locale)
        end
    end
end

local function getSystemLocales()
    local locales = {}

    if love and love.system then
        if type(love.system.getPreferredLocales) == "function" then
            local ok, value = pcall(love.system.getPreferredLocales)
            if ok then
                addLocale(locales, value)
            end
        end

        if type(love.system.getLocale) == "function" then
            local ok, value = pcall(love.system.getLocale)
            if ok then
                addLocale(locales, value)
            end
        end
    end

    if os and type(os.setlocale) == "function" then
        local ok, value = pcall(os.setlocale, nil, "ctype")
        if ok then
            addLocale(locales, value)
        end
    end

    if os and type(os.getenv) == "function" then
        for _, name in ipairs({ "LANGUAGE", "LC_ALL", "LC_MESSAGES", "LANG" }) do
            local ok, value = pcall(os.getenv, name)
            if ok then
                addLocale(locales, value)
            end
        end
    end

    return locales
end

local function getSystemLanguage(available)
    for _, locale in ipairs(getSystemLocales()) do
        local lang = matchAvailableLanguage(locale, available)
        if lang then
            return lang
        end
    end

    return nil
end

local function resolveLanguageId(lang, available)
    lang = normalizeLanguageId(lang)

    if lang == AUTO_LANGUAGE then
        return getSystemLanguage(available)
    end

    return matchAvailableLanguage(lang, available)
end

local function getDefaultLanguage(available)
    local configured = getConfig("defaultLanguage") or DEFAULT_LANGUAGE
    return resolveLanguageId(configured, available) or available[1] or DEFAULT_LANGUAGE
end

local function isCjkCodepoint(codepoint)
    return (codepoint >= 0x2E80 and codepoint <= 0x9FFF)
        or (codepoint >= 0xF900 and codepoint <= 0xFAFF)
        or (codepoint >= 0xFE10 and codepoint <= 0xFE1F)
        or (codepoint >= 0xFF00 and codepoint <= 0xFFEF)
        or (codepoint >= 0x20000 and codepoint <= 0x2FA1F)
end

local function hasCjkText(text)
    for _, codepoint in utf8.codes(text) do
        if isCjkCodepoint(codepoint) then
            return true
        end
    end
    return false
end

local function hasMultipleCodepoints(text)
    local count = 0
    for _ in utf8.codes(text) do
        count = count + 1
        if count > 1 then
            return true
        end
    end
    return false
end

local function addCjkTextSpacing(text, spacing_value, offset_y)
    if type(text) ~= "string" then
        return text
    end

    if Game.lang ~= "zh_hans" or not hasCjkText(text) or text:find("%[spacing:") then
        return text
    end

    local out = {}
    if offset_y and not text:find("%[offset:") then
        table.insert(out, "[offset:0," .. tostring(offset_y) .. "]")
    end

    local spacing = false
    local index = 1
    while index <= #text do
        local char = text:sub(index, index)
        if char == "[" then
            local close = text:find("]", index, true)
            if close then
                table.insert(out, text:sub(index, close))
                index = close + 1
            else
                table.insert(out, char)
                index = index + 1
            end
        else
            local codepoint = utf8.codepoint(text, index)
            local next_index = utf8.offset(text, 2, index) or (#text + 1)
            local cjk = isCjkCodepoint(codepoint)

            if cjk and not spacing then
                table.insert(out, "[spacing:" .. tostring(spacing_value) .. "]")
                spacing = true
            elseif not cjk and spacing then
                table.insert(out, "[spacing:0]")
                spacing = false
            end

            table.insert(out, text:sub(index, next_index - 1))
            index = next_index
        end
    end

    if spacing then
        table.insert(out, "[spacing:0]")
    end

    return table.concat(out)
end

-- Hometown Pack extension: wrap over-long CJK dialogue lines at natural
-- punctuation boundaries, so the engine's latin-word auto-wrap never kicks in.
local function utf8Chars(s)
    local chars = {}
    local i = 1
    while i <= #s do
        local b = s:byte(i)
        local len
        if b < 0x80 then len = 1
        elseif b < 0xE0 then len = 2
        elseif b < 0xF0 then len = 3
        elseif b < 0xF8 then len = 4
        else len = 1 end
        chars[#chars + 1] = s:sub(i, i + len - 1)
        i = i + len
    end
    return chars
end

local function wrapCjkText(text, limit)
    if type(text) ~= "string" or Game.lang ~= "zh_hans" or not hasCjkText(text) then
        return text
    end
    limit = limit or 19
    local out_lines = {}
    for line in text:gmatch("[^\n]+") do
        local chars = utf8Chars(line)
        local cur, cur_core = {}, 0
        local i = 1
        while i <= #chars do
            local c = chars[i]
            if c == "[" then
                local close = line:find("]", i, true)
                if close then
                    cur[#cur + 1] = line:sub(i, close)
                    i = close + 1
                else
                    cur[#cur + 1] = c
                    i = i + 1
                end
            else
                cur[#cur + 1] = c
                if c ~= "*" and c ~= " " then
                    cur_core = cur_core + 1
                end
                if c:match("[，。！？、；：—]") and cur_core >= 12 then
                    out_lines[#out_lines + 1] = table.concat(cur)
                    cur, cur_core = {}, 0
                elseif cur_core >= limit then
                    out_lines[#out_lines + 1] = table.concat(cur)
                    cur, cur_core = {}, 0
                end
                i = i + 1
            end
        end
        if #cur > 0 then
            out_lines[#out_lines + 1] = table.concat(cur)
        end
    end
    return table.concat(out_lines, "\n")
end

local function wrapCjkTextValue(value, limit)
    if type(value) == "table" then
        local out = {}
        for key, item in pairs(value) do
            out[key] = wrapCjkTextValue(item, limit)
        end
        return out
    end
    return wrapCjkText(value, limit)
end

local function addCjkTextSpacingValue(value, spacing_value, offset_y)
    if type(value) == "table" then
        if type(isClass) == "function" and isClass(value) then
            return value
        end

        local out = {}
        for key, item in pairs(value) do
            out[key] = addCjkTextSpacingValue(item, spacing_value, offset_y)
        end
        return out
    end
    return addCjkTextSpacing(value, spacing_value, offset_y)
end

local function isBattleSpeechDialogue(dialogue)
    if not Game.battle or not dialogue then
        return false
    end

    return dialogue.font == "plain" or dialogue.font == "zh_plain"
end

local function setBattleSpeechDialogueFont(dialogue)
    if not isBattleSpeechDialogue(dialogue) then
        return false
    end

    dialogue.font = Game.lang == "zh_hans" and "zh_plain" or "plain"
    return true
end

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

    return applyOriginalDebugTermReplacements(localized or text)
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
        return Game:loc("debug_light_item_suffix", { name = item_name })
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
    -- Raw-string dictionary lookup, so that mod dialogue/shop/battle strings
    -- are translated without changing call sites.
    if type(static) == "string" and Game and Game.lang == "zh_hans" then
        if Game:hasStr(static) then
            return Game:loc(static)
        end
        -- Combined messages (e.g. World:heal prefixes): localize line by line.
        if static:find("\n", 1, true) then
            local out = {}
            local matched = false
            for line in static:gmatch("[^\n]+") do
                line = line:gsub("%s+$", "")
                local localized = localizeStaticTextValue(line)
                if localized ~= line then
                    matched = true
                end
                out[#out + 1] = localized
            end
            if matched then
                return table.concat(out, "\n")
            end
        end
        -- Dynamic messages (e.g. heal amount) via pattern.
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
            width = width + cjkFixedTextSpacing
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
                cursor_x = cursor_x + cjkFixedTextSpacing
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
    local requested = getConfig("defaultNameLanguage") or Game.langNameLanguage
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

    Game.lang = resolveLanguageId(Game.lang or getConfig("defaultLanguage") or DEFAULT_LANGUAGE, Game.langAvailable)
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

local function mergeLangTable(merged, data)
    for key, value in pairs(data or {}) do
        merged[key] = value
    end
end

local function mergeNameTable(merged, data)
    if type(data) ~= "table" then
        return
    end

    merged.names = merged.names or {}
    for raw_id, languages in pairs(data) do
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

    if kristalI18n.info and kristalI18n.info.path then
        table.insert(bases, kristalI18n.info.path)
    end
    if Mod and Mod.info and Mod.info.path then
        table.insert(bases, Mod.info.path)
    end

    for _, base in ipairs(bases) do
        for _, path in ipairs(langFileCandidates(base, lang)) do
            local data = readJsonIfExists(path)
            if type(data) == "table" then
                mergeLangTable(merged, data)
                break
            end
        end

        for _, path in ipairs(nameFileCandidates(base)) do
            local data = readJsonIfExists(path)
            if type(data) == "table" then
                mergeNameTable(merged, data)
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
        or "[color:red]Name missing: " .. tostring(default or id) .. "[color:reset]"
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
    -- Do not derive child IDs or inspect the fallback value when it exists.
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

    -- These fields belong to a text-choice descriptor and are consumed by
    -- normalizeTextChoiceArgs rather than being passed to the textbox.
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

local function refreshCachedFont(object)
    if object and object.font and object.font_name then
        object.font = Assets.getFont(object.font_name, object.font_size)
    end
end

local function refreshCachedEngineFonts()
    if not Kristal then
        return
    end

    refreshCachedFont(Kristal.Console)
    refreshCachedFont(Kristal.DebugSystem)

    if Kristal.DebugSystem then
        refreshCachedFont(Kristal.DebugSystem.context)
        refreshCachedFont(Kristal.DebugSystem.window)
    end
end

-- Restore the base asset id by stripping any number of "lang/<segment>/" prefixes.
local function getBaseAssetId(path)
    while true do
        local stripped = path:match("^lang/[^/]+/(.+)$")
        if not stripped then
            return path
        end
        path = stripped
    end
end

-- Tileset instance -> whole-image base id. Captured once from the ORIGINAL
-- texture (never derived from an already-localized one, so switching back
-- to the base language can't get stuck in lang/lang nesting).
local localized_tileset_image_ids = {}

-- Re-resolve cached Tileset textures for the current language.
local function refreshLocalizedTilesets()
    if not Registry or not Registry.tilesets then
        return
    end

    local tilesets = {}
    for _, tileset in pairs(Registry.tilesets) do
        tilesets[tileset] = true
    end
    if Game and Game.world and Game.world.map and Game.world.map.tilesets then
        for _, tileset in ipairs(Game.world.map.tilesets) do
            tilesets[tileset] = true
        end
    end

    for tileset in pairs(tilesets) do
        -- Per-tile images (tsx <tile><image>): info.path is always the base id.
        for _, info in pairs(tileset.tile_info or {}) do
            if info and info.path then
                local texture = Assets.getTexture(info.path)
                if texture then
                    local old_w, old_h = info.texture:getWidth(), info.texture:getHeight()
                    info.texture = texture
                    if info.quad and (old_w ~= texture:getWidth() or old_h ~= texture:getHeight()) then
                        info.quad = love.graphics.newQuad(
                            info.x or 0, info.y or 0,
                            info.width or texture:getWidth(), info.height or texture:getHeight(),
                            texture:getWidth(), texture:getHeight())
                    end
                end
            end
        end

        -- Whole-image tilesets (tsx <image>).
        if tileset.texture then
            local base_id = localized_tileset_image_ids[tileset]
            if not base_id then
                base_id = getBaseAssetId(Assets.getTextureID(tileset.texture) or "")
                if base_id ~= "" then
                    localized_tileset_image_ids[tileset] = base_id
                end
            end
            if base_id and base_id ~= "" then
                local texture = Assets.getTexture(base_id)
                if texture then
                    local old_w, old_h = tileset.texture:getWidth(), tileset.texture:getHeight()
                    tileset.texture = texture
                    if old_w ~= texture:getWidth() or old_h ~= texture:getHeight() then
                        tileset.quads = {}
                        local tw, th = texture:getWidth(), texture:getHeight()
                        for i = 0, tileset.tile_count - 1 do
                            local tx = tileset.margin + (i % tileset.columns) * (tileset.tile_width + tileset.spacing)
                            local ty = tileset.margin + math.floor(i / tileset.columns) * (tileset.tile_height + tileset.spacing)
                            tileset.quads[i] = love.graphics.newQuad(tx, ty, tileset.tile_width, tileset.tile_height, tw, th)
                        end
                    end
                end
            end
        end
    end
end

local function refreshLocalizedAssets()
    refreshCachedEngineFonts()

    -- Tileset caches (created before the Assets hooks were installed).
    refreshLocalizedTilesets()

    -- Tile layers hold a SpriteBatch over the old tileset texture; rebuild on next draw.
    if Game and Game.world and Game.world.map then
        for _, layer in ipairs(Game.world.map.tile_layers or {}) do
            layer:markTilesDirty()
        end
    end

    if not Game or not Game.stage then
        return
    end

    for _, sprite in pairs(Game.stage:getObjects(Sprite)) do
        if sprite.texture_path then
            -- Strip any lang/ prefix first so switching back to the base
            -- language resolves correctly.
            local texture = Assets.getTexture(getBaseAssetId(sprite.texture_path))
            if texture then
                sprite.texture = texture
            end
        end
    end

    if Game.world and Game.world.menu then
        if Game.world.menu.font then
            Game.world.menu.font = Assets.getFont("main")
        end
        if Game.world.menu.box and Game.world.menu.box.font then
            Game.world.menu.box.font = Assets.getFont("main")
        end
    end
end

local function getLocalizedTexturePaths(path)
    if type(path) ~= "string" then
        return {}
    end

    -- Already-localized id: never nest another lang/ prefix.
    if path:sub(1, 5) == "lang/" then
        return {}
    end

    -- Game may not exist yet if hooks are ever installed earlier; nil-guard.
    local lang = Game and Game.lang or FALLBACK_LANGUAGE
    local name_language = Game and Game.langNameLanguage or lang

    -- Prefer the original path; also try stripping a sprites/ prefix
    -- (defensive: tmx-derived ids are prefix-free in v0.10.0, but mods
    -- may hand-write such ids).
    local variants = { path }
    local stripped = path:match("^assets/sprites/(.+)$") or path:match("^sprites/(.+)$")
    if stripped then
        variants[#variants + 1] = stripped
    end

    local paths = {}
    for _, variant in ipairs(variants) do
        paths[#paths + 1] = "lang/" .. lang .. "/" .. name_language .. "/" .. variant
        paths[#paths + 1] = "lang/" .. lang .. "/" .. variant
    end

    return paths
end

local function getLocalizedTextureAsset(orig, path)
    for _, lang_path in ipairs(getLocalizedTexturePaths(path)) do
        local asset = orig(lang_path)
        if asset then
            return asset
        end
    end
    return orig(path)
end

local POWER_STAT_LABELS = {
    ["Guts:"] = "guts_stat",
    ["Rudeness"] = "rudeness_stat",
    ["Fluffiness"] = "fluffiness_stat",
    ["Coldness"] = "coldness_stat",
    ["Boldness"] = "boldness_stat",
}

local ITEM_BONUS_NAMES = {
    ["GrazeTime"] = "graze_time_bonus",
    ["Money Earned UP"] = "bonus_money_up",
    ["Spookiness UP"] = "bonus_spookiness_up",
    ["Defense"] = "bonus_defense",
    ["Festive"] = "bonus_festive",
    ["Annoying"] = "bonus_annoying",
    ["SlayDark"] = "bonus_slaydark",
    ["$ +5%"] = "bonus_money_5",
}

local NOELLE_SPECIAL_TITLE_KEYS = {
    ["Ice Trancer"] = "chara_noelle_title_ice_trancer",
    ["Frostmancer"] = "chara_noelle_title_frostmancer",
}

local function mapNameKey(id)
    return "map_" .. tostring(id):gsub("[^%w_]", "_") .. "_name"
end

local function localizeMapName(map)
    if not map or not map.id or not Game or not Game.loc then
        return
    end

    local properties = (map.data and map.data.properties) or {}
    local name_key = properties.name_id or mapNameKey(map.id)
    map.name = Game:loc(name_key)
end

local function refreshMapName()
    if Game.world then
        localizeMapName(Game.world.map)
    end
end

local function refreshBattleLocalization()
    if not Game.battle then
        return
    end

    for _, enemy in ipairs(Game.battle.enemies or {}) do
        if type(enemy.applyLocalization) == "function" then
            enemy:applyLocalization(true)
        end
    end
end

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
        love.graphics.print = function(text, ...)
            local key = POWER_STAT_LABELS[text]
            if key then
                text = Game:loc(key)
            end
            return original_print(text, ...)
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

local function localizeVictoryText(text)
    if Game:getLanguage() ~= "zh_hans" or type(text) ~= "string" then
        return text
    end

    local xp, money, currency = text:match("^%* You won!\n%* Got (.-) EXP and (.-) (.-)%.$")
    if xp then
        return Game:loc("battle_victory_with_exp", {
            xp = xp,
            money = money,
            currency = currency,
        })
    end

    local stronger_money, stronger_currency, stronger = text:match("^%* You won!\n%* Got (.-) (.-)%.\n%* (.-) became stronger%.$")
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

    return text
end

local function localizeBattleText(text)
    if Game:getLanguage() ~= "zh_hans" or type(text) ~= "string" then
        return text
    end

    local battler_name, enemy_name = text:match("^%* (.-) spared (.-)!$")
    if battler_name then
        return Game:loc("battle_spare_success", {
            battlerName = battler_name,
            enemyName = enemy_name,
        })
    end

    battler_name = text:match("^%* (.-) spared!$")
    if battler_name then
        return Game:loc("battle_spare_no_enemy", { battlerName = battler_name })
    end

    battler_name, enemy_name = text:match("^%* (.-) spared (.-)!\n%* But its name wasn't %[color:yellow%]YELLOW%[color:reset%]%.%.%.$")
    if battler_name then
        return Game:loc("battle_spare_not_yellow", {
            battlerName = battler_name,
            enemyName = enemy_name,
        })
    end

    local party_name, spell_name = text:match("^%* %(Try using (.-)'s %[color:blue%](.-)%[color:reset%]!%)$")
    if party_name then
        return Game:loc("battle_spare_try_spell", {
            partyName = party_name,
            spellName = spell_name,
        })
    end

    if text == "* (Try using [color:blue]ACTs[color:reset]!)" then
        return Game:loc("battle_spare_try_act")
    end

    return text
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

local function resolveDisplayText(value, options)
    if value == nil then
        return nil
    end
    return localizeStaticTextValue(resolveTextInput(value, options))
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

local function resolveFileData(data)
    if type(data) ~= "table" or isClassInstance(data) then
        return data
    end

    local result = tableCopy(data)
    result.name = resolveDisplayText(data.name)
    result.room_name = resolveDisplayText(data.room_name)
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

local function resolveConsoleLines(text)
    if isTextDescriptor(text) then
        local resolved = resolveDisplayText(text)
        return type(resolved) == "table" and resolved or { resolved }
    end
    if type(text) ~= "table" or isClassInstance(text) then
        return text
    end

    local result = {}
    for index, line in ipairs(text) do
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

local function hookFrameworkLocalization()
    if kristalI18n.framework_localization_hooked then
        return
    end

    kristalI18n.framework_localization_hooked = true

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

    HookSystem.hook(Battle, "battleText", function(orig, battle, text, ...)
        text = resolveDisplayText(text)
        return orig(battle, localizeBattleTextValue(localizeVictoryText(text)), ...)
    end)

    HookSystem.hook(Battle, "shortActText", function(orig, battle, text)
        return orig(battle, resolveTextLines(text))
    end)

    HookSystem.hook(Battle, "infoText", function(orig, battle, text)
        return orig(battle, resolveDisplayText(text))
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
        hookMethod(World, "heal", function(orig, self, target, amount, text)
            return orig(self, target, amount, resolveDisplayText(text))
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

        HookSystem.hook(World, "showText", function(orig, self, text, after)
            if isTextDescriptor(text) then
                text = { text }
            end
            return orig(self, text, after)
        end)

        HookSystem.hook(World, "partyReact", function(orig, self, party_member, text, display_time)
            return orig(self, party_member, resolveDisplayText(text), display_time)
        end)
    end

    if Battler then
        HookSystem.hook(Battler, "spawnSpeechBubble", function(orig, self, text, options)
            text, options = resolveTextInput(text, options)
            return orig(self, localizeStaticTextValue(text), options)
        end)
    end

    if SpeechBubble then
        HookSystem.hook(SpeechBubble, "init", function(orig, self, text, x, y, options, speaker)
            text, options = resolveTextInput(text, options)
            return orig(self, localizeStaticTextValue(text), x, y, options, speaker)
        end)

        HookSystem.hook(SpeechBubble, "setText", function(orig, self, text, callback, line_callback)
            text = resolveTextInput(text)
            return orig(self, localizeStaticTextValue(text), callback, line_callback)
        end)
    end

    if Textbox then
        HookSystem.hook(Textbox, "setText", function(orig, self, text, callback)
            text = resolveTextInput(text)
            return orig(self, localizeStaticTextValue(text), callback)
        end)

        HookSystem.hook(Textbox, "addReaction", function(orig, self, id, text, x, y, face, actor)
            return orig(self, id, resolveDisplayText(text), x, y, face, actor)
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

        HookSystem.hook(TextChoicebox, "setText", function(orig, self, text, callback)
            text = resolveTextInput(text)
            return orig(self, localizeStaticTextValue(text), callback)
        end)
    end

    if Shop then
        hookMethod(Shop, "getVoicedText", function(orig, self, text)
            return orig(self, resolveDisplayText(text))
        end)
        hookMethod(Shop, "setDialogueText", function(orig, self, text, no_voice)
            return orig(self, resolveDisplayText(text), no_voice)
        end)
        hookMethod(Shop, "setRightText", function(orig, self, text, no_voice)
            return orig(self, resolveDisplayText(text), no_voice)
        end)

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
        hookMethod(OverworldActionBox, "react", function(orig, self, text, display_time)
            return orig(self, resolveDisplayText(text), display_time)
        end)
    end
end

local function applyItemLocalizationPatch(item)
    if not item or item.__langlib_zh_localized then
        return item
    end

    item.__langlib_zh_localized = true

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

function kristalI18n:init()
    loadCjkConfig()
    ensureLanguageGlobals()
    hookRegistryItemCreation()
    hookFrameworkLocalization()
end

function kristalI18n:onKeyPressed(key, is_repeat)
    local toggle_key = getConfig("languageToggleKey")
    if toggle_key == false then
        return
    end
    toggle_key = tostring(toggle_key or DEFAULT_LANGUAGE_TOGGLE_KEY):lower()

    if is_repeat or key:lower() ~= toggle_key or not Game.setLanguage then
        return
    end

    local next_language = Game:getLanguage() == "zh_hans" and "en" or "zh_hans"
    if Game:setLanguage(next_language) then
        refreshMapName()

        local message = Game:loc("lang_language_switched", {
            language = Game:getLanguageName()
        })
        print(message)

        if Game.world and Game.world.player and not Game.world:hasCutscene() and not Game.world.menu then
            Game.world:showText(message)
        end

        return true
    end
end

function kristalI18n:registerDebugOptions(debug_system)
    debug_system:registerOption(
        "engine_options",
        "Debug Mode Terminology",
        function()
            return debug_system:appendBool(
                "Translate debug mode terminology.",
                Game:getDebugTermsTranslated()
            )
        end,
        function()
            Game:setDebugTermsTranslated(not Game:getDebugTermsTranslated())
        end
    )
end

function kristalI18n:postInit()
    -- Re-evaluate the name language now that the mod config and Game exist
    -- (at init time the config/Game were not available and it fell back to EN).
    ensureNameLanguageGlobals()
    ensureLanguageGlobals()
    Game:loadLang(Game.lang)

    Game.hasXtraConfig = (Utils.getAnyCase(Mod.libs, "xtractrl") and true) or false

    HookSystem.hook(Assets, "getFont", function(orig, path, size)
        local lang_path = "lang/" .. (Game.lang or FALLBACK_LANGUAGE) .. "/" .. path
        return orig(lang_path, size) or orig(path, size)
    end)

    HookSystem.hook(Assets, "getTexture", function(orig, path)
        return getLocalizedTextureAsset(orig, path)
    end)

    HookSystem.hook(Assets, "getTextureData", function(orig, path)
        return getLocalizedTextureAsset(orig, path)
    end)

    HookSystem.hook(Assets, "getFrames", function(orig, path)
        return getLocalizedTextureAsset(orig, path)
    end)

    HookSystem.hook(Assets, "getFrameIds", function(orig, path)
        return getLocalizedTextureAsset(orig, path)
    end)

    HookSystem.hook(Assets, "getSound", function(orig, sound)
        local lang_path = "lang/" .. (Game.lang or FALLBACK_LANGUAGE) .. "/" .. sound
        return orig(lang_path) or orig(sound)
    end)

    HookSystem.hook(Assets, "newSound", function(orig, sound)
        local lang_path = "lang/" .. (Game.lang or FALLBACK_LANGUAGE) .. "/" .. sound
        if Assets.sounds and Assets.sounds[lang_path] then
            return orig(lang_path)
        end
        return orig(sound)
    end)

    HookSystem.hook(Assets, "startSound", function(orig, sound)
        local lang_path = "lang/" .. (Game.lang or FALLBACK_LANGUAGE) .. "/" .. sound
        if Assets.sounds and Assets.sounds[lang_path] then
            return orig(lang_path)
        end
        return orig(sound)
    end)

    HookSystem.hook(Assets, "stopSound", function(orig, sound, actually_stop)
        local lang_path = "lang/" .. (Game.lang or FALLBACK_LANGUAGE) .. "/" .. sound
        return orig(lang_path, actually_stop) or orig(sound, actually_stop)
    end)

    HookSystem.hook(Assets, "playSound", function(orig, sound, volume, pitch)
        local lang_path = "lang/" .. (Game.lang or FALLBACK_LANGUAGE) .. "/" .. sound
        if Assets.sounds and Assets.sounds[lang_path] then
            return orig(lang_path, volume, pitch)
        end
        return orig(sound, volume, pitch)
    end)

    HookSystem.hook(Assets, "stopAndPlaySound", function(orig, sound, volume, pitch, actually_stop)
        local lang_path = "lang/" .. (Game.lang or FALLBACK_LANGUAGE) .. "/" .. sound
        if Assets.sounds and Assets.sounds[lang_path] then
            return orig(lang_path, volume, pitch, actually_stop)
        end
        return orig(sound, volume, pitch, actually_stop)
    end)

    HookSystem.hook(Assets, "getMusicPath", function(orig, music)
        local lang_path = "lang/" .. (Game.lang or FALLBACK_LANGUAGE) .. "/" .. music
        return orig(lang_path) or orig(music)
    end)

    HookSystem.hook(Assets, "getVideoPath", function(orig, video)
        local lang_path = "lang/" .. (Game.lang or FALLBACK_LANGUAGE) .. "/" .. video
        return orig(lang_path) or orig(video)
    end)

    HookSystem.hook(Assets, "newVideo", function(orig, video, load_audio)
        local lang_path = "lang/" .. (Game.lang or FALLBACK_LANGUAGE) .. "/" .. video
        if Assets.data and Assets.data.videos and Assets.data.videos[lang_path] then
            return orig(lang_path, load_audio)
        end
        return orig(video, load_audio)
    end)

    HookSystem.hook(StringUtils, "upper", function(_, str)
        local map = getConfig("lowerAndUpper", true, true) or {}
        local result = {}
        for _, codepoint in utf8.codes(tostring(str or "")) do
            local char = utf8.char(codepoint)
            table.insert(result, map[char] or char:upper())
        end
        return table.concat(result)
    end)

    HookSystem.hook(StringUtils, "lower", function(_, str)
        local upper_to_lower = {}
        for lower, upper in pairs(getConfig("lowerAndUpper", true, true) or {}) do
            upper_to_lower[upper] = lower
        end

        local result = {}
        for _, codepoint in utf8.codes(tostring(str or "")) do
            local char = utf8.char(codepoint)
            table.insert(result, upper_to_lower[char] or char:lower())
        end
        return table.concat(result)
    end)

    local graphics_print = love.graphics.print
    HookSystem.hook(love.graphics, "print", function(orig, text, ...)
        return printCjkTextWithSpacing(orig, text, ...)
    end)

    HookSystem.hook(love.graphics, "printf", function(orig, text, ...)
        return printfCjkTextWithSpacing(graphics_print, orig, text, ...)
    end)

    hookLightMenuDraw(LightMenu)
    hookLightMenuDraw(LightStatMenu)
    hookLightMenuDraw(LightItemMenu)
    hookLightMenuDraw(LightCellMenu)

    if GonerChoice then
        HookSystem.hook(GonerChoice, "init", function(orig, self, x, y, choices, on_complete, on_select)
            return orig(self, x, y, resolveGonerChoices(choices), on_complete, on_select)
        end)

        HookSystem.hook(GonerChoice, "setChoices", function(orig, self, choices, selected_x, selected_y)
            return orig(self, resolveGonerChoices(choices), selected_x, selected_y)
        end)

        HookSystem.hook(GonerChoice, "setChoice", function(orig, self, x, y, choice)
            return orig(self, x, y, resolveGonerChoice(choice))
        end)

        HookSystem.hook(GonerChoice, "getChoiceText", function(orig, self, choice, x, y)
            if type(choice) == "table" and choice[1] ~= nil then
                choice = tableCopy(choice)
                choice[1] = resolveDisplayText(choice[1])
            end
            return resolveDisplayText(orig(self, choice, x, y))
        end)

        HookSystem.hook(GonerChoice, "isHidden", function(orig, self, choice, x, y)
            if type(choice) == "table" and choice[1] ~= nil then
                choice = resolveGonerChoice(choice)
            end
            return orig(self, choice, x, y)
        end)
    end

    HookSystem.hook(Text, "init", function(orig, self, text, x, y, w, h, options)
        if type(w) == "table" then
            options = mergeTextOptions(w, options)
            w, h = options, nil
        end

        text, options = resolveTextInput(text, options)
        return orig(self, text, x, y, w, h, options)
    end)

    HookSystem.hook(DialogueText, "init", function(orig, self, text, x, y, w, h, options)
        if type(w) == "table" then
            options = mergeTextOptions(w, options)
            w, h = options, nil
        end

        text, options = resolveTextInput(text, options)
        return orig(self, text, x, y, w, h, options)
    end)

    HookSystem.hook(Text, "setText", function(orig, self, text)
        text = resolveTextInput(text)
        text = localizeStaticTextValue(text)
        text = wrapCjkTextValue(text)
        return orig(self, addCjkTextSpacingValue(text, cjkFixedTextSpacing))
    end)

    HookSystem.hook(WorldCutscene, "text", function(orig, self, text, portrait, actor, options)
        text, portrait, actor, options = normalizeCutsceneTextArgs(text, portrait, actor, options)
        return orig(self, text, portrait, actor, options)
    end)

    HookSystem.hook(BattleCutscene, "text", function(orig, self, text, portrait, actor, options)
        text, portrait, actor, options = normalizeCutsceneTextArgs(text, portrait, actor, options)
        return orig(self, text, portrait, actor, options)
    end)

    HookSystem.hook(BattleCutscene, "battlerText", function(orig, self, battlers, text, options)
        text, options = resolveTextInput(text, options)
        return orig(self, battlers, localizeStaticTextValue(text), options)
    end)

    if LegendCutscene then
        hookMethod(LegendCutscene, "text", function(orig, self, text, pos)
            return orig(self, resolveDisplayText(text), pos)
        end)
    end

    HookSystem.hook(DialogueText, "setText", function(orig, self, text, ...)
        text = resolveTextInput(text)
        text = localizeStaticTextValue(text)

        -- Battle speech bubbles use a Chinese-capable plain font directly.
        -- Keep the extra spacing and offset for other DialogueText instances.
        if setBattleSpeechDialogueFont(self) then
            return orig(self, text, ...)
        end

        return orig(self, addCjkTextSpacingValue(text, cjkDialogueTextSpacing, cjkDialogueYOffset), ...)
    end)

    HookSystem.hook(DialogueText, "updateTypewriter", function(orig, self)
        if Game.lang ~= "zh_hans"
            or type(self.text) ~= "string"
            or not hasCjkText(self.text)
            or not self.state
            or type(self.state.speed) ~= "number"
        then
            return orig(self)
        end

        local speed = self.state.speed
        self.state.speed = speed * cjkTypewriterSpeedMultiplier
        local ok, result = pcall(orig, self)
        self.state.speed = speed

        if not ok then
            error(result)
        end

        return result
    end)

    HookSystem.hook(WorldCutscene, "textChoicer", function(orig, self, text, choices, portrait, actor, options)
        text, choices, portrait, actor, options = normalizeTextChoiceArgs(
            text, choices, portrait, actor, options
        )
        return orig(self, text, choices, portrait, actor, options)
    end)

    HookSystem.hook(WorldCutscene, "choicer", function(orig, self, choices, options)
        choices, options = normalizeChoices(choices, options)
        return orig(self, choices, options)
    end)

    HookSystem.hook(BattleCutscene, "choicer", function(orig, self, choices, options)
        choices, options = normalizeChoices(choices, options)
        return orig(self, choices, options)
    end)

    if DarkMenu then
        HookSystem.hook(DarkMenu, "setDescription", function(orig, self, text, visible)
            text = resolveDisplayText(text)
            if type(text) == "string" then
                local item_name = text:match("^Really throw away the\n(.+)%?$")
                if item_name then
                    text = Game:loc("dark_item_toss_confirm", {
                        itemName = item_name
                    })
                end
            end
            return orig(self, text, visible)
        end)
    end

    if DebugSystem then
        HookSystem.hook(DebugSystem, "registerOption", function(orig, self, menu, name, description, func, visible_func, color)
            return orig(
                self,
                menu,
                resolveDisplayText(name),
                localizeDynamicStaticTextValue(description),
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

        HookSystem.hook(DebugSystem, "printShadow", function(orig, self, text, ...)
            return orig(self, resolveDisplayText(text), ...)
        end)

        refreshDebugOptionDescriptions()
    end

    hookMethod(Draw, "printShadow", function(orig, text, ...)
        return orig(resolveDisplayText(text), ...)
    end)

    hookMethod(Draw, "printAlign", function(orig, text, ...)
        return orig(resolveDisplayText(text), ...)
    end)

    hookMethod(Battle, "addMenuItem", function(orig, self, item)
        item = tableCopy(item or {})
        item.name = resolveDisplayText(item.name)
        item.description = resolveDisplayText(item.description)
        return orig(self, item)
    end)

    hookMethod(Battle, "debugPrintOutline", function(orig, self, text, x, y, color)
        return orig(self, resolveDisplayText(text), x, y, color)
    end)

    if ContextMenu then
        HookSystem.hook(ContextMenu, "init", function(orig, self, name)
            return orig(self, resolveDisplayText(name))
        end)

        HookSystem.hook(ContextMenu, "addMenuItem", function(orig, self, name, description, callback, options)
            return orig(
                self,
                resolveDisplayText(name),
                resolveDisplayText(description),
                callback,
                options
            )
        end)

        HookSystem.hook(ContextMenu, "getInnerWidth", function(orig, self)
            if Game.lang ~= "zh_hans" then
                return orig(self)
            end

            local inner_width = getPrintedTextWidth(self.font, self.name or "")

            for _, item in ipairs(self.items or {}) do
                inner_width = math.max(inner_width, getPrintedTextWidth(self.font, item.name or ""))
            end

            return inner_width
        end)

        HookSystem.hook(ContextMenu, "draw", function(orig, self)
            if Game.lang ~= "zh_hans" then
                return orig(self)
            end

            local bg_color = { 0.156863, 0.172549, 0.211765, 0.8 }
            local highlighted_color = { 1, 0.070588, 0.466667, 0.8 }

            if self.adjusted then
                self:keepInBounds()
            else
                self.adjusted = false
                self:adjustToCorner()
            end

            local padding_x = self:getHorizontalPadding()
            local padding_y = self:getVerticalPadding()

            local canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
            love.graphics.clear()

            love.graphics.setFont(self.font)
            Draw.setColor(1, 1, 1, 1)
            local offset = self:getVerticalPadding()
            local tooltip_to_draw = nil
            if self.name then
                offset = offset + self.font:getHeight() + 4
                Draw.setColor(bg_color)
                love.graphics.rectangle("fill", 0, 0, self.width, offset)

                Draw.setColor(1, 1, 1, 1)
                love.graphics.print(self.name, padding_x, padding_y)

                love.graphics.setLineWidth(2)
                love.graphics.line(0, offset, self.width, offset)
            end

            for _, item in ipairs(self.items) do
                if self:isMouseOver(0, offset, self.width, offset + item.height) then
                    Draw.setColor(highlighted_color)
                    tooltip_to_draw = item
                else
                    Draw.setColor(bg_color)
                end
                love.graphics.rectangle("fill", 0, offset, self.width, item.height)

                Draw.setColor(1, 1, 1, 1)
                love.graphics.print(item.name or "", padding_x, padding_y + offset - 3)
                offset = offset + item.height
            end

            Draw.setColor(bg_color)
            love.graphics.rectangle("fill", 0, offset, self.width, self.height - offset)

            Draw.setColor(1, 1, 1, 1)

            Draw.popCanvas()

            local anim = Utils.ease(0, 1, self.anim_timer / 0.2, "outQuad")
            Draw.setColor(1, 1, 1, anim)
            Draw.draw(canvas, 0, 12 - (anim * 12))

            if tooltip_to_draw then
                local mouse_x, mouse_y = self:getLocalMousePosition()
                local tooltip_x, tooltip_y = mouse_x + 12, mouse_y
                local tooltip_padding_x, tooltip_padding_y = 2, 2
                local description = tooltip_to_draw.description or ""
                local lines = StringUtils.split(description, "\n", false)
                local tooltip_width = tooltip_padding_x * 2 + getPrintedTextWidth(self.font, description)
                local tooltip_height = tooltip_padding_y * 2 + self.font:getHeight() * #lines
                local screen_right, screen_bottom = self:screenToLocalPos(SCREEN_WIDTH, SCREEN_HEIGHT)

                if tooltip_x + tooltip_width > screen_right then
                    tooltip_x = mouse_x - tooltip_width - 4
                end
                if tooltip_y + tooltip_height > screen_bottom then
                    tooltip_y = mouse_y - tooltip_height - 4
                end
                tooltip_x = math.max(0, tooltip_x)
                tooltip_y = math.max(0, tooltip_y)

                local tooltip = Draw.pushCanvas(tooltip_width, tooltip_height)
                love.graphics.clear()
                Draw.setColor(bg_color)

                love.graphics.rectangle("fill", 0, 0, tooltip_width, tooltip_height)

                Draw.setColor(1, 1, 1, 1)
                love.graphics.print(description, tooltip_padding_x, tooltip_padding_y - 2)

                Draw.popCanvas()
                Draw.setColor(1, 1, 1, anim)
                Draw.draw(tooltip, tooltip_x + (12 - (anim * 12)), tooltip_y)
            end

            if Object and Object.draw then
                Object.draw(self)
            end
        end)
    end

    if FileButton then
        hookMethod(FileButton, "setData", function(orig, self, data)
            return orig(self, resolveFileData(data))
        end)

        hookMethod(FileButton, "setChoices", function(orig, self, choices, prompt)
            return orig(self, resolveTextList(choices), resolveDisplayText(prompt))
        end)
    end

    if MainMenuModConfig then
        hookMethod(MainMenuModConfig, "registerOption", function(orig, self, id, name, description, type, options)
            return orig(
                self,
                id,
                resolveDisplayText(name),
                resolveDisplayText(description),
                type,
                resolveTextList(options)
            )
        end)
    end

    if MainMenuOptions then
        hookMethod(MainMenuOptions, "registerOptionsPage", function(orig, self, id, name)
            return orig(self, id, resolveDisplayText(name))
        end)
        hookMethod(MainMenuOptions, "registerOption", function(orig, self, page, name, value, callback)
            return orig(
                self,
                page,
                resolveDisplayText(name),
                localizeDynamicStaticTextValue(value),
                callback
            )
        end)
    end

    if FileNamer then
        hookMethod(FileNamer, "init", function(orig, self, options)
            return orig(self, resolveFileNamerOptions(options))
        end)
    end

    if ListMenuItemComponent then
        hookMethod(ListMenuItemComponent, "init", function(orig, self, list, value, on_changed, options)
            options = tableCopy(options)
            options.prefix = resolveDisplayText(options.prefix)
            options.suffix = resolveDisplayText(options.suffix)
            return orig(self, resolveListMenuValues(list), value, on_changed, options)
        end)
    end

    if SmallFaceText then
        hookMethod(SmallFaceText, "init", function(orig, self, text, x, y, face, actor)
            return orig(self, resolveDisplayText(text), x, y, face, actor)
        end)
    end

    if HPText then
        hookMethod(HPText, "init", function(orig, self, text, x, y)
            return orig(self, resolveDisplayText(text), x, y)
        end)
    end

    if ModButton then
        hookMethod(ModButton, "init", function(orig, self, name, width, height, mod)
            return orig(self, resolveDisplayText(name), width, height, mod)
        end)
        hookMethod(ModButton, "setName", function(orig, self, name)
            return orig(self, resolveDisplayText(name))
        end)
        hookMethod(ModButton, "setSubtitle", function(orig, self, subtitle)
            return orig(self, resolveDisplayText(subtitle))
        end)
    end

    if MainMenuFileSelect then
        hookMethod(MainMenuFileSelect, "setResultText", function(orig, self, text)
            return orig(self, resolveDisplayText(text))
        end)
    end

    if TextMenuItemComponent then
        hookMethod(TextMenuItemComponent, "init", function(orig, self, text, callback, options)
            return orig(self, resolveDisplayText(text), callback, options)
        end)
    end

    if LabelMenuItemComponent then
        hookMethod(LabelMenuItemComponent, "init", function(orig, self, text, child, x_sizing, y_sizing, options)
            return orig(self, resolveDisplayText(text), child, x_sizing, y_sizing, options)
        end)
    end

    if DebugWindow then
        HookSystem.hook(DebugWindow, "init", function(orig, self, name, text, type, callback)
            local result = orig(self, resolveDisplayText(name), resolveDisplayText(text), type, callback)
            for index, button in ipairs(self.buttons or {}) do
                self.buttons[index] = resolveDisplayText(button)
            end
            return result
        end)
    end

    if Console then
        HookSystem.hook(Console, "print", function(orig, self, text, x, y)
            if Game.lang ~= "zh_hans" then
                return orig(self, text, x, y)
            end
            if text == nil then
                return
            end

            local x_offset = 0

            for _, line in ipairs(text) do
                Draw.setColor(self.color)
                if type(line) == "table" and not isTextDescriptor(line) then
                    self.color = line
                else
                    line = resolveDisplayText(line)
                    self:printOutlined(line, x + x_offset, y)
                    if shouldPrintWithCjkSpacing(line) then
                        x_offset = x_offset + getCjkPrintedTextWidth(self.font, line)
                    else
                        x_offset = x_offset + self.font:getWidth(line)
                    end
                end
            end
        end)

        HookSystem.hook(Console, "push", function(orig, self, str)
            return orig(self, resolveDisplayText(str))
        end)
        refreshConsoleStartupHistory()
    end

    HookSystem.hook(Game, "setLanguage", function(orig, lang, refresh_assets)
        local result = orig(lang, refresh_assets)
        if result then
            refreshConsoleStartupHistory()
        end
        return result
    end)

    refreshLocalizedAssets()
end

function kristalI18n:load(data)
    ensureLanguageGlobals()

    Game.lang = resolveLanguageId(data.lang or Game.lang or getConfig("defaultLanguage") or DEFAULT_LANGUAGE, Game.langAvailable)
        or getDefaultLanguage(Game.langAvailable)
    Game.langSelected = data.langSelected or Game.langSelected or 1
    Game.langNameLanguage = data.langNameLanguage or Game.langNameLanguage
    Game.langDebugTermsTranslated = data.langDebugTermsTranslated ~= false

    Game:loadLang(Game.lang)
    return data
end

function kristalI18n:save(data)
    data.lang = Game.lang
    data.langSelected = Game.langSelected
    data.langNameLanguage = Game.langNameLanguage
    data.langDebugTermsTranslated = Game:getDebugTermsTranslated()
    return data
end

function Game:loadLang(lang)
    ensureLanguageGlobals()

    lang = resolveLanguageId(lang or Game.lang or DEFAULT_LANGUAGE, Game.langAvailable)
        or getDefaultLanguage(Game.langAvailable)

    Game.langBaseStr = loadLangTable(FALLBACK_LANGUAGE)
    Game.langStr = loadLangTable(lang)
    Game.lang = lang
    ensureNameLanguageGlobals()

    for index, available in ipairs(Game.langAvailable) do
        if available == lang then
            Game.langSelected = index
            break
        end
    end
end

function Game:setLanguage(lang, refresh_assets)
    ensureLanguageGlobals()

    lang = resolveLanguageId(lang, Game.langAvailable)
    if not lang then
        return false
    end

    Game:loadLang(lang)
    refreshMapName()
    refreshBattleLocalization()
    if refresh_assets ~= false then
        refreshLocalizedAssets()
    end
    return true
end

function Game:getLanguage()
    ensureLanguageGlobals()
    return Game.lang
end

function Game:getLanguageName(lang)
    return getLanguageName(normalizeLanguageId(lang or Game.lang))
end

function Game:getSystemLanguage()
    ensureLanguageGlobals()
    return getSystemLanguage(Game.langAvailable) or getDefaultLanguage(Game.langAvailable)
end

function Game:getLanguages()
    ensureLanguageGlobals()
    return tableCopy(Game.langAvailable)
end

function Game:setNameLanguage(language, refresh_assets)
    ensureLanguageGlobals()
    local resolved = matchAvailableLanguage(
        normalizeNameLanguage(language, Game.lang),
        Game.langNameLanguages
    )
    if not resolved then
        return false
    end

    local old_language = Game.langNameLanguage
    Game.langNameLanguage = resolved
    Game.langNameLanguageSelected = getNameLanguageIndex(Game.langNameLanguage)
    if old_language ~= Game.langNameLanguage then
        refreshBattleLocalization()
        if refresh_assets ~= false then
            refreshLocalizedAssets()
        end
    end
    return true
end

function Game:getNameLanguage()
    ensureLanguageGlobals()
    return Game.langNameLanguage
end

function Game:setDebugTermsTranslated(translated)
    Game.langDebugTermsTranslated = translated ~= false
    return Game.langDebugTermsTranslated
end

function Game:getDebugTermsTranslated()
    return Game.langDebugTermsTranslated ~= false
end

function Game:getNameLanguages()
    ensureLanguageGlobals()
    return tableCopy(Game.langNameLanguages)
end

function Game:getNameLanguageName(language)
    ensureLanguageGlobals()
    language = matchAvailableLanguage(
        normalizeNameLanguage(language or Game.langNameLanguage, Game.lang),
        Game.langNameLanguages
    ) or Game.langNameLanguage
    return getLanguageName(language)
end

function Game:loc(id, var)
    if isTextDescriptor(id) then
        local descriptor_id = getTextId(id)
        local descriptor_options = id.options or {}
        local descriptor_var = descriptor_options.var
            or (id.var ~= nil and id.var or var)
        if descriptor_id ~= nil then
            return Game:loc(descriptor_id, descriptor_var)
        end
        return Game:locText(id.text, descriptor_var)
    end

    if type(id) == "string" then
        local stripped = id:match("^%{([%w_./]+)%}$")
        if stripped then
            id = stripped
        end
    end

    if type(id) ~= "string" or id == "" then
        error("Game:loc expects a non-empty localization id")
    end

    local value = Game:locRaw(id)
    if value == nil then
        value = "[color:red]Localization missing: " .. id .. "[color:reset]"
    end

    return Game:concat(value, var)
end

function Game:locText(text, var)
    if isTextDescriptor(text) then
        local descriptor_id = getTextId(text)
        local descriptor_options = text.options or {}
        local descriptor_var = descriptor_options.var
            or (text.var ~= nil and text.var or var)
        if descriptor_id ~= nil then
            return Game:loc(descriptor_id, descriptor_var)
        end
        return Game:locText(text.text, descriptor_var)
    end

    if type(text) ~= "string" then
        if type(text) == "table" then
            if isClassInstance(text) or isColorTable(text) then
                return text
            end

            local out = {}
            for key, value in pairs(text) do
                out[key] = Game:locText(value, var)
            end
            return out
        end
        error("Game:locText expects a string or text descriptor")
    end
    return Game:concat(text, var)
end

function Game:locRaw(id)

    if Game.langStr and Game.langStr[id] ~= nil then
        return Game.langStr[id]
    end
    if Game.langBaseStr and Game.langBaseStr[id] ~= nil then
        return Game.langBaseStr[id]
    end
    return nil
end

function Game:hasStr(id)
    return Game:locRaw(id) ~= nil
end

function Game:concat(value, var)
    if isTextDescriptor(value) then
        local id = getTextId(value)
        local descriptor_options = value.options or {}
        local descriptor_var = descriptor_options.var
            or (value.var ~= nil and value.var or var)
        if id ~= nil then
            return Game:loc(id, descriptor_var)
        end
        return Game:concat(value.text, descriptor_var)
    end

    if type(value) == "table" then
        if isClassInstance(value) or isColorTable(value) then
            return value
        end

        local out = {}
        for key, item in pairs(value) do
            out[key] = Game:concat(item, var)
        end
        return out
    end

    local str = replaceNameReferences(tostring(value or ""))
    if var then
        str = (str:gsub("%[var:([^%]]+)%]", function(key)
            local replacement = var[key]
            if replacement == nil then
                return ""
            end
            return tostring(replacement)
        end))
    end

    return resolveIdInterpolation(str, var)
end

return kristalI18n
