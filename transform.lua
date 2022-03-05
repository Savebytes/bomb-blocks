local transform = {}

function transform:new()
    local t = {
        position = {
            x = 0,
            y = 0
        }
    }

    t.scale = 1
    
    t.setPosition = function (x, y)
        t.position.x = x
        t.position.y = y
    end

    return setmetatable(t, {__index = self})
end

return transform