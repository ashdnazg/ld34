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

local function clickedRadioRight(x, y)
    local leftX = 430
    local rightX = 490
    local bottomY = 400
    local topY = 365

    if (x >= leftX and x <= rightX) and (y <= bottomY and y >= topY) then
        return true
    end

    return false
end

local function clickedRadioLeft(x, y)
    local leftX = 300
    local rightX = 360
    local bottomY = 400
    local topY = 360

    if (x >= leftX and x <= rightX) and (y <= bottomY and y >= topY) then
        return true
    end

    return false
end

local function dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

local function clickedCensor(x, y)
    local cx, cy = 128, 352
    local radius = 50
    local dist = dist(cx, cy, x, y)
    if dist <= radius then
        return true
    end

    return false
end

function Game:mousePressed(x, y, button)
    if button == 'l' then
        if clickedRadioRight(x, y) then
            self.buttonStates['next'].state = 1
        elseif clickedRadioLeft(x, y) then
            self.buttonStates['prev'].state = 1
        elseif clickedCensor(x, y) then
            self.buttonStates['censor'].state = 1
        end
    end
end

function Game:handleMouse(x, y, button)
    if button == 'l' then
        if clickedRadioRight(x, y) then
            self.player.radio:advanceDial()
            self.buttonStates['next'].state = 0
        elseif clickedRadioLeft(x, y) then
            self.player.radio:retreatDial()
            self.buttonStates['prev'].state = 0
        elseif clickedCensor(x, y) then
            self.player:censorStation()
            self.buttonStates['censor'].state = 0
        else
            -- lazy: click only counts if it ends on the button as well
            self.buttonStates['censor'].state = 0
            self.buttonStates['prev'].state = 0
            self.buttonStates['next'].state = 0
        end
    end
end

function Game:conclude(reason)
    print("game is ending!", reason)
    self.player:conclude()
    self.advanceGameState(reason)
end
