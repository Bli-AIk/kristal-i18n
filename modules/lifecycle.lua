--- Library lifecycle: callbacks, hooks, public Game API, save/load.
---@param ctx table Shared module context.
---@return table kristalI18n Library instance.
return function(ctx)
    local kristalI18n = ctx.library
    local constants = ctx.constants
    local runtime = ctx.runtime
    local system_language = ctx.system_language
    local cjk = ctx.cjk
    local text = ctx.text
    local assets = ctx.assets
    local hooks = ctx.hooks

    local DEFAULT_LANGUAGE = constants.DEFAULT_LANGUAGE
    local FALLBACK_LANGUAGE = constants.FALLBACK_LANGUAGE
    local DEFAULT_LANGUAGE_TOGGLE_KEY = constants.DEFAULT_LANGUAGE_TOGGLE_KEY

    local getConfig = runtime.getConfig
    local tableCopy = runtime.tableCopy
    local normalizeLanguageId = runtime.normalizeLanguageId
    local normalizeNameLanguage = runtime.normalizeNameLanguage
    local getStartupLanguage = runtime.getStartupLanguage
    local getStartupNameLanguage = runtime.getStartupNameLanguage
    local matchAvailableLanguage = runtime.matchAvailableLanguage
    local resolveLanguageId = runtime.resolveLanguageId
    local getDefaultLanguage = runtime.getDefaultLanguage
    local getSystemLanguage = system_language.getSystemLanguage
    local loadCjkConfig = cjk.loadCjkConfig
    local hasCjkText = cjk.hasCjkText
    local wrapCjkTextValue = cjk.wrapCjkTextValue
    local addCjkTextSpacingValue = cjk.addCjkTextSpacingValue
    local setBattleSpeechDialogueFont = cjk.setBattleSpeechDialogueFont

    local getTextId = text.getTextId
    local isClassInstance = text.isClassInstance
    local isColorTable = text.isColorTable
    local isTextDescriptor = text.isTextDescriptor
    local localizeStaticTextValue = text.localizeStaticTextValue
    local localizeDynamicStaticTextValue = text.localizeDynamicStaticTextValue
    local resolveTextInput = text.resolveTextInput
    local mergeTextOptions = text.mergeTextOptions
    local normalizeCutsceneTextArgs = text.normalizeCutsceneTextArgs
    local normalizeChoices = text.normalizeChoices
    local normalizeTextChoiceArgs = text.normalizeTextChoiceArgs
    local hookLightMenuDraw = text.hookLightMenuDraw
    local hookShopDraw = text.hookShopDraw
    local refreshDebugOptionDescriptions = text.refreshDebugOptionDescriptions
    local refreshConsoleStartupHistory = text.refreshConsoleStartupHistory
    local shouldPrintWithCjkSpacing = text.shouldPrintWithCjkSpacing
    local getCjkPrintedTextWidth = text.getCjkPrintedTextWidth
    local getPrintedTextWidth = text.getPrintedTextWidth
    local printCjkTextWithSpacing = text.printCjkTextWithSpacing
    local printfCjkTextWithSpacing = text.printfCjkTextWithSpacing
    local getLanguageName = text.getLanguageName
    local getNameLanguageIndex = text.getNameLanguageIndex
    local ensureNameLanguageGlobals = text.ensureNameLanguageGlobals
    local ensureLanguageGlobals = text.ensureLanguageGlobals
    local loadLangTable = text.loadLangTable
    local replaceNameReferences = text.replaceNameReferences
    local resolveIdInterpolation = text.resolveIdInterpolation

    local refreshLocalizedAssets = assets.refreshLocalizedAssets
    local getLocalizedTextureAsset = assets.getLocalizedTextureAsset
    local refreshMapName = assets.refreshMapName
    local refreshBattleLocalization = assets.refreshBattleLocalization
    local mapNameKey = assets.mapNameKey

    local hookMethod = hooks.hookMethod
    local hookDebugSystemLocalization = hooks.hookDebugSystemLocalization
    local hookRegistryItemCreation = hooks.hookRegistryItemCreation
    local hookFrameworkLocalization = hooks.hookFrameworkLocalization
    local resolveDisplayText = hooks.resolveDisplayText
    local resolveGonerChoice = hooks.resolveGonerChoice
    local resolveGonerChoices = hooks.resolveGonerChoices
    local resolveTextList = hooks.resolveTextList
    local findRoomNameKeyInTable = hooks.findRoomNameKeyInTable
    local findRoomNameKey = hooks.findRoomNameKey
    local resolveShopItemOptions = hooks.resolveShopItemOptions
    local resolveFileNamerOptions = hooks.resolveFileNamerOptions
    local resolveListMenuValues = hooks.resolveListMenuValues

    -- Searches the currently loaded language tables, then every other available
    -- language table, for a key whose value matches the stored room name. This
    -- lets old Chinese saves be migrated even when the game is currently
    -- running in English (the stored room name is Chinese, so it only matches
    -- the Chinese table).
    local function findRoomNameKeyInAnyLanguage(value)
        local key = findRoomNameKey(value)
        if key then
            return key
        end

        if type(Game.langAvailable) ~= "table" then
            return nil
        end

        for _, lang in ipairs(Game.langAvailable) do
            if lang ~= Game.lang and lang ~= FALLBACK_LANGUAGE then
                local lang_table = loadLangTable(lang)
                key = findRoomNameKeyInTable(value, lang_table)
                if key then
                    return key
                end
            end
        end

        return nil
    end

    -- Rewrites save summaries that were created before this library stored the
    -- raw room name: the file select in the engine's main menu cannot render
    -- Chinese, so move the localized room name behind room_name_key and store
    -- the English (ASCII-safe) value in room_name. In-game menus keep showing
    -- the localized name through Kristal.getSaveFile.
    local function migrateSaveFileRoomNames()
        if not Mod or not Mod.info or not Mod.info.id or not Game
            or type(Game.langStr) ~= "table" or type(Game.langBaseStr) ~= "table"
        then
            return
        end

        for slot = 1, 3 do
            local data = Kristal.loadData("file_" .. slot, Mod.info.id)
            if type(data) == "table" and type(data.room_name) == "string"
                and hasCjkText(data.room_name)
            then
                local key = data.room_name_key
                if type(key) ~= "string" or key == "" then
                    key = findRoomNameKeyInAnyLanguage(data.room_name)
                end

                if type(key) == "string" and key ~= "" then
                    local raw_name = Game.langBaseStr[key]
                    if type(raw_name) == "string" and raw_name ~= "" then
                        local changed = false
                        if data.room_name_key ~= key then
                            data.room_name_key = key
                            changed = true
                        end
                        if data.room_name ~= raw_name then
                            data.room_name = raw_name
                            changed = true
                        end
                        if changed then
                            Kristal.saveData("file_" .. slot, data, Mod.info.id)
                        end
                    end
                end
            end
        end
    end

    function kristalI18n:init()
        loadCjkConfig()
        ensureLanguageGlobals()
        hookDebugSystemLocalization()
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
        -- Config is available now, so apply its name-language default once.
        Game.langNameLanguage = nil
        ensureNameLanguageGlobals()
        ensureLanguageGlobals()
        Game:loadLang(Game.lang)

        Game.hasXtraConfig = (Utils.getAnyCase(Mod.libs, "xtractrl") and true) or false

        migrateSaveFileRoomNames()

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
        HookSystem.hook(love.graphics, "print", function(orig, value, ...)
            return printCjkTextWithSpacing(orig, value, ...)
        end)

        HookSystem.hook(love.graphics, "printf", function(orig, value, ...)
            return printfCjkTextWithSpacing(graphics_print, orig, value, ...)
        end)

        hookLightMenuDraw(LightMenu)
        hookLightMenuDraw(LightStatMenu)
        hookLightMenuDraw(LightItemMenu)
        hookLightMenuDraw(LightCellMenu)
        hookShopDraw(Shop)

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

        HookSystem.hook(Text, "init", function(orig, self, value, x, y, w, h, options)
            if type(w) == "table" then
                options = mergeTextOptions(w, options)
                w, h = options, nil
            end

            value, options = resolveTextInput(value, options)
            return orig(self, value, x, y, w, h, options)
        end)

        HookSystem.hook(DialogueText, "init", function(orig, self, value, x, y, w, h, options)
            if type(w) == "table" then
                options = mergeTextOptions(w, options)
                w, h = options, nil
            end

            value, options = resolveTextInput(value, options)
            return orig(self, value, x, y, w, h, options)
        end)

        HookSystem.hook(Text, "setText", function(orig, self, value)
            value = resolveTextInput(value)
            value = localizeStaticTextValue(value)
            value = wrapCjkTextValue(value)
            return orig(self, addCjkTextSpacingValue(value, cjk.settings.cjkFixedTextSpacing))
        end)

        HookSystem.hook(WorldCutscene, "text", function(orig, self, value, portrait, actor, options)
            value, portrait, actor, options = normalizeCutsceneTextArgs(value, portrait, actor, options)
            return orig(self, value, portrait, actor, options)
        end)

        HookSystem.hook(BattleCutscene, "text", function(orig, self, value, portrait, actor, options)
            value, portrait, actor, options = normalizeCutsceneTextArgs(value, portrait, actor, options)
            return orig(self, value, portrait, actor, options)
        end)

        HookSystem.hook(BattleCutscene, "battlerText", function(orig, self, battlers, value, options)
            value, options = resolveTextInput(value, options)
            return orig(self, battlers, localizeStaticTextValue(value), options)
        end)

        if LegendCutscene then
            hookMethod(LegendCutscene, "text", function(orig, self, value, pos)
                return orig(self, resolveDisplayText(value), pos)
            end)
        end

        HookSystem.hook(DialogueText, "setText", function(orig, self, value, ...)
            value = resolveTextInput(value)
            value = localizeStaticTextValue(value)

            -- Battle speech bubbles use a Chinese-capable plain font directly.
            if setBattleSpeechDialogueFont(self) then
                return orig(self, value, ...)
            end

            return orig(self, addCjkTextSpacingValue(
                value,
                cjk.settings.cjkDialogueTextSpacing,
                cjk.settings.cjkDialogueYOffset
            ), ...)
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
            self.state.speed = speed * cjk.settings.cjkTypewriterSpeedMultiplier
            local ok, result = pcall(orig, self)
            self.state.speed = speed

            if not ok then
                error(result)
            end

            return result
        end)

        HookSystem.hook(WorldCutscene, "textChoicer", function(orig, self, value, choices, portrait, actor, options)
            value, choices, portrait, actor, options = normalizeTextChoiceArgs(
                value, choices, portrait, actor, options
            )
            return orig(self, value, choices, portrait, actor, options)
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
            HookSystem.hook(DarkMenu, "setDescription", function(orig, self, value, visible)
                value = resolveDisplayText(value)
                if type(value) == "string" then
                    local item_name = value:match("^Really throw away the\n(.+)%?$")
                    if item_name then
                        value = Game:loc("dark_item_toss_confirm", {
                            itemName = item_name
                        })
                    end
                end
                -- The description box uses half the regular CJK fixed-text
                -- spacing; Text:setText bakes the spacing into the text.
                local saved = cjk.settings.cjkFixedTextSpacing
                cjk.settings.cjkFixedTextSpacing = cjk.settings.cjkTitleTextSpacing
                local ok, result = xpcall(function()
                    return orig(self, value, visible)
                end, debug.traceback)
                cjk.settings.cjkFixedTextSpacing = saved
                if not ok then
                    error(result)
                end
                return result
            end)
        end

        if DarkPowerMenu then
            -- The party title (class name + its description) is drawn next to
            -- the character name in the power menu. Use half the regular CJK
            -- spacing for the title only, leaving the name untouched.
            HookSystem.hook(DarkPowerMenu, "drawChar", function(orig, self, ...)
                local party = self.party:getSelected()
                Draw.setColor(PALETTE["world_text"])
                love.graphics.print(party:getName(), 48, -7)

                local saved = cjk.settings.cjkFixedTextSpacing
                cjk.settings.cjkFixedTextSpacing = cjk.settings.cjkTitleTextSpacing
                local ok, result = xpcall(function()
                    love.graphics.print(party:getTitle(), 238, -7)
                end, debug.traceback)
                cjk.settings.cjkFixedTextSpacing = saved
                if not ok then
                    error(result)
                end
                return result
            end)
        end

        hookDebugSystemLocalization()
        refreshDebugOptionDescriptions()

        hookMethod(Draw, "printShadow", function(orig, value, ...)
            return orig(resolveDisplayText(value), ...)
        end)

        hookMethod(Draw, "printAlign", function(orig, value, ...)
            return orig(resolveDisplayText(value), ...)
        end)

        hookMethod(Battle, "addMenuItem", function(orig, self, item)
            item = tableCopy(item or {})
            item.name = resolveDisplayText(item.name)
            item.description = resolveDisplayText(item.description)
            return orig(self, item)
        end)

        hookMethod(Battle, "debugPrintOutline", function(orig, self, value, x, y, color)
            return orig(self, resolveDisplayText(value), x, y, color)
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

        -- FileButton is used by the engine's main-menu file select. That menu
        -- reads save data straight from disk via Kristal.loadData (bypassing
        -- Kristal.getSaveFile), so it draws whatever is persisted and must show
        -- the ASCII-safe values stored in the save file; do NOT hook
        -- FileButton:setData (localizing room_name/name there would re-introduce
        -- Chinese into the main menu). Only the in-game save menus are hooked,
        -- through Kristal.getSaveFile.
        if FileButton then
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
            hookMethod(SmallFaceText, "init", function(orig, self, value, x, y, face, actor)
                return orig(self, resolveDisplayText(value), x, y, face, actor)
            end)
        end

        if HPText then
            hookMethod(HPText, "init", function(orig, self, value, x, y)
                return orig(self, resolveDisplayText(value), x, y)
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
            hookMethod(MainMenuFileSelect, "setResultText", function(orig, self, value)
                return orig(self, resolveDisplayText(value))
            end)
        end

        if TextMenuItemComponent then
            hookMethod(TextMenuItemComponent, "init", function(orig, self, value, callback, options)
                return orig(self, resolveDisplayText(value), callback, options)
            end)
        end

        if LabelMenuItemComponent then
            hookMethod(LabelMenuItemComponent, "init", function(orig, self, value, child, x_sizing, y_sizing, options)
                return orig(self, resolveDisplayText(value), child, x_sizing, y_sizing, options)
            end)
        end

        if DebugWindow then
            HookSystem.hook(DebugWindow, "init", function(orig, self, name, value, type, callback)
                local result = orig(self, resolveDisplayText(name), resolveDisplayText(value), type, callback)
                for index, button in ipairs(self.buttons or {}) do
                    self.buttons[index] = resolveDisplayText(button)
                end
                return result
            end)
        end

        if Console then
            HookSystem.hook(Console, "print", function(orig, self, value, x, y)
                if Game.lang ~= "zh_hans" then
                    return orig(self, value, x, y)
                end
                if value == nil then
                    return
                end

                local x_offset = 0

                for _, line in ipairs(value) do
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

        Game.lang = resolveLanguageId(getStartupLanguage() or data.lang or Game.lang or getConfig("defaultLanguage") or DEFAULT_LANGUAGE, Game.langAvailable)
            or getDefaultLanguage(Game.langAvailable)
        Game.langSelected = data.langSelected or Game.langSelected or 1
        Game.langNameLanguage = getStartupNameLanguage() or data.langNameLanguage or Game.langNameLanguage
        Game.langDebugTermsTranslated = data.langDebugTermsTranslated ~= false

        Game:loadLang(Game.lang)
        return data
    end

    function kristalI18n:save(data)
        data.lang = Game.lang
        data.langSelected = Game.langSelected
        data.langNameLanguage = Game.langNameLanguage
        data.langDebugTermsTranslated = Game:getDebugTermsTranslated()

        -- The engine's main-menu file select reads save data straight from disk
        -- via Kristal.loadData (bypassing Kristal.getSaveFile), so the summary
        -- persisted here must be ASCII-safe: store the raw room name and
        -- remember the localization key; in-game menus re-localize it through
        -- Kristal.getSaveFile.
        local map = Game and Game.world and Game.world.map
        if map and map.data and map.data.properties then
            local room_key = map.data.properties["name_id"]
                or (map.id and mapNameKey(map.id))
            if type(room_key) == "string" and room_key ~= "" then
                local raw_room_name = map.data.properties["name"]
                if type(raw_room_name) ~= "string" or raw_room_name == "" then
                    -- Maps without a raw name property fall back to the base
                    -- (English) localized name so the saved summary stays
                    -- ASCII-safe.
                    raw_room_name = type(Game.langBaseStr) == "table"
                        and Game.langBaseStr[room_key]
                        or nil
                end
                if type(raw_room_name) == "string" and raw_room_name ~= "" then
                    data.room_name = raw_room_name
                end
                data.room_name_key = room_key
            end
        end

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
            value = id .. " is missing"
        end

        return Game:concat(value, var)
    end

    function Game:locText(value, var)
        if isTextDescriptor(value) then
            local descriptor_id = getTextId(value)
            local descriptor_options = value.options or {}
            local descriptor_var = descriptor_options.var
                or (value.var ~= nil and value.var or var)
            if descriptor_id ~= nil then
                return Game:loc(descriptor_id, descriptor_var)
            end
            return Game:locText(value.text, descriptor_var)
        end

        if type(value) ~= "string" then
            if type(value) == "table" then
                if isClassInstance(value) or isColorTable(value) then
                    return value
                end

                local out = {}
                for key, item in pairs(value) do
                    out[key] = Game:locText(item, var)
                end
                return out
            end
            error("Game:locText expects a string or text descriptor")
        end
        return Game:concat(value, var)
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
end
