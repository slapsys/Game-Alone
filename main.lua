require 'point'
require 'camera'
require 'player'
require 'radar'

sum = 0
rotDirection = 0
goDirection = 0
inertia = 0

world = {}

spaceWidth = 8000

function love.load()
    player:init()
    player.air = 100
    player.power = 100
    player.gold = 0
    radar:init(400, 100)
    radarPeriod = 5
    powerAmount = 500
    airAmount = 500
    goldAmount = 10
    dronesAmount = 20
    scrapAmount = 500

    pSight = 175
    pSense = 200
    rSight = 12
    rSense = 30
    currentRadarTime = radarPeriod
    createWorld()
    love.window.setTitle("Alone")
end

function love.update(dt)
    player:rotate(rotDirection*3*dt)
    local forward = goDirection*15*dt
    if player.power == 0 then forward = 0 end
    inertia = inertia * (1 - 3*dt) + forward
    player:forward(inertia)

    checkForCollision(dt)

    camera:setRotation(player.rot+math.pi/2)
    camera:setRotationCenter(player.x, player.y)
    local width, height = love.window.getDimensions()
    camera:setPosition(player.x - width/2, player.y - height/2)

    --[[currentRadarTime = currentRadarTime - dt

    if currentRadarTime < 0 then
        currentRadarTime = currentRadarTime + radarPeriod
        radar:resetRadius()
    end

    radar:update(dt)
    radar:setCenter(player.x, player.y)
    ---]]

    player.air = math.max(0, player.air-dt*2.5)
    player.power = math.max(0, player.power - dt*math.abs(inertia) )
end

function checkForCollision(dt)

    local p = Point(player.x, player.y)
    local r = Point(radar.x, radar.y)

    for k,v in pairs(world) do
        local x,y = v.p:get()
        local mX = math.abs(player.x - x)
        local mY = math.abs(player.y - y)
        if mX + mY < 16 then
            local length = (v.p - p):len()
            if length < 16 then
               --collision happen
                if v.type == "air" then
                  player.air = math.min(100, player.air + 10)
                  table.remove(world, k)
                elseif v.type == "power" then
                  player.power = math.min(100, player.power + 10)
                  table.remove(world, k)
                elseif v.type == "gold" then
                  player.gold = player.gold + 1
                  table.remove(world, k)
                elseif v.type == "scrap" then
                    inertia = inertia * (1 - 10* dt)
                elseif v.type == "drone" then
                  player.power = player.power - dt*70
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
    for i=1,airAmount do
        local x = math.random() * spaceWidth - spaceWidth/2
        local y = math.random() * spaceWidth - spaceWidth/2
        local hp = {}
        hp.p = Point(x, y)
        hp.type = "air"
        table.insert(world, hp)
    end

    for i=1,powerAmount do
        local x = math.random() * spaceWidth - spaceWidth/2
        local y = math.random() * spaceWidth - spaceWidth/2
        local hp = {}
        hp.p = Point(x, y)
        hp.type = "power"
        table.insert(world, hp)
    end

    for i=1,goldAmount do
        local x = math.random() * spaceWidth - spaceWidth/2
        local y = math.random() * spaceWidth - spaceWidth/2
        local hp = {}
        hp.p = Point(x, y)
        hp.type = "gold"
        table.insert(world, hp)
    end

    for i=1,dronesAmount do
        local x = math.random() * spaceWidth - spaceWidth/2
        local y = math.random() * spaceWidth - spaceWidth/2
        local hp = {}
        hp.p = Point(x, y)
        hp.type = "drone"
        table.insert(world, hp)
    end

    for i=1,scrapAmount do
        local x = math.random() * spaceWidth - spaceWidth/2
        local y = math.random() * spaceWidth - spaceWidth/2
        local hp = {}
        hp.p = Point(x, y)
        hp.type = "scrap"
        table.insert(world, hp)
    end
end


function love.draw()
    local w, h = love.window.getDimensions( )
    if player.gold == goldAmount then
        love.graphics.setBackgroundColor(20, 20, 20)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.printf( "It's done.", w/2-250, h/2, 500, "center")
        return
    end

    if player.air == 0 then
        love.graphics.setBackgroundColor(20, 20, 20)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.printf( "It's over.", w/2-250, h/2, 500, "center")
        return
    end

    camera:set()

    love.graphics.setBackgroundColor(70, 107, 119)

    local color = {255, 0, 0, 255}
    love.graphics.setColor(color)
    for k,v in pairs(world) do
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
    vert = {player.x, player.y-8, player.x-6, player.y+6,player.x+6, player.y+6}

    love.graphics.polygon("line", vert)

    love.graphics.pop()

    love.graphics.rectangle("line", -spaceWidth/2, -spaceWidth/2, spaceWidth, spaceWidth)

    if radar.currentRadius ~= radar.maxRadius then
        color[4] = (1 - radar.currentRadius/radar.maxRadius) * 255;
        if radar.currentRadius < 40 then
            color[4] = (radar.currentRadius/40)*color[4];
        end
        love.graphics.setColor(color)
        love.graphics.circle("line", radar.x, radar.y, radar.currentRadius, 100)
    end

    camera:unset()

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
    local airWidth = (player.air/100) * barWidth
    love.graphics.rectangle("fill", airX+margin, barY+margin, airWidth, barHeight)

    local powerX = w - barWidth - 20

    love.graphics.rectangle("line", powerX, barY, barWidth+margin*2, barHeight+margin*2)
    local powerWidth = (player.power/100) * barWidth
    love.graphics.rectangle("fill", powerX+margin, barY+margin, powerWidth, barHeight)

    love.graphics.printf( player.gold.."/"..goldAmount, w/2-250, barY+barHeight+margin, 500, "center")

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
            p = p - (outerRing / ((len-spaceWidth)*(len-spaceWidth)))
        end

        local x,y = p:get()

        if x ~= 0 or y ~= 0 then
            p = 300*dt*p
            v.point = v.point + p
            if v.point:len() > spaceWidth then
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

        if pLen < pSight then alpha = 255
            elseif pLen < pSense then alpha = (1-((pLen - pSight)/(pSense-pSight))) * 255
            else alpha = 0 end

        local distToRadar = math.abs(rLen - radar.currentRadius)

        if distToRadar < rSense and radar.currentRadius ~= radar.maxRadius then
            if distToRadar < rSight then alpha = 255
                else alpha = math.max(1 - (distToRadar-rSight)/(rSense-rSight) * 255, alpha)
           end
        end

        color[4] = alpha

        love.graphics.setColor(color)
        love.graphics.circle("line",x, y, 5, 10)
		--love.graphics.point(v.point:get())
	end
end

function love.keypressed(k)
	if k == " " then


	elseif k == "a" then
        rotDirection = rotDirection - 1
    elseif k == "d" then
        rotDirection = rotDirection + 1
    elseif k == "w" then
        goDirection = goDirection + 1
    elseif k == "s" then
        goDirection = goDirection - 1
    end

end

function love.keyreleased(k)
	if k == "a" then
        rotDirection = rotDirection + 1
    elseif k == "d" then
        rotDirection = rotDirection - 1
    elseif k == "w" then
        goDirection = goDirection - 1
    elseif k == "s" then
        goDirection = goDirection + 1
    end
end
