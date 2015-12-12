math.randomseed(os.time())
math.random()


require 'lib/player'


function love.load()
    background = love.graphics.newImage("assets/img/mainscreen.png")
    state = 'ingame'
    player = Player:new()
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
        love.graphics.draw(background)
        player:draw()
    end
end
