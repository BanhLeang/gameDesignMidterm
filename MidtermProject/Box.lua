Box = Class{}

-- since we only want the image loaded once, not per instantation, define it externally
local BOX_IMAGE = love.graphics.newImage('box.png')

function Box:init()
    self.x = VIRTUAL_WIDTH
    self.y = math.random(0, 200)

    self.width = BOX_IMAGE:getWidth()
end

function Box:update(dt)
    self.x = self.x - BOX_SPEED * dt
end

function Box:render()
    love.graphics.draw(BOX_IMAGE, math.floor(self.x + 0.5), math.floor(self.y))
end