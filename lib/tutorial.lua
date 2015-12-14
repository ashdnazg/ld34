local class = require "3rdparty/middleclass"

local tween = require '3rdparty/tween'
Tutorial = class('Tutorial')

function Tutorial:initialize(advanceGameState)
    self.advanceGameState = advanceGameState
end

function Tutorial:start()
    self.phase = 1

    self.phases = {
        {
            autoadvance = true,
            sound = { vol = 0.5 },
            color = { alpha = 255 },
        },
        {
            autoadvance = false,
            sound = { vol = 1 },
            color = { alpha = 0 },
        },
        {
            autoadvance = true,
            sound = { vol = 1 },
            color = { alpha = 0 },
        },
        {
            autoadvance = true,
            sound = { vol = 0 },
            color = { alpha = 255 },
        },
        {
            autoadvance = true,
            sound = { vol = 0 },
            color = { alpha = 0 },
        },

    }

    self.phases[1].colorTween =
        tween.new(1, self.phases[1].color, self.phases[2].color, 'linear')

    self.phases[1].soundTween =
        tween.new(1, self.phases[1].sound, self.phases[2].sound, 'linear')

    self.phases[2].colorTween =
        tween.new(1, self.phases[2].color, self.phases[3].color, 'linear')

    self.phases[2].soundTween =
        tween.new(1, self.phases[2].sound, self.phases[3].sound, 'linear')

    self.phases[3].colorTween =
        tween.new(1, self.phases[3].color, self.phases[4].color, 'linear')

    self.phases[3].soundTween =
        tween.new(0.1, self.phases[3].sound, self.phases[4].sound, 'linear')

    self.phases[4].colorTween =
        tween.new(1, self.phases[4].color, self.phases[5].color, 'linear')


    self.source = love.audio.newSource("assets/audio/tutorial.ogg")
    self.source:setVolume(1)
    self.source:play()
    self.timer = 0
    self.voiceLength = 78.5
end

function Tutorial:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()


    love.graphics.setColor(255, 255, 255, 255)
    local phase = self.phases[self.phase]
    love.graphics.draw(game.background)

    love.graphics.setColor(200, 0, 0, 255)
    love.graphics.print("1) Important: Make sure your audio is on.", 20, 48)
    love.graphics.print("2) Imperialist lies? Hit the button!", 20, 64)
    love.graphics.print("3) Truth? Don't Hit the button!", 20, 80)
    love.graphics.print("Press space to skip tutorial", 20, 112)
    love.graphics.setColor(255, 255, 255, 255)

    if phase.color then
        love.graphics.setColor(0, 0, 0, phase.color.alpha)
    end

    love.graphics.rectangle( "fill", 0, 0, w, h )
end

function Tutorial:fadeOut()
    if self.phase < 3 then
        self.phase = 3
    end
end

function Tutorial:update(dt)
    self.timer = self.timer + dt
    local phase = self.phases[self.phase]
    local phaseDone = phase.autoadvance
    if phase.colorTween then
        local tweenDone = phase.colorTween:update(dt)
        phaseDone = phaseDone and phase.colorTween:update(dt)
    end

    if phase.soundTween then
        self.source:setVolume(phase.sound.vol)
        phaseDone = phaseDone and phase.soundTween:update(dt)
    end

    if self.phase == 5 then
        self.source:stop()
        self.advanceGameState()
    end

    if phaseDone and self.phase < #self.phases then
        self.phase = self.phase + 1
    end

    if self.timer > self.voiceLength and self.phase < 3 then
        self.phase = 3
    end
end

function Tutorial:handleKey(key)
    if key == ' ' then
        if not self.concluding then
            self:conclude()
        end
    end
end
function Tutorial:mousePressed(x, y, key)
end

function Tutorial:handleMouse(x, y, key)
end

-- clean stuff up
function Tutorial:conclude()
    self.concluding = true
    self:fadeOut()
end
