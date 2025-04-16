--███████╗ ██████╗ ██╗   ██╗██╗███████╗██╗  ██╗██╗   ██╗███████╗     █████╗ ██████╗ ██╗
--██╔════╝██╔═══██╗██║   ██║██║██╔════╝██║  ██║╚██╗ ██╔╝██╔════╝    ██╔══██╗██╔══██╗██║
--███████╗██║   ██║██║   ██║██║███████╗███████║ ╚████╔╝ ███████╗    ███████║██████╔╝██║
--╚════██║██║▄▄ ██║██║   ██║██║╚════██║██╔══██║  ╚██╔╝  ╚════██║    ██╔══██║██╔═══╝ ██║
--███████║╚██████╔╝╚██████╔╝██║███████║██║  ██║   ██║   ███████║    ██║  ██║██║     ██║
--╚══════╝ ╚══▀▀═╝  ╚═════╝ ╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝    ╚═╝  ╚═╝╚═╝     ╚═╝
----------------------------------------------------------------------------------------

-- Author: Squishy
-- Discord tag: mrsirsquishy

-- Version: 0.2.0
-- Legal: Do not Redistribute without explicit permission.
-- Modified by InvalidOS

-- IMPORTANT FOR NEW USERS!!! READ THIS!!!

-- Thank you for using SquAPI! Unless you're experienced and wish to actually modify the functionality
-- of this script, I wouldn't reccomend snooping around. 
-- Don't know exactly what you're doing? This site should explain everything!(also linked on github):
-- https://mrsirsquishy.notion.site/Squishy-API-Guide-3e72692e93a248b5bd88353c96d8e6c5

-- This file does have some mini-documentation on paramaters if you need like a quick reference, but
-- do not modify, and do not copy-paste code from this file unless you are an avid scripter who knows what they are doing.


-- Don't be afraid to ask me for help, be afraid of not giving me enough info to help




local squapi = {}



-- Control Variables
-- these variables can be changed within your script to control certain features of squapi
-- to do so, call squapi.[variable name] = [what you want]
-- within your script(do not modify these within squapi itself)

--set to false to disable blinking, set to true to enable blinking
squapi.doBlink = true

--controls the scale of each eye. good for emotes.
squapi.eyeScale = 1

--detects if the bounce function is enabled, doesn't typically need to be modified
squapi.doBounce = false

--altering this value will add to the head rot if smooth Head is enabled
squapi.smoothHeadOffset = vec(0,0,0)

-- SMOOTH HEAD
-- guide:(note if it has a * that means you can leave it blank to use reccomended settings)
-- element: 			the head element that you wish to effect
-- *keeporiginalheadpos: when true(automatically true) the heads position will change like normally, set to false to disable.
-- IMPORTANT: for this to work you need to name your head element something other than "Head" - the name "Head" will make it follow vanilla rotations which we don't want, so it is reccomended to rename it to something like "head" instead)
function squapi.smoothHead(element, tilt, strength, keeporiginalheadpos)
	strength = strength or 1
	tilt = tilt or 1/10
	if keeporiginalheadpos == nil then keeporiginalheadpos = true end
	local mainheadrot = vec(0, 0, 0)
	local offset = vec(0,0,0)
	function events.render(delta, context)
		local headrot = (vanilla_model.HEAD:getOriginRot()+180 + squapi.smoothHeadOffset)%360-180
		
		if squapi.cancelHeadMovement then
			offset = squapi.torsoOffset
		end
		mainheadrot[1] = mainheadrot[1] + (headrot[1] - mainheadrot[1])/12
		mainheadrot[2] = mainheadrot[2] + (headrot[2] - mainheadrot[2])/12
		mainheadrot[3] = mainheadrot[2]*tilt
		mainheadrot = mainheadrot
	

		element:setOffsetRot((mainheadrot-offset)*strength)
		if keeporiginalheadpos then 
			element:setPos(-vanilla_model.HEAD:getOriginPos()) 
		end
		
		-- Better Combat SquAPI Compatibility created by @jimmyhelp and @foxy2526 on Discord
		if renderer:isFirstPerson() and context == "RENDER" then
			element:setVisible(false)
			-- Set path to head model
		else
			element:setVisible(true)
			-- Set path to head model
		end


	end
end

-- MOVING EYES
--guide:(note if it has a * that means you can leave it blank to use reccomended settings)
-- element:	 		the eye element that is going to be moved, each eye is seperate.
-- *leftdistance: 	the distance from the eye to it's leftmost posistion
-- *rightdistance: 	the distance from the eye to it's rightmost posistion
-- *updistance: 	the distance from the eye to it's upmost posistion
-- *downdistance: 	the distance from the eye to it's downmost posistion

