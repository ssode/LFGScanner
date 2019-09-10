LFGScanner.GroupManager = {}
local g = LFGScanner.GroupManager
local Group = LFGScanner.Group

-- Gobal table of groups indexed by leader name
g.groupTable = {}

-- Attempts to add a new group to the table, if it
-- is already found, it updates the lastSeen time
function g:addGroup(leader, msg)
    if self.groupTable[leader.name] then
        self.groupTable[leader.name].lastSeen = time()
    else
        self.groupTable[leader.name] = Group:new(leader, msg)
        if LFGScanner.loaded then
            if LFGScanner.UI.mainFrame:IsShown() then
                LFGScanner.UI.mainFrame.scrollFrame:update()
            end
        end
    end
end

-- Returns groups in array format, applying an optional filter
-- each time this is called, all groups older than 3 minutes are deleted
function g:getListData(filter)
    local data = {}
    local curTime = time()
    for k, v in pairs(self.groupTable) do
        if curTime - v.lastSeen > 180 then
            self.groupTable[k] = nil
        else
            if not filter or v.message:upper():find(filter) then
                tinsert(data, v)
            end
        end
    end
    sort(data, function(a, b) return a.lastSeen > b.lastSeen end)
    return data
end
