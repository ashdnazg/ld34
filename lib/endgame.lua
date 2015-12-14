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
    first.colorTween = tween.new(1, first.color, { alpha = 255 }, 'linear')
    first.soundTween = tween.new(1, first.sound, { vol = 0 }, 'linear')
end

function Endgame:start(endType)
    self.endType = endType
end

local function printStats(endType)
    local radio = game.player.radio
    local player = game.player
    local badCensors = player.unrest - 1 -- index, starts at one
    local totalChannels = #radio.stations - 1 -- govt doesn't count
    local censoredChannels = 0
    local govt = radio:govtStation()
    local completion = {}
    local totalStations = 0
    for i, station in ipairs(radio.stations) do
        -- we want to preserve order
        table.insert(completion, { station.name, station:completion() })

        if station ~= govt then
            if station.censored then
                censoredChannels = censoredChannels + 1
            end
        end
    end

    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    local r = h / 5
    local fontSize = 16
    local headerSize = 2 * fontSize
    local lineSize = fontSize + 2
    local font = love.graphics.newFont(fontSize)
    local header = love.graphics.newFont(headerSize)
    love.graphics.setFont(header)
    love.graphics.print("<enter> to play again!", w / 5, h - (lineSize * 4))

    if censoredChannels == totalChannels then
        love.graphics.setColor(0, 200, 0, 255)
        love.graphics.print("Well Done!", w / 3, lineSize)
        love.graphics.setFont(font)
        love.graphics.print("The Ministry's station has grown to broadcast over the entire spectrum!", lineSize, r)
        r = r + lineSize * 2
    else
        love.graphics.setColor(200, 0, 0, 255)
        love.graphics.print("Game Over", w / 3, lineSize)
        love.graphics.setFont(font)
        love.graphics.print("An angry mob stormed the Ministry and broke your bones and the machine.", lineSize, r)
        r = r + lineSize * 2
    end
    love.graphics.print("You saved FRUP from " .. censoredChannels .. " out of " .. totalChannels .. " subversive radio stations", lineSize, r)
    r = r + lineSize
    love.graphics.print("In the process, you incorrectly censored " .. badCensors .. " times", lineSize, r)
    r = r + lineSize * 2
    love.graphics.print("You listened to: ", lineSize, r)
    r = r + lineSize

    for _, completion in pairs(completion) do
        love.graphics.print(completion[2] .. "% of " .. completion[1],
        w / 4,
        r)
        r = r + lineSize
    end


    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(love.graphics.newFont(12))
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
        printStats(self.endType)
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
    if key == 'return' then
        self:advanceGameState()
    end
end

function Endgame:mousePressed(x, y, key)
end

function Endgame:handleMouse(x, y, key)
end
