--[[
	© 2014 TeslaCloud Studios.
	
	Feel free to use, edit and share this code, but do not
	re-distribute or sell without the permission of it's author.
	
	Feel free to contact us at support@teslacloud.net
--]]

local ROLE = TTT.Role:New("None");
	ROLE.isDefault = true;
	ROLE.roleID = "none";
	ROLE.icon = "ttt/icons/roles/none.png";
	ROLE.color = "150 150 150 255";
	ROLE.prefix = "";
	ROLE.shop = false;
	ROLE.shopItems = {};
	ROLE.hasCredits = false;
	ROLE.startCredits = 0;
	ROLE.maxPly = 0;
	ROLE.minPly = 0;
	ROLE.ratio = 1;
	ROLE.chance = 100;
	ROLE.shouldWearDetectiveHat = false;
	ROLE.group = RG_NONE;
ROLE:Register();