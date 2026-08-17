local DarkConfigMenu, super = HookSystem.hookScript(DarkConfigMenu)
local DarkConfigBooleanOption, boolean_super = HookSystem.hookScript(DarkConfigBooleanOption)
local DarkConfigBorderOption, border_super = HookSystem.hookScript(DarkConfigBorderOption)
local DarkConfigRebindState = HookSystem.hookScript(DarkConfigRebindState)
local cjk = _G.kristalI18nCjk

local CONFIG_OPTION_IDS = {
    ["Master Volume"] = "master_volume_config",
    ["Controls"] = "controls_config",
    ["Simplify VFX"] = "simp_vfx_config",
    ["Fullscreen"] = "fullscreen_config",
    ["Auto-Run"] = "auto_run_config",
    ["Border"] = "border_config",
    ["Return to Title"] = "back_title_config",
    ["Back"] = "back_config",
}

local BORDER_NAME_IDS = {
    ["OFF"] = "off",
    ["Dynamic"] = "dynamic_config",
    ["Simple"] = "simple_config",
    ["None"] = "none_config",
}

local function formatLocalizedInput(text, mode)
    if mode == "upper" then
        return StringUtils.upper(text)
    elseif mode == "title" then
        return StringUtils.titleCase(text)
    end
    return text
end

local function localizeInputText(default, id, mode)
    local text = Game:hasStr(id) and Game:loc(id) or Game:locText(default)
    return formatLocalizedInput(text, mode)
end

local function localizeAlias(alias)
    if type(alias) == "table" then
        local parts = {}
        for _, word in ipairs(alias) do
            table.insert(parts, localizeInputText(word, word, "title"))
        end
        return table.concat(parts, "+")
    elseif alias ~= nil then
        return localizeInputText(alias, alias, "title")
    end
end

local function languageOptionIndex(self)
    for index, option in ipairs(self.options or {}) do
        if option == self.i18n_language_option then
            return index
        end
    end
    return self.currently_selected
end

local function refreshLabels(self)
    if not self.config_text then
        return
    end

    -- Config labels are Text objects, so the CJK spacing is baked in at
    -- setText time; use half the regular spacing like the other dark menus.
    local saved = cjk.settings.cjkFixedTextSpacing
    cjk.settings.cjkFixedTextSpacing = cjk.settings.cjkTitleTextSpacing
    local ok, result = xpcall(function()
        self.config_text:setText(Game:loc("config"))
        for _, option in ipairs(self.options or {}) do
            local id = option.i18n_text_id or CONFIG_OPTION_IDS[option.name]
            if id then
                option.i18n_text_id = id
                option.name = Game:loc(id)
                option.text:setText(option.name)
            end
        end
    end, debug.traceback)
    cjk.settings.cjkFixedTextSpacing = saved
    if not ok then
        error(result)
    end
    self.i18n_menu_language = Game:getLanguage()
end

