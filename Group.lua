

LFGScanner.Group = {}
local g = LFGScanner.Group
g.__index = g

function g:new(leader, msg)
    local o = {}
    o.leader = leader
    o.message = msg
    o.lastSeen = time()
    return setmetatable(o, self)
end