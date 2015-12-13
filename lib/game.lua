local class = require "3rdparty/middleclass"
require 'lib/player'

Game = class('Game')

function Game:initialize(advanceGameState)
    self.advanceGameState = advanceGameState
    self.player = Player:new()
    self.background = love.graphics.newImage("assets/img/mainscreen.png")
end

function Game:start()
    self.player:start()
end

function Game:draw()
    love.graphics.draw(self.background)
    self.player:draw()
end

function Game:update(dt)
    self.player:update(dt)
end

function Game:handleKey(key)
    if key == 'right' then
        self.player.radio:advanceDial()
    elseif key == 'left' then
        self.player.radio:retreatDial()
    elseif key == 'c' then
        self.player:censorStation()
    elseif key == 'e' then
        self:conclude()
    end
end

-- cascade
function Game:conclude()
    print("game is ending!")
    self.player:conclude()
    self.advanceGameState()
end