function squapi.eye(element, leftdistance, rightdistance, updistance, downdistance, switchvalues)
	local switchvalues = switchvalues or false
	local left = leftdistance or .25
	local right = rightdistance or 1.25
	local up = updistance or 0.5
	local down = downdistance or 0.5
	
	function events.render(delta, context)
		local headrot = (vanilla_model.HEAD:getOriginRot()+180)%360-180
		if headrot[2] > 50 then headrot[2] = 50 end
		if headrot[2] < -50 then headrot[2] = -50 end
		local x = -squapi.parabolagraph(-50, -left, 0,0, 50, right, headrot[2])
		local y = squapi.parabolagraph(-90, -down, 0,0, 90, up, headrot[1])
		
		--prevents any eye shenanigans
		if x > left then x = left end
		if x < -right then x = -right end
		if y > up then y = up end
		if y < -down then y = down end

		if switchvalues then
			element:setPos(0,y,-x)
		else
			element:setPos(x,y,0)
		end
		element:setOffsetScale(squapi.eyeScale,squapi.eyeScale,squapi.eyeScale)
	end
end	


--BLINK
-- guide:(note if it has a * that means you can leave it blank to use reccomended settings)
-- animation: 			the blink animation to play
-- *chancemultipler:	higher values make blinks less likely to happen, lower values make them more common.
function squapi.blink(animation, chancemultipler)
	local blinkchancemultipler = chancemultipler or 1
	function events.tick()
		if math.random(0, 200 * blinkchancemultipler) == 1 and animation:isStopped() and squapi.doBlink then
			animation:play()
		end
	end	
end

--BOUNCY EARS
--guide:(note if it has a * that means you can leave it blank to use reccomended settings)
-- element: 		the ear element that you want to affect(models.[modelname].path)
-- *element2: 		the second element you'd like to use(second ear), set to nil or leave empty to ignore
-- *doearflick:		reccomended true. This adds the random chance for the ears to do a "flick" animation, set to false to disable.
-- *earflickchance:	how rare a flick should be. high values mean less liklihood, low values mean high liklihood.(200 reccomended)
-- *rangemultiplier:at normal state of 1 the ears rotate from -90 to 90, this range will be multiplied by this, so a value of 0.5 would half the range
-- *horizontalEars: setting this to true will change the motion of the ears to be sideways, like elf ears.
-- *bendstrength: 	how strong the ears bend when you move(jump, fall, run, etc.)
-- *earstiffness: 	how stiff the ears movement is(0-1)
-- *earbounce: 		how bouncy the ears are(0-1)

function squapi.ear(element, element2, doearflick, earflickchance, rangemultiplier, horizontalEars, bendstrength, earstiffness, earbounce)
	if doearflick == nil then doearflick = true end
	local earflickchance = earflickchance or 400
	local element2 = element2 or nil
	local bendstrength = bendstrength or 2
	local earstiffness = earstiffness or 0.025
	local earbounce = earbounce or 0.1
	local horizontalEars = horizontalEars or false
	local rangemultiplier = rangemultiplier or 1
	
	local eary = squapi.bounceObject:new()
	local earx = squapi.bounceObject:new()
	local earx2 = squapi.bounceObject:new()
	local leftlegrot = 0
	local oldpose = "STANDING"
	function events.render(delta, context)
		local leftlegrot
		if squapi.doBounce then
			leftlegrot = vanilla_model.LEFT_LEG:getOriginRot()[1]
		else
			leftlegrot = 0
		end
		local vel = squapi.getForwardVel()
		local yvel = squapi.yvel()
		local svel = squapi.getSideVelocity()
		local headrot = (vanilla_model.HEAD:getOriginRot()+180)%360-180
		
		local bend = bendstrength
		if headrot[1] < -22.5 then bend = -bend end
		
		--moves when player crouches
		local pose = player:getPose()
		if pose == "CROUCHING" and oldpose == "STANDING" then
			eary.vel = eary.vel + 3 * bendstrength
		elseif pose == "STANDING" and oldpose == "CROUCHING" then
			eary.vel = eary.vel - 3 * bendstrength
		end
		oldpose = pose

		--y vel change
		if horizontalEars then
			earx.vel = earx.vel + yvel * bend
			--x vel change
			earx.vel = earx.vel + vel * bend * 1.5 *10

			earx2.vel = earx2.vel - yvel * bend
			--x vel change
			earx2.vel = earx2.vel - vel * bend * 1.5 *10
		else
			eary.vel = eary.vel + yvel * bend
			--x vel change
			eary.vel = eary.vel + vel * bend * 1.5 *10
		end

		if doearflick then
			if math.random(0, earflickchance) == 1 then
				if math.random(0, 1) == 1 then
					earx.vel = earx.vel + 50
				else
					earx2.vel = earx2.vel - 50
				end
			end
		end
		
		local rot1 = eary:doBounce(headrot[1] * rangemultiplier - math.abs(leftlegrot)/8*bendstrength, earstiffness, earbounce)
		local rot2 = earx:doBounce(headrot[2] * rangemultiplier - svel*150*bendstrength, earstiffness, earbounce)
		local rot2b = earx2:doBounce(headrot[2] * rangemultiplier - svel*150*bendstrength, earstiffness, earbounce)
		
		--prevents chaos ears
		if rot2 > 90 then rot2 = 90 end
		if rot2 < -90 then rot2 = -90 end
		if rot1 > 90 then rot1 = 90 end
		if rot1 < -90 then rot1 = -90 end
		if rot2b > 90 then rot2b = 90 end
		if rot2b < -90 then rot2b = -90 end

		local rot3 = rot2/4
		local rot3b = rot2b/4
		if horizontalEars then
			element:setOffsetRot(rot1/4, rot2/3, rot3)
			if element2 ~= nil then 
				element2:setOffsetRot(rot1/4, rot2b/3, rot3b) 
			end
		else
			element:setOffsetRot(rot1, rot2/4, rot3)
			if element2 ~= nil then 
				element2:setOffsetRot(rot1, rot2b/4, rot3b) 
			end
		end
		
	end
