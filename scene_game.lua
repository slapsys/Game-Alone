Gamestate = require "hump.gamestate"
require 'point'
require 'camera'
require 'player'
require 'radar'

local game = {}

function game:init()

    game.sum = 0
    game.rotDirection = 0
    game.goDirection = 0
    game.inertia = 0
    game.spaceWidth = 8000
    game.world = {}

    game.player = player
    game.player:init()
    game.player.air = 100
    game.player.power = 100
    game.player.gold = 0
    game.radar = radar
    game.radar:init(400, 100)
    game.radarPeriod = 5
    game.powerAmount = 500
    game.airAmount = 500
    game.goldAmount = 10
    game.dronesAmount = 20
    game.scrapAmount = 500

    game.camera = camera

    game.pSight = 175
    game.pSense = 200
    game.rSight = 12
    game.rSense = 30
    game.currentRadarTime = game.radarPeriod
    createWorld()
end

function game:update(dt)
    game.player:rotate(game.rotDirection*3*dt)
    local forward = game.goDirection*15*dt
    if game.player.power == 0 then forward = 0 end
    game.inertia = game.inertia * (1 - 3*dt) + forward
    game.player:forward(game.inertia)

    checkForCollision(dt)

    game.camera:setRotation(game.player.rot+math.pi/2)
    game.camera:setRotationCenter(game.player.x, player.y)
    local width, height = love.window.getDimensions()
    game.camera:setPosition(game.player.x - width/2, game.player.y - height/2)

    --[[currentRadarTime = currentRadarTime - dt

    if currentRadarTime < 0 then
        currentRadarTime = currentRadarTime + radarPeriod
        radar:resetRadius()
    end

    radar:update(dt)
    radar:setCenter(player.x, player.y)
    ---]]

    game.player.air = math.max(0, game.player.air-dt*2.5)
    game.player.power = math.max(0, game.player.power - dt*math.abs(game.inertia) )

    if game.player.air == 0 then
      Gamestate.switch(game_end, false)
    elseif game.player.gold == game.goldAmount then
      Gamestate.switch(game_end, true)
    end

end

function checkForCollision(dt)

    local p = Point(game.player.x, game.player.y)
    local r = Point(game.radar.x, game.radar.y)

    for k,v in pairs(game.world) do
        local x,y = v.p:get()
        local mX = math.abs(game.player.x - x)
        local mY = math.abs(game.player.y - y)
        if mX + mY < 16 then
            local length = (v.p - p):len()
            if length < 16 then
               --collision happen
                if v.type == "air" then
                  game.player.air = math.min(100, game.player.air + 10)
                  table.remove(game.world, k)
                elseif v.type == "power" then
                  game.player.power = math.min(100, game.player.power + 10)
                  table.remove(game.world, k)
                elseif v.type == "gold" then
                  game.player.gold = game.player.gold + 1
                  table.remove(game.world, k)
                elseif v.type == "scrap" then
                    game.inertia = game.inertia * (1 - 10* dt)
                elseif v.type == "drone" then
                  game.player.power = game.player.power - dt*70
                end
            end
        end

        if mX + mY < 400 and v.type == "drone" then
            local dir = v.p - p

            local len = dir:len()

            if len > 0 then
                  dir:normalize()
                  dir = 100 * dt *((400-len)/400)* dir
                  v.p = v.p - dir
            end

        end
    end
end

function createWorld()
    for i=1,game.airAmount do
        local x = math.random() * game.spaceWidth - game.spaceWidth/2
        local y = math.random() * game.spaceWidth - game.spaceWidth/2
        local hp = {}
        hp.p = Point(x, y)
        hp.type = "air"
        table.insert(game.world, hp)
    end

    for i=1,game.powerAmount do
        local x = math.random() * game.spaceWidth - game.spaceWidth/2
        local y = math.random() * game.spaceWidth - game.spaceWidth/2
        local hp = {}
        hp.p = Point(x, y)
        hp.type = "power"
        table.insert(game.world, hp)
    end

    for i=1,game.goldAmount do
        local x = math.random() * game.spaceWidth - game.spaceWidth/2
        local y = math.random() * game.spaceWidth - game.spaceWidth/2
        local hp = {}
        hp.p = Point(x, y)
        hp.type = "gold"
        table.insert(game.world, hp)
    end

    for i=1,game.dronesAmount do
        local x = math.random() * game.spaceWidth - game.spaceWidth/2
        local y = math.random() * game.spaceWidth - game.spaceWidth/2
        local hp = {}
        hp.p = Point(x, y)
        hp.type = "drone"
        table.insert(game.world, hp)
    end

    for i=1,game.scrapAmount do
        local x = math.random() * game.spaceWidth - game.spaceWidth/2
        local y = math.random() * game.spaceWidth - game.spaceWidth/2
        local hp = {}
        hp.p = Point(x, y)
        hp.type = "scrap"
        table.insert(game.world, hp)
    end
end


