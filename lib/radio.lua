local class = require "3rdparty/middleclass"

require "lib/station"
Radio = class('Radio')

--TODO: if we want static, or static/channel crossover, mix the audio and put
--the def in the correct position (on either side of the real track)
--this becomes problematic with censoring, though...
local stations = {
    {
        name = 'FRUP FM',
        filename = 'assets/audio/govt.ogg',
        violations = {}
    },
    {
        name = 'Voice of Liberty FM',
        filename = 'assets/audio/opposition.ogg',
        violations = {
            { range = { 1, 500 }, reason = "criticism" }
        }
    }
}

function Radio:initialize()
    self.loopCount = 0
    self.stations = {}
    for i, stationDef in ipairs(stations) do
        local station = Station:new(stationDef)
        table.insert(self.stations, station)
    end
    self.censoredStations = {}
    self.currentStationIndex = 1
end

function Radio:update(dt)
    for _, station in ipairs(self.stations) do
        station:update(dt)
    end
end

function Radio:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    local current = self:currentStation()
    if current.censored then
        love.graphics.print('[CENSORED]', w / 3, h / 3)
    else
        love.graphics.print(current.name, w / 3, h / 3)
        love.graphics.print(current.loops, w / 5, h / 5)
        love.graphics.print(current.position, w / 6, h / 6)
    end
end

function Radio:govtStation()
    return self.stations[1]
end

function Radio:currentStation()
    return self.stations[self.currentStationIndex]
end

function Radio:start()
    self:currentStation():foreground()
    print("setting", self:currentStation().name, " to foreground")
    for i, station in ipairs(self.stations) do
        station:start()
    end
end

function Radio:_setActiveStation(newStationIndex) 
	if (newStationIndex > #self.stations) then
		newStationIndex = 1
	end

	if (newStationIndex <= 0) then
		newStationIndex = #self.stations
	end

	local curr = self.stations[self.currentStationIndex]
	local new = self.stations[newStationIndex]
	self.currentStationIndex = newStationIndex

	curr:background()
	new:foreground()
end

function Radio:advanceDial()
    print('advancing dial')
	local nextIndex = self.currentStationIndex + 1
	self:_setActiveStation(self.currentStationIndex + 1)
end

function Radio:retreatDial()
    print('retreating dial')
	local prevIndex = self.currentStationIndex - 1
	self:_setActiveStation(self.currentStationIndex - 1)
end

function Radio:censor()
    local current = self:currentStation()
    local govt = self:govtStation()
    -- TODO: visual feedback on 'you can't censor the govt station'
    if current == govt then 
        return false, "govt"
    end
    if current.censored then
        return false, "already_censored"
    end

    local hasViolation, message = current:hasActiveViolation()
    if hasViolation then
        current:censor(govt.source)
        govt:foreground()
        return hasViolation, message
    else
        return false, "no_violation"
    end
end
