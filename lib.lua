local kristalI18n = {}

local DEFAULT_LANGUAGE = "en"
local FALLBACK_LANGUAGE = "en"
local AUTO_LANGUAGE = "auto"
local CJK_FIXED_TEXT_SPACING = 4
local CJK_DIALOGUE_TEXT_SPACING = 4
local CJK_DIALOGUE_Y_OFFSET = -1
local CJK_TYPEWRITER_SPEED_MULTIPLIER = 1 --0.85
local DEFAULT_LANGUAGE_TOGGLE_KEY = "f7"

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
        default = "Welcome to [color:cyan]KRISTAL[color:reset]! This is the debug console.",
        plain = "Welcome to KRISTAL! This is the debug console.",
        id = "console_welcome",
    },
    {
        index = 2,
        default = "You can enter Lua here to be ran! Use [color:gray]clear()[color:reset] to clear the console.",
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

local function addCjkTextSpacingValue(value, spacing_value, offset_y)
    if type(value) == "table" then
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
        local out = {}
        for key, item in pairs(value) do
            out[key] = localizeStaticTextValue(item)
        end
        return out
    end
    return localizeStaticText(value)
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
            return localizeStaticText(value(...))
        end
    elseif type(value) == "string" then
        return function()
            return localizeStaticText(value)
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
            width = width + CJK_FIXED_TEXT_SPACING
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
    text = localizeStaticText(text)

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
                cursor_x = cursor_x + CJK_FIXED_TEXT_SPACING
            end
        end
    end

    love.graphics.pop()
end

local function printfCjkTextWithSpacing(print_orig, printf_orig, text, x, y, limit, align, r, sx, sy, ox, oy, kx, ky)
    text = localizeStaticText(text)

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
    local requested = Game.langNameLanguage
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
    -- Keep the original library's misspelled field as an alias for existing hooks/mod code.
    Game.langAvalable = Game.langAvailable

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

local function localizeTextValue(value, id, var)
    if type(value) == "table" then
        local out = {}
        for key, item in pairs(value) do
            local child_id = nil
            if type(id) == "table" then
                child_id = id[key]
            elseif type(id) == "string" then
                child_id = id .. "." .. tostring(key)
            end
            out[key] = localizeTextValue(item, child_id, var)
        end
        return out
    end

    if id then
        return Game:loc(id, var)
    end
    return Game:locText(value, var)
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

local function refreshLocalizedAssets()
    refreshCachedEngineFonts()

    if not Game or not Game.stage then
        return
    end

    for _, sprite in pairs(Game.stage:getObjects(Sprite)) do
        if sprite.texture_path then
            local texture = Assets.getTexture(sprite.texture_path)
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

    local lang = Game.lang or FALLBACK_LANGUAGE
    local name_language = Game.langNameLanguage or lang
    local paths = {
        "lang/" .. lang .. "/" .. name_language .. "/" .. path,
        "lang/" .. lang .. "/" .. path,
    }

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
        local out = {}
        for key, item in pairs(value) do
            out[key] = localizeBattleTextValue(item)
        end
        return out
    end
    return localizeBattleText(value)
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
        return orig(battle, localizeBattleTextValue(localizeVictoryText(text)), ...)
    end)

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
                self.text_id = self.text_id or {}
                self.text_id[1] = "frozen_enemy_text"
            end
            return orig(self, ...)
        end)
    end

    if World then
        HookSystem.hook(World, "setupMap", function(orig, self, ...)
            local result = orig(self, ...)
            localizeMapName(self.map)
            return result
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
        HookSystem.hook(GonerChoice, "getChoiceText", function(orig, self, choice, x, y)
            return localizeStaticText(orig(self, choice, x, y))
        end)
    end

    HookSystem.hook(Text, "init", function(orig, self, text, x, y, w, h, options)
        options = options or {}
        local id = options["id"] or options["loc_id"] or options["loc"]

        if id then
            text = localizeTextValue(text, id, options["var"])
        elseif options["var"] then
            text = Game:concat(text, options["var"])
        end

        return orig(self, text, x, y, w, h, options)
    end)

    HookSystem.hook(Text, "setText", function(orig, self, text)
        text = localizeStaticTextValue(text)
        return orig(self, addCjkTextSpacingValue(text, CJK_FIXED_TEXT_SPACING))
    end)

    HookSystem.hook(WorldCutscene, "text", function(orig, self, text, portrait, actor, options)
        options = options or {}
        local id = options["id"] or options["loc_id"] or options["loc"]
        if id then
            text = localizeTextValue(text, id, options["var"])
        elseif options["var"] then
            text = Game:concat(text, options["var"])
        end
        return orig(self, text, portrait, actor, options)
    end)

    HookSystem.hook(BattleCutscene, "text", function(orig, self, text, portrait, actor, options)
        options = options or {}
        local id = options["id"] or options["loc_id"] or options["loc"]
        if id then
            text = localizeTextValue(text, id, options["var"])
        elseif options["var"] then
            text = Game:concat(text, options["var"])
        end
        return orig(self, text, portrait, actor, options)
    end)

    HookSystem.hook(DialogueText, "setText", function(orig, self, text, ...)
        text = localizeStaticTextValue(text)

        -- Battle speech bubbles use a Chinese-capable plain font directly.
        -- Keep the extra spacing and offset for other DialogueText instances.
        if setBattleSpeechDialogueFont(self) then
            return orig(self, text, ...)
        end

        return orig(self, addCjkTextSpacingValue(text, CJK_DIALOGUE_TEXT_SPACING, CJK_DIALOGUE_Y_OFFSET), ...)
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
        self.state.speed = speed * CJK_TYPEWRITER_SPEED_MULTIPLIER
        local ok, result = pcall(orig, self)
        self.state.speed = speed

        if not ok then
            error(result)
        end

        return result
    end)

    HookSystem.hook(WorldCutscene, "choicer", function(orig, self, choices, options)
        options = options or {}
        local ids = options["ids"] or options["loc_ids"]
        if ids then
            local localized = {}
            for index, choice in ipairs(choices) do
                localized[index] = ids[index]
                    and Game:loc(ids[index], options["var"])
                    or Game:locText(choice, options["var"])
            end
            choices = localized
        elseif options["var"] then
            choices = Game:concat(choices, options["var"])
        end
        return orig(self, choices, options)
    end)

    HookSystem.hook(BattleCutscene, "choicer", function(orig, self, choices, options)
        options = options or {}
        local ids = options["ids"] or options["loc_ids"]
        if ids then
            local localized = {}
            for index, choice in ipairs(choices) do
                localized[index] = ids[index]
                    and Game:loc(ids[index], options["var"])
                    or Game:locText(choice, options["var"])
            end
            choices = localized
        elseif options["var"] then
            choices = Game:concat(choices, options["var"])
        end
        return orig(self, choices, options)
    end)

    if DarkMenu then
        HookSystem.hook(DarkMenu, "setDescription", function(orig, self, text, visible)
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
            return orig(self, menu, name, localizeDynamicStaticTextValue(description), func, visible_func, color)
        end)

        HookSystem.hook(DebugSystem, "appendBool", function(orig, self, desc, bool)
            if Game.lang == "zh_hans" then
                return Game:loc("debug_bool_suffix", {
                    desc = localizeStaticText(desc),
                    state = Game:loc(bool and "on" or "off")
                })
            end
            return orig(self, desc, bool)
        end)

        HookSystem.hook(DebugSystem, "printShadow", function(orig, self, text, ...)
            return orig(self, localizeStaticText(text), ...)
        end)

        refreshDebugOptionDescriptions()
    end

    if ContextMenu then
        HookSystem.hook(ContextMenu, "init", function(orig, self, name)
            return orig(self, localizeStaticText(name))
        end)

        HookSystem.hook(ContextMenu, "addMenuItem", function(orig, self, name, description, callback, options)
            return orig(self, localizeStaticText(name), localizeStaticText(description), callback, options)
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

    if DebugWindow then
        HookSystem.hook(DebugWindow, "init", function(orig, self, name, text, type, callback)
            local result = orig(self, localizeStaticText(name), localizeStaticText(text), type, callback)
            for index, button in ipairs(self.buttons or {}) do
                self.buttons[index] = localizeStaticText(button)
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
                if type(line) == "table" then
                    self.color = line
                else
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
            return orig(self, localizeStaticText(str))
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
    if type(text) ~= "string" then
        error("Game:locText expects a string")
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
    if type(value) == "table" then
        local out = {}
        for key, item in pairs(value) do
            out[key] = Game:concat(item, var)
        end
        return out
    end

    local str = replaceNameReferences(tostring(value or ""))
    if not var then
        return str
    end

    return (str:gsub("%[var:([^%]]+)%]", function(key)
        local replacement = var[key]
        if replacement == nil then
            return ""
        end
        return tostring(replacement)
    end))
end

return kristalI18n
