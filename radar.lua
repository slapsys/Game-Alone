radar = {}

function radar:init(maxRadius, speed)
    self.maxRadius = maxRadius
    self.currentRadius = maxRadius
    self.speed = speed
    self.x = 0
    self.y = 0
end

function radar:update(dt)
    self.currentRadius = self.currentRadius + self.speed*dt
    if self.currentRadius > self.maxRadius then
        self.currentRadius = self.maxRadius
        end
end

function radar:setCenter(x, y)
    self.x = x
    self.y = y
end

function radar:resetRadius()
    self.currentRadius = 0    
end

function radar:isActive()
    return self.currentRadius ~= self.maxRadius   
end
