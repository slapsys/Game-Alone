Gamestate = require "hump.gamestate"

local scene = {}

function scene:draw()
    local w, h = love.window.getDimensions( )
    love.graphics.setBackgroundColor(20, 20, 20)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf( "Press Enter to start a game", w/2-250, h/2, 500, "center")
end

function scene:keyreleased(key, code)
  if key == 'enter' or key == 'return' then
    Gamestate.switch(game)
  end
end

return scene
