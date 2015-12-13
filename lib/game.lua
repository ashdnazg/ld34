local class = require "3rdparty/middleclass"
require 'lib/player'

Game = class('Game')

function Game:initialize(advanceGameState)
    self.buttonStates = {
        next = {
            pressedImg = love.graphics.newImage("assets/img/next_pressed.png"),
            state = 0,
        },

        prev = {
            pressedImg = love.graphics.newImage("assets/img/prev_pressed.png"),
            state = 0,
        },
        censor = {
            pressedImg = love.graphics.newImage("assets/img/censor_pressed.png"),
            state = 0,
        }
    }

    self.advanceGameState = advanceGameState
    self.player = Player:new()
    self.background = love.graphics.newImage("assets/img/mainscreen.png")
end

function Game:start()
    self.player:start()
end

function Game:draw()
    love.graphics.draw(self.background)
    for name, button in pairs(self.buttonStates) do
        if button.state == 1 then
            love.graphics.draw(button.pressedImg)
        end
    end
    self.player:draw()
end

function Game:update(dt)
    self.player:update(dt)
end

function Game:keyPress(key)
    if key == 'right' then
        self.buttonStates['next'].state = 1
    elseif key == 'left' then
        self.buttonStates['prev'].state = 1
    elseif key == 'c' then
        self.buttonStates['censor'].state = 1
    elseif key == 'e' then
        self:conclude()
    end

end

function Game:handleKey(key)
    if key == 'right' then
        self.player.radio:advanceDial()
        self.buttonStates['next'].state = 0
    elseif key == 'left' then
        self.player.radio:retreatDial()
        self.buttonStates['prev'].state = 0
    elseif key == 'c' then
        self.player:censorStation()
        self.buttonStates['censor'].state = 0
    elseif key == 'e' then
        self:conclude()
    end
end

-- cascade
function Game:conclude(reason)
    print("game is ending!", reason)
    self.player:conclude()
    self.advanceGameState()
end
