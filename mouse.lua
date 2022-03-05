local mouse = {}

function mouse:new(spritePath)
    local object = {}
    object.x = 0
    object.y = 0
    object.scale = 1

    object.sprite = love.graphics.newImage(spritePath)

    object.setPosition = function (x, y)
        object.x = x
        object.y = y
    end

    return setmetatable(object, {__index = self})
end

function mouse:draw()
    love.graphics.draw(self.sprite, self.x, self.y, nil, self.scale, self.scale)
end

return mouse