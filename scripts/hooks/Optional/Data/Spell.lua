local Spell, super = HookSystem.hookScript(Spell)

local function loc(key, fallback, var)
    if Game.hasStr and Game:hasStr(key) then
        return Game:loc(key, var)
    end
    return fallback
end

-- Resolve a chapter-scoped localization ID. Spell text that differs
-- per chapter (e.g. the ACT spell) use the per-chapter key; the engine
-- defines those for chapters 1-5 and reuses the chapter 5 text for anything
-- above, so the chapter is clamped to mirror that `else` branch. Spells
-- without chapter-scoped text fall back to the plain key.
local function locChapter(key, fallback)
    local chapter = tonumber(Game.chapter) or 1
    chapter = math.max(1, math.min(5, chapter))
    local chapter_key = key .. "_chapter_" .. tostring(chapter)
    if Game.hasStr and Game:hasStr(chapter_key) then
        return Game:loc(chapter_key)
    end
    return loc(key, fallback)
end

function Spell:getName() return loc("spell_"..self.id.."_name", self.name) end

function Spell:getCastName()
    return locChapter("spell_"..self.id.."_castName", self.cast_name or StringUtils.upper(self.name or ""))
end

function Spell:getDescription() return locChapter("spell_"..self.id.."_description", self.description) end
function Spell:getBattleDescription() return locChapter("spell_"..self.id.."_effect", self.effect) end

function Spell:getCastMessage(user, target)
    local user_name = user.chara:getName()
    local cast_name = self:getCastName()
    return loc("spell_castMessage", "* " .. user_name .. " used " .. cast_name .. "!", {
        userName = user_name,
        castName = cast_name
    })
end

return Spell
