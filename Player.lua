

LFGScanner.Player = {}
local p = LFGScanner.Player
p.__index = p

function p:new(name, race, class)
    local o = {}
    o.name = name
    o.race = race
    o.class = class
    return setmetatable(o, self)
end

function p:fromGUID(guid)
    local class, _, race, _, _, name = GetPlayerInfoByGUID(guid)
    return self:new(name, race, class)
end