local colectible = {}

function colectible:new()
    local object = {}
    object.currentColectible = 0
    object.colectibleNeeded = 1

    return setmetatable(object, {__index = self})
end

function colectible:addColectible()
    self.currentColectible = self.currentColectible + 1
end

function colectible:targetReached()
    return self.currentColectible == self.colectibleNeeded
end

return colectible