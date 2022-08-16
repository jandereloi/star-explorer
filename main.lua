local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

display.setStatusBar(display.HiddenStatusBar)

math.randomseed(os.time())

local spriteOptions = {
	frames = {
		{ -- Asteroid #1
			x = 0,
			y = 0,
			width = 102,
			height = 85
		},
		{  -- Asteroid #2
			x = 0,
			y = 85,
			width = 90,
			heigth = 83
		},
		{  -- Asteroid #3
			x = 0,
			y = 168,
			width = 100,
			height = 97
		},
		{  -- Spaceship
			x = 0, 
			y = 265,
			width = 98,
			height = 79
		},
		{  -- laser
			x = 98,
			y = 265,
			width = 14,
			height = 40
		},
	},
}

local sprite = graphics.newImageSheet("images/sprite.png", spriteOptions)


local lifes = 3
local score = 0
local dead = false

local asteroidsTable = {}

local ship
local gameLoopTimer
local lifesText
local scoreText

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

-- Background
local bg = display.newImageRect(backGroup, "images/bg.png", 800, 1400)
bg.x = display.contentCenterX
bg.y = display.contentCenterY


-- Player
ship = display.newImageRect(mainGroup, sprite, 4, 98, 79)
ship.x = display.contentCenterX
ship.y = display.contentHeight - 100
physics.addBody(ship, "dinamic", {radius=30, isSensor=true})
ship.myName = "ship"

-- UI
lifesText = display.newText(uiGroup, "Vidas: " .. lifes, display.contentCenterX - 130, 80, native.systemFont, 36)
scoreText = display.newText(uiGroup, "Pontuação: " .. score, display.contentCenterX + 100, 80, native.systemFont, 36)

