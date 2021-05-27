Bird = Class{}

local GRAVITY = 2 --20

function Bird:init()
    characterSheet = love.graphics.newImage('bird.png')
    characterQuads = GenerateQuads(characterSheet, 32, 33)
    self.image = love.graphics.newImage('bird.png')
    self.x = VIRTUAL_WIDTH / 2 - 8
    self.y = VIRTUAL_HEIGHT / 2 - 8

    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.dy = 0

    idleAnimation = Animation {
        frames = {1},
        interval = 1
    }
    flapAnimation = Animation {
        frames = {2},
        interval = 0.5
    }

    currentAnimation = idleAnimation
end

--[[
    AABB collision that expects a pipe, which will have an X and Y and reference
    global pipe width and height values.
]]
function Bird:collides(pipe)
    -- the 2's are left and top offsets
    -- the 4's are right and bottom offsets
    -- both offsets are used to shrink the bounding box to give the player
    -- a little bit of leeway with the collision
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end

----------------------------------------------------------------------------------
function Bird:collidesB(bx)
    if (self.x + 2) + (self.width - 4) >= bx.x and self.x + 2 <= bx.x + BOX_WIDTH then
        if (self.y + 2) + (self.height - 4) >= bx.y and self.y + 2 <= bx.y + BOX_HEIGHT then
            return true
        end
    end

    return false
end
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
function Bird:collidesW(w)
    if (self.x + 2) + (self.width - 4) >= w.x and self.x + 2 <= w.x + WALL_WIDTH then
        if (self.y + 2) + (self.height - 4) >= w.y and self.y + 2 <= w.y + WALL_HEIGHT then
            return true
        end
    end

    return false
end
----------------------------------------------------------------------------------


function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') or love.mouse.wasPressed(1) then
        self.dy = -1
        currentAnimation = flapAnimation
        sounds['jump']:play() --This plays the sound jump every time the button is pressed.
    end
    if self.dy > 0 then 
        currentAnimation = idleAnimation
    end

    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(characterSheet, characterQuads[currentAnimation:getCurrentFrame()], self.x, self.y)
end