-- **********************************************************************
-- GnomTEC Babel
-- Version: 11.2.7
-- Author: Peter Jack
-- URL: http://www.gnomtec.de/
-- **********************************************************************
-- Copyright © 2011-2023 by Peter Jack
--
-- Licensed under the EUPL, Version 1.1 only (the "Licence");
-- You may not use this work except in compliance with the Licence.
-- You may obtain a copy of the Licence at:
--
-- http://ec.europa.eu/idabc/eupl5
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the Licence is distributed on an "AS IS" basis,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the Licence for the specific language governing permissions and
-- limitations under the Licence.
-- **********************************************************************
-- load localization first.
local L = LibStub("AceLocale-3.0"):GetLocale("GnomTEC_Babel")

-- ----------------------------------------------------------------------
-- Legacy global variables and constants (will be deleted in future)
-- ----------------------------------------------------------------------

GnomTEC_Babel_Options = {
	["Enabled"] = true,
	["LanguageID"] = select(2, GetLanguageByIndex(1)),
	["LanguageSelectorEnabled"] = true,
	["AdditionalLanguages"] ={},
}

-- ----------------------------------------------------------------------
-- Addon global Constants (local)
-- ----------------------------------------------------------------------

-- internal used version number since WoW only updates from TOC on game start
local addonVersion = "10.2.0.31"

-- addonInfo for addon registration to GnomTEC API
local addonInfo = {
	["Name"] = "GnomTEC Babel",
	["Version"] = addonVersion,
	["Date"] = "2023-11-19",
	["Author"] = "Peter Jack",
	["Email"] = "info@gnomtec.de",
	["Website"] = "http://www.gnomtec.de/",
	["Copyright"] = "(c)2011-2023 by Peter Jack",
}

-- GnomTEC API revision
local GNOMTEC_REVISION = 0

-- Log levels
local LOG_FATAL 	= 0
local LOG_ERROR	= 1
local LOG_WARN		= 2
local LOG_INFO 	= 3
local LOG_DEBUG 	= 4

-- Horde
local LANGUAGE_ORCISH					= 1
local LANGUAGE_TAURAHE 					= 3
local LANGUAGE_THALASSIAN				= 10
local LANGUAGE_ZANDALI					= 14
local LANGUAGE_FORSAKEN					= 33
local LANGUAGE_GOBLIN					= 40
local LANGUAGE_PANDAREN_HORDE			= 44
-- Alliance
local LANGUAGE_DARNASSIAN				= 2
local LANGUAGE_DWARVISH					= 6
local LANGUAGE_COMMON					= 7
local LANGUAGE_GNOMISH					= 13
local LANGUAGE_DRAENEI					= 35
local LANGUAGE_PANDAREN_ALLIANCE		= 43
-- Other
local LANGUAGE_Demonic					= 8

local MaxUserDefinedLanguages = 5

-- ----------------------------------------------------------------------
-- Addon global variables (local)
-- ----------------------------------------------------------------------

-- Main options menue with general addon information
local optionsMain = {
	name = "GnomTEC Babel",
	type = "group",
	args = {
		descriptionTitle = {
			order = 1,
			type = "description",
			name = L["L_OPTIONS_TITLE"],
		},
		babelOptionEnable = {
			type = "toggle",
			name = L["L_OPTIONS_ENABLE"],
			desc = "",
			set = function(info,val) GnomTEC_Babel_Options["Enabled"] = val;  end,
			get = function(info) return GnomTEC_Babel_Options["Enabled"] end,
			width = 'full',
			order = 2
		},
		babelOptionLanguageSelectorEnable = {
			type = "toggle",
			name = L["L_OPTIONS_BUTTON"],
			desc = "",
			set = function(info,val) GnomTEC_Babel_Options["LanguageSelectorEnabled"] = val; if (GnomTEC_Babel_Options["LanguageSelectorEnabled"]) then GNOMTEC_BABEL_FRAME:Show(); else GNOMTEC_BABEL_FRAME:Hide(); end;  end,
			get = function(info) return GnomTEC_Babel_Options["LanguageSelectorEnabled"] end,
			width = 'full',
			order = 3
		},
		descriptionAbout = {
			name = "About",
			type = "group",
			guiInline = true,
			order = 2,
			args = {
				descriptionVersion = {
				order = 1,
				type = "description",			
				name = "|cffffd700".."Version"..": ".._G["GREEN_FONT_COLOR_CODE"]..addonInfo["Version"],
				},
				descriptionAuthor = {
					order = 2,
					type = "description",
					name = "|cffffd700".."Author"..": ".."|cffff8c00"..addonInfo["Author"],
				},
				descriptionEmail = {
					order = 3,
					type = "description",
					name = "|cffffd700".."Email"..": ".._G["HIGHLIGHT_FONT_COLOR_CODE"]..addonInfo["Email"],
				},
				descriptionWebsite = {
					order = 4,
					type = "description",
					name = "|cffffd700".."Website"..": ".._G["HIGHLIGHT_FONT_COLOR_CODE"]..addonInfo["Website"],
				},
				descriptionLicense = {
					order = 5,
					type = "description",
					name = "|cffffd700".."Copyright"..": ".._G["HIGHLIGHT_FONT_COLOR_CODE"]..addonInfo["Copyright"],
				},
			}
		},
		descriptionLogo = {
			order = 5,
			type = "description",
			name = "",
			image = "Interface\\AddOns\\GnomTEC_Babel\\Textures\\GnomTEC-Logo",
			imageCoords = {0.0,1.0,0.0,1.0},
			imageWidth = 512,
			imageHeight = 128,
		},
	}
}

