local LightInventory, super = HookSystem.hookScript(LightInventory)

function LightInventory:tryGiveItem(item, ignore_dark)
    if type(item) == "string" then
        item = Registry.createItem(item)
    end
    if ignore_dark or item.light then
        return super.tryGiveItem(self, item, ignore_dark)
    else
        local dark_inv = self:getDarkInventory()
        local result = dark_inv:addItem(item)
        if result then
            return true, Game:loc("inventory_tryGiveDarkTrue", {itemName = item:getName()})
        else
            return false, Game:loc("inventory_tryGiveDarkFalse", {itemName = item:getName()})
        end
    end
end

return LightInventory