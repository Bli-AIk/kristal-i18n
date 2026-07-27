local PM, super = Class(PartyMember)

local function locChapter(default, key)
    local chapter_key = key .. "_chapter_" .. tostring(Game.chapter)
    if Game.hasStr and Game:hasStr(chapter_key) then
        return Game:loc(chapter_key)
    end
    return Game:loc(key)
end

function PM:getName()   return Game:locText("[name:" .. self.id .. "]") end
function PM:getTitle()  return Game:loc("chara_getTitle", {lv = self:getLevel(), title = locChapter(self.title, "chara_"..self.id.."_title")}) end

function PM:getXActName() return Game:loc("chara_"..self.id.."_xactName") end

return PM
