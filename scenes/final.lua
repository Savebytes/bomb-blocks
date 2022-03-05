local maps = require("maps")
local gameConfig = require("game_config")

local player = require("player")
local shakeCam = require("shakeCam")
local colectible = require("collectible")

local scene = {}

function scene:new(sceneManager)
    local scene = {}
    self.player = player:new()
    self.colectible = colectible:new()
    self.colectible.colectibleNeeded = 10

	self.sceneManager = sceneManager

    self.sounds = {
        blipSound = love.audio.newSource("assets/sounds/blip.wav", "static"),
        moveSound = love.audio.newSource("assets/sounds/move.wav", "static"),
        doorClosed = love.audio.newSource("assets/sounds/door_closed.wav", "static"),
        doorOpen = love.audio.newSource("assets/sounds/door_open.wav", "static"),
        explosion = love.audio.newSource("assets/sounds/explosion.wav", "static"),
        restart = love.audio.newSource("assets/sounds/restart.wav", "static"),
        winSound = love.audio.newSource("assets/sounds/win_level_sound.wav", "static")
    }

    self.shakeCam = shakeCam:new()

    self.sounds.moveSound:setVolume(0.7)

    self.map = maps:new().maps.map9

    self.canMove = false
    self.died = false

    self.time = 0.2
    self.timeToRestart = 1
    self.timeToWin = 1.3

    self.winSoundPlayed = false

    return setmetatable(scene, {__index = self})
end

function scene:update(dt)
    self.shakeCam:update(dt)

    if self.died then
        if self.timeToRestart <= 0 then
           --self.sceneManager:restart()
        else 
            self.timeToRestart = self.timeToRestart - dt
        end
        return
    end

    self.player:update(dt)

    if self.colectible:targetReached() then
        if self.timeToWin <= 0 then
            self.sceneManager:changeScene("scene07")
        else 
            if not self.winSoundPlayed then
                self.winSoundPlayed = true
                self.sounds.winSound:play()
            end
            self.timeToWin = self.timeToWin - dt
        end
    end

    if self.time <= 0 then
        self.canMove = true
    else 
        self.canMove = false
        self.time = self.time - dt
    end
end

function scene:draw()
    self.shakeCam:draw()
    
    for y = 1, #self.map do
		for x = 1, #self.map[y] do
			if self.map[y][x] == gameConfig.objects.wall then
				love.graphics.rectangle("line", (x-1) * gameConfig.tileSize, (y-1) * gameConfig.tileSize, gameConfig.tileSize, gameConfig.tileSize, 5, 5)
			end

			if self.map[y][x] == gameConfig.objects.gold then
				love.graphics.setColor(1, 1, 0, 1)
				love.graphics.rectangle("fill", (x-1) * gameConfig.tileSize, (y-1) * gameConfig.tileSize, gameConfig.tileSize, gameConfig.tileSize)
				love.graphics.setColor(1, 1, 1, 1)
			end

			if self.map[y][x] == gameConfig.objects.win then
				love.graphics.setColor(0, 0.5, 0, 1)
				love.graphics.rectangle("fill", (x-1) * gameConfig.tileSize, (y-1) * gameConfig.tileSize, gameConfig.tileSize, gameConfig.tileSize)
				love.graphics.setColor(1, 1, 1, 1)
			end
            
            if self.map[y][x] == gameConfig.objects.button then
                love.graphics.setColor(0.5, 0, 0, 1)
                love.graphics.rectangle("fill", (x-1) * gameConfig.tileSize, (y-1) * gameConfig.tileSize, gameConfig.tileSize, gameConfig.tileSize)
                love.graphics.setColor(1, 1, 1, 1)
            end

            if self.map[y][x] == gameConfig.objects.door then
                love.graphics.setColor(0.5, 0.5, 0.5, 1)
                love.graphics.rectangle("fill", (x-1) * gameConfig.tileSize, (y-1) * gameConfig.tileSize, gameConfig.tileSize, gameConfig.tileSize)
                love.graphics.setColor(1, 1, 1, 1)
            end

            if self.map[y][x] == gameConfig.objects.bomb then
                love.graphics.setColor(0.45, 0, 0, 1)
                love.graphics.rectangle("fill", (x-1) * gameConfig.tileSize, (y-1) * gameConfig.tileSize, gameConfig.tileSize, gameConfig.tileSize)
                love.graphics.setColor(1, 1, 1, 1)
            end
		end
	end

    self.player:draw()

    if self.died then
        love.graphics.print("Congratulations.. you won a unfinished game!", 150, 350)
        love.graphics.print("You can exit now...", 150, 400)
    end
