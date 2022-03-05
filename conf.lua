function love.conf(t)
    t.window.title = "LoveJam"
    t.window.vsync = false
    t.window.resizable = true

    --t.window.width = 683
    --t.window.height = 384
    t.window.width = 960
    t.window.height = 540

    t.window.fullscreen = false

    t.modules.joystick = false
    t.modules.touch = false
    t.modules.physics = false
    t.modules.thread = false

    t.modules.video = false
end