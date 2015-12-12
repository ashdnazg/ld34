math.randomseed(os.time())
math.random()

local state = 'ingame'

require 'lib/player'


local player = Player:new()

function love.load()

end

function love.update(dt)
    if state == 'ingame' then
        player:update(dt)
    elseif state == 'tutorial' then

    elseif state == 'endgame' then

    end
end

function love.keypressed(key)
    if key == 'right' then
        player.radio:advanceDial()
    elseif key == 'left' then
        player.radio:retreatDial()
    elseif key == 'c' then
        player:censorStation()
    end
end

function love.draw()
    if state == 'ingame' then
        player:draw()
    end
end