end

function scene:checkCollsion(x, y)
	if self.map[(self.player.gridY / gameConfig.tileSize) + y] == nil then
		return false
	end

	if self.map[(self.player.gridY / gameConfig.tileSize) + y][(self.player.gridX / gameConfig.tileSize) + x] == nil then
		return false
	end

	local collision = self.map[(self.player.gridY / gameConfig.tileSize) + y][(self.player.gridX / gameConfig.tileSize) + x]

	if collision == gameConfig.objects.wall then
		return false
	end

	--print(map[(player.gridY / tileSize) + y][(player.gridX / tileSize) + x])

	-- " " == 0
	-- wall == # == 1
	-- gold == * == 2
	-- green == o == 3
    
	if collision == gameConfig.objects.gold then
		if self.map[(self.player.gridY / gameConfig.tileSize) + y * 2] == nil then
			return false
		end
	
		if self.map[(self.player.gridY / gameConfig.tileSize) + y * 2][(self.player.gridX / gameConfig.tileSize) + x * 2] == nil then
			return false
		end

		local nextCollision = self.map[(self.player.gridY / gameConfig.tileSize) + y * 2][(self.player.gridX / gameConfig.tileSize) + x*2]

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
			self.map[(self.player.gridY / gameConfig.tileSize) + y][(self.player.gridX / gameConfig.tileSize) + x] = gameConfig.objects.nothing
			
			self:boxesLogic()
			return true
		end

		self.map[(self.player.gridY / gameConfig.tileSize) + y][(self.player.gridX / gameConfig.tileSize) + x] = gameConfig.objects.nothing
		self.map[(self.player.gridY / gameConfig.tileSize) + y * 2][(self.player.gridX / gameConfig.tileSize) + x*2] = gameConfig.objects.gold

		self.sounds.moveSound:setPitch(0.7)
		self.sounds.moveSound:play()
		return true
	end

	if collision == gameConfig.objects.win then
		return false
	end

    if collision == gameConfig.objects.door then
        print("door")
        self.sounds.doorClosed:play()
        return false
    end

    if collision == gameConfig.objects.button then
        print("y: " .. (self.player.gridY / gameConfig.tileSize) + y, (self.player.gridX / gameConfig.tileSize) + x)

        local buttonX = (self.player.gridX / gameConfig.tileSize) + x 
        local buttonY = (self.player.gridY / gameConfig.tileSize) + y

        if buttonY == 3 then
            if buttonX == 3 then
                self.map[6][13] = gameConfig.objects.nothing

                if self.sounds.doorOpen:isPlaying() then
                    self.sounds.doorOpen:stop()
                end
        
                self.sounds.doorOpen:play()
                return true
            end
        end
    end

    if collision == gameConfig.objects.bomb then
        print("bomb")
        self.shakeCam:startShake(0.5, 1)
        self.sounds.explosion:play()

        self.canMove = false
        self.died = true

        return false
    end

	self.sounds.moveSound:setPitch(1)
	self.sounds.moveSound:play()
	return true
end

function scene:boxesLogic()
    self.colectible:addColectible()
    if self.colectible:targetReached() then
        
    else
        self.sounds.blipSound:play()
    end
end

-- love callback
function scene:keypressed(k)
    if not self.canMove then
        return
    end

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