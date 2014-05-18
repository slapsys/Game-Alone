player = {}

function player:init()
    local w,h = love.window.getDimensions()
    player.x = w/2
    player.y = h/2
    player.rot = -math.pi/2
end

function player:rotate(dr)
    self.rot = self.rot + dr
end

function player:forward(amount)
    self.x = self.x + amount * math.cos(self.rot)
    self.y = self.y + amount * math.sin(self.rot)
end