local optionsLanguages = {
	name = L["L_OPTIONS_LANGUAGES"],
	type = 'group',
	args = {
		language1 = {
			type = "input",
			name = L["L_OPTIONS_LANGUAGES_1"],
			desc = "",
			disabled = function(info) return not GnomTEC_Babel_Options["Enabled"] end,
			set = function(info,val) GnomTEC_Babel_Options["AdditionalLanguages"][1] = val end,
	   	get = function(info) return GnomTEC_Babel_Options["AdditionalLanguages"][1] end,
			multiline = false,
			width = 'full',
			order = 1
		},
		language2 = {
			type = "input",
			name = L["L_OPTIONS_LANGUAGES_2"],
			desc = "",
			disabled = function(info) return not GnomTEC_Babel_Options["Enabled"] end,
			set = function(info,val) GnomTEC_Babel_Options["AdditionalLanguages"][2] = val end,
	   	get = function(info) return GnomTEC_Babel_Options["AdditionalLanguages"][2] end,
			multiline = false,
			width = 'full',
			order = 1
		},
		language3 = {
			type = "input",
			name = L["L_OPTIONS_LANGUAGES_3"],
			desc = "",
			disabled = function(info) return not GnomTEC_Babel_Options["Enabled"] end,
			set = function(info,val) GnomTEC_Babel_Options["AdditionalLanguages"][3] = val end,
	   	get = function(info) return GnomTEC_Babel_Options["AdditionalLanguages"][3] end,
			multiline = false,
			width = 'full',
			order = 1
		},
		language4 = {
			type = "input",
			name = L["L_OPTIONS_LANGUAGES_4"],
			desc = "",
			disabled = function(info) return not GnomTEC_Babel_Options["Enabled"] end,
			set = function(info,val) GnomTEC_Babel_Options["AdditionalLanguages"][4] = val end,
	   	get = function(info) return GnomTEC_Babel_Options["AdditionalLanguages"][4] end,
			multiline = false,
			width = 'full',
			order = 1
		},
		language5 = {
			type = "input",
			name = L["L_OPTIONS_LANGUAGES_5"],
			desc = "",
			disabled = function(info) return not GnomTEC_Babel_Options["Enabled"] end,
			set = function(info,val) GnomTEC_Babel_Options["AdditionalLanguages"][5] = val end,
	   	get = function(info) return GnomTEC_Babel_Options["AdditionalLanguages"][5] end,
			multiline = false,
			width = 'full',
			order = 1
		},
	}
}

local addonDataObject =	{
	type = "data source",
	text = "---",
	label = "GnomTEC Babel",
	icon = [[Interface\Icons\Inv_Misc_Tournaments_banner_Gnome]],
	OnClick = function(self, button)
		ToggleDropDownMenu(1, nil, GNOMTEC_BABEL_FRAME_LDB_SELECTLANGUAGE_DROPDOWN, self:GetName(), 0, 0)
	end,
	OnTooltipShow = function(tooltip)
		GnomTEC_Babel:ShowAddonTooltip(tooltip)
	end,
}
	
