-- Model setup
local model     = models.snailtaur
local upperRoot = model.Player.UpperBody
local lowerRoot = model.Player.LowerBody
local anims     = animations.snailtaur

-- Config setup
config:name("Snailtaur")
local upperRot = config:load("AvatarUpperBodyRot")
if upperRot == nil then upperRot = true end

-- Variables
local pose    = require("scripts.Posing")
local origins = require("lib.OriginsAPI")
local peek    = false

-- Base Animations
do
	-- Animation variable
	local posCurrent, posNextTick, posTarget, posCurrentPos = 0, 0, 0, 0

	function events.TICK()
		-- Pos lerp
		posCurrent  = posNextTick
		posNextTick = math.lerp(posNextTick, posTarget, 0.25)
	end
	
	local basePos = vec(0, 0, 0)
	function events.RENDER(delta, context)
		if context == "FIRST_PERSON" or context == "RENDER" or (not client.isHudEnabled() and context ~= "MINECRAFT_GUI") then
			-- Animation modifiers
			local vel             = player:getVelocity()
			local walking         = vel.zx:length() ~= 0
            -- local crouch       = player:isCrouching()
			
			-- Animation states
			local groundIdleState     = not walking and (not player:getVehicle()) and not (pose.swim or pose.elytra or pose.spin or pose.crouch or pose.shell) or (pose.climb and vel:length() == 0)
			local groundWalkState     =     walking and (not player:getVehicle()) and not (pose.swim or pose.elytra or pose.spin or pose.crouch or pose.shell) or (pose.climb and vel:length() ~= 0)
			local sneakIdleState      = not walking and (pose.crouch or pose.crawl or pose.swim) and (not player:getVehicle()) and not (pose.elytra or pose.spin or pose.shell)
            local sneakWalkState      =     walking and (pose.crouch or pose.crawl or pose.swim) and (not player:getVehicle()) and not (pose.elytra or pose.spin or pose.shell)
            local sneakStateShell     =                 (pose.crouch or pose.crawl or pose.swim) and (not player:getVehicle()) and not (pose.elytra or pose.spin)      
			
            -- Detect if animations were playing
            local sneakMove  = anims.sneak:isPlaying()
            local sneakShell = anims.sneakIntoShell:isPlaying()

			-- Animations
			anims.groundIdle:setPlaying(groundIdleState or sneakIdleState or groundWalkState or sneakWalkState) -- only moves the eyestalks
            anims.mouthIdle:setPlaying(groundIdleState or sneakIdleState)
			anims.groundWalk:setPlaying(groundWalkState)
			anims.sneakStart:setPlaying(sneakIdleState)
            anims.sneak:setPlaying(sneakWalkState)
			anims.sleep:setPlaying(pose.sleep)
            anims.goIntoShell:setPlaying(pose.shell and not sneakStateShell and not anims.peek:isPlaying())
            anims.sneakIntoShell:setPlaying(pose.shell and sneakStateShell and not anims.peek:isPlaying())
			
            -- Prevent animations from playing if needed
            if sneakMove  or peek then anims.sneakStart:setTime(0.48) end
            if sneakShell or peek then anims.goIntoShell:setTime(0.48) end

			-- Pos state table
			local statePos = {
				{ state = pose.climb,   pos = vec(0, 0, 25)  },
				{ state = pose.crouch,  pos = vec(0, 2, 0)   },
				{ state = pose.elytra,  pos = vec(0, 0, 15)  },
				{ state = pose.crawl,   pos = vec(0, 0, 33)  },
				{ state = pose.sleep,   pos = vec(0, 0, 15)  },
				{ state = pose.spin,    pos = vec(0, 0, 16)  },
				{ state = pose.swim,    pos = vec(0, 20, 15) },
			}
			
			-- Base position check
			for _, case in ipairs(statePos) do
				if case.state then
					basePos = case.pos
					break
				else
					basePos = 0
				end
			end
			
			-- Pos Lerp
			posTarget     = basePos
			posCurrentPos = math.lerp(posCurrent, posNextTick, delta)
			
			-- Animation modifiers application
			local animPos = model.Player:getAnimPos(delta)
			model.Player:setPos(posCurrentPos + ((pose.swim or pose.climb or pose.crawl) and vec(0, animPos.z - animPos.y, animPos.y - animPos.z) or 0))
		end

		peek = anims.peek:isPlaying()
	end

	function events.RENDER(delta, context)
		-- Animations where we want the player's head to be able to rotate despite vanilla anims being overridden
		local headRotNeeded = false;
		local animLooking = {
			anims.groundWalk,
			anims.sneakStart,
			anims.sneak
		}

		-- Check if one of the above animations is being played
		for _, anim in ipairs(animLooking) do
			headRotNeeded = anim:isPlaying() or headRotNeeded
		end

		-- If needed, rotate the player's head manually
		upperRoot.Head:offsetRot(headRotNeeded and vanilla_model.HEAD:getOriginRot() or nil)
	end
end

