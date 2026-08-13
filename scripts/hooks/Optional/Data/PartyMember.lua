local PM, super = Class(PartyMember)

-- Party titles are scoped per chapter: the engine defines a distinct title
-- for chapters 1-4 and reuses the chapter 4 title for anything above (its
-- `else` branch). Resolve the per-chapter key, mirroring that clamp. Party
-- members without chapter-scoped titles (e.g. Noelle) fall back to the
-- plain title key.
local function locTitle(id)
    local chapter = tonumber(Game.chapter) or 1
    chapter = math.max(1, math.min(4, chapter))
    local key = "chara_" .. id .. "_title"
    local chapter_key = key .. "_chapter_" .. tostring(chapter)
    if Game.hasStr and Game:hasStr(chapter_key) then
        return Game:loc(chapter_key)
    end
    return Game:loc(key)
end

function PM:getName()   return Game:locText("[name:" .. self.id .. "]") end
function PM:getTitle()  return Game:loc("chara_getTitle", {lv = self:getLevel(), title = locTitle(self.id)}) end

function PM:getXActName() return Game:loc("chara_"..self.id.."_xactName") end

return PM
