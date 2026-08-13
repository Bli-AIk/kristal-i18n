--- Localized asset resolution and cache refresh.
---@param ctx table Shared module context.
---@return table Assets module.
return function(ctx)
    local M = {}
    local FALLBACK_LANGUAGE = ctx.constants.FALLBACK_LANGUAGE

    local function refreshCachedFont(object)
        if object and object.font and object.font_name then
            object.font = Assets.getFont(object.font_name, object.font_size)
        end
    end

    local function refreshCachedEngineFonts()
        if not Kristal then
            return
        end

        refreshCachedFont(Kristal.Console)
        refreshCachedFont(Kristal.DebugSystem)

        if Kristal.DebugSystem then
            refreshCachedFont(Kristal.DebugSystem.context)
            refreshCachedFont(Kristal.DebugSystem.window)
        end
    end

    -- Restore the base asset id by stripping any number of "lang/<segment>/" prefixes.
    local function getBaseAssetId(path)
        while true do
            local stripped = path:match("^lang/[^/]+/(.+)$")
            if not stripped then
                return path
            end
            path = stripped
        end
    end

    -- Tileset instance -> whole-image base id. Captured once from the ORIGINAL
    -- texture so switching back to the base language cannot get stuck in nesting.
    local localized_tileset_image_ids = {}

    local function refreshLocalizedTilesets()
        if not Registry or not Registry.tilesets then
            return
        end

        local tilesets = {}
        for _, tileset in pairs(Registry.tilesets) do
            tilesets[tileset] = true
        end
        if Game and Game.world and Game.world.map and Game.world.map.tilesets then
            for _, tileset in ipairs(Game.world.map.tilesets) do
                tilesets[tileset] = true
            end
        end

        for tileset in pairs(tilesets) do
            -- Per-tile images (tsx <tile><image>): info.path is the base id.
            for _, info in pairs(tileset.tile_info or {}) do
                if info and info.path then
                    local texture = Assets.getTexture(info.path)
                    if texture then
                        local old_w, old_h = info.texture:getWidth(), info.texture:getHeight()
                        info.texture = texture
                        if info.quad and (old_w ~= texture:getWidth() or old_h ~= texture:getHeight()) then
                            info.quad = love.graphics.newQuad(
                                info.x or 0, info.y or 0,
                                info.width or texture:getWidth(), info.height or texture:getHeight(),
                                texture:getWidth(), texture:getHeight())
                        end
                    end
                end
            end

            -- Whole-image tilesets (tsx <image>).
            if tileset.texture then
                local base_id = localized_tileset_image_ids[tileset]
                if not base_id then
                    base_id = getBaseAssetId(Assets.getTextureID(tileset.texture) or "")
                    if base_id ~= "" then
                        localized_tileset_image_ids[tileset] = base_id
                    end
                end
                if base_id and base_id ~= "" then
                    local texture = Assets.getTexture(base_id)
                    if texture then
                        local old_w, old_h = tileset.texture:getWidth(), tileset.texture:getHeight()
                        tileset.texture = texture
                        if old_w ~= texture:getWidth() or old_h ~= texture:getHeight() then
                            tileset.quads = {}
                            local tw, th = texture:getWidth(), texture:getHeight()
                            for i = 0, tileset.tile_count - 1 do
                                local tx = tileset.margin + (i % tileset.columns) * (tileset.tile_width + tileset.spacing)
                                local ty = tileset.margin + math.floor(i / tileset.columns) * (tileset.tile_height + tileset.spacing)
                                tileset.quads[i] = love.graphics.newQuad(tx, ty, tileset.tile_width, tileset.tile_height, tw, th)
                            end
                        end
                    end
                end
            end
        end
    end

    local function refreshLocalizedAssets()
        refreshCachedEngineFonts()

        -- Tileset caches are created before the Assets hooks are installed.
        refreshLocalizedTilesets()

        -- Tile layers hold a SpriteBatch over the old tileset texture; rebuild on next draw.
        if Game and Game.world and Game.world.map then
            for _, layer in ipairs(Game.world.map.tile_layers or {}) do
                layer:markTilesDirty()
            end
        end

        if not Game or not Game.stage then
            return
        end

        for _, sprite in pairs(Game.stage:getObjects(Sprite)) do
            if sprite.texture_path then
                local texture = Assets.getTexture(getBaseAssetId(sprite.texture_path))
                if texture then
                    sprite.texture = texture
                end
            end
        end

        if Game.world and Game.world.menu then
            if Game.world.menu.font then
                Game.world.menu.font = Assets.getFont("main")
            end
            if Game.world.menu.box and Game.world.menu.box.font then
                Game.world.menu.box.font = Assets.getFont("main")
            end
        end
    end

    local function getLocalizedTexturePaths(path)
        if type(path) ~= "string" then
            return {}
        end

        -- Already-localized id: never nest another lang/ prefix.
        if path:sub(1, 5) == "lang/" then
            return {}
        end

        -- Game may not exist yet if hooks are installed earlier.
        local lang = Game and Game.lang or FALLBACK_LANGUAGE
        local name_language = Game and Game.langNameLanguage or lang

        -- Prefer the original path; also try stripping a sprites/ prefix.
        local variants = { path }
        local stripped = path:match("^assets/sprites/(.+)$") or path:match("^sprites/(.+)$")
        if stripped then
            variants[#variants + 1] = stripped
        end

        local paths = {}
        for _, variant in ipairs(variants) do
            paths[#paths + 1] = "lang/" .. lang .. "/" .. name_language .. "/" .. variant
            paths[#paths + 1] = "lang/" .. lang .. "/" .. variant
        end

        return paths
    end

    local function getLocalizedTextureAsset(orig, path)
        for _, lang_path in ipairs(getLocalizedTexturePaths(path)) do
            local asset = orig(lang_path)
            if asset then
                return asset
            end
        end
        return orig(path)
    end

    local function mapNameKey(id)
        return "map_" .. tostring(id):gsub("[^%w_]", "_") .. "_name"
    end

    local function localizeMapName(map)
        if not map or not map.id or not Game or not Game.loc then
            return
        end

        local properties = (map.data and map.data.properties) or {}
        local name_key = properties.name_id or mapNameKey(map.id)
        map.name = Game:loc(name_key)
    end

    local function refreshMapName()
        if Game.world then
            localizeMapName(Game.world.map)
        end
    end

    local function refreshBattleLocalization()
        if not Game.battle then
            return
        end

        for _, enemy in ipairs(Game.battle.enemies or {}) do
            if type(enemy.applyLocalization) == "function" then
                enemy:applyLocalization(true)
            end
        end
    end

    M.refreshLocalizedAssets = refreshLocalizedAssets
    M.getLocalizedTextureAsset = getLocalizedTextureAsset
    M.refreshMapName = refreshMapName
    M.refreshBattleLocalization = refreshBattleLocalization
    M.localizeMapName = localizeMapName
    M.mapNameKey = mapNameKey
    return M
end
