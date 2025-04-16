-- Connects various actions accross many scripts into pages
local mainPage            = action_wheel:newPage("MainPage")
local mainPageShell       = action_wheel:newPage("MainPageShell")
local mainPageOrigin      = action_wheel:newPage("MainPageOrigin")
local mainPageOriginShell = action_wheel:newPage("MainPageOriginShell")

local avatPage = action_wheel:newPage("AvatarPage")
local camPage  = action_wheel:newPage("CameraPage")

local anim = require("scripts.Animations")
local origins = require("lib.OriginsAPI")
local pose = require("scripts.Posing")

action_wheel:setPage(mainPage)

-- Main actions

local avatAction = action_wheel:newAction()
	:title("§9§lAvatar Settings")
	:hoverColor(vectors.hexToRGB("5EB7DD"))
	:item("minecraft:armor_stand")
	:onLeftClick(function() action_wheel:setPage(avatPage) end)

local camAction = action_wheel:newAction()
	:title("§9§lCamera Settings")
	:hoverColor(vectors.hexToRGB("5EB7DD"))
	:item("minecraft:redstone")
	:onLeftClick(function() action_wheel:setPage(camPage) end)


-- peek / hide in shell options appear/disappear depending on origin or whether the player is in their shell

local mainPages = {
	mainPage,
	mainPageShell,
	mainPageOrigin,
	mainPageOriginShell
}

-- are we on a main page
local function isOnMainPage()
	local b = false
	local curPage = action_wheel:getCurrentPage()

	for _, mp in ipairs(mainPages) do 
		if curPage == mp then
			b = true
			break
		end
	end

	return b
end

-- get which main page we should be on
local function getMainPage()
	local snail = origins.hasOrigin(player, "snail:snail")

	if snail then return pose.shell and mainPageOriginShell or mainPageOrigin
	else return pose.shell and mainPageShell or mainPage end
end

-- update main page
function events.TICK()
	if isOnMainPage() then action_wheel:setPage(getMainPage()) end
end

-- go to the main page we should be on
local backPage = action_wheel:newAction()
	:title("§c§lGo Back?")
	:hoverColor(vectors.hexToRGB("FF7F7F"))
	:item("minecraft:barrier")
	:onLeftClick(function() action_wheel:setPage(getMainPage()) end)

-- main pages
mainPage
    :setAction( -1, anim.shellPage)
	:setAction( -1, avatAction)
	:setAction( -1, camAction)

mainPageShell
	:setAction( -1, anim.shellPage)
	:setAction( -1, anim.peekPage)
	:setAction( -1, avatAction)
	:setAction( -1, camAction)

mainPageOrigin
	:setAction( -1, avatAction)
	:setAction( -1, camAction)

mainPageOriginShell
	:setAction( -1, anim.peekPage)
	:setAction( -1, avatAction)
	:setAction( -1, camAction)

-- Avatar actions
do
	local avatar = require("scripts.Player")
	avatPage
		:setAction( -1, avatar.vanillaSkinPage)
		:setAction( -1, avatar.modelPage)
        :setAction( -1, avatar.mouthPage)
		:setAction( -1, anim.upperBodyRotPage)
		--:setAction( -1, require("scripts.ArmSwingControl"))
		:setAction( -1, backPage)
end

-- Camera actions
do
	local camera = require("scripts.CameraControl")
	camPage
		:setAction( -1, camera.posPage)
		:setAction( -1, camera.rotPage)
		:setAction( -1, camera.eyePage)
		:setAction( -1, backPage)
end