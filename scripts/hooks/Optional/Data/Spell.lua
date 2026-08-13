local Spell, super = HookSystem.hookScript(Spell)

-- Resolve a chapter-scoped localization ID. Spell descriptions that differ
-- per chapter (e.g. the ACT spell) use the per-chapter key; the engine
-- defines those for chapters 1-4 and reuses the chapter 4 text for anything
-- above, so the chapter is clamped to mirror that `else` branch. Spells
-- without chapter-scoped text fall back to the plain key.
local function locChapter(key)
    local chapter = tonumber(Game.chapter) or 1
    chapter = math.max(1, math.min(4, chapter))
    local chapter_key = key .. "_chapter_" .. tostring(chapter)
    if Game.hasStr and Game:hasStr(chapter_key) then
        return Game:loc(chapter_key)
    end
    return Game:loc(key)
end

function Spell:getName()        return Game:loc("spell_"..self.id.."_name")     end
function Spell:getCastName()    return Game:loc("spell_"..self.id.."_castName") end

function Spell:getDescription()         return locChapter("spell_"..self.id.."_description") end
function Spell:getBattleDescription()   return locChapter("spell_"..self.id.."_effect")      end

function Spell:getCastMessage(user, target)
    return Game:loc("spell_castMessage", {userName = user.chara:getName(), castName = self:getCastName()})
end

return Spell
