Gamestate = require "hump/gamestate"
game = require 'scene_game'
menu = require 'scene_menu'
game_end = require 'scene_end'

function love.load()
    love.window.setTitle("Alone")
    Gamestate.switch(menu)
    Gamestate.registerEvents()
end
