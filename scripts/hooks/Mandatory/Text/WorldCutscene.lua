local WorldCutscene, super = Class(WorldCutscene)

local function getTextId(value)
    if type(value) ~= "table" then
        return nil
    end
    return value.id
end

local function isTextDescriptor(value)
    return type(value) == "table"
        and (getTextId(value) ~= nil or (value.text ~= nil and value[1] == nil))
end

local function copyOptions(options)
    local result = {}
    for key, value in pairs(options or {}) do
        result[key] = value
    end
    return result
end

local function resolveIdInterpolation(text, var)
    if type(text) ~= "string" or not text:find("{", 1, true) then
        return text
    end
    return (text:gsub("%{([%w_./]*[a-zA-Z][%w_./]*)%}", function(id)
        return Game:loc(id, var)
    end))
end

function WorldCutscene:text(text, portrait, actor, options)
    if type(actor) == "table" and not isClass(actor) then
        local merged = copyOptions(actor)
        for key, value in pairs(options or {}) do
            merged[key] = value
        end
        options = merged
        actor = nil
    end
    if type(portrait) == "table" then
        local merged = copyOptions(portrait)
        for key, value in pairs(options or {}) do
            merged[key] = value
        end
        options = merged
        portrait = nil
    end

    options = copyOptions(options)

    if isTextDescriptor(text) then
        local descriptor = text
        text = descriptor.text
        for key, value in pairs(descriptor) do
            if key ~= "text" and key ~= "options" and type(key) ~= "number"
                and key ~= "choices" and key ~= "ids"
            then
                options[key] = value
            end
        end
        for key, value in pairs(descriptor.options or {}) do
            options[key] = value
        end
    end

    local id = options["id"]
    if id ~= nil then
        text = Game:loc(id, options["var"])
    elseif type(text) == "table" or options["var"] then
        text = Game:concat(text, options["var"])
    elseif text == nil then
        text = ""
    end

    text = resolveIdInterpolation(text, options["var"])

    return super.text(self, text, portrait, actor, options)
end

return WorldCutscene
