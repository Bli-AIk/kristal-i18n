local Item, super = HookSystem.hookScript(Item)

function Item:onCheck()
    if type(self:getCheck()) == "table" then
        local text
        for i, check in ipairs(self:getCheck()) do
            if i > 1 then
                if text == nil then
                    text = {}
                end
                table.insert(text, check)
            end
        end
        Game.world:showText({{Game:loc("item_check", {name = self:getName(), check = (self:getCheck()[1] or "")})}, text})
    else
        Game.world:showText(Game:loc("item_check", {name = self:getName(), check = self:getCheck()}))
    end
end

function Item:onToss()
    if Game:isLight() then
        if self.type == "weapon" and not Game:getConfig("canTossLightWeapons") then
            Game.world:showText(Game:loc("item_tossWeapon"))
            return false
        end

        local choice = love.math.random(30)
        if choice == 1 then
            local key = Game:hasStr("item_"..self.id.."_toss1") and "item_"..self.id.."_toss1" or "item_toss1"
            Game.world:showText(Game:loc(key, {name = self:getName()}))
        elseif choice == 2 then
            local key = Game:hasStr("item_"..self.id.."_toss2") and "item_"..self.id.."_toss2" or "item_toss2"
            Game.world:showText(Game:loc(key, {name = self:getName()}))
        elseif choice == 3 then
            local key = Game:hasStr("item_"..self.id.."_toss3") and "item_"..self.id.."_toss3" or "item_toss3"
            Game.world:showText(Game:loc(key, {name = self:getName()}))
        elseif choice == 4 then
            local key = Game:hasStr("item_"..self.id.."_toss4") and "item_"..self.id.."_toss4" or "item_toss4"
            Game.world:showText(Game:loc(key, {name = self:getName()}))
        else
            local key = Game:hasStr("item_"..self.id.."_toss5") and "item_"..self.id.."_toss5" or "item_toss5"
            Game.world:showText(Game:loc(key, {name = self:getName()}))
        end
    end
    return true
end

function Item:getName()     return Game:loc("item_"..self.id.."_name") end
function Item:getUseName()  return Game:loc("item_"..self.id.."_useName") end

local function locChapter(key)
    local chapter_key = key .. "_chapter_" .. tostring(Game.chapter)
    if Game.hasStr and Game:hasStr(chapter_key) then
        return Game:loc(chapter_key)
    end
    return Game:loc(key)
end

function Item:getDescription() return locChapter("item_"..self.id.."_description") end
function Item:getBattleDescription() return locChapter("item_"..self.id.."_effect") end
function Item:getCheck() return Game:loc("item_"..self.id.."_check") end

function Item:getShopDescription()
    return Game:loc("item_"..self.id.."_shopDesc", {typeName = self:getTypeName(), shopName = Game:loc("item_"..self.id.."_shopName")})
end

function Item:getBattleText(user, target)
    local key = Game:hasStr("item_"..self.id.."_battleText") and "item_"..self.id.."_battleText" or "item_battleText"
    return Game:loc(key, {charaName = user.chara:getName(), useName = self:getUseName()})
end

function Item:getReaction(user_id, reactor_id)
    local reactions = self:getReactions()
    if reactions[user_id] then
        if type(reactions[user_id]) == "string" then
            if reactor_id == user_id then
                return Game:loc("item_"..self.id.."_"..user_id.."Reaction") -- item_darkburger_krisReaction
            else
                return nil
            end
        else
            return Game:loc("item_"..self.id.."_"..user_id.."/"..reactor_id.."Reaction") -- item_darkburger_kris/ralseiReaction
        end
    end
end

function Item:getTypeName()
    if self.type == "item" then
        return Game:loc("itemType_item")
    elseif self.type == "key" then
        return Game:loc("itemType_key")
    elseif self.type == "weapon" then
        return Game:loc("itemType_weapon")
    elseif self.type == "armor" then
        return Game:loc("itemType_armor")
    end
    return Game:loc("itemType_unknown")
end

return Item
