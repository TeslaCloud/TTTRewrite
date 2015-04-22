--[[
	© 2014 TeslaCloud Studios.
	
	Feel free to use, edit and share this code, but do not
	re-distribute or sell without the permission of it's author.
	
	Feel free to contact us at support@teslacloud.net
--]]

local ROLE = TTT.Role:New("Innocent");
	ROLE.isDefault = true;
	ROLE.roleID = "innocent";
	ROLE.icon = "ttt/icons/roles/innocent.png";
	ROLE.color = "60 220 60 255";
	ROLE.prefix = "";
	ROLE.group = RG_GOOD;
	ROLE.shop = false;
	ROLE.shopItems = {};
	ROLE.hasCredits = false;
	ROLE.startCredits = 0;
	ROLE.maxPly = 0;
	ROLE.minPly = 0;
	ROLE.ratio = 1;
	ROLE.chance = 100;
	ROLE.shouldWearDetectiveHat = false;
ROLE:Register();