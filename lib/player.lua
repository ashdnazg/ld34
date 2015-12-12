local class = require "3rdparty/middleclass"
require "lib/radio"

Player = class('Player')

function Player:initialize()
    self.radio = Radio:new()
    self.radio:start()
end

local censorOutcomes = {
    govt = "this channel is already spreading THE TRUTH!",
    already_censored = "this channel is already spreading THE TRUTH!",
    no_violation = "this channel is not currently in violation of any rules",
    plumbers = "FILTHY SEWAGE MONGERS!",
    criticism = "We'll have none of that.",
    top_secret = "Aiding and abetting THE ENEMY",
    frup_grows_greater = "FRUP GROWS EVER GREATER. Not any other way."
}

function Player:censorStation()
    --TODO: handle messages and do stuff
    local success, message = self.radio:censor()
    print("tried to censor: ", success, message, censorOutcomes[message])
end

function Player:draw()
    self.radio:draw()
end

function Player:update(dt)
    self.radio:update(dt)
end
