local maps = require("maps")

local gameLogic = {}

function gameLogic:new(player, _maps)
    local object = {}
    object.player = player
    object.maps = _maps
    object.currentTargetGetted = 0
    object.target = 1

    return setmetatable(object, {__index = self})
end

function gameLogic:start()

end

function gameLogic:update()
    
end

function gameLogic:getTargetText()
    return self.currentTargetGetted .. "/" .. self.target
end

function gameLogic:resetScore()
    self.currentTargetGetted = 0
end

function gameLogic:doLogic(currentMap)
    self.currentTargetGetted = self.currentTargetGetted + 1

    print(currentMap == maps.map1)

    if currentMap == maps.map1 then
        if self.currentTargetGetted == self.target then
            self.player:setPosition(192, 384)

            self:resetScore()
            self.target = 1
        end
    end

    if currentMap == maps.map2 then
        if self.currentTargetGetted == self.target then
            self.player:setPosition(192, 384)
            
            self:resetScore()
            self.target = 2
        end
    end

    if currentMap == maps.map3 then
        if self.currentTargetGetted == self.target then 
            self.player:setPosition(192, 384)

            self:resetScore()
            self.target = 3
        end
    end

    if currentMap == maps.map4 then
        if self.currentTargetGetted == self.target then
            print("map4 lol")
            
            --self:resetScore()
        end
    end
end

function gameLogic:restart()
    
end

return gameLogic