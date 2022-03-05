local sceneManager = {}

local scenes = {
    
}

local scenesDir = love.filesystem.getDirectoryItems("scenes")

for _, component in ipairs(scenesDir) do
    local trim = string.gsub(component, ".lua", "")
    scenes[trim] = require("scenes" .. "." .. trim)
end

function sceneManager:new()
    local object = {}
    local initialScene = "scene01"
    object.currentScene = scenes[initialScene]:new(object)

    object.currentSceneStr = initialScene

    return setmetatable(object, {__index = self})
end

function sceneManager:changeScene(scene)
    self.currentScene = scenes[scene]:new(self)
    self.currentSceneStr = scene
    collectgarbage("collect")
end

function sceneManager:restart()
    self:changeScene(self.currentSceneStr)
end

return sceneManager