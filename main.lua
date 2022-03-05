local gameConfig = require("game_config")
local sceneManager = require("scene_manager"):new()

-- lol
local editorMode = false 

local appWidth, appHeight = 1280, 704

local scaleFactor = 1
local offsets = {
    x = 0,
    y = 0
}

local mouseX, mouseY

local font = love.graphics.newFont("assets/fonts/coolvetica_rg.otf", 34)

local currentSelectedObject = 1
local maxSelectedObject = 3

local mouse = require("mouse"):new("assets/sprites/mouse.png")
local gameLogic = require("game_logic"):new()

local gameCanvas = love.graphics.newCanvas(appWidth, appHeight)

function love.load()
	mouse.scale = 0.2
	love.mouse.setVisible(false)
end




function love.update(dt)
	mouseX, mouseY = ScreenToWorldPosition(love.mouse.getPosition())
	mouse.setPosition(mouseX, mouseY)

	mouseX = math.floor(mouseX / gameConfig.tileSize) * gameConfig.tileSize
	mouseY = math.floor(mouseY / gameConfig.tileSize) * gameConfig.tileSize

	sceneManager.currentScene:update(dt)
end

function love.mousepressed(x, y, button)
	sceneManager.currentScene:mousepressed(x, y, button, mouseX, mouseY)

	-- local positionInArrayY = currentMap[(mouseY / tileSize)+1]

	-- if positionInArrayY == nil then
	-- 	return
	-- end

	-- local positionInArrayX = currentMap[(mouseY / tileSize) + 1][(mouseX / tileSize)+1]

	-- if positionInArrayX == nil then
	-- 	return
	-- end

	-- if not editorMode then
	-- 	return
	-- end

	-- if(button == 1) then
	-- 	currentMap[(mouseY / tileSize)+1][(mouseX / tileSize)+1] = objects.wall
	-- end

	-- if(button == 2) then
	-- 	currentMap[(mouseY / tileSize)+1][(mouseX / tileSize)+1] = 0
	-- end
end

function love.quit()
	
end

function love.keypressed(k)
	if k == "escape" then
		love.event.quit()
	end

	if k == "f2" then
		editorMode = not editorMode
	end

	sceneManager.currentScene:keypressed(k)
end

-- function love.wheelmoved(a, b)

-- end


function ScreenToWorldPosition(x, y)
    return (x - offsets.x) / scaleFactor, (y - offsets.y) / scaleFactor
end

function love.draw()
	local width, height = love.graphics.getDimensions()

	local xscale = width / appWidth
	local yscale = height / appHeight
	local scale = math.min(xscale, yscale)

	scaleFactor = scale

	local xoffset = (width - (appWidth * scale)) / 2
	local yoffset = (height - (appHeight * scale)) / 2

	offsets.x = xoffset
	offsets.y = yoffset

	love.graphics.setCanvas(gameCanvas)
	love.graphics.clear()

	sceneManager.currentScene:draw()
	
	-- cursor
	love.graphics.setFont(font)
	
	love.graphics.setColor(1,0,0,1)
	love.graphics.rectangle("line", mouseX, mouseY, gameConfig.tileSize, gameConfig.tileSize)
	love.graphics.setColor(1, 1, 1, 1)

	if editorMode then
		love.graphics.print("X: " .. mouseX + gameConfig.tileSize, appWidth - 100, -10)
		love.graphics.print("Y: " .. mouseY + gameConfig.tileSize, appWidth - 100, 25)

		love.graphics.print("X: " .. mouseX / gameConfig.tileSize+1, appWidth - 100, 65)
		love.graphics.print("Y: " .. mouseY / gameConfig.tileSize+1, appWidth - 100, 90)
		
		love.graphics.print("Fps: " .. love.timer.getFPS(), 0, 0)
	end

	--timerBar:draw()


	mouse:draw()

	love.graphics.setCanvas()

	love.graphics.draw(gameCanvas, xoffset, yoffset, nil, scale, scale)
end