-- Main frame
local UI = LFGScanner.UI
local MessageHandler = LFGScanner.MessageHandler

UI.mainFrame = CreateFrame("Frame", "LFGScannerMainFrame", UIParent, "UIPanelDialogTemplate")
local frame = UI.mainFrame

frame:SetSize(600, 440)
frame:EnableMouse(true)
frame:SetMovable(true)
frame:RegisterForDrag("LeftButton")
frame:SetPoint("CENTER")
frame:Hide()
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:RegisterEvent("CHAT_MSG_CHANNEL")
frame:RegisterEvent("ADDON_LOADED")
frame.eventHandlers = {
    ["CHAT_MSG_CHANNEL"] = function(...) MessageHandler:handleMessage(...) end,
    ["ADDON_LOADED"] = function(...)
        local name = ...
        if name == "LFGScanner" then
            LFGScanner.loaded = true
            print("LFGScanner loaded")
            frame:UnregisterEvent("ADDON_LOADED")
        end
    end,
}
frame.titleText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
frame.titleText:SetPoint("TOP", 0, -12)
frame.titleText:SetTextColor(1, 0.5, 0.25, 1)
frame.titleText:SetHeight(4)
frame.titleText:SetText("LFGScanner")
frame.filterInput = CreateFrame("EditBox", "LFGScannerFilterInput", frame, "InputBoxTemplate")
local filterInput = frame.filterInput
filterInput:SetAutoFocus(false)
filterInput:SetSize(300, 18)
filterInput:SetPoint("TOPLEFT", 65, -35)
filterInput:SetScript("OnTextChanged", function()
    if LFGScanner.loaded then frame.scrollFrame:update() end
end)
filterInput:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
filterInput.label = filterInput:CreateFontString(nil, "BORDER", "GameFontNormal")
filterInput.label:SetJustifyH("RIGHT")
filterInput.label:SetPoint("TOPRIGHT", filterInput, "TOPLEFT", -8, -3)
filterInput.label:SetText("Filter: ")
filterInput.clearBtn = CreateFrame("Button", "LFGScannerFilterInputClearButton", frame, "UIPanelButtonTemplate")
filterInput.clearBtn:SetSize(50, 22)
filterInput.clearBtn:SetText("Clear")
filterInput.clearBtn:SetPoint("TOPLEFT", filterInput, "TOPRIGHT", 3, 2)
filterInput.clearBtn:SetScript("OnClick", function() filterInput:SetText("") end)


function frame:toggle()
    if self:IsShown() then self:Hide() else self:Show(); self.scrollFrame:update() end
end

SLASH_LFGSCANNER1 = "/lfg"

SlashCmdList["LFGSCANNER"] = function(msg) frame:toggle() end

frame:SetScript("OnEvent", function(self, event, ...) self.eventHandlers[event](...) end)