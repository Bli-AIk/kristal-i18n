--- CJK typesetting: text spacing, wrapping, and battle speech font selection.
---@param ctx table Shared module context.
---@return table CJK module.
return function(ctx)
    local M = {}
    local runtime = ctx.runtime
    local constants = ctx.constants

    local settings = {
        cjkFixedTextSpacing = constants.CJK_FIXED_TEXT_SPACING,
        cjkDialogueTextSpacing = constants.CJK_DIALOGUE_TEXT_SPACING,
        cjkTitleTextSpacing = math.floor(constants.CJK_FIXED_TEXT_SPACING / 2),
        cjkDialogueYOffset = constants.CJK_DIALOGUE_Y_OFFSET,
        cjkTypewriterSpeedMultiplier = constants.CJK_TYPEWRITER_SPEED_MULTIPLIER,
    }

    local function loadCjkConfig()
        settings.cjkFixedTextSpacing = runtime.getConfig("cjkFixedTextSpacing")
            or constants.CJK_FIXED_TEXT_SPACING
        settings.cjkDialogueTextSpacing = runtime.getConfig("cjkDialogueTextSpacing")
            or constants.CJK_DIALOGUE_TEXT_SPACING
        -- Party titles and the description box default to half the fixed-text
        -- spacing; configurable via "cjkTitleTextSpacing".
        settings.cjkTitleTextSpacing = runtime.getConfig("cjkTitleTextSpacing")
            or math.floor(settings.cjkFixedTextSpacing / 2)
        settings.cjkDialogueYOffset = runtime.getConfig("cjkDialogueYOffset")
            or constants.CJK_DIALOGUE_Y_OFFSET
        settings.cjkTypewriterSpeedMultiplier = runtime.getConfig("cjkTypewriterSpeedMultiplier")
            or constants.CJK_TYPEWRITER_SPEED_MULTIPLIER
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

    -- Wrap over-long CJK dialogue lines at natural punctuation boundaries.
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

    local function isCjkWrapPunctuation(char)
        local codepoint = utf8.codepoint(char)
        return codepoint == 0xFF0C
            or codepoint == 0x3002
            or codepoint == 0xFF01
            or codepoint == 0xFF1F
            or codepoint == 0x3001
            or codepoint == 0xFF1B
            or codepoint == 0xFF1A
            or codepoint == 0x2014
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
                    if isCjkWrapPunctuation(c) and cur_core >= 12 then
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

    M.settings = settings
    M.loadCjkConfig = loadCjkConfig
    M.isCjkCodepoint = isCjkCodepoint
    M.hasCjkText = hasCjkText
    M.hasMultipleCodepoints = hasMultipleCodepoints
    M.addCjkTextSpacing = addCjkTextSpacing
    M.wrapCjkTextValue = wrapCjkTextValue
    M.addCjkTextSpacingValue = addCjkTextSpacingValue
    M.isBattleSpeechDialogue = isBattleSpeechDialogue
    M.setBattleSpeechDialogueFont = setBattleSpeechDialogueFont
    return M
end
