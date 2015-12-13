local class = require "3rdparty/middleclass"

local tween = require '3rdparty/tween'
Endgame = class('Endgame')

function Endgame:initialize(advanceGameState)
    self.advanceGameState = advanceGameState

    self.phase = 1
    self.phases = {
        {
            sound = { vol = 1 },
            color = { alpha = 0 },
        }
    }
    local first = self.phases[1]
    first.colorTween = tween.new(5, first.color, { alpha = 255 }, 'linear')
    first.soundTween = tween.new(5, first.sound, { vol = 0 }, 'linear')
end

function Endgame:start()

end

function Endgame:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    if self.phase == 1 then
        local phase = self.phases[self.phase]
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.draw(game.background)
        love.graphics.setColor(0, 0, 0, phase.color.alpha)
        love.graphics.rectangle( "fill", 0, 0, w, h )
    else
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.print("this is the ENDGAME, press 'e' to restart the game", w / 3, h / 2.5)
    end
end

function Endgame:update(dt)
    if self.phase == 1 then
        local phase = self.phases[1]
        local colorComplete = phase.colorTween:update(dt)
        local soundComplete = phase.soundTween:update(dt)
        local currentStation = game.player.radio:currentStation()

        currentStation.source:setVolume(phase.sound.vol)

        if colorComplete and soundComplete then
            self.phase = self.phase + 1
        end
    elseif self.phase == 2 then
        -- TODO: show endgame statistics/score. how long did it take to clear,
        -- public unrest level, exploration?
        -- extract from game/player/radio singletons
    end
end

function Endgame:handleKey(key)
    if key == 'e' then
        self:advanceGameState()
    end
end
