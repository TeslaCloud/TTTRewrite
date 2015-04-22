--[[
	© 2014 TeslaCloud Studios.
	
	Feel free to use, edit and share this code, but do not
	re-distribute or sell without the permission of it's author.
	
	Feel free to contact us at support@teslacloud.net
--]]

local ROLE = TTT.Role:New("Maniac");
	ROLE.roleID = "maniac";
	ROLE.icon = "ttt/icons/roles/maniac.png";
	ROLE.color = "170 0 170 255";
	ROLE.prefix = "FELLOW MANIAC";
	ROLE.group = RG_FFA;
	ROLE.shop = true;
	ROLE.shopItems = {
      "weapon_ttt_c4",
      "weapon_ttt_flaregun",
      "weapon_ttt_knife",
      "weapon_ttt_phammer",
      "weapon_ttt_push",
      "weapon_ttt_radio",
      "weapon_ttt_sipistol",
      "weapon_ttt_teleport",
      "weapon_ttt_decoy",
      EQUIP_ARMOR,
      EQUIP_RADAR,
      EQUIP_DISGUISE
	};
	ROLE.hasCredits = true;
	ROLE.startCredits = 2;
	ROLE.maxPly = 2;
	ROLE.minPly = 16;
	ROLE.ratio = 16;
	ROLE.chance = 40;
	ROLE.realTime = true;
	ROLE.shouldWearDetectiveHat = false;
ROLE:Register();