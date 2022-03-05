local maps = require("maps")
local gameConfig = require("game_config")

local player = require("player")
local colectible = require("collectible")

local scene = {}

function scene:new(sceneManager)
    local scene = {}
    scene.player = player:new()
	scene.sceneManager = sceneManager

	self.colectible = colectible:new()
	self.colectible.colectibleNeeded = 1

    scene.sounds = {
        blipSound = love.audio.newSource("assets/sounds/blip.wav", "static"),
        moveSound = love.audio.newSource("assets/sounds/move.wav", "static"),
		restart = love.audio.newSource("assets/sounds/restart.wav", "static"),
        winSound = love.audio.newSource("assets/sounds/win_level_sound.wav", "static")
    }

    scene.sounds.moveSound:setVolume(0.7)

    scene.map01 = maps:new().maps.map1

	self.timeToWin = 1.3
    self.winSoundPlayed = false

    return setmetatable(scene, {__index = self})
end

function scene:update(dt)
    self.player:update(dt)

	if self.colectible:targetReached() then
        if self.timeToWin <= 0 then
            self.sceneManager:changeScene("scene02")
        else 
            if not self.winSoundPlayed then
                self.winSoundPlayed = true
                self.sounds.winSound:play()
            end
            self.timeToWin = self.timeToWin - dt
        end
    end
end

function scene:draw()
    self.player:draw()

    for y = 1, #self.map01 do
		for x = 1, #self.map01[y] do
			if self.map01[y][x] == gameConfig.objects.wall then
				love.graphics.rectangle("line", (x-1) * gameConfig.tileSize, (y-1) * gameConfig.tileSize, gameConfig.tileSize, gameConfig.tileSize, 5, 5)
			end

			if self.map01[y][x] == gameConfig.objects.gold then
				love.graphics.setColor(1, 1, 0, 1)
				love.graphics.rectangle("fill", (x-1) * gameConfig.tileSize, (y-1) * gameConfig.tileSize, gameConfig.tileSize, gameConfig.tileSize)
				love.graphics.setColor(1, 1, 1, 1)
			end

			if self.map01[y][x] == gameConfig.objects.win then
				love.graphics.setColor(0, 0.5, 0, 1)
				love.graphics.rectangle("fill", (x-1) * gameConfig.tileSize, (y-1) * gameConfig.tileSize, gameConfig.tileSize, gameConfig.tileSize)
				love.graphics.setColor(1, 1, 1, 1)
			end
		end
	end
end

function scene:checkCollsion(x, y)
	if self.map01[(self.player.gridY / gameConfig.tileSize) + y] == nil then
		return false
	end

	if self.map01[(self.player.gridY / gameConfig.tileSize) + y][(self.player.gridX / gameConfig.tileSize) + x] == nil then
		return false
	end

	local collision = self.map01[(self.player.gridY / gameConfig.tileSize) + y][(self.player.gridX / gameConfig.tileSize) + x]

	if collision == gameConfig.objects.wall then
		return false
	end

	--print(map[(player.gridY / tileSize) + y][(player.gridX / tileSize) + x])

	-- " " == 0
	-- wall == # == 1
	-- gold == * == 2
	-- green == o == 3
    
	if collision == gameConfig.objects.gold then
		if self.map01[(self.player.gridY / gameConfig.tileSize) + y * 2] == nil then
			return false
		end
	
		if self.map01[(self.player.gridY / gameConfig.tileSize) + y * 2][(self.player.gridX / gameConfig.tileSize) + x * 2] == nil then
			return false
		end

		local nextCollision = self.map01[(self.player.gridY / gameConfig.tileSize) + y * 2][(self.player.gridX / gameConfig.tileSize) + x*2]

		-- todo: diagonal (bug?) fix
		--[[
		
		-- if math.abs(x) == 1 and math.abs(y) == 1 then
		-- 	return false
		-- end
		 --]]

		if nextCollision == gameConfig.objects.wall then
			return false
		elseif nextCollision == gameConfig.objects.gold then
			return false
		elseif nextCollision == gameConfig.objects.win then
			self.map01[(self.player.gridY / gameConfig.tileSize) + y][(self.player.gridX / gameConfig.tileSize) + x] = gameConfig.objects.nothing
			

			self:targetLogic()
			return true
		end

		self.map01[(self.player.gridY / gameConfig.tileSize) + y][(self.player.gridX / gameConfig.tileSize) + x] = gameConfig.objects.nothing
		self.map01[(self.player.gridY / gameConfig.tileSize) + y * 2][(self.player.gridX / gameConfig.tileSize) + x*2] = gameConfig.objects.gold

		self.sounds.moveSound:setPitch(0.7)
		self.sounds.moveSound:play()
		return true
	end

	if collision == gameConfig.objects.win then
		return false
	end

	self.sounds.moveSound:setPitch(1)
	self.sounds.moveSound:play()
	return true
end

function scene:targetLogic()
	self.colectible:addColectible()
	if not self.colectible:targetReached() then
		self.sounds.blipSound:play()
	end
end

-- love callback
function scene:keypressed(k)
    if k == "w" or k == "up" then
        if self:checkCollsion(0, -1) then
            self.player.gridY = self.player.gridY - gameConfig.tileSize
        end
    elseif k == "a" or k == "left" then
        if self:checkCollsion(-1, 0) then
            self.player.gridX = self.player.gridX - gameConfig.tileSize
        end
    elseif k == "s" or k == "down" then
        if self:checkCollsion(0, 1) then
            self.player.gridY = self.player.gridY + gameConfig.tileSize
        end
    elseif k == "d" or k == "right" then
        if self:checkCollsion(1, 0) then
            self.player.gridX = self.player.gridX + gameConfig.tileSize
        end
    end
end

function scene:mousepressed(x, y, button, mouseX, mouseY)
    local mouseGridX, mouseGridY = mouseX + gameConfig.tileSize, mouseY + gameConfig.tileSize

    if button == 1 then
		if mouseGridX == self.player.gridX and mouseGridY == self.player.gridY then
			self.sceneManager:restart()
			self.sounds.restart:play()
		end
	end
end

return scene