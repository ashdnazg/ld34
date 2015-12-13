local class = require "3rdparty/middleclass"
require "lib/radio"

Player = class('Player')

function Player:initialize()
    self.radio = Radio:new()
    self.unrest = 1
end

function Player:start()
    self.radio:start()
end

local censorOutcomes = {
    govt = "This channel is already spreading THE TRUTH!",
    already_censored = "This channel is already spreading THE TRUTH!",
    no_violation = "This channel is not currently in violation of any rules",
    profession = "FILTHY SEWAGE MONGERS!",
    lies = "Such falsehoods will not be tolerated.",
    morale = "Our spirit is as strong as a paperweight.",
    top_secret = "Aiding and abetting THE ENEMY.",
    frup_grows_greater = "FRUP GROWS EVER GREATER. Not any other way."
}

local unrestText = {
    "The public is content. Bob is beloved.",
    "Occasional jokes about Bob in pubs",
    "A rogue paper published Caricatures of Bob",
    "Grandmas reminisce about pre-Bob FRUP",
    "M-Info popularity at a historical low point",
    "Criminals caught calling for Bob's resignation",
    "Graffiti on the Palace: \"Bob is a slob!\"",
    "Daily defecting rate is double the usual",
    "#FRUPlies is trending worldwide on Twitter",
    "Mass demonstrations across the country.",
    "Bob is displeased with you.",
    "Game over"
}

function Player:censorStation()
    --TODO: self:notify("blah blah blah")
    local success, message = self.radio:censor()
    if success then

    else
        -- TODO: per-channel censorship failure messages? like, how dare you
        -- censor a beloved children's radio host
        self.unrest = self.unrest + 1
        if self.unrest == #unrestText then
            game:conclude("failure")
        end
    end

    print("tried  to censor: ", success, message, censorOutcomes[message])
end

-- all player monitors: successful/failed censors
function Player:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    love.graphics.print(unrestText[self.unrest], w / 4.5, h / 1.5)
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