end


local pose = require("scripts.Posing")

--TAUR PHYSICS
-- guide:
-- taurbody: the group of the body that contains all parts of the actual centaur part of the body, pivot should be placed near the connection between body and centaur body
function squapi.taurPhysics(taurbody)
	squapi.cent = squapi.bounceObject:new()
	
	function events.render(delta, context)
		local yvel = squapi.yvel()
		
		if pose.elytra or pose.swim or (player:isClimbing() and not player:isOnGround()) or player:riptideSpinning() then	
			taurbody:setRot(80, 0, 0)
		else	
			taurbody:setRot(squapi.cent.pos, 0, 0)
		end

		local target = yvel * 40
		if target < -30 then target = -30 end
		if target < -5 and pose.crouch then target = -5 end

		squapi.cent:doBounce(target, 0.01, .2)
	end
end

-- USEFUL CALLS ------------------------------------------------------------------------------------------

-- returns how fast the player moves forward, negative means backward
function squapi.getForwardVel()
	return player:getVelocity():dot((player:getLookDir().x_z):normalize())
end

-- returns y velocity
function squapi.yvel()
	return player:getVelocity()[2]
end

-- returns how fast player moves sideways, negative means left
-- Courtesy of @auriafoxgirl on discord
function squapi.getSideVelocity()
	return (player:getVelocity() * matrices.rotation3(0, player:getRot().y, 0)).x
end


--functions that are made for use through this code, or personal use. Not meant to be used outside but if you know what you're doing go ahead. 
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

--[[
function squapi.getSideVelocity()
	local vel = player:getVelocity()
	local look = player:getLookDir().z_x
	local totalvel = math.sqrt(vel[1]^2 + vel[3]^2)
	
	--angle of velocity relative to world
	local velangle = (-math.deg(math.atan2(vel[3], vel[1])) + 360) % 360
	--angle of player relative to world
	local angle = (math.deg(math.atan2(look[3], look[1])) + 630) % 360
	--angle of velocity relative to players rotation
	local angledif = ((angle - velangle + 180) % 360) - 180

	local sidevel = -math.sin(math.rad(angledif))*totalvel
	
	return sidevel
end
--]]


-- Linear graph stuff
function squapi.lineargraph(x1, y1, x2, y2, t)
	local slope = (y2-y1)/(x2-x1)
	local inter = y2 - slope*x2
	return slope*t + inter
end

--Parabolic graph stuff
function squapi.parabolagraph(x1, y1, x2, y2, x3, y3, t)
    local denom = (x1 - x2) * (x1 - x3) * (x2 - x3)
    
	local a = (x3 * (y2 - y1) + x2 * (y1 - y3) + x1 * (y3 - y2)) / denom
    local b = (x3^2 * (y1 - y2) + x2^2 * (y3 - y1) + x1^2 * (y2 - y3)) / denom
    local c = (x2 * x3 * (x2 - x3) * y1 + x3 * x1 * (x3 - x1) * y2 + x1 * x2 * (x1 - x2) * y3) / denom

    -- returns y based on t
    return a * t^2 + b * t + c
end

--smooth bouncy stuff
local bounceID = 0
squapi.bounceObject = {}
squapi.bounceObject.__index = squapi.bounceObject
function squapi.bounceObject:new()
	local o = {
		vel = 0,
		pos = 0
	}
	bounceID = bounceID + 1
	setmetatable(o, squapi.bounceObject)
	return o
end	
function squapi.bounceObject:doBounce(target, stiff, bounce)
	local target = target or 2
	local dif = target - self.pos
	self.vel = self.vel + ((dif - self.vel * stiff) * stiff)
	self.pos = (self.pos + self.vel) + (dif * bounce)
	return self.pos
end

--1: dif is the distance between current and target
--2: lower vals of stiff mean that it is slower(lags behind more) 
--   This means slower acceleration. This acceleration is then added to vel.
--4: apply velocity to the current value, as well as adding bounce factor.
--5: returns the new value, as well as the velocity at that moment.

--Paramter details:
-- current: the current value(like position, rotation, etc.) of object that will be moved.
-- target: the target value - this is what it will bounce towards
-- stiff: how stiff it should be(between 0-1)
-- bounce: how bouncy it should be(between 0-1)
-- vel: the current velocity of the current value.

-- Returns the new position and new velocity.

function squapi.bouncetowards(current, target, vel, stiff, bounce)
	local bounce = bounce or 0.05
	local stiff = stiff or 0.005	
	local dif = target - current
	vel = vel + ((dif - vel * stiff) * stiff)
	current = (current + vel) + (dif * bounce)
	return current, vel
end

return squapi