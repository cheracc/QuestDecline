addonName, QuestDecline = ...
local QD_DEBUG = false
QuestDecline.debug = QD_DEBUG

--[[

this handles plugin events

]]--
local function OnEvent(_, event, addon, ...)
	local inInstance, instanceType = IsInInstance()

	if (event == "PLAYER_ENTERING_WORLD" and inInstance and instanceType == "pvp" and QDSettings.enabled) then
		print("|cFFFFFF00Entered a battleground. Shared quests will be declined.|r")
		return
	end

	if (event == "QUEST_DETAIL" and (instanceType == "pvp" or QDSettings.declineAll)) then
		local questID = GetQuestID()

		-- autoaccept war effort quest if enabled
		if (questID == 64845 and QDSettings.acceptWarEffort) then
			if (QDSettings.notifyOnAccept) then
				-- notifies with link to quest
				print("|cFF00FFFFAccepted |cFFFFFF00|Hquest:64845:70|h[Alliance War Effort]|r")
			end
			AcceptQuest()
			return

		elseif (QDSettings.enabled) then
			DeclineQuest()
			if (QDSettings.notifyOnDecline) then
				-- notifies with link to declined quest
				print("|cFF00FFFFDeclined Quest |cFF9999FF|Hquest:" .. questID .. ":70|h[Quest ID:" .. questID .. "]|r")
			end
		end
		return
	end

	if (event == "ADDON_LOADED" and addon == "QuestDecline") then
		-- QuestDeclineConfig.lua
		QuestDecline:LoadSettings()

		QuestDecline:Debug("addonName:" .. addonName)
		for k, v in pairs(QuestDecline) do
			QuestDecline:Debug(tostring(k) .. ":" .. tostring(v))
		end
	end
end

-- used to send debug messages
function QuestDecline:Debug(msg)
	if (QD_DEBUG) then
		print("|cFF00FFFFQuestDecline|Debug: |r" .. msg)
	end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("QUEST_DETAIL")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:SetScript("OnEvent", OnEvent)