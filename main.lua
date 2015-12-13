math.randomseed(os.time())
math.random()

require 'lib/game'
require 'lib/tutorial'
require 'lib/endgame'

--TODO: nice transitions or something
local function advanceToGame()
    state = 'ingame'
    love.graphics.setColor(255, 255, 255, 255)
    game:start()
end

local function advanceToEndgame(endType)
    state = 'endgame'
    love.graphics.setColor(255, 255, 255, 255)
    endgame:start()
end

local function init()
    --deliberately globals
    state = 'tutorial'
    tutorial = Tutorial:new(advanceToGame)
    tutorial:start()
    game = Game:new(advanceToEndgame)
    endgame = Endgame:new(init)
end

function love.load()
    init()
end

function love.update(dt)
    if state == 'ingame' then
        game:update(dt)
    elseif state == 'tutorial' then
        tutorial:update(dt)
    elseif state == 'endgame' then
        endgame:update(dt)
    end
end

function love.keypressed(key)
    if state == 'ingame' then
        game:keyPress(key)
    elseif state == 'tutorial' then
        --tutorial:keyPress(key)
    elseif state == 'endgame' then
        --endgame:keyPress(key)
    end
end

function love.keyreleased(key)
    if state == "ingame" then
        game:handleKey(key)
    elseif state == 'tutorial' then
        tutorial:handleKey(key)
    elseif state == 'endgame' then
        endgame:handleKey(key)
    end
end

function love.draw()
    if state == 'ingame' then
        game:draw()
    elseif state == "tutorial" then
        tutorial:draw()
    elseif state == "endgame" then
        endgame:draw()
    end
end
