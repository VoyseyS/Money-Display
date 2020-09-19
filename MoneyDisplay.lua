-- MoneyDisplay (Updates by Skizo since v2)
--
-- Concept and original design by Sphinx
-- Alpha and border functionality submitted by Rabbit
-- Implemented change of Command Line Call from /moneydisplay to /money as suggested by Rabbit
-- Implemented save window position based on code supplied by MentllyGuitarded
-- Implemented cashflow functionality suggested by Gorramit

---------------------
-- Global variables
---------------------

MoneyDisplay_DEFAULT_ON       = 1;
MoneyDisplay_DEFAULT_LOCKED   = nil;
MoneyDisplay_DEFAULT_ALPHA    = 255;
MoneyDisplay_DEFAULT_BORDER   = 1;
MoneyDisplay_DEFAULT_dispX    = GetScreenWidth()/2;
MoneyDisplay_DEFAULT_dispY    = GetScreenHeight()-50;
MoneyDisplay_DEFAULT_CASHFLOW = { };
MoneyDisplay_DEFAULT_DEFCF    = { cash = nil; display = false; on = false; }
MoneyDisplay_Gold      = 0;
MoneyDisplay_Silver    = 0;
MoneyDisplay_Copper    = 0;
MoneyDisplay_LastShown = nil;
MoneyDisplay_Passive   = nil;
MoneyDisplay_PlayerName = UnitName("player") .. "-" .. GetRealmName();

---------------------
-- Backdrop Settings
---------------------
local MD_Backdrop = {
	--The background texture Information
	bginfo = "BACKDROP_DIALOG_12_12",

	-- path to the background texture
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",

	-- path to the border texture
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",

	-- true to repeat the background texture to fill the frame, false to scale it
	tile = true,

	-- size (width or height) of the square repeating background tiles (in pixels)
	tileSize = 32,

	-- thickness of edge segments and square size of edge corners (in pixels)
	edgeSize = 10,

	-- distance from the edges of the frame to those of the background texture (in pixels)
	insets = { left = 1, right = 1, top = 1, bottom = 1 }
}

---------------------
-- OnLoad Function
---------------------

