Gamestate = require "hump.gamestate"
game = require "scene_game"

local menu = {}

function menu:draw()
    love.graphics.print("Press Enter to continue", 10, 10)
end

function menu:keyreleased(key, code)
    if key == 'enter' then
        Gamestate.switch(game)
    end
end
