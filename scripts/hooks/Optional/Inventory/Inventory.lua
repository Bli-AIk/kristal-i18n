local Inventory, super = HookSystem.hookScript(Inventory)

local function getStorageName(storage)
    local id = "storage_" .. tostring(storage.id)
    return Game:hasStr(id) and Game:loc(id) or Game:locText(storage.name)
end

function Inventory:tryGiveItem(item, ignore_convert)
    if type(item) == "string" then
        item = Registry.createItem(item)
    end
    local result = self:addItem(item, ignore_convert)
    if result then
        local destination = self:getStorage(self.stored_items[result].storage)
        return true, Game:loc("inventory_giveItemTrue", {itemName = item:getName(), destinationName = getStorageName(destination)})
    else
        local destination = self:getDefaultStorage(item)
        return false, Game:loc("inventory_giveItemFalse", {destinationName = getStorageName(destination), itemName = item:getName()})
    end
end

return Inventory
