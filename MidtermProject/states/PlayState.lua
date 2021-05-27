PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
BOX_SPEED = 80
WALL_SPEED = 60

PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BOX_WIDTH = 50
BOX_HEIGHT = 50

WALL_WIDTH = 50
WALL_HEIGHT = 600

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()

    self.pipePairs = {}
    self.boxes = {}
    self.wall = {}

    self.timer = 0
    self.timer_box = 0
    self.timer_wall = 0

    self.score = 0
    self.lives = 3

    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    self.timer = self.timer + dt
    if self.timer > 6 then
        local y = math.max(-PIPE_HEIGHT + 10, 
            math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y
        table.insert(self.pipePairs, PipePair(y))
        self.timer = 0
    end

-----------------------------------------------------------------
    self.timer_box = self.timer_box + dt
    if self.timer_box > 2 then
        table.insert(self.boxes, Box())
        self.timer_box = 0
    end
-----------------------------------------------------------------
    for k, bx in pairs(self.boxes) do
        bx:update(dt)
    end
-----------------------------------------------------------------

-----------------------------------------------------------------
    self.timer_wall = self.timer_wall + dt
    if self.timer_wall > 28 then
        table.insert(self.wall, Wall())
        self.timer_wall = 0
    end
-----------------------------------------------------------------
    for k, w in pairs(self.wall) do
        w:update(dt)
    end
-----------------------------------------------------------------


    for k, pair in pairs(self.pipePairs) do
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:play()
            end
        end

        pair:update(dt)
    end

    -- we need this second loop, rather than deleting in the previous loop, because
    -- modifying the table in-place without explicit keys will result in skipping the
    -- next pipe, since all implicit keys (numerical indices) are automatically shifted
    -- down after a table removal
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- simple collision between bird and all pipes in pairs
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                if self.lives > 1 then
                    table.remove(self.pipePairs, k)
                    sounds['explosion']:play()
                    self.lives = self.lives - 1
                else
                    sounds['explosion']:play()
                    sounds['hurt']:play()
                    gStateMachine:change('score', {
                        score = self.score
                    })
                end
            end
        end
    end


--------------------------------------------------
for k, bx in pairs(self.boxes) do
    if self.bird:collidesB(bx) then
        sounds['dababy']:play()
        self.score = self.score + 10
        table.remove(self.boxes, k)
    end
end
--------------------------------------------------
--------------------------------------------------
for k, w in pairs(self.wall) do
    if self.bird:collidesW(w) then
        sounds['explosion']:play()
        gStateMachine:change('play2', {
            score = self.score + 500, 
            lives = self.lives
        })
    end
end
--------------------------------------------------





        -- update bird based on gravity and input
    self.bird:update(dt)

    -- reset if we get to the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        sounds['explosion']:play()
        sounds['hurt']:play()

        gStateMachine:change('score', {
            score = self.score
        })
    end
end

function PlayState:render()

    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('LEVEL-1' , 8, 8)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 40)
    love.graphics.print('Lives: ' .. tostring(self.lives), 8, 68)

    self.bird:render()

--------------------------------------------------
    for k, bx in pairs(self.boxes) do
        bx:render()
    end
--------------------------------------------------
--------------------------------------------------
    for k, w in pairs(self.wall) do
        w:render()
    end
--------------------------------------------------
end

--[[
    Called when this state is transitioned to from another state.
]]
function PlayState:enter()
    -- if we're coming from death, restart scrolling
    scrolling = true
end

--[[
    Called when this state changes to another state.
]]
function PlayState:exit()
    -- stop scrolling for the death/score screen
    scrolling = false
end