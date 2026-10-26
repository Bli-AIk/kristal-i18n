-- A custom enemy's fatigue getter takes precedence over its backing field.
local hooks = dofile("modules/hooks.lua")({
    library = {}, runtime = {}, text = {}, assets = {},
})
Game = { loc = function(_, key) return key end }

local spell = hooks.applySpellLocalizationPatch({
    id = "pacify", getCastName = function() return "PACIFY" end,
})
local user = { chara = { getName = function() return "RALSEI" end } }
local target = { tired = false, mercy = 0, isTired = function() return true end }
assert(spell:getCastMessage(user, target) == "spell_castMessage")

target.tired = true
target.isTired = function() return false end
assert(spell:getCastMessage(user, target):find("spell_pacify_not_tired_enemy", 1, true))
target.mercy = 100
assert(spell:getCastMessage(user, target):find("spell_pacify_not_tired_foe_spare", 1, true))

print("localized pacify tired getter: PASS")
