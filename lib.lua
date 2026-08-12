--- Public entry: wires up the kristal-i18n implementation modules.
local kristalI18n = {}

local constants = {
    DEFAULT_LANGUAGE = "en",
    FALLBACK_LANGUAGE = "en",
    AUTO_LANGUAGE = "auto",
    CJK_FIXED_TEXT_SPACING = 4,
    CJK_DIALOGUE_TEXT_SPACING = 4,
    CJK_DIALOGUE_Y_OFFSET = -1,
    CJK_TYPEWRITER_SPEED_MULTIPLIER = 1, --0.85
    DEFAULT_LANGUAGE_TOGGLE_KEY = "f7",
    ID_INTERP_PATTERN = "%{([%w_./]*[a-zA-Z][%w_./]*)%}",
}

-- lib.lua is the public entry point; implementation is grouped by responsibility.
local library_id = ACTIVE_LIB and ACTIVE_LIB.info and ACTIVE_LIB.info.id or "kristalI18n"
local ctx = {
    library = kristalI18n,
    library_id = library_id,
    constants = constants,
}

ctx.data = libRequire(library_id, "modules.data")(ctx)
ctx.runtime = libRequire(library_id, "modules.runtime")(ctx)
ctx.system_language = libRequire(library_id, "modules.system_language")(ctx)
ctx.cjk = libRequire(library_id, "modules.cjk")(ctx)
ctx.text = libRequire(library_id, "modules.text")(ctx)
ctx.assets = libRequire(library_id, "modules.assets")(ctx)
ctx.hooks = libRequire(library_id, "modules.hooks")(ctx)

-- Load order matters: data -> runtime -> cjk -> text/assets -> hooks, then
-- lifecycle attaches the library callbacks and public Game API.
return libRequire(library_id, "modules.lifecycle")(ctx)
