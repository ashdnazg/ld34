local class = require "3rdparty/middleclass"

local tween = require '3rdparty/tween'
Tutorial = class('Tutorial')

function Tutorial:initialize(advanceGameState)
    self.advanceGameState = advanceGameState
end

function Tutorial:start()
    self.phase = 1
    self.phases = {
        {},
        {
            sound = { vol = 0 },
            color = { alpha = 255 },
        }
    }
    local conclude = self.phases[2]
    conclude.colorTween = tween.new(3, conclude.color, { alpha = 0 }, 'linear')
    conclude.soundTween = tween.new(3, conclude.sound, { vol = 1 }, 'linear')
end

function Tutorial:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    if self.phase == 1 then
        love.graphics.print("this is the tutorial, press 'e' to start the game", w / 3, h / 2.5)
    elseif self.phase == 2 then
        local phase = self.phases[self.phase]
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.draw(game.background)
        love.graphics.setColor(0, 0, 0, phase.color.alpha)
        love.graphics.rectangle( "fill", 0, 0, w, h )
    end
end

function Tutorial:fadeOut()
    self.phase = 2
end

function Tutorial:update(dt)
    if self.phase == 2 then
        local phase = self.phases[2]
        if phase.colorTween and phase.colorTween:update(dt) then
            print("advancing game state to game!!")
            self.advanceGameState()
        end
    end
end

function Tutorial:handleKey(key)
    if key == 'e' then
        self:conclude()
    end
end
function Tutorial:mousePressed(x, y, key)
end

function Tutorial:handleMouse(x, y, key)
end

-- clean stuff up
function Tutorial:conclude()
    print("tutorial is ending!")
    self:fadeOut()
end
