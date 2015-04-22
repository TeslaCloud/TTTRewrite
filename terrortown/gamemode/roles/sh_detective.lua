--[[
	© 2014 TeslaCloud Studios.
	
	Feel free to use, edit and share this code, but do not
	re-distribute or sell without the permission of it's author.
	
	Feel free to contact us at support@teslacloud.net
--]]

local ROLE = TTT.Role:New("Detective");
	ROLE.roleID = "detective";
	ROLE.icon = "ttt/icons/roles/detective.png";
	ROLE.color = "40 40 255 255";
	ROLE.prefix = "DETECTIVE";
	ROLE.group = RG_GOOD;
	ROLE.shop = true;
	ROLE.shopItems = {
      "weapon_ttt_binoculars",
      "weapon_ttt_defuser",
      "weapon_ttt_health_station",
      "weapon_ttt_stungun",
      "weapon_ttt_cse",
      "weapon_ttt_teleport",
      EQUIP_ARMOR,
      EQUIP_RADAR
	};
	ROLE.hasCredits = true;
	ROLE.startCredits = 2;
	ROLE.maxPly = 8;
	ROLE.minPly = 8;
	ROLE.ratio = 8;
	ROLE.chance = 100;
	ROLE.shouldWearDetectiveHat = true;
ROLE:Register();