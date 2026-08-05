local Spell, super = HookSystem.hookScript(Spell)

local function locChapter(key)
    local chapter_key = key .. "_chapter_" .. tostring(Game.chapter)
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
