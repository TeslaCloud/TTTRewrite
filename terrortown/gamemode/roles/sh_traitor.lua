--[[
	© 2014 TeslaCloud Studios.
	
	Feel free to use, edit and share this code, but do not
	re-distribute or sell without the permission of it's author.
	
	Feel free to contact us at support@teslacloud.net
--]]

local ROLE = TTT.Role:New("Traitor");
	ROLE.isDefault = true;
	ROLE.roleID = "traitor";
	ROLE.icon = "ttt/icons/roles/traitor.png";
	ROLE.color = "205 20 20 255";
	ROLE.prefix = "FELLOW TRAITOR";
	ROLE.group = RG_BAD;
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
	ROLE.maxPly = 16;
	ROLE.minPly = 2; -- should be 2.
	ROLE.ratio = 6;
	ROLE.chance = 100;
	ROLE.realTime = true;
	ROLE.shouldWearDetectiveHat = false;
	
	-- You can have callhacks that are called when player is picked for that role.
	-- This means - YOU CAN DO LITERALLY ANYTHING.
	function ROLE.Callback(player)
		print("Picked TRAITOR - "..player:Name());
	end;
	
ROLE:Register();