function MD_OnLoad(frame)

	-- Set Variables if required
	MoneyDisplay_SetVariables();

	-- Register the events that need to be watched
	frame:RegisterEvent("PLAYER_LOGIN");

	-- Register the slash command
	SlashCmdList["MONEYDISPLAY"] = function(msg)
	  MoneyDisplay_SlashCommand(msg);
	end;
	SLASH_MONEYDISPLAY1 = "/money";

	if( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage("|cffffff00MoneyDisplay v9./money0.0 loaded");
	end

	UIErrorsFrame:AddMessage("MoneyDisplay AddOn loaded", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
end

----------------------
-- OnEvent Event
----------------------

function MD_OnEvent(frame, event)

	-- If the settings are loaded then update the display
	if (event == "PLAYER_LOGIN") then

		-- v2.2 Adjustments
		if (strsub(tostring(MoneyDisplaySettings.cashflow),1,7) ~= "table: ") then
			MoneyDisplaySettings.cashflow = MoneyDisplay_DEFAULT_CASHFLOW;
		end;

		if (not MoneyDisplaySettings.cashflow[MoneyDisplay_PlayerName]) then
			MoneyDisplaySettings.cashflow[MoneyDisplay_PlayerName] = MoneyDisplay_DEFAULT_DEFCF;
		end;

		MD_Frame:ClearAllPoints();
		MD_Frame:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", MoneyDisplaySettings.dispX, MoneyDisplaySettings.dispY);

		MD_Frame:SetBackdrop(MD_Backdrop);

		MoneyDisplay_Update();
	end
end

----------------------
-- Set Variables
----------------------

function MoneyDisplay_SetVariables()

	if not (MoneyDisplaySettings) then
		-- Default Settings
		MoneyDisplay_ResetVariables();
	end
end

function MoneyDisplay_ResetVariables()

	-- Reset Settings
	MoneyDisplaySettings = { };
	MoneyDisplaySettings.on       = MoneyDisplay_DEFAULT_ON;
	MoneyDisplaySettings.locked   = MoneyDisplay_DEFAULT_LOCKED;
	MoneyDisplaySettings.alpha    = MoneyDisplay_DEFAULT_ALPHA;
	MoneyDisplaySettings.border   = MoneyDisplay_DEFAULT_BORDER;
	MoneyDisplaySettings.dispX    = MoneyDisplay_DEFAULT_dispX;
	MoneyDisplaySettings.dispY    = MoneyDisplay_DEFAULT_dispY;
	MoneyDisplaySettings.cashflow = MoneyDisplay_DEFAULT_CASHFLOW;

	MoneyDisplaySettings.cashflow[MoneyDisplay_PlayerName] = MoneyDisplay_DEFAULT_DEFCF;
end

----------------------
-- OnUpdate Function
----------------------

function MD_OnUpdate()
	local cf = GetMoney();

	if (MoneyDisplaySettings.cashflow[MoneyDisplay_PlayerName].display) then
	  cf = cf - MoneyDisplaySettings.cashflow[MoneyDisplay_PlayerName].cash;
	end

	if ((cf >= 0) and (MoneyDisplay_Passive == 1)) then
	  MoneyDisplay_Passive = nil;

	  MD_GoldText:SetTextColor  (1.0,0.8196,0.0);
	  MD_SilverText:SetTextColor(1.0,0.8196,0.0);
	  MD_CopperText:SetTextColor(1.0,0.8196,0.0);

	elseif (cf < 0) then
		cf = -cf;

		if ((MoneyDisplay_Passive == nil)) then
			MoneyDisplay_Passive = 1;

			MD_GoldText:SetTextColor  (1.0,0.0,0.0);
			MD_SilverText:SetTextColor(1.0,0.0,0.0);
			MD_CopperText:SetTextColor(1.0,0.0,0.0);
		end;
	end;

	if (MoneyDisplay_LastShown ~= cf) then
		MoneyDisplay_LastShown = cf;
		MoneyDisplay_Gold   = floor(cf/10000);
		MoneyDisplay_Silver = floor((cf-MoneyDisplay_Gold*10000)/100);
		MoneyDisplay_Copper = cf-MoneyDisplay_Gold*10000-MoneyDisplay_Silver*100;
	end;

	MD_GoldText:SetText  (""..(MoneyDisplay_Gold  ).."    ");
	MD_SilverText:SetText(""..(MoneyDisplay_Silver).."    ");
	MD_CopperText:SetText(""..(MoneyDisplay_Copper).."    ");
end

---------------------------
-- Cashflow Function
---------------------------

function MD_OnMiddleClick()
	if(MoneyDisplaySettings.cashflow[MoneyDisplay_PlayerName].on) then
		MoneyDisplaySettings.cashflow[MoneyDisplay_PlayerName].cash = GetMoney();
	end;
end

function MD_OnMouseWheel(UporDown)
	if (MoneyDisplaySettings.cashflow[MoneyDisplay_PlayerName].on) then
		if (UporDown < 0) then
			MoneyDisplaySettings.cashflow[MoneyDisplay_PlayerName].display = true;

			if (MoneyDisplaySettings.cashflow[MoneyDisplay_PlayerName].cash == nil) then
				MoneyDisplaySettings.cashflow[MoneyDisplay_PlayerName].cash = GetMoney();
			end;
		else
			MoneyDisplaySettings.cashflow[MoneyDisplay_PlayerName].display = false;
		end;
	end;
end

----------------------
-- Slash Commands
----------------------

function MoneyDisplay_SlashCommand(msg)

	-- Check the command
	if(msg) then
		local command = string.lower(msg);
		
		if(command == "show") then
			MoneyDisplaySettings.on = 1;
			MoneyDisplay_Update();
			DEFAULT_CHAT_FRAME:AddMessage("|cffffff00MoneyDisplay Show");

		elseif(command == "hide") then
			MoneyDisplaySettings.on = nil;
			MoneyDisplay_Update();
			DEFAULT_CHAT_FRAME:AddMessage("|cffffff00MoneyDisplay Hide");

		elseif(command == "reset") then
			MoneyDisplay_ResetVariables();
			MoneyDisplay_Update();
			DEFAULT_CHAT_FRAME:AddMessage("|cffffff00MoneyDisplay Reset");

		elseif(command == "lock") then
			MoneyDisplaySettings.locked = 1;
			MoneyDisplay_Update();
			DEFAULT_CHAT_FRAME:AddMessage("|cffffff00MoneyDisplay Locked");

		elseif(command == "unlock") then
			MoneyDisplaySettings.locked = nil;
			MoneyDisplay_Update();
			DEFAULT_CHAT_FRAME:AddMessage("|cffffff00MoneyDisplay Unlocked");

		elseif(command == "hideborder") then
			MoneyDisplaySettings.border = nil;
			MoneyDisplay_Update();
			DEFAULT_CHAT_FRAME:AddMessage("|cffffff00MoneyDisplay Border Hidden");

		elseif(command == "showborder") then
			MoneyDisplaySettings.border = 1;
			MoneyDisplay_Update();
			DEFAULT_CHAT_FRAME:AddMessage("|cffffff00MoneyDisplay Border Shown");

		elseif(command == "cashflow") then
			local MDCF = "Enabled";

			if (MoneyDisplaySettings.cashflow[MoneyDisplay_PlayerName].on) then
				MDCF = "Reset";
			end;

			MoneyDisplaySettings.cashflow[MoneyDisplay_PlayerName].cash = GetMoney();
			MoneyDisplaySettings.cashflow[MoneyDisplay_PlayerName].on = true;

			MoneyDisplay_Update();
			DEFAULT_CHAT_FRAME:AddMessage("|cffffff00MoneyDisplay Cashflow "..MDCF);

		elseif(command == "cashflow off") then
			MoneyDisplaySettings.cashflow[MoneyDisplay_PlayerName].on = false;
			MoneyDisplaySettings.cashflow[MoneyDisplay_PlayerName].display = false;
			MoneyDisplay_Update();

			DEFAULT_CHAT_FRAME:AddMessage("|cffffff00MoneyDisplay Cashflow Disabled");

		elseif(string.find(command, "alpha") ~= nul) then
			local i, j = string.find(command, "%d+");

			if (i ~= nil) then
				MoneyDisplay_Alpha(tonumber(string.sub(command, i, j), 10));
			end

			MoneyDisplay_Update();
			DEFAULT_CHAT_FRAME:AddMessage("|cffffff00MoneyDisplay Alpha Set");

		else
			DEFAULT_CHAT_FRAME:AddMessage(" ");
			DEFAULT_CHAT_FRAME:AddMessage(" ");
			DEFAULT_CHAT_FRAME:AddMessage("|cffffff00MoneyDisplay Command List");
			DEFAULT_CHAT_FRAME:AddMessage(" ");
			DEFAULT_CHAT_FRAME:AddMessage("|cffffff00/money reset - Reset all defaults");
			DEFAULT_CHAT_FRAME:AddMessage("|cffffff00/money show - Shows the mod");
			DEFAULT_CHAT_FRAME:AddMessage("|cffffff00/money hide - Hides the mod");
			DEFAULT_CHAT_FRAME:AddMessage("|cffffff00/money lock - Locks the mod");
			DEFAULT_CHAT_FRAME:AddMessage("|cffffff00/money unlock - Unlocks the mod");
			DEFAULT_CHAT_FRAME:AddMessage("|cffffff00/money cashflow [off] - Enables/Resets/Disables cashflow mode");
			DEFAULT_CHAT_FRAME:AddMessage("|cffffff00/money hideborder - Hides window border");
			DEFAULT_CHAT_FRAME:AddMessage("|cffffff00/money showborder - Shows window border");
			DEFAULT_CHAT_FRAME:AddMessage("|cffffff00/money alpha 0-255 - Set bg transparency (0 = transparent, 255 = solid)");
		end
	end

	MD_Frame:ClearAllPoints();
	MD_Frame:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", MoneyDisplaySettings.dispX, MoneyDisplaySettings.dispY);

end

function MoneyDisplay_Alpha(iAlpha)
	if (iAlpha >= 0 and iAlpha <= 255) then
		MoneyDisplaySettings.alpha = iAlpha;
	end
end

----------------------
-- Update Function
----------------------

function MoneyDisplay_Update()

	-- Apply the display settings
	if(MoneyDisplaySettings) then
		if(MoneyDisplaySettings.on) then
			MD_Frame:Show();
		else
			MD_Frame:Hide();
		end

		if (MoneyDisplaySettings.border) then
			MD_Frame:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b, 1.0)
		else
			MD_Frame:SetBackdropBorderColor(0.0, 0.0, 0.0, 0.0);
		end

		if (MoneyDisplaySettings.alpha) then
			MD_Frame:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b, MoneyDisplaySettings.alpha / 255);
		else
			MD_Frame:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b, 1);
		end

		MD_Frame:SetHeight(26);
		MD_Frame:SetWidth(155);
	end
end

function MD_SavePosition(frame)
    MoneyDisplaySettings.dispX = frame:GetLeft();
    MoneyDisplaySettings.dispY = frame:GetBottom();
end

function MD_Locked()
    return MoneyDisplaySettings.locked;
end
