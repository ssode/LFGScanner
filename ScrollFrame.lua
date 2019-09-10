-- Scroll frame

local UI = LFGScanner.UI

local num_lines = 20
local line_height = 18
local max_chars_per_msg = 75


local _classColors = {
    ["Druid"] = "ff7d0a",
    ["Hunter"] = "abd473",
    ["Mage"] = "40c7eb",
    ["Paladin"] = "f58cba",
    ["Priest"] = "ffffff",
    ["Rogue"] = "fff569",
    ["Shaman"] = "0070de",
    ["Warlock"] = "8787ed",
    ["Warrior"] = "c79c6e",
}
local classColors = setmetatable({}, {__index = function(_, k)
    return "|cff" .. _classColors[k]
end})

local _timeColors = {
    "3eff00", "65ff00", "8aff00", "b0ff00", "d7ff00", "fdff00", "fffa00",
    "ffff00", "ffe600", "ffdc00", "ffd200", "ffc800", "ffbe00", "ffb400",
    "ffaa00", "ff9600", "ff8c00", "ff8200", "ff7800", "ff6e00", "ff6400",
    "ff5a00", "ff5000", "ff4600", "ff3c00", "ff3200", "ff2800", "ff1e00",
    "ff1400", "ff0a00"
}
local timeColors = setmetatable({}, {__index = function(_, k)
    return "|cff" .. _timeColors[floor(k/10 + 1)]
end})


UI.mainFrame.scrollFrame = CreateFrame("ScrollFrame", "LFGScannerScrollFrame", UI.mainFrame, "FauxScrollFrameTemplate")
local frame = UI.mainFrame.scrollFrame
frame:SetSize(545, 370)
frame:SetPoint("CENTER", -8, -20)
frame.lines = {}
for i = 1, num_lines do
    frame.lines[i] = CreateFrame("Button", "LFGScannerScrollFrameButton"..i, UI.mainFrame)
    local line = frame.lines[i]
    line:SetSize(frame:GetWidth(), line_height)
    line:SetNormalFontObject("GameFontHighlightLeft")
    line.highlightTexture = line:CreateTexture(nil, "HIGHLIGHT")
    line.highlightTexture:SetAllPoints(line)
    line.highlightTexture:SetColorTexture(1, 1, 0, 0.5)
    line:SetHighlightTexture(line.highlightTexture)
    line:SetPoint("TOPLEFT", frame, 0, -(i-1) * line_height - 5)
    line:SetScript("OnClick", function(self)
        if self.plrName then
            local e = ChatFrame1EditBox
            e:SetAttribute("chatType", "WHISPER")
            e:SetAttribute("tellTarget", self.plrName)
            ChatFrame_OpenChat("", ChatFrame1)
        end
    end)
end

-- Updates the scrollFrame data according to the scroll position
function frame:update()
    local filter = UI.mainFrame.filterInput:GetText():upper()
    --if filter:len() < 1 then filter = nil end
    local data = LFGScanner.GroupManager:getListData(filter) or {}
    FauxScrollFrame_Update(self, #data, num_lines, line_height)
    for i = 1, num_lines do
        local offset = FauxScrollFrame_GetOffset(self) + i
        local line = self.lines[i]
        if offset <= #data then
            local group = data[offset]
            line.plrName = group.leader.name
            local text = classColors[group.leader.class] .. group.leader.name .. ":|r " .. group.message
            if text:len() > max_chars_per_msg then
                text = text:sub(1, 72) .. "..."
            end
            local elapsedTime = time() - group.lastSeen
            text = text .. timeColors[elapsedTime] .. " (" .. elapsedTime .. "s ago)|r"
            line:SetText(text)
            line:Show()
        else
            line.plrName = nil
            line:Hide()
        end
    end
end

frame:SetScript("OnVerticalScroll", function(self, offset)
    FauxScrollFrame_OnVerticalScroll(self, offset, line_height, self.update)
end)

frame:SetScript("OnShow", function(self)
    self:update()
end)

