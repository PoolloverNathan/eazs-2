-- Model setup
local model     = models.snailtaur
local upperRoot = model.Player.UpperBody
local lowerRoot = model.Player.LowerBody

-- Glowing outline
renderer:outlineColor(vectors.hexToRGB("69CDEC"))

-- Config setup
config:name("Snailtaur")
local vanillaSkin = config:load("AvatarVanillaSkin")
if vanillaSkin == nil then vanillaSkin = true end
local slim = config:load("AvatarSlim") or false
local mouth = config:load("Mouth")
if mouth == nil then mouth = true end



-- Vanilla parts table
local skinParts = {
	upperRoot.Head.Head,
	upperRoot.Head.HatLayer,
	
	upperRoot.Body.Body,
	upperRoot.Body.BodyLayer,
	
	upperRoot.RightArm.Default,
	upperRoot.RightArm.Slim,
	
	upperRoot.LeftArm.Default,
	upperRoot.LeftArm.Slim,
	
	--model.Portrait.Head,
	--model.Portrait.HatLayer,
	
	--model.Skull.Head,
	--model.Skull.HatLayer,
}

-- Variable setup
local vanillaAvatarType = nil
function events.ENTITY_INIT()
	vanillaAvatarType = player:getModelType()
end

-- Misc tick required events
function events.TICK()
	-- Model shape
	local slimShape = (vanillaSkin and vanillaAvatarType == "SLIM") or (slim and not vanillaSkin)
	
	upperRoot.LeftArm.Default:setVisible(not slimShape)
	upperRoot.RightArm.Default:setVisible(not slimShape)
	
	upperRoot.LeftArm.Slim:setVisible(slimShape)
	upperRoot.RightArm.Slim:setVisible(slimShape)

    upperRoot.Head.Mouth:setVisible(mouth)
	
	-- Skin textures
	for _, part in ipairs(skinParts) do
		part:setPrimaryTexture(vanillaSkin and "SKIN" or nil)
	end
	
	-- Cape/Elytra texture
	-- upperRoot.Body.Cape:setPrimaryTexture(vanillaSkin and "CAPE" or nil)
	-- upperRoot.Body.Elytra:setPrimaryTexture(vanillaSkin and player:hasCape() and (player:isSkinLayerVisible("CAPE") and "CAPE" or "ELYTRA") or nil)
	--	:setSecondaryRenderType(player:getItem(5):hasGlint() and "GLINT" or "NONE")
	
	-- Disables lower body if player is in spectator mode
	lowerRoot:setParentType(player:getGamemode() == "SPECTATOR" and "BODY" or "NONE")
end

-- Show/hide skin layers depending on Skin Customization settings
local layerParts = {
	HAT = {
		upperRoot.Head.HatLayer,
	},
	JACKET = {
		upperRoot.Body.BodyLayer,
	},
	RIGHT_SLEEVE = {
		upperRoot.RightArm.Default.ArmLayer,
		upperRoot.RightArm.Slim.ArmLayer,
	},
	LEFT_SLEEVE = {
		upperRoot.LeftArm.Default.ArmLayer,
		upperRoot.LeftArm.Slim.ArmLayer,
	}
}
function events.TICK()
	for playerPart, parts in pairs(layerParts) do
		local enabled = player:isSkinLayerVisible(playerPart)
		for _, part in ipairs(parts) do
			part:setVisible(enabled)
		end
	end
end

-- Vanilla skin toggle
local function setVanillaSkin(boolean)
	vanillaSkin = boolean
	config:save("AvatarVanillaSkin", vanillaSkin)
end

-- Model type toggle
local function setModelType(boolean)
	slim = boolean
	config:save("AvatarSlim", slim)
end

local function setMouth(boolean)
    mouth = boolean
    config:save("Mouth", mouth)
end

-- Sync variables
local function syncPlayer(a, b, c)
	vanillaSkin = a
	slim = b
    mouth = c
end

-- Pings setup
pings.setAvatarVanillaSkin = setVanillaSkin
pings.setAvatarModelType   = setModelType
pings.setMouth             = setMouth
pings.syncPlayer           = syncPlayer

-- Sync on tick
if host:isHost() then
	function events.TICK()
		if world.getTime() % 200 == 0 then
			pings.syncPlayer(vanillaSkin, slim, mouth)
		end
	end
end

-- Activate actions
setVanillaSkin(vanillaSkin)
setModelType(slim)
setMouth(mouth)

-- Setup table
local t = {}

-- Action wheel pages
t.vanillaSkinPage = action_wheel:newAction("VanillaSkin")
	:title("§9§lToggle Vanilla Texture\n\n§bToggles the usage of your vanilla skin for the upper body.")
	:hoverColor(vectors.hexToRGB("5EB7DD"))
	:toggleColor(vectors.hexToRGB("4078B0"))
	:item('minecraft:player_head{"SkullOwner":"'..avatar:getEntityName()..'"}')
	:onToggle(pings.setAvatarVanillaSkin)
	:toggled(vanillaSkin)

t.modelPage = action_wheel:newAction("ModelShape")
	:title("§9§lToggle Model Shape\n\n§bAdjust the model shape to use Default or Slim Proportions.\nWill be overridden by the vanilla skin toggle.")
	:hoverColor(vectors.hexToRGB("5EB7DD"))
	:toggleColor(vectors.hexToRGB("4078B0"))
	:item('minecraft:player_head')
	:toggleItem('minecraft:player_head{"SkullOwner":"MHF_Alex"}')
	:onToggle(pings.setAvatarModelType)
	:toggled(slim)

t.mouthPage = action_wheel:newAction("Mouth")
    :title("§9§lToggle Mouth\n\n§bWill hide the mouth the model comes with.")
    :hoverColor(vectors.hexToRGB("5EB7DD"))
	:toggleColor(vectors.hexToRGB("4078B0"))
	:item('minecraft:golden_boots')
	:toggleItem('minecraft:netherite_boots')
	:onToggle(pings.setMouth)
	:toggled(mouth)

-- Return table
return t