local function changeLanguage(self, direction)
    local languages = Game:getLanguages()
    local current = Game.langSelected or 1
    local selected = MathUtils.clamp(current + direction, 1, #languages)
    if selected ~= current and Game:setLanguage(languages[selected]) then
        refreshLabels(self)
        return true
    end
    return false
end

local function changeNameLanguage(direction)
    local languages = Game:getNameLanguages()
    local current = Game.langNameLanguageSelected or 1
    local selected = MathUtils.clamp(current + direction, 1, #languages)
    if selected ~= current then
        return Game:setNameLanguage(languages[selected])
    end
    return false
end

local DarkConfigLanguageState, language_super = Class(StateClass)

function DarkConfigLanguageState:init(menu)
    self.menu = menu
end

function DarkConfigLanguageState:registerEvents()
    self:registerEvent("enter", self.onEnter)
    self:registerEvent("leave", self.onLeave)
    self:registerEvent("update", self.onUpdate)
    self:registerEvent("draw", self.onDraw)
end

function DarkConfigLanguageState:onEnter(old_state)
    self.currently_selected = 1
    self.menu:hideOptions()
end

function DarkConfigLanguageState:onLeave(new_state)
    self.menu:showOptions()
end

function DarkConfigLanguageState:onUpdate()
    local menu = self.menu

    if Input.pressed("cancel") then
        menu.currently_selected = languageOptionIndex(menu)
        Assets.stopAndPlaySound("ui_select")
        menu:setState("MAIN")
        return
    end

    if Input.pressed("confirm") then
        if self.currently_selected == 3 then
            menu.currently_selected = languageOptionIndex(menu)
            Assets.stopAndPlaySound("ui_select")
            menu:setState("MAIN")
        else
            Assets.stopAndPlaySound("ui_select")
        end
        return
    end

    local old_selected = self.currently_selected
    if Input.pressed("up") then
        self.currently_selected = self.currently_selected - 1
    end
    if Input.pressed("down") then
        self.currently_selected = self.currently_selected + 1
    end
    self.currently_selected = MathUtils.clamp(self.currently_selected, 1, 3)

    if old_selected ~= self.currently_selected then
        Assets.stopAndPlaySound("ui_move")
    end

    local changed = false
    if Input.pressed("left") then
        if self.currently_selected == 1 then
            changed = changeLanguage(menu, -1)
        elseif self.currently_selected == 2 then
            changed = changeNameLanguage(-1)
        end
    end
    if Input.pressed("right") then
        if self.currently_selected == 1 then
            changed = changeLanguage(menu, 1)
        elseif self.currently_selected == 2 then
            changed = changeNameLanguage(1)
        end
    end

    if changed then
        Assets.stopAndPlaySound("ui_move")
    end
end

function DarkConfigLanguageState:onDraw()
    -- Draw the language screen with half the regular CJK spacing as well.
    local saved = cjk.settings.cjkFixedTextSpacing
    cjk.settings.cjkFixedTextSpacing = cjk.settings.cjkTitleTextSpacing
    local ok, result = xpcall(function()
        local menu = self.menu
        local font = Assets.getFont("main")
        love.graphics.setFont(font)
        Draw.setColor(PALETTE["world_text"])
        love.graphics.printf(Game:loc("language_settings_config"), 0, -12, menu.width, "center")

        local labels = {
            Game:loc("text_language_config"),
            Game:loc("name_language_config"),
            Game:loc("back_config"),
        }
        local values = {
            Game:getLanguageName(),
            Game:getNameLanguageName(),
            nil,
        }
        local label_x = 88
        local value_right = menu.width - label_x

        for index, label in ipairs(labels) do
            Draw.setColor(PALETTE["world_text"])
            local y = 38 + ((index - 1) * menu:getOptionHeight())
            love.graphics.print(label, label_x, y)

            if values[index] then
                local value, scale = StringUtils.squishAndTrunc(values[index], font, 150, nil, 0.5)
                love.graphics.print(value, value_right - (font:getWidth(value) * scale), y, 0, scale, 1)
            end
        end

        Draw.setColor(Game:getSoulColor())
        Draw.draw(menu.heart_sprite, 63, 48 + ((self.currently_selected - 1) * menu:getOptionHeight()))
        Draw.setColor(1, 1, 1, 1)
    end, debug.traceback)
    cjk.settings.cjkFixedTextSpacing = saved
    if not ok then
        error(result)
    end
end

function DarkConfigMenu:addExitOptions()
    local language_option = DarkConfigOption(self, Game:loc("lang_config"), function()
        self:setState("LANGUAGE")
    end)
    language_option.i18n_text_id = "lang_config"
    self.i18n_language_option = self:addOption(language_option)

    super.addExitOptions(self)
end

function DarkConfigMenu:init()
    super.init(self)

    self.language_state = DarkConfigLanguageState(self)
    self.state_manager:addState("LANGUAGE", self.language_state)

    refreshLabels(self)
end

function DarkConfigMenu:update()
    if self.i18n_menu_language ~= Game:getLanguage() then
        refreshLabels(self)
    end
    return super.update(self)
end

function DarkConfigBooleanOption:draw()
    local saved = cjk.settings.cjkFixedTextSpacing
    cjk.settings.cjkFixedTextSpacing = cjk.settings.cjkTitleTextSpacing
    local ok, result = xpcall(function()
        boolean_super.super.draw(self)

        Draw.setColor(PALETTE["world_text"])
        love.graphics.setFont(Assets.getFont("main"))
        love.graphics.print(self.enabled and Game:loc("on") or Game:loc("off"), 348, 0)
    end, debug.traceback)
    cjk.settings.cjkFixedTextSpacing = saved
    if not ok then
        error(result)
    end
end

function DarkConfigBorderOption:draw()
    local saved = cjk.settings.cjkFixedTextSpacing
    cjk.settings.cjkFixedTextSpacing = cjk.settings.cjkTitleTextSpacing
    local ok, result = xpcall(function()
        border_super.super.draw(self)

        if self.selected then
            Draw.setColor(PALETTE["world_text_selected"])
        else
            Draw.setColor(PALETTE["world_text"])
        end

        love.graphics.setFont(Assets.getFont("main"))
        local name = Kristal.getBorderName()
        local id = BORDER_NAME_IDS[name]
        love.graphics.print(id and Game:loc(id) or name, 348, 0)
    end, debug.traceback)
    cjk.settings.cjkFixedTextSpacing = saved
    if not ok then
        error(result)
    end
end

function DarkConfigRebindState:onDraw()
    love.graphics.setFont(Assets.getFont("main"))
    Draw.setColor(PALETTE["world_text"])

    local dualshock = Input.getControllerType() == "ps4"

    love.graphics.print(Game:loc("function_config"), 23, -12)
    if not Kristal.isConsole() then
        love.graphics.print(Game:loc("key_config"), 243, -12)
    end
    if Input.hasGamepad() then
        local heading = Kristal.isConsole() and Game:loc("button_config") or Game:loc("gamepad_config")
        love.graphics.print(heading, 353, -12)
    end

    for index, name in ipairs(Input.order) do
        if index > 7 then
            break
        end
        Draw.setColor(PALETTE["world_text"])
        if self.currently_selected == index then
            if self.rebinding then
                Draw.setColor(PALETTE["world_text_rebind"])
            else
                Draw.setColor(PALETTE["world_text_hover"])
            end
        end

        local input_name = localizeInputText(name:gsub("_", " "), name, "upper")
        if dualshock then
            love.graphics.print(input_name, 23, -4 + (29 * index))
        else
            love.graphics.print(input_name, 23, -4 + (28 * index) + 4)
        end

        if not Kristal.isConsole() then
            local alias = Input.getBoundKeys(name, false)[1]
            local alias_text = localizeAlias(alias)
            if alias_text then
                love.graphics.print(alias_text, 243, 0 + (28 * index))
            end
        end

        Draw.setColor(1, 1, 1)

        if Input.hasGamepad() then
            local alias = Input.getBoundKeys(name, true)[1]
            if alias then
                local btn_tex = Input.getButtonTexture(alias)
                if dualshock then
                    Draw.draw(btn_tex, 353 + 42, -2 + (29 * index), 0, 2, 2, btn_tex:getWidth() / 2, 0)
                else
                    Draw.draw(btn_tex, 353 + 42 + 16 - 6, -2 + (28 * index) + 11 - 6 + 1, 0, 2, 2,
                        btn_tex:getWidth() / 2, 0)
                end
            end
        end
    end

    Draw.setColor(PALETTE["world_text"])
    if self.currently_selected == 8 then
        Draw.setColor(PALETTE["world_text_hover"])
    end

    if self.reset_flash_timer > 0 then
        Draw.setColor(ColorUtils.mergeColor(PALETTE["world_text_hover"], PALETTE["world_text_selected"],
            ((self.reset_flash_timer / 10) - 0.1)))
    end

    if dualshock then
        love.graphics.print(Game:loc("reset_default_config"), 23, -4 + (29 * 8))
    else
        love.graphics.print(Game:loc("reset_default_config"), 23, -4 + (28 * 8) + 4)
    end

    Draw.setColor(PALETTE["world_text"])
    if self.currently_selected == 9 then
        Draw.setColor(PALETTE["world_text_hover"])
    end

    if dualshock then
        love.graphics.print(Game:loc("finish_config"), 23, -4 + (29 * 9))
    else
        love.graphics.print(Game:loc("finish_config"), 23, -4 + (28 * 9) + 4)
    end

    Draw.setColor(Game:getSoulColor())
    local heart = Assets.getTexture("player/heart")

    if dualshock then
        Draw.draw(heart, -2, 34 + ((self.currently_selected - 1) * 29))
    else
        Draw.draw(heart, -2, 34 + ((self.currently_selected - 1) * 28) + 2)
    end
end

return DarkConfigMenu