function game:draw()
    local w, h = love.window.getDimensions( )
    game.camera:set()

    love.graphics.setBackgroundColor(70, 107, 119)

    local color = {255, 0, 0, 255}
    love.graphics.setColor(color)
    for k,v in pairs(game.world) do
        local x,y = v.p:get()
        if v.type == "air" then color = {100, 100, 255, 255}
        elseif v.type == "power" then color = {100, 255, 100, 255}
        elseif v.type == "drone" then color = {255, 100, 100, 255}
        elseif v.type == "scrap" then color = {230, 230, 230, 255}
        else  color = {255, 255, 100, 255} end


        love.graphics.setColor(color)
        love.graphics.circle("line", x, y, 5, 8)


    end

    love.graphics.push()
    love.graphics.translate(player.x, player.y)
    love.graphics.rotate(player.rot+math.pi/2)
    love.graphics.translate(-player.x, -player.y)

    color = {230,230,230,255}
    love.graphics.setColor(color)
    vert = {game.player.x, game.player.y-8, game.player.x-6, game.player.y+6,game.player.x+6, game.player.y+6}

    love.graphics.polygon("line", vert)

    love.graphics.pop()

    love.graphics.rectangle("line", -game.spaceWidth/2, -game.spaceWidth/2, game.spaceWidth, game.spaceWidth)

    if game.radar.currentRadius ~= game.radar.maxRadius then
        color[4] = (1 - game.radar.currentRadius/game.radar.maxRadius) * 255;
        if game.radar.currentRadius < 40 then
            color[4] = (game.radar.currentRadius/40)*color[4];
        end
        love.graphics.setColor(color)
        love.graphics.circle("line", game.radar.x, game.radar.y, game.radar.currentRadius, 100)
    end

    game.camera:unset()

    --HUD

    color = {230,230,230,255}
    hey = 12
    local barWidth = 150
    local barHeight = 10
    local margin = 5

    local airX = 20
    local barY = 20

    love.graphics.setColor(color)
    love.graphics.rectangle("line", airX, barY, barWidth+margin*2, barHeight+margin*2)
    local airWidth = (game.player.air/100) * barWidth
    love.graphics.rectangle("fill", airX+margin, barY+margin, airWidth, barHeight)

    local powerX = w - barWidth - 20

    love.graphics.rectangle("line", powerX, barY, barWidth+margin*2, barHeight+margin*2)
    local powerWidth = (game.player.power/100) * barWidth
    love.graphics.rectangle("fill", powerX+margin, barY+margin, powerWidth, barHeight)

    love.graphics.printf( game.player.gold.."/"..game.goldAmount, w/2-250, barY+barHeight+margin, 500, "center")

end

function movePixels(dt, allies, food, enemy)
    local width, height = love.window.getDimensions( )
    for k,v in pairs(allies) do

        p = Point(0, 0)
        p = calc(p, v.point, food, -5)
        p = calc(p, v.point, enemy, 5)
        p = calc(p, v.point, allies, -0.1)

        outerRing = v.point
        local len = outerRing:len()
        if len ~= 0 then
            p = p - (outerRing / ((len-game.spaceWidth)*(len-game.spaceWidth)))
        end

        local x,y = p:get()

        if x ~= 0 or y ~= 0 then
            p = 300*dt*p
            v.point = v.point + p
            if v.point:len() > game.spaceWidth then
                allies[k] = nil
                addPixel()
            end
        end

  end


end

function calc(direction, startPoint, others, gravitation)
     for k1,v1 in pairs(others) do
            local diff = startPoint - v1.point
            local len = diff:len()
            if len ~= 0 then
                direction = direction + gravitation*(diff / (len*len))
            end
        end
    return direction
end

function drawPixels(pixels, color)
    local p = Point(player.x, player.y)
    local r = Point(radar.x, radar.y)

    for k,v in pairs(pixels) do
        local x,y = v.point:get()
        local pLen = (Point(x, y) - p):len()
        local rLen = (Point(x, y) - r):len()
        local alpha = color[4]

        if game.pLen < game.pSight then alpha = 255
            elseif pLen < pSense then alpha = (1-((game.pLen - game.pSight)/(game.pSense-game.pSight))) * 255
            else alpha = 0 end

        local distToRadar = math.abs(rLen - game.radar.currentRadius)

        if distToRadar < game.rSense and game.radar.currentRadius ~= game.radar.maxRadius then
            if distToRadar < game.rSight then alpha = 255
                else alpha = math.max(1 - (distToRadar-game.rSight)/(game.rSense-game.rSight) * 255, alpha)
           end
        end

        color[4] = alpha

        love.graphics.setColor(color)
        love.graphics.circle("line",x, y, 5, 10)
    --love.graphics.point(v.point:get())
  end
end

function game:keypressed(k)
  if k == " " then


  elseif k == "a" or k == "left" then
        game.rotDirection = game.rotDirection - 1
    elseif k == "d" or k == "right" then
        game.rotDirection = game.rotDirection + 1
    elseif k == "w" or k == "up" then
        game.goDirection = game.goDirection + 1
    elseif k == "s" or k == "down" then
        game.goDirection = game.goDirection - 1
    end

end

function game:keyreleased(k)
  if k == "a" or k == "left" then
        game.rotDirection = game.rotDirection + 1
    elseif k == "d" or k == "right" then
        game.rotDirection = game.rotDirection - 1
    elseif k == "w" or k == "up" then
        game.goDirection = game.goDirection - 1
    elseif k == "s" or k == "down" then
        game.goDirection = game.goDirection + 1
    end
end

return game
