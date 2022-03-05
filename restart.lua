local transform = require("transform")

local restartButton = transform:new()

function restartButton:new(spritePath, info)
    local object = {}
    object.sprite = love.graphics.newImage(spritePath)
    object.info = info

    object.dimensions = {
        width = object.sprite:getWidth(),
        height = object.sprite:getHeight()
    }
    return setmetatable(object, {__index = self})
end

function restartButton:start()
    self.position.x = (self.position.x - self.dimensions.width / 2) + 100
    self.scale = 0.5
end

function restartButton:draw()
    
end

return restartButton