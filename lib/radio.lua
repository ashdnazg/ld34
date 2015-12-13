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
        name = "FRUP4KIDS FM",
        filename = 'assets/audio/children.ogg',
        violations = {
            { range =  { 142, 500 }, reason = "lies" }
        },
    },
    {
        name = "E.T. FM",
        filename = 'assets/audio/aliens.ogg',
        violations = {
            { range = { 90, 95 } , reason = "lies"  },
            { range = { 180, 500 }, reason = "morale" }
        }
    },
    {
        name = 'Voice of Liberty FM',
        filename = 'assets/audio/opposition.ogg',
        violations = {
            { range = { 1, 60 }, reason = "lies" },
            -- TODO: classify more
            { range = { 60, 500 }, reason = "morale" }
        }
    },
    {
        name = 'CAT RADIO',
        filename = 'assets/audio/cats.ogg',
        violations = {
            { range = { 115, 119 }, reason = "frup_grows_greater" }
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
    love.graphics.print("press 'e' to end the game", w / 1.5, h / 2)
    if current.censored then
        love.graphics.print('[CENSORED]', w / 3, h / 2.5)
    else
        love.graphics.print(current.name, w / 3, h / 2.5)
        love.graphics.print(current.loops, w / 5, h / 2.5)
        love.graphics.print(current.position, w / 1.5, h / 2.5)
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

function Radio:conclude()
    local current = self:currentStation()
    for _, station in ipairs(self.stations) do
        -- the current station gets a fade-out from the endgame object
        if station ~= current then
            station:conclude()
        end
    end
end
