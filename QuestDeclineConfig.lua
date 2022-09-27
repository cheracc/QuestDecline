addonName, QuestDecline = ...

local defaults = {
	enabled = true,
	declineAll = false;
	notifyOnDecline = true,
	acceptWarEffort = true,
	notifyOnAccept = true,
}

uiFrame = CreateFrame("Frame")
uiFrame.name = addonName
InterfaceOptions_AddCategory(uiFrame)

-- creates a checkbox with the given arguments
local function CreateCheckbox(name, parent, xPos, yPos, text)
	local cb = CreateFrame("CheckButton", "qd_cb_" .. name, parent, "InterfaceOptionsCheckButtonTemplate")
	cb:SetPoint("TOPLEFT", xPos, yPos)
	getglobal(cb:GetName() .. 'Text'):SetText(text)

	return cb
end

-- sets up the options panel once the addon is loaded
local function OnEvent(_, _, addon)
	if (addon ~= addonName) then
		return
	end
	QuestDecline:SetupOptionsPanel()
end

-- does the layout of the options menu
function QuestDecline:SetupOptionsPanel()
	local panelTitle = uiFrame:CreateFontString("ARTWORK", nil, "OptionsFontLarge")
	panelTitle:SetPoint("TOPLEFT", 10, -10)
	panelTitle:SetText("QuestDecline Options")

	local enabledCb = CreateCheckbox("enabled", uiFrame, 20, -40, "Decline shared quests in battlegrounds")
	enabledCb:SetChecked(QDSettings.enabled)
	enabledCb.tooltip = "Player-shared quests will be automatically declined while you are in a battleground."
	enabledCb:HookScript("OnClick", function()
		if (QuestDecline:toggle("enabled")) then
			QuestDecline:enable("declineAll")
			QuestDecline:enable("notifyOnDecline")
		else
			QuestDecline:disable("declineAll")
			QuestDecline:disable("notifyOnDecline")
		end
	end)

	local declineAllCb = CreateCheckbox("declineAll", uiFrame, 30, -60, "Decline \124cFFFF2222all \124rshared quests")
	declineAllCb:SetChecked(QDSettings.declineAll)
	declineAllCb.tooltip = "Declines all quests shared by players in any group in or outside of an instance/battleground"
	declineAllCb:HookScript("OnClick", function()
		QuestDecline:toggle("declineAll")
	end)

	local notifyDeclineCb = CreateCheckbox("notifyOnDecline", uiFrame, 30, -80, "Show when a quest is declined")
	notifyDeclineCb:SetChecked(QDSettings.notifyOnDecline)
	notifyDeclineCb:HookScript("OnClick", function()
		QuestDecline:toggle("notifyOnDecline")
	end)

	local acceptWarEffortCb = CreateCheckbox("acceptWarEffort", uiFrame, 20, -120, "Accept [Alliance War Effort] quest automatically")
	acceptWarEffortCb:SetChecked(QDSettings.acceptWarEffort)
	acceptWarEffortCb:HookScript("OnClick", function()
		if (QuestDecline:toggle("acceptWarEffort")) then
			QuestDecline:enable("notifyOnAccept")
		else
			QuestDecline:disable("notifyOnAccept")
		end
	end)

	local notifyAcceptCb = CreateCheckbox("notifyOnAccept", uiFrame, 30, -140, "Show when War Effort quest is accepted")
	notifyAcceptCb:SetChecked(QDSettings.notifyOnAccept)
	notifyAcceptCb:HookScript("OnClick", function()
		QuestDecline:toggle("notifyOnAccept")
	end)
end

-- enables an options widget
function QuestDecline:enable(name)
	cb = getglobal("qd_cb_" .. name)

	if (cb == nil) then
		QuestDecline:Debug("enable couldn't find " .. name)
		return
	end

	cb:Enable()
	cb:Show()
end

-- disables an options widget
function QuestDecline:disable(name)
	cb = getglobal("qd_cb_" .. name)

	if (cb == nil) then
		QuestDecline:Debug("disable couldn't find " .. name)
		return
	end

	cb:Disable()
end

-- toggles the value of a savedvariable plugin setting
function QuestDecline:toggle(name)
	if (QDSettings[name] == nil) then
		QuestDecline:Debug("toggle(name) couldn't find a setting named " .. name)
		return
	end

	QDSettings[name] = not QDSettings[name]

	QuestDecline:Debug("current settings:")
	for k, v in pairs(QDSettings) do
		QuestDecline:Debug("  " .. tostring(k) .. ":" .. tostring(v))
	end

	return QDSettings[name]
end
--[[

this sets defaults if the savedvariable doesnt exist

]]--
function QuestDecline:LoadSettings()
	if (QDSettings == nil) then
		QDSettings = {}
	end

	for k, v in pairs(defaults) do
		if (type(v) ~= type(QDSettings[k])) then
			QDSettings[k] = v
		end
	end

	QuestDecline:Debug("settings as loaded:")
	for k, v in pairs(QDSettings) do
		QuestDecline:Debug("    " .. tostring(k) .. ": " .. tostring(v))
	end
end

uiFrame:RegisterEvent("ADDON_LOADED")
uiFrame:SetScript("OnEvent", OnEvent)

