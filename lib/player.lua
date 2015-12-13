local class = require "3rdparty/middleclass"
require "lib/radio"

Player = class('Player')

function Player:initialize()
    self.radio = Radio:new()
end

function Player:start()
    self.radio:start()
end

local censorOutcomes = {
    govt = "this channel is already spreading THE TRUTH!",
    already_censored = "this channel is already spreading THE TRUTH!",
    no_violation = "this channel is not currently in violation of any rules",
    plumbers = "FILTHY SEWAGE MONGERS!",
    lies = "Such falsehoods will not be tolerated.",
    morale = "Undermining the national morale.",
    top_secret = "Aiding and abetting THE ENEMY.",
    frup_grows_greater = "FRUP GROWS EVER GREATER. Not any other way."
}

function Player:censorStation()
    --TODO: self:notify("blah blah blah")
    local success, message = self.radio:censor()
    print("tried to censor: ", success, message, censorOutcomes[message])
end

function Player:draw()
    self.radio:draw()
end

function Player:update(dt)
    self.radio:update(dt)
end

-- TODO: some way to send messages
function Player:notify()

end

function Player:conclude()
    self.radio:conclude()
end
