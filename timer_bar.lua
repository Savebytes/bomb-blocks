local transform = require("transform")

local timerBar = transform:new()

function timerBar:new(info)
    local t = {}
    t.width = 600
    t.height = 20
    t.info = info or {}
    t.speed = 20

    return setmetatable(t, {__index = self})
end

function timerBar:start()
    self.position.x = (self.info.appWidth / 2) - (self.width / 2)
    self.position.y = 10
end

function timerBar:update(dt)
    if self.width <= 0 then
        self.width = 0
        return
    end
    self.width = self.width - dt * self.speed
end

function timerBar:draw()
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.width, self.height)
end

return timerBar