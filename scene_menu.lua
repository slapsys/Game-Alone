Gamestate = require "hump.gamestate"

local scene = {}

function scene:draw()
  local w, h = love.window.getDimensions( )
  love.graphics.setBackgroundColor(20, 20, 20)
  love.graphics.setColor(255, 255, 255, 255)

  love.graphics.printf( "Alone.", w/2-250, h/2-90, 500, "center")

  scene.drawTutorial( w/2-100, h/2-40, "Things you need to collect.", "gold")
  scene.drawTutorial( w/2-100, h/2-20, "Gives you air.", "air")
  scene.drawTutorial( w/2-100, h/2, "Gives you power.", "power")
  scene.drawTutorial( w/2-100, h/2+20, "Slows you down.", "scrap")
  scene.drawTutorial( w/2-100, h/2+40, "Chases and drains your power.", "drone")

  love.graphics.printf( "Use WASD or arrow keys to move.", w/2-250, h/2+70, 500, "center")

  love.graphics.printf( "Press Enter to start a game", w/2-250, h/2+90, 500, "center")

  love.graphics.printf( "Press i for credits", 20, h-30, 500, "left")
end

function scene.drawTutorial(x, y, text, type)
  if type == "air" then color = {100, 100, 255, 255}
  elseif type == "power" then color = {100, 255, 100, 255}
  elseif type == "drone" then color = {255, 100, 100, 255}
  elseif type == "scrap" then color = {230, 230, 230, 255}
  else  color = {255, 255, 100, 255} end

  love.graphics.setColor(color)
  love.graphics.circle("line", x, y, 5, 8)


  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.printf( text, x+10, y-6, 500, "left")

end

function scene:keyreleased(key, code)
  if key == 'enter' or key == 'return' then
    Gamestate.switch(game)
  elseif key == 'i' then
    Gamestate.switch(credits)
  elseif key == 'escape' then
    love.event.quit()
  end
end

return scene
