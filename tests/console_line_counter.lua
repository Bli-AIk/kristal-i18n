-- Run from the library root: luajit tests/console_line_counter.lua
-- Exercise the real dynamic matcher and lifecycle hook without a graphics
-- server. Font widths are deliberately synthetic, so using raw getWidth()
-- instead of the CJK-aware width helper fails the positioning assertions.
local ctx
libRequire = function(_, path)
    local factory = assert(loadfile(path:gsub("%.", "/") .. ".lua"))()
    return function(context)
        ctx = context
        return factory(context)
    end
end
Game = { lang = "zh_hans" }
local library = dofile("lib.lua")

local function langValue(language, key)
    local file = assert(io.open("lang/" .. language .. ".json", "rb"))
    local source = file:read("*a")
    file:close()
    return assert(source:match('"' .. key .. '"%s*:%s*"([^"]*)"'))
end
Game.langStr = { console_line_counter = langValue("zh_hans", "console_line_counter") }
Game.langBaseStr = { console_line_counter = langValue("en", "console_line_counter") }

for _, pair in ipairs({ { 0, 0 }, { 1, 1 }, { 8, 8 }, { 2, 100 }, { 12345, 67890 } }) do
    local line, total = pair[1], pair[2]
    assert(ctx.hooks.resolveDisplayText(("Line %d of %d"):format(line, total))
        == ("第 %d 行，共 %d 行"):format(line, total))
end
for _, source in ipairs({ "Line x of x", "Line 8 of 8 extra", "prefix Line 8 of 8", "Lines 8 of 8" }) do
    assert(ctx.hooks.resolveDisplayText(source) == source)
end

local function noop() end
-- Avoid unrelated startup work; keep the actual resolver and console hook.
ctx.text.ensureLanguageGlobals = noop
ctx.text.ensureNameLanguageGlobals = noop
ctx.text.refreshConsoleStartupHistory = noop
ctx.text.hookLightMenuDraw = noop
ctx.text.hookShopDraw = noop
ctx.text.refreshDebugOptionDescriptions = noop
ctx.hooks.hookDebugSystemLocalization = noop
ctx.assets.refreshLocalizedAssets = noop
ctx.text.getPrintedTextWidth = function(font, value)
    return value:find("第", 1, true) and 188 or font:getWidth(value)
end
library = dofile("modules/lifecycle.lua")(ctx)
Game.loadLang = noop

local consoleHook
Console = {}
Assets = {}
StringUtils = {}
love = { graphics = {} }
HookSystem = {
    hook = function(target, name, hook)
        if target == Console and name == "print" then consoleHook = hook end
    end,
}
library:postInit()
assert(consoleHook)

local currentColor
Draw = { setColor = function(...) currentColor = { ... } end }
ColorUtils = {
    ensureAlpha = function(color)
        return { color[1], color[2], color[3], color[4] or 1 }
    end,
}
SCREEN_WIDTH = 640
local output = {}
local font = { getWidth = function(_, value) return #value * 2 end }
local console = {
    font = font,
    color = { 1, 1, 1, 1 },
    printOutlined = function(_, value, x, y)
        output[#output + 1] = { text = value, x = x, y = y, color = currentColor }
    end,
}
local function noFallback() error("unexpected delegation") end

local source = { "Line 8 of 8" }
consoleHook(noFallback, console, source, 8, 42, "right")
assert(source[1] == "Line 8 of 8", "caller-owned segments must remain unchanged")
assert(output[1].text == "第 8 行，共 8 行")
assert(output[1].x == 640 - 8 - 188)
assert(output[1].y == 42)

output = {}
local red = { 1, 0, 0, 0.8 }
local green = { 0, 1, 0 }
consoleHook(noFallback, console, { red, "Line 2 of 100", green, "!" }, 8, 24, "right", 0.5)
assert(output[1].text == "第 2 行，共 100 行")
assert(output[1].x == 640 - 8 - 188 - 2)
assert(output[2].x == 640 - 8 - 2)
assert(output[1].color[1] == 1 and output[1].color[4] == 0.4)
assert(output[2].color[2] == 1 and output[2].color[4] == 0.5)

for _, alignment in ipairs({ false, "left" }) do
    output = {}
    consoleHook(noFallback, console, { red, "Line 1 of 1", "!" }, 8, 0, alignment or nil, 0)
    assert(output[1].x == 8 and output[2].x == 8 + 188)
    assert(output[1].color[4] == 0, "an explicit zero alpha is preserved")
end
consoleHook(noFallback, console, nil, 8, 0)

-- Unknown alignment modes continue to use the engine's original semantics.
local delegated = false
consoleHook(function(_, value, x, y, align, alpha)
    delegated = true
    assert(value[1] == "第 8 行，共 8 行")
    assert(x == 8 and y == 42 and align == "center" and alpha == 0.25)
end, console, source, 8, 42, "center", 0.25)
assert(delegated)

-- A language switch takes effect without reinstalling hooks or mutating input.
Game.lang = "en"
assert(ctx.hooks.resolveDisplayText("Line 8 of 8") == "Line 8 of 8")
local result = consoleHook(function(_, value, x, y, align, alpha)
    assert(value == source and x == 8 and y == 42 and align == "right" and alpha == 0.5)
    return "original return value"
end, console, source, 8, 42, "right", 0.5)
assert(result == "original return value")
Game.lang = "zh_hans"
output = {}
consoleHook(noFallback, console, source, 8, 42, "right")
assert(output[1].text == "第 8 行，共 8 行")

print("console line counter localization, alignment, colors and alpha: PASS")
