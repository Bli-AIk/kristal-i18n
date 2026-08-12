--- Runtime utilities: config access, language normalization/matching, helpers.
---@param ctx table Shared module context.
---@return table Runtime module.
return function(ctx)
    local M = {}
    local constants = ctx.constants

    local DEFAULT_LANGUAGE = constants.DEFAULT_LANGUAGE
    local FALLBACK_LANGUAGE = constants.FALLBACK_LANGUAGE
    local AUTO_LANGUAGE = constants.AUTO_LANGUAGE

    local function getConfig(key, merge, deep_merge)
        if Kristal and Kristal.getLibConfig then
            local ok, value = pcall(Kristal.getLibConfig, ctx.library_id, key, merge, deep_merge)
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

    local function getStartupLanguage()
        local args = Kristal and Kristal.Args
        if type(args) ~= "table" then
            return nil
        end

        for _, name in ipairs({ "lang", "language" }) do
            local values = args[name]
            if type(values) == "table" and values[1] ~= nil and tostring(values[1]) ~= "" then
                return values[1]
            end
        end
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
            if normalized:find("hant") or normalized:find("_tw")
                or normalized:find("_hk") or normalized:find("_mo")
            then
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

    M.getConfig = getConfig
    M.tableCopy = tableCopy
    M.deepMerge = deepMerge
    M.listContains = listContains
    M.normalizeLanguageId = normalizeLanguageId
    M.normalizeNameId = normalizeNameId
    M.normalizeNameLanguage = normalizeNameLanguage
    M.getStartupLanguage = getStartupLanguage
    M.applyOriginalDebugTermReplacements = applyOriginalDebugTermReplacements
    M.matchAvailableLanguage = matchAvailableLanguage
    M.getSystemLanguage = getSystemLanguage
    M.resolveLanguageId = resolveLanguageId
    M.getDefaultLanguage = getDefaultLanguage
    return M
end
