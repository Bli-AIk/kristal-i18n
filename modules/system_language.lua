--- System language detection: SDL FFI, love.system, C locale, env vars.
---@param ctx table Shared module context.
---@return table System language module.
return function(ctx)
    local M = {}
    local matchAvailableLanguage = ctx.runtime.matchAvailableLanguage

    -- LuaJIT FFI (bundled with LÖVE); falls back to love.system / env vars.
    local ffi
    do
        local ok, loaded = pcall(require, "ffi")
        if ok then
            ffi = loaded
        end
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

    -- SDL FFI (SDL_GetPreferredLocales) for system language, most portable:
    -- Windows sets no env vars and getLocale may be "C", SDL uses GetUserPreferredUILanguages.
    -- NOTE: switch to LÖVE 12's native API and remove this once available.
    local function getSdlLocales()
        local locales = {}

        if not ffi then
            return locales
        end

        local sdl
        for _, name in ipairs({ "SDL2", "libSDL2-2.0.so.0", "SDL2.framework/SDL2" }) do
            local ok, lib = pcall(ffi.load, name)
            if ok then
                sdl = lib
                break
            end
        end
        if not sdl then
            return locales
        end

        pcall(function()
            ffi.cdef [[
                typedef struct SDL_Locale {
                    const char *language;
                    const char *country;
                } SDL_Locale;
                SDL_Locale * SDL_GetPreferredLocales(void);
            ]]

            -- Returns an SDL_Locale array; the final item is zeroed.
            local arr = sdl.SDL_GetPreferredLocales()
            if arr ~= nil then
                local i = 0
                while arr[i].language ~= nil do
                    local value = ffi.string(arr[i].language)
                    if arr[i].country ~= nil and arr[i].country[0] ~= 0 then
                        value = value .. "_" .. ffi.string(arr[i].country)
                    end
                    table.insert(locales, value)
                    i = i + 1
                end
            end
        end)

        return locales
    end

    local function getSystemLocales()
        local locales = {}

        -- SDL first: the only reliable system-language source on Windows.
        addLocale(locales, getSdlLocales())

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

    function M.getSystemLanguage(available)
        for _, locale in ipairs(getSystemLocales()) do
            local lang = matchAvailableLanguage(locale, available)
            if lang then
                return lang
            end
        end

        return nil
    end

    return M
end
