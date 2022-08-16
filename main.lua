local physics = require("physics")
physics.start()
physics.setGravity(0, 0)
physics.setDrawMode("normal")

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
			height = 83
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

local function updateText()
	lifesText.text = "Vidas: " .. lifes
	scoreText.text = "Pontuação: " .. score
end

local function createAsteroids()
	local pickAsteroid = math.random(3)
	local asteroidWidth
	local asteroidHeigth

	if (pickAsteroid == 1) then
		asteroidWidth = 102
		asteroidHeigth = 85
	elseif (pickAsteroid == 2) then
		asteroidWidth = 90
		asteroidHeigth = 83
	elseif (pickAsteroid == 3) then
		asteroidWidth = 100
		asteroidHeigth = 97
	end

	print(pickAsteroid, asteroidWidth, asteroidHeigth)

	local newAsteroid = display.newImageRect(mainGroup, sprite, pickAsteroid, asteroidWidth, asteroidHeigth)
	table.insert(asteroidsTable, newAsteroid)
	physics.addBody(newAsteroid, "dinamic", {radius=40, bounce=0.8})
	newAsteroid.myName = "asteroid"

	local location = math.random(3)

	if (location == 1) then
		newAsteroid.x = -60
		newAsteroid.y = math.random(500)
		newAsteroid:setLinearVelocity(math.random(40, 120), math.random(20, 60))
	elseif (location == 2) then
		newAsteroid.x = math.random(display.contentWidth)
		newAsteroid.y = -60
		newAsteroid:setLinearVelocity(math.random(-40, 40), math.random(20, 120))
	elseif (location == 3) then
		newAsteroid.x = display.contentWidth + 60
		newAsteroid.y = math.random(500)
		newAsteroid:setLinearVelocity(math.random(-120, -40), math.random(20, 60))
	end

	newAsteroid:applyTorque(math.random(-6, 6))

end

local function shipShooting()
	local newLaser = display.newImageRect(mainGroup, sprite, 5, 14, 40)
	physics.addBody(newLaser, "dinamic", {isSensor=true, isBullet=true})
	newLaser.myName = "laser"	

	newLaser.x = ship.x
	newLaser.y = ship.y
	newLaser:toBack()

	transition.to(newLaser, {y=-40, time=500,
	 onComplete = function() display.remove(newLaser) end}
	 )

end

ship:addEventListener("tap", shipShooting)