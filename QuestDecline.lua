addonName, QuestDecline = ...
QD_DEBUG = true
QuestDecline.debug = QD_DEBUG

--[[

this handles plugin events

]]--
local function OnEvent(self, event, addon, ...)
	local inInstance, instanceType = IsInInstance()

	if (event == "PLAYER_ENTERING_WORLD" and inInstance and instanceType == "pvp") then
		print("|cFFFFFF00Entered a battleground. Shared quests will be declined.|r")
		return
	end

	if (event == "QUEST_DETAIL" and instanceType == "pvp") then
		local questID = GetQuestID()

		if (questID == 64845) then
			print("|cFF00FFFFAccepted |cFFFFFF00|Hquest:64845:70|h[Alliance War Effort]|r")
			AcceptQuest()
			return
		else
			DeclineQuest()
			print("|cFF00FFFFDeclined Quest |r|Hquest:" .. questID .. ":70|h(" .. questID .. ")|r")
		end
		return
	end

	if (event == "ADDON_LOADED" and addon == "QuestDecline") then
		QuestDecline:SetDefaults()
		print("addonName:" .. addonName)
		for k, v in pairs(QuestDecline) do
			print(tostring(k) .. ":" .. tostring(v))
		end
	end
end


local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("QUEST_DETAIL")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:SetScript("OnEvent", OnEvent)