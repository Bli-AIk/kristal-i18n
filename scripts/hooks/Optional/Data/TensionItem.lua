local TensionItem, super = HookSystem.hookScript(TensionItem)

function TensionItem:onWorldUse(target)
    Game.world:showText({
        Game:loc("tensionItem_worldUse1"),
        Game:loc("tensionItem_worldUse2")
    })
    return false
end

return TensionItem