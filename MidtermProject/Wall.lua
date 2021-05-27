Wall = Class{}

-- since we only want the image loaded once, not per instantation, define it externally
local WALL_IMAGE = love.graphics.newImage('wall.png')

function Wall:init()
    self.x = VIRTUAL_WIDTH
    self.y = 0

    self.width = WALL_IMAGE:getWidth()
end

function Wall:update(dt)
    self.x = self.x - WALL_SPEED * dt
end

function Wall:render()
    love.graphics.draw(WALL_IMAGE, math.floor(self.x + 0.5), math.floor(self.y))
end