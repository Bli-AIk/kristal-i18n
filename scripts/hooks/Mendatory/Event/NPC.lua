local NPC, super = HookSystem.hookScript(NPC)

local function getDialogueSource(self)
    if type(self.text_id) == "table" and #self.text_id > 0 then
        return self.text_id, true
    end
    return self.text or {}, false
end

local function getDialogueGroup(source, index)
    local group = source[index]
    if type(group) == "table" then
        return group
    elseif group ~= nil then
        return {group}
    end
    return {}
end

function NPC:init(x, y, shape, properties)
    properties = properties or {}

    super.init(self, x, y, shape, properties)

    self.text_id = TiledUtils.parsePropertyMultiList("id", properties)
end

function NPC:onInteract(player, dir)
    if self.talk_sprite then
        self:setSprite(self.talk_sprite)
    end
    if self.turn then
        self:facePlayer()
    end
    self.interact_count = self.interact_count + 1

    if self.script then
        Registry.getEventScript(self.script)(self, player, dir)
    end
    if self.set_flag then
        Game:setFlag(self.set_flag, (self.set_value == nil and true) or self.set_value)
    end
    if self.cutscene then
        self.world:startCutscene(self.cutscene, self, player, dir):after(function()
            self:onTextEnd()
        end)
        return true
    else
        local dialogue, uses_ids = getDialogueSource(self)
        if #dialogue == 0 then
            return
        end

        self.world:startCutscene(function(cutscene)
            cutscene:setSpeaker(self, self.talk)
            local text_index = MathUtils.clamp(self.interact_count, 1, #dialogue)
            local group = getDialogueGroup(dialogue, text_index)
            for _, line in ipairs(group) do
                cutscene:text(uses_ids and Game:loc(line) or Game:locText(line))
            end
        end):after(function()
            self:onTextEnd()
        end)
        return true
    end
end

return NPC
