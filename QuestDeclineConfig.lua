addonName, QuestDecline = ...
QD_DEBUG = QuestDecline.debug

QuestDecline.defaults = {
	enabled = true,
	declineAll = false;
	notifyOnDecline = true,
	acceptWarEffort = true,
	notifyOnAccept = true,
}


uiFrame = CreateFrame("Frame")
uiFrame.name = addonName
InterfaceOptions_AddCategory(uiFrame)

local function CreateCheckbox(name, parent, xPos, yPos, text)
	local cb = CreateFrame("CheckButton", "qd_cb_" .. name, parent, "InterfaceOptionsCheckButtonTemplate")
	cb:SetPoint("TOPLEFT", xPos, yPos)
	getglobal(cb:GetName() .. 'Text'):SetText(text)

	return cb
end

local function OnEvent(self, event, addon)
	if (addon ~= addonName) then
		return
	end

	local panelTitle = uiFrame:CreateFontString("ARTWORK", nil, "OptionsFontLarge")
	panelTitle:SetPoint("TOPLEFT", 10, -10)
	panelTitle:SetText("QuestDecline Options")

	local enabledCb = CreateCheckbox("enabled", uiFrame, 20, -30, "Decline shared quests in battlegrounds")
	enabledCb:SetChecked(QDSettings.enabled)
	enabledCb:HookScript("OnClick", function() 
		if (QuestDecline:toggle("enabled")) then
			QuestDecline:enable("declineAll")
		else
			QuestDecline:disable("declineAll")
		end
	end)

	local declineAllCb = CreateCheckbox("declineAll", uiFrame, 30, -50, "Decline \124cFFFF2222all \124rshared quests")
	declineAllCb:SetChecked(QDSettings.declineAll)
	declineAllCb:HookScript("OnClick", function() 
		QuestDecline:toggle("declineAll")
	end)

	local notifyDeclineCb = CreateCheckbox("notifyOnDecline", uiFrame, 30, -70, "Show when a quest is declined")
	notifyDeclineCb:SetChecked(QDSettings.notifyOnDecline)
	notifyDeclineCb:HookScript("OnClick", function() 
		QuestDecline:toggle("notifyOnDecline")
	end)

	local acceptWarEffortCb = CreateCheckbox("acceptWarEffort", uiFrame, 20, -90, "Accept [Alliance War Effort] quest automatically")
	acceptWarEffortCb:SetChecked(QDSettings.acceptWarEffort)
	acceptWarEffortCb:HookScript("OnClick", function() 
		if (QuestDecline:toggle("acceptWarEffort")) then
			QuestDecline:enable("notifyOnAccept")
		else
			QuestDecline:disable("notifyOnAccept")
		end
	end)

	local notifyAcceptCb = CreateCheckbox("notifyOnAccept", uiFrame, 30, -110, "Show when War Effort quest is accepted")
	notifyAcceptCb:SetChecked(QDSettings.notifyOnAccept)
	notifyAcceptCb:HookScript("OnClick", function() 
		QuestDecline:toggle("notifyOnAccept")
	end)
end

function QuestDecline:enable(name)
	cb = getglobal("qd_cb_" .. name)

	if (cb == nil) then
		print("enable couldn't find " .. name)
		return
	end

	cb:Enable()
	cb:Show()
end

function QuestDecline:disable(name)
		cb = getglobal("qd_cb_" .. name)

	if (cb == nil) then
		print("enable couldn't find " .. name)
		return
	end

	cb:Disable()
	cb:SetChecked(false)
	--cb:Hide()
end

function QuestDecline:toggle(name)
	if (QDSettings[name] == nil) then
		print("toggle(name) couldn't find a setting by that name")
		return
	end

	QDSettings[name] = not QDSettings[name]
	if (QD_DEBUG) then
		print("current settings:")
		for k, v in pairs(QDSettings) do
			print("  " .. tostring(k) .. ":" .. tostring(v))
		end
	end

	return QDSettings[name]
end
--[[

this sets defaults if the savedvariable doesnt exist

]]--
function QuestDecline:SetDefaults()
	if (QDSettings == nil) then
		QDSettings = {}
	end

	for k, v in pairs(QuestDecline.defaults) do
		if (type(v) ~= type(QDSettings[k])) then
			QDSettings[k] = v
		end
	end

	if (QD_DEBUG) then
		print("settings as loaded:")
		for k, v in pairs(QDSettings) do
			print("    " .. tostring(k) .. ":" .. tostring(v))
		end
	end
end

uiFrame:RegisterEvent("ADDON_LOADED")
uiFrame:SetScript("OnEvent", OnEvent)

