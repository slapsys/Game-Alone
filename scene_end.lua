Gamestate = require "hump.gamestate"

local scene = {}

function scene:enter(previous, isWin)
    scene.msg = isWin
end

function scene:draw()
    local w, h = love.window.getDimensions( )
    local text = "It's over."
    if scene.msg then
        text = "It's done."
    end

    love.graphics.setBackgroundColor(20, 20, 20)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf( text, w/2-250, h/2, 500, "center")

    love.graphics.printf("Press any key to continue", w/2-250, h/2+20, 500, "center")
end

function scene:keyreleased(key, code)
  if key == 'enter' or key == 'return' or key == 'escape' then
    Gamestate.switch(menu)
  end
end

return scene
