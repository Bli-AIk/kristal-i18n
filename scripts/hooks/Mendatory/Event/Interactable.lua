local Interactable, super = HookSystem.hookScript(Interactable)

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

function Interactable:init(x, y, shape, properties)
    properties = properties or {}

    super.init(self, x, y, shape, properties)

    self.text_id = TiledUtils.parsePropertyMultiList("id", properties)
end

function Interactable:getDebugInfo()
    local info = super.getDebugInfo(self)
    if self.cutscene then table.insert(info, "Cutscene: " .. tostring(self.cutscene)) end
    if self.script then table.insert(info, "Script: " .. tostring(self.script)) end
    if self.set_flag then table.insert(info, "Set Flag: " .. self.set_flag) end
    if self.set_value then table.insert(info, "Set Value: " .. self.set_value) end
    table.insert(info, "Once: " .. (self.once and "True" or "False"))

    local dialogue = getDialogueSource(self)
    table.insert(info, "Text length: " .. #dialogue)
    return info
end

function Interactable:onInteract(player, dir)
    self.interact_count = self.interact_count + 1

    if self.script then
        Registry.getEventScript(self.script)(self, player, dir)
    end
    local cutscene
    if self.cutscene then
        cutscene = self.world:startCutscene(self.cutscene, self, player, dir)
    else
        local dialogue, uses_ids = getDialogueSource(self)
        cutscene = self.world:startCutscene(function(c)
            if #dialogue == 0 then
                return
            end

            local text_index = MathUtils.clamp(self.interact_count, 1, #dialogue)
            local group = getDialogueGroup(dialogue, text_index)
            for _, line in ipairs(group) do
                c:text(uses_ids and Game:loc(line) or Game:locText(line))
            end
        end)
    end
    cutscene:after(function()
        self:onTextEnd()
    end)

    if self.set_flag then
        Game:setFlag(self.set_flag, (self.set_value == nil and true) or self.set_value)
    end

    self:setFlag("used_once", true)
    if self.once then
        self:remove()
    end

    return true
end

return Interactable
