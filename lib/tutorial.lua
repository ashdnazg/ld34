local class = require "3rdparty/middleclass"
Tutorial = class('Tutorial')

function Tutorial:initialize(advanceGameState)
    self.advanceGameState = advanceGameState
end

function Tutorial:start()

end

function Tutorial:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    love.graphics.print("this is the tutorial, press 'e' to start the game", w / 3, h / 2.5)
end

function Tutorial:update(dt)
end

function Tutorial:handleKey(key)
    if key == 'e' then
        self:conclude()
    end
end

-- clean stuff up
function Tutorial:conclude()
    print("tutorial is ending!")
    self.advanceGameState()
end
