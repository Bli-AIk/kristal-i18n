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

-- `Game:hasStr` includes the English base language. Optional overrides must
-- check `Game.langStr` directly so a missing local key falls back to `name`.
local function resolveChapterKey(key, item, current_language_only)
    local has_key
    if current_language_only then
        if not Game.langStr then
            return nil
        end
        has_key = function(candidate)
            return Game.langStr[candidate] ~= nil
        end
    else
        if not Game.hasStr then
            return key
        end
        has_key = function(candidate)
            return Game:hasStr(candidate)
        end
    end

    local chapter = tostring(Game.chapter)
    local chapter_key = key .. "_chapter_" .. chapter

    if item and item.id == "dark_candy" and item.name == "Darker Candy" then
        local chapter_variant_key = chapter_key .. "_darker"
        if has_key(chapter_variant_key) then
            return chapter_variant_key
        end

        local variant_key = key .. "_darker"
        if has_key(variant_key) then
            return variant_key
        end
    end

    if has_key(chapter_key) then
        return chapter_key
    end
    if has_key(key) then
        return key
    end
    return nil
end

local function locChapter(key, item)
    return Game:loc(resolveChapterKey(key, item) or key)
end

function Item:getName()     return Game:loc("item_"..self.id.."_name") end

-- `useName` is an optional battle-only override. Without it, battle text
-- uses the localized canonical `name`; other item fields remain independent.
function Item:getUseName()
    local key = "item_"..self.id.."_useName"
    local localized_key = resolveChapterKey(key, self, true)
    if localized_key then
        return Game:loc(localized_key)
    end
    return self:getName()
end

-- `description` is menu text and `check` is inspect text. They may match,
-- but one must not be used as the other's fallback.
function Item:getDescription() return locChapter("item_"..self.id.."_description", self) end
function Item:getBattleDescription() return locChapter("item_"..self.id.."_effect", self) end
function Item:getCheck() return Game:loc("item_"..self.id.."_check") end

-- Shop lookups are per item, even when the template text repeats.
function Item:getShopDescription()
    return Game:loc("item_"..self.id.."_shopDesc", {typeName = self:getTypeName(), shopName = Game:loc("item_"..self.id.."_shopName")})
end

function Item:getBattleText(user, target)
    local key = Game:hasStr("item_"..self.id.."_battleText") and "item_"..self.id.."_battleText" or "item_battleText"
    return Game:loc(key, {charaName = user.chara:getName(), useName = self:getUseName()})
end

function Item:getReaction(user_id, reactor_id)
    local reactions = self:getReactions()
    local user_reaction = reactions[user_id]
    if not user_reaction then
        return nil
    end

    local reaction
    local key = "item_"..self.id
    if self.reaction_variants and Game.save_id ~= nil then
        key = key.."_variant_"..tostring(Game.save_id)
    end

    if type(user_reaction) == "string" then
        if reactor_id ~= user_id then
            return nil
        end
        reaction = user_reaction
        key = key.."_"..user_id.."Reaction"
    else
        reaction = user_reaction[reactor_id]
        key = key.."_"..user_id.."/"..reactor_id.."Reaction"
    end

    if not reaction then
        return nil
    end

    -- Keep framework text when a source string has no authoritative translation.
    if Game.hasStr and Game:hasStr(key) then
        return Game:loc(key)
    end
    return reaction
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
