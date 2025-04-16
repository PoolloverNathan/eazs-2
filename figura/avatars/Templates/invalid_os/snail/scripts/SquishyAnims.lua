-- Model setup
local model     = models.snailtaur
local upperRoot = model.Player.UpperBody
local lowerRoot = model.Player.LowerBody
local head      = upperRoot.Head
local anims     = animations.snailtaur

-- Squishy API Animations
local squapi = require("lib.SquAPI")

-- Blink animation when in shell
squapi.blink(anims.shellBlink)

-- taur physics
squapi.taurPhysics(lowerRoot)

-- eyestalk physics
squapi.ear(head.Eyestalks.LeftEyestalk, head.Eyestalks.RightEyestalk, false, nil, .5, false, .25)