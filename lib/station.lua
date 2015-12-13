local class = require "3rdparty/middleclass"

local VIOLATION_ACTIVE_PERIOD = 4;
Station = class('Station')

function Station:initialize(def)
    self.name = def.name
    self.violations = def.violations

    self.loops = 0
    self.source = love.audio.newSource(def.filename)
	self.source:setVolume(0)
    self.source:setLooping(true)
    self.position = self.source:tell()
    -- so that checks are staggered through the second
    self.tellCheck = math.random()

    self.censored = false
end

function Station:start()
	self.source:play()
end

function Station:update(dt)
    self.tellCheck = self.tellCheck + dt
    if self.tellCheck >= 1 then
        self.tellCheck = 0
        local position = self.source:tell()
        if position < self.position then
            self.loops = self.loops + 1
        end
        self.position = position
    end
end

--TODO: timer, crossfade, static?
function Station:foreground()
	self.source:setVolume(1)
end

--TODO: timer, crossfade?
function Station:background()
	self.source:setVolume(0)
end

function Station:hasActiveViolation()
    -- this is a dumb algo, but the dataset is small and only happens when
    -- a person pushes a button.
    local position = self.position
    for i, violation in ipairs(self.violations) do
        local rangeStart = violation.range[1]
        local rangeEnd = violation.range[2]
        if position >= rangeStart and position <= (rangeEnd + VIOLATION_ACTIVE_PERIOD) then
            self.censored = true
            return true, violation.reason
        end
    end
    return false, "no violation"
end

function Station:censor(replacementSource)
    self.originalSource = self.source
    self.originalSource:setVolume(0)
    self.source = replacementSource
    return true
end

function Station:uncensor()
    self.source = self.originalSource
end

function Station:conclude()
    self.source:stop()
end
