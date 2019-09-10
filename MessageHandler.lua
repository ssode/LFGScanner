LFGScanner.MessageHandler = {}
local m = LFGScanner.MessageHandler
local GroupManager = LFGScanner.GroupManager
local Player = LFGScanner.Player

LFGScanner.DB.Channels = {
    ["LOOKINGFORGROUP"] = true,
    ["TRADE"] = true,
    ["WORLD"] = true,
}

local channels = LFGScanner.DB.Channels

function m:handleMessage(...)
    local msg, _, _, _, _, _, _, _, chName, _, _, guid = ...
    if channels[chName:upper()] and msg:upper():find("LF") then
        local plr = Player:fromGUID(guid)
        GroupManager:addGroup(plr, msg)
    end
end