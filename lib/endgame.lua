local class = require "3rdparty/middleclass"
Endgame = class('Endgame')

function Endgame:initialize(advanceGameState)
    self.advanceGameState = advanceGameState
end

function Endgame:start()

end

function Endgame:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    love.graphics.print("this is the ENDGAME, press 'e' to restart the game", w / 3, h / 2.5)
end

function Endgame:update(dt)
end

function Endgame:handleKey(key)
    if key == 'e' then
        self.advanceGameState()
    end
end