-- Yaw rotations
do
	-- Variables
	local yawCurrent, yawNextTick, yawTarget, yawCurrentPos = 0, 0, 0, 0
	
	-- Gradual values
	function events.TICK()
		yawCurrent  = yawNextTick
		yawNextTick = math.lerp(yawNextTick, yawTarget, 0.25)
	end
	
	-- Yaw rotations parts
	local yawParts = {
		upperRoot,
		lowerRoot.Segment1,
	}
	
	-- Application
	local yawLimit = 26
	function events.RENDER(delta, context)
		if context == "RENDER" or context == "FIRST_PERSON" or (not client.isHudEnabled() and context ~= "MINECRAFT_GUI") then
			-- Variables
			local vel = player:getVelocity().y
			local yawShouldRot = pose.stand and not pose.climb and upperRot
			
			-- Yaw lerps
			yawTarget     = yawShouldRot and math.clamp((vanilla_model.HEAD:getOriginRot(delta).y + 180) % 360 - 180, -yawLimit, yawLimit) or 0
			yawCurrentPos = math.lerp(yawCurrent, yawNextTick, delta)
			
			-- Yaw applications
			for _, part in ipairs(yawParts) do
				part:setOffsetRot(0, yawCurrentPos, 0)
			end
		end
	end
end

-- Breathing control
do
	local speed     = 0
	local lastSpeed = 0
	function events.TICK()
		lastSpeed = speed
		speed     = speed + math.clamp((player:getVelocity():length() * 15 + 1) * 0.05, 0, 0.4)
	end
	
	function events.RENDER(delta, context)
		if context == "RENDER" or context == "FIRST_PERSON" or (not client.isHudEnabled() and context ~= "MINECRAFT_GUI") then
			local scale = math.sin(math.lerp(lastSpeed, speed, delta)) * 0.0125 + 1.0125
			lowerRoot.SnailBody.Segment1:setScale(scale)
		end
	end
end

-- GS Blending Setup
do
	require("lib.GSAnimBlend")
	
	anims.groundIdle:blendTime(7)
	anims.groundWalk:blendTime(7)
	anims.sleep:blendTime(7)
	
	anims.groundIdle:onBlend("easeOutQuad")
	anims.groundWalk:onBlend("easeOutQuad")
	anims.sleep:onBlend("easeOutQuad")
end

-- UpperBody rot toggler
local function setUpperRot(boolean)
	upperRot = boolean
	config:save("AvatarUpperBodyRot", upperRot)
end

-- Shell toggler
local function setShell(boolean) pose.shell = boolean end

-- Sync variables
local function syncVars(a, b)
	upperRot = a
    pose.shell = b
end

-- Peek animation
local function peekOut()
	if (pose.shell) then
		anims.peek:setPlaying(true) 
		peek = true
	end
end

-- Ping setup
pings.setUpperBodyRot = setUpperRot
pings.setShell        = setShell
pings.syncVars        = syncVars
pings.peekOut         = peekOut

-- Sync on tick
if host:isHost() then
	function events.TICK()
		if world.getTime() % 200 == 0 then
			pings.syncVars(upperRot, pose.shell)
		end
	end
end

-- Activate action
setUpperRot(upperRot)


-- =================== [ SHELL STUFF ] ==================== --

if host:isHost() then
	local kbForward = keybinds:newKeybind("Shell Forward Blocker"):onPress(function() return pose.shell end)
	local kbBack    = keybinds:newKeybind("Shell Back Blocker"   ):onPress(function() return pose.shell end)
	local kbRight   = keybinds:newKeybind("Shell Right Blocker"  ):onPress(function() return pose.shell end)
	local kbLeft    = keybinds:newKeybind("Shell Left Blocker"   ):onPress(function() return pose.shell end)
	local kbJump    = keybinds:newKeybind("Shell Jump Blocker"   ):onPress(function() return pose.shell end)
	local kbCrouch  = keybinds:newKeybind("Shell Crouch Blocker" ):onPress(function() return pose.shell end)

	-- Keybind maintainer (Prevents changes)
	function events.TICK()
		kbForward:setKey(keybinds:getVanillaKey("key.forward"))
		kbBack:setKey(keybinds:getVanillaKey("key.back"))
		kbRight:setKey(keybinds:getVanillaKey("key.right"))
		kbLeft:setKey(keybinds:getVanillaKey("key.left"))
		kbJump:setKey(keybinds:getVanillaKey("key.jump"))
		kbCrouch:setKey(keybinds:getVanillaKey("key.sneak"))
	end

	-- Prevents mouse movement while in shell
	function events.MOUSE_MOVE() return pose.shell end
end

-- table setup
t = {}

t.shellPage = action_wheel:newAction("GoInShell")
    :title("§9§lEnter Shell\n\n§bCauses you to enter your shell.\nThis option will not appear if you have the snail origin.")
    :hoverColor(vectors.hexToRGB("5EB7DD"))
    :toggleColor(vectors.hexToRGB("4078B0"))
    :item("minecraft:nautilus_shell")
    :onToggle(pings.setShell)
    :toggled(pose.shell)

t.upperBodyRotPage = action_wheel:newAction("UpperBodyRot")
	:title("§9§lUpperBody Rotation Toggle\n\n§bToggles the rotation of the upperbody.\nThis also controls the camera rotation.")
	:hoverColor(vectors.hexToRGB("5EB7DD"))
	:toggleColor(vectors.hexToRGB("4078B0"))
	:item("minecraft:music_disc_11")
	:toggleItem("minecraft:music_disc_wait")
	:onToggle(pings.setUpperBodyRot)
	:toggled(upperRot)

t.peekPage = action_wheel:newAction("PeekFromShell")
	:title("§9§lPeek out of shell\n\n§bLets you peek out of your shell. Does nothing if you aren't in your shell")
	:hoverColor(vectors.hexToRGB("5EB7DD"))
	:item("minecraft:ender_eye")
	:onLeftClick(pings.peekOut)

return t