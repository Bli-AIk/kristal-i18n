local Actor, super = HookSystem.hookScript(Actor)

function Actor:getName() return Game:locText("[name:" .. self.id .. "]") end

return Actor
