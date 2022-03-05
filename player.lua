local transform = require("transform")
local gameConfig = require("game_config")

local player = transform:new()

function player:new()
    local object = {}
    object.x = 200
	object.y = 200
	object.gridX = 128
	object.gridY = 384
	object.speed = 10

    return setmetatable(object, {__index = self})
end

function player:awake()
    
end

function player:update(dt)
    self.x = self.x - ((self.x - self.gridX) * self.speed * dt)
	self.y = self.y - ((self.y - self.gridY) * self.speed * dt)
end

function player:draw()
    love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("fill", self.x - gameConfig.tileSize, self.y - gameConfig.tileSize, gameConfig.tileSize, gameConfig.tileSize)
end


return player