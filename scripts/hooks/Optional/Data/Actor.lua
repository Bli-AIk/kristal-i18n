local Actor, super = HookSystem.hookScript(Actor)

function Actor:getName() return Game:loc("[name:" .. self.id .. "]") end

return Actor
