--[[
	© 2014 TeslaCloud Studios.
	
	Feel free to use, edit and share this code, but do not
	re-distribute or sell without the permission of it's author.
	
	Feel free to contact us at support@teslacloud.net
--]]

--[[
local ROLE = TTT.Role:New("Role Name");
	ROLE.name = "Example"; -- The name of our role.
	ROLE.isDefault = false; -- Whether it is the default role or not.
	ROLE.description = "This is an example role."; -- Description of the role.
	ROLE.roleID = "example"; -- ID of the role.
	ROLE.icon = "whitesand/icons/roles/example.png"; -- Icon of the role. Relative to Garrysmod/Materials path. Should be 64x64 .png image.
	ROLE.color = "205 20 20 255"; -- Color (RGBA) of the role.
	ROLE.prefix = "FELLOW EXAMPLE"; -- Prefix of the role to appear inside role-specific chat.
	ROLE.enemies = {"innocent", "maniac", "detective"}; -- Table containing all the enemies of the role.
	ROLE.friends = {}; -- Table containing friends of the role.
	ROLE.shop = true; -- Should the role have access to the role shop?
	ROLE.shopItems = {
		"weapon_ws_ak47"
	}; -- If yes, then what items should this role be able to buy?
	ROLE.hasCredits = true; -- Does this role gets credits for the shop specified above?
	ROLE.startCredits = 2; -- If yes, how much starting credits to give?
	ROLE.maxPly = 16; -- The maximum amount of players inside the role.
	ROLE.minPly = Whitesand.config.minPly; -- The minimum amount of players for the system to be able to pick someone for that role.
	ROLE.ratio = 6; -- Ratio. For every X players there is 1 player in this role.
	ROLE.chance = 100; -- The chance for player to become this role.
	ROLE.realTime = true;
	ROLE.requireDead = true; -- If the players in this role must be killed for the round to end for the default role.
	ROLE.shouldWearDetectiveHat = false; -- Should this role wear super-awesome detective hat?
ROLE:Register();
--]]