-- ----------------------------------------------------------------------
-- Startup initialization
-- ----------------------------------------------------------------------
local coreFrame = CreateFrame("Frame");
GnomTEC_Babel = LibStub("AceAddon-3.0"):NewAddon(coreFrame, "GnomTEC_Babel", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
LibStub("AceConfig-3.0"):RegisterOptionsTable("GnomTEC Babel Main", optionsMain)
LibStub("AceConfig-3.0"):RegisterOptionsTable("GnomTEC Babel Languages", optionsLanguages)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GnomTEC Babel Main", "GnomTEC Babel");
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GnomTEC Babel Languages", L["L_OPTIONS_LANGUAGES"], "GnomTEC Babel");

local ldb = LibStub:GetLibrary("LibDataBroker-1.1")local ldb = LibStub:GetLibrary("LibDataBroker-1.1")

-- ----------------------------------------------------------------------
-- Local stubs for the GnomTEC API
-- ----------------------------------------------------------------------

local function GnomTEC_LogMessage(level, message)
	if (level < LOG_DEBUG) then
		GnomTEC_Babel:Print(message)
	end
end

local function GnomTEC_RegisterAddon()
end

-- ----------------------------------------------------------------------
-- Local functions
-- ----------------------------------------------------------------------

-- function which returns also nil for empty strings
local function emptynil( x ) return x ~= "" and x or nil end

function GnomTEC_Babel:SetLanguage(ID)
	local i = 1
	local languageName, languageID
	GnomTEC_Babel_Options["LanguageID"] = ID
	
	if (ID < 0) then
		if (GnomTEC_Babel_Options["Enabled"] and (nil ~= emptynil(GnomTEC_Babel_Options["AdditionalLanguages"][-ID]))) then
			languageName = GnomTEC_Babel_Options["AdditionalLanguages"][-ID]
		else	
			languageName, GnomTEC_Babel_Options["LanguageID"] = GetLanguageByIndex(1)
		end		
	else
		repeat
			languageName, languageID = GetLanguageByIndex(i)
			if (languageID == GnomTEC_Babel_Options["LanguageID"]) then
				i = 0
			else
				i = i + 1
			end
		until ((i < 1) or (i > GetNumLanguages()))
		if (i > 0) then
			-- we can not speak the given language so change to the first one
			languageName, GnomTEC_Babel_Options["LanguageID"] = GetLanguageByIndex(1)
		end
	end
 	GNOMTEC_BABEL_FRAME_SELECTLANGUAGE_BUTTON:SetText(languageName or "")
 	addonDataObject.text = languageName or ""
 	return languageName
end


-- ----------------------------------------------------------------------
-- Frame event handler and functions
-- ----------------------------------------------------------------------

-- initialize drop down menu languages
local function GnomTEC_Babel_SelectLanguage_InitializeDropDown(level)
	local i = 1
	local language = {
		notCheckable = 1,
		func = function (self, arg1, arg2, checked) GnomTEC_Babel:SetLanguage(arg2) end
	}
	-- to fix issue at login with sometimes returned nil
	local numLanguages = GetNumLanguages() or 1

	repeat
		language.arg1, language.arg2 = GetLanguageByIndex(i)	
		language.text = language.arg1
		UIDropDownMenu_AddButton(language)
		i = i + 1
	until (i > numLanguages)
	
	i = 1
	if (GnomTEC_Babel_Options["Enabled"]) then
		repeat
			if (nil ~= emptynil(GnomTEC_Babel_Options["AdditionalLanguages"][i])) then
				language.arg1 = GnomTEC_Babel_Options["AdditionalLanguages"][i]	
				language.arg2 = -i
				language.text = language.arg1
				UIDropDownMenu_AddButton(language)
			end
			i = i + 1
		until (i > MaxUserDefinedLanguages)
	end
end

-- select languages drop down menu OnLoad
function GnomTEC_Babel:SelectLanguage_DropDown_OnLoad(self)
	UIDropDownMenu_Initialize(self, GnomTEC_Babel_SelectLanguage_InitializeDropDown, "MENU")
end

-- select languages drop down menu OnClick
function GnomTEC_Babel:SelectLanguage_Button_OnClick(self, button, down)
	ToggleDropDownMenu(1, nil, GNOMTEC_BABEL_FRAME_SELECTLANGUAGE_DROPDOWN, self:GetName(), 0, 0)
end

-- select languages drop down menu OnLoad (LDB)
function GnomTEC_Babel:LDB_SelectLanguage_DropDown_OnLoad(self)
	UIDropDownMenu_Initialize(self, GnomTEC_Babel_SelectLanguage_InitializeDropDown, "MENU")
end

-- ----------------------------------------------------------------------
-- Hook functions
-- ----------------------------------------------------------------------


function GnomTEC_Babel:SendChatMessage(msg, chatType, languageID, channel)
	if ((chatType == "SAY") or (chatType == "YELL")) then
		-- check if we know this language yet, when not will be reset to common
		GnomTEC_Babel:SetLanguage(GnomTEC_Babel_Options["LanguageID"])
		languageID = GnomTEC_Babel_Options["LanguageID"]
		if (GnomTEC_Babel_Options["Enabled"]) then
			if ((not languageID) or (LANGUAGE_ORCISH == languageID) or (LANGUAGE_COMMON == languageID)) then
				self.hooks[C_ChatInfo].SendChatMessage(msg,chatType,nil, channel)
			else
				local maxlen				
				if (languageID < 0) then
					maxlen = 255 - string.len("["..GnomTEC_Babel_Options["AdditionalLanguages"][-languageID].."] ")
				else				
					maxlen = 255 - string.len("["..GnomTEC_Babel:SetLanguage(languageID).."] ")
				end
	
				if (string.len(msg) <= maxlen) then
					if (languageID < 0) then
						self.hooks[C_ChatInfo].SendChatMessage("["..GnomTEC_Babel_Options["AdditionalLanguages"][-languageID].."] "..msg,chatType,nil, channel)
					else				
						self.hooks[C_ChatInfo].SendChatMessage("["..GnomTEC_Babel:SetLanguage(languageID).."] "..msg,chatType,nil, channel)
					end
				else
					local m = ""
					local w

					for w in string.gmatch(msg, "[^ ]+") do
						if ((string.len(m) + string.len(w)) + 1 <= maxlen) then
							if ("" ~= m) then
								m = m.." "..w
							else
								m = w
							end
						else
							if ("" == m) then
								-- nobody should type single words that are too long for a line, but if...
								m = string.sub(w,1,maxlen)
								w = ""
							end
							if (languageID < 0) then
								self.hooks[C_ChatInfo].SendChatMessage("["..GnomTEC_Babel_Options["AdditionalLanguages"][-languageID].."] "..m,chatType,nil, channel)
							else				
								self.hooks[C_ChatInfo].SendChatMessage("["..GnomTEC_Babel:SetLanguage(languageID).."] "..m,chatType,nil, channel)
							end
							m = w
						end
					end
					if ("" ~= m) then
						if (languageID < 0) then
							self.hooks[C_ChatInfo].SendChatMessage("["..GnomTEC_Babel_Options["AdditionalLanguages"][-languageID].."] "..m,chatType,nil, channel)
						else				
							self.hooks[C_ChatInfo].SendChatMessage("["..GnomTEC_Babel:SetLanguage(languageID).."] "..m,chatType,nil, channel)
						end
					end
				end								
			end
		else
			self.hooks[C_ChatInfo].SendChatMessage(msg,chatType,languageID, channel)
		end
	else
		self.hooks[C_ChatInfo].SendChatMessage(msg,chatType,languageID, channel)
	end
end

-- ----------------------------------------------------------------------
-- Event handler
-- ----------------------------------------------------------------------
	function	GnomTEC_Babel:ShowAddonTooltip(tooltip)
		tooltip:AddLine("GnomTEC Babel",1.0,1.0,1.0)
		tooltip:AddLine(L["L_LDB_HINT"],0.0,1.0,0.0)
	end	
	
	
-- ----------------------------------------------------------------------
-- Addon OnInitialize, OnEnable and OnDisable
-- ----------------------------------------------------------------------

function GnomTEC_Babel:OnInitialize()
 	-- Code that you want to run when the addon is first loaded goes here.
  
  	GnomTEC_RegisterAddon()
  	GnomTEC_LogMessage(LOG_INFO, L["L_WELCOME"])
  	  	
end

function GnomTEC_Babel:OnEnable()
    -- Called when the addon is enabled
	GnomTEC_LogMessage(LOG_INFO, "GnomTEC_Babel Enabled")
	self:RawHook(C_ChatInfo, "SendChatMessage", true)
	-- Initialize options which are propably not valid because they are new added in new versions of addon
	if (nil == GnomTEC_Babel_Options["LanguageSelectorEnabled"]) then
		GnomTEC_Babel_Options["LanguageSelectorEnabled"] = GnomTEC_Babel_Options["Enabled"]
	end
	if (nil == GnomTEC_Babel_Options["LanguageID"]) then
		GnomTEC_Babel_Options["LanguageID"] = select(2, GetLanguageByIndex(1))
		GnomTEC_Babel_Options["Language"] = nil
	end
	if (nil == GnomTEC_Babel_Options["AdditionalLanguages"]) then
		GnomTEC_Babel_Options["AdditionalLanguages"] = {}
	end
		
	-- Show GUI
	if (GnomTEC_Babel_Options["LanguageSelectorEnabled"]) then
		GNOMTEC_BABEL_FRAME:Show()
	end
	
	-- Setup LDB
	addonDataObject = ldb:NewDataObject("GnomTEC Babel", addonDataObject)

	GnomTEC_Babel:SetLanguage(GnomTEC_Babel_Options["LanguageID"])

end

function GnomTEC_Babel:OnDisable()
    -- Called when the addon is disabled
    
	GnomTEC_Babel:UnregisterAllEvents();
	GNOMTEC_BABEL_FRAME:Hide()

end

-- ----------------------------------------------------------------------
-- External API
-- ----------------------------------------------------------------------

