local class = require "3rdparty/middleclass"
require "lib/radio"

Player = class('Player')

function Player:initialize()
    self.radio = Radio:new()
    self.censored = 0
    self.unrest = 1
    self.failedCensorSound = love.audio.newSource("assets/audio/nope.ogg")
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
        self.censored = self.censored + 1
        self:notify("Good work. " .. censorOutcomes[message])
        -- GOOD JOB PLAYER. highlight the rule that was violated?
        if self.censored == (#self.radio.stations - 1) then
            game:conclude("success")
        end
    else
        -- TISK TISK. BAD PLAYER: play nasty sound, flash a light, whatever.
        -- show the message, bump the unrest meter + associated message
        self:notify('WRONG')
        self.failedCensorSound:play()
        self.unrest = self.unrest + 1
        if self.unrest == #unrestText then
            game:conclude("failure")
        end
    end
end

-- all player monitors: successful/failed censors
function Player:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print("public status: " .. unrestText[self.unrest], 50, 70)
    love.graphics.print("truthified: " .. self.censored .. "/" .. (#self.radio.stations - 1), 50, 100)
    if self.notice then
        love.graphics.print(self.notice, 50, 150)
    end
    love.graphics.setColor(255, 255, 255, 255)
    self.radio:draw()
end

function Player:update(dt)
    if self.notice then
        self.noticeTime = self.noticeTime + dt
        if self.noticeTime > 3 then
            self.notice = nil
            self.noticeTime = 0
        end
    end
    self.radio:update(dt)
end

-- TODO: some way to send messages
function Player:notify(message)
    self.notice = message
    self.noticeTime = 0
end

function Player:conclude()
    self.radio:conclude()
end
