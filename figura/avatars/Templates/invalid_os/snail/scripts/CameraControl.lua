-- Model setup
local model     = models.snailtaur
local upperRoot = model.Player.UpperBody
local lowerRoot = model.Player.LowerBody

-- Config setup
config:name("Snailtaur")
local camPos = config:load("CameraPos") or false
local eyePos = false

-- Startup camera pos
local trueHeadPos = 0
function events.ENTITY_INIT()
	trueHeadPos = player:getPos()
end

function events.POST_RENDER(delta, context)
	if context == "FIRST_PERSON" or context == "RENDER" or (not client.isHudEnabled() and context ~= "MINECRAFT_GUI") then
		-- Pos checking
		local playerPos    = player:getPos(delta)
		local headModelPos = upperRoot.Head:partToWorldMatrix():apply()
		trueHeadPos        = (headModelPos == headModelPos) and headModelPos or trueHeadPos
		
		-- Pehkui scaling
		local nbt   = player:getNbt()
		local types = nbt["pehkui:scale_data_types"]

		local scale = (
			types and (
			    types["pehkui:base"] and
			    types["pehkui:base"]["scale"] or 1
            ) or 1)
		local modelWidth = (
			types and (
			    types["pehkui:width"] and
			    types["pehkui:width"]["scale"] or (
				    types["pehkui:model_width"] and
			        types["pehkui:model_width"]["scale"] or 1
			)) or 1)
		local modelHeight = (
			types and (
			    types["pehkui:height"] and
			    types["pehkui:height"]["scale"] or (
			    	types["pehkui:model_height"] and
				    types["pehkui:model_height"]["scale"] or 1
			)) or 1)
		
		local offsetScale = vec(modelWidth, modelHeight, modelWidth) * scale
		
		-- Camera offset
		local posOffset = (trueHeadPos - playerPos) * (context == "FIRST_PERSON" and offsetScale or 1) + vec(0, -player:getEyeHeight() + ((3/16) * offsetScale.y), 0)
		
		-- Renders offset
		local posOffsetApply = player:getPose() == "STANDING" or player:getPose() == "CROUCHING"
		renderer:offsetCameraPivot(camPos and posOffsetApply and posOffset or 0)
			:eyeOffset(eyePos and camPos and posOffsetApply and posOffset or 0)
		
		-- Nameplate Placement
		nameplate.ENTITY:pivot(posOffset + vec(0, player:getBoundingBox().y + 13/16, 0))
		
	end
end

-- Camera pos toggler
local function setPos(boolean)
	camPos = boolean
	config:save("CameraPos", camPos)
end

-- Eye pos toggler
local function setEye(boolean)
	eyePos = boolean
end

-- Sync variables
local function syncCamera(a, b)
	camPos = a
	eyePos = b
end

-- Setup pings
pings.setCameraPos = setPos
pings.setCameraEye = setEye
pings.syncCamera   = syncCamera

-- Sync on tick
if host:isHost() then
	function events.TICK()
		if world.getTime() % 200 == 0 then
			pings.syncCamera(camPos, eyePos)
		end
	end
end

-- Activate actions
setPos(camPos)

-- Table setup
local t = {}

-- Action wheel pages
t.posPage = action_wheel:newAction("CameraPos")
	:title("§9§lCamera Position Toggle\n\n§bSets the camera position to where your avatar's head is.\n(Perfect for the crawling toggle!)")
	:hoverColor(vectors.hexToRGB("55FFFF"))
	:toggleColor(vectors.hexToRGB("5555FF"))
	:item("minecraft:skeleton_skull")
	:toggleItem(('minecraft:player_head{"SkullOwner":"%s"}'):format(avatar:getEntityName()))
	:onToggle(pings.setCameraPos)
	:toggled(camPos)
	
t.eyePage = action_wheel:newAction("OffsetEye")
	:title("§9§lEye Position Toggle\n\n§bSets the eye position to match the avatar's head.\nRequires camera position toggle.\n\n§4§lWARNING: §cThis feature is dangerous!\nIt can and will be flagged on servers with anticheat!\nFurthermore, \"In Wall\" damage is possible.\nThis setting will §c§lNOT §cbe saved between sessions for your safety.\n\nPlease use with extreme caution!")
	:hoverColor(vectors.hexToRGB("FF0000"))
	:toggleColor(vectors.hexToRGB("7F0000"))
	:item("minecraft:ender_pearl")
	:toggleItem("minecraft:ender_eye")
	:onToggle(pings.setCameraEye)

-- Return action wheel pages
return t