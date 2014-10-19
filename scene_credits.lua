Gamestate = require "hump.gamestate"

local scene = {}

function scene:draw()
  love.graphics.setBackgroundColor(20, 20, 20)
  love.graphics.setColor(255, 255, 255, 255)

  scene.top = -120
  scene.drawText("Developed by: Aurimas Slapšys")
  scene.drawText("")
  scene.drawText("")
  scene.drawText("Music & Sounds: ")
  scene.drawText("")
  scene.drawText("Suoni Di Genova - Ghost Yacht")
  scene.drawText("tcrocker68 - Girl Heavy Breathing")
  scene.drawText("Trebblofang - Background atmospheres - Horror Atmosphere Background")
  scene.drawText("")
  scene.drawText("Downloaded from freesound.org")
  scene.drawText("")
  scene.drawText("")
  scene.drawText("Contact me: aurimas.slapsys@gmail.com")

end

function scene.drawText(text)
  local w, h = love.window.getDimensions( )
  love.graphics.printf( text, w/2-250, h/2+scene.top, 500, "left")
  scene.top = scene.top + 20
end

function scene:keyreleased(key, code)
  if key == 'enter' or key == 'return' or key == 'escape' then
    Gamestate.switch(menu)
  end
end

return scene
