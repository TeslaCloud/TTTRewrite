if (!TTT) then
	TTT = GM;
else
	CurrentGM = TTT;
	table.Merge(CurrentGM, GM);
	TTT = nil;
	
	TTT = GM;
	table.Merge(TTT, CurrentGM);
	CurrentGM = nil;
end;

GM.Name = "Trouble in Terrorist Town"
GM.Author = "Bad King Urgrain"
GM.Email = "thegreenbunny@gmail.com"
GM.Website = "ttt.badking.net"
-- Date of latest changes (YYYY-MM-DD)
GM.Version = "2015-03-30"

GM.Customized = false

-- Fix name conflicts. Just because I like using
-- "player" instead of "ply" :p
_player, _team, _file = player, team, file;

-- A function to include a file based on its prefix.
function util.Include(name)
	local isShared = (string.find(name, "sh_") or string.find(name, "shared.lua"));
	local isClient = (string.find(name, "cl_") or string.find(name, "cl_init.lua"));
	local isServer = string.find(name, "sv_");
	
	if (isServer and !SERVER) then return end;
	
	if (isShared and SERVER) then
		AddCSLuaFile(name);
	elseif (isClient and SERVER) then
		AddCSLuaFile(name);
		return;
	end;
	
	include(name);
end;

-- A function to include files in a directory.
function util.IncludeDirectory(directory)
	if (string.sub(directory, -1) != "/") then
		directory = directory.."/";
	end;
	
	for k, v in pairs(file.Find(directory.."*.lua", "LUA", "namedesc")) do
		self:Include(directory..v);
	end;
end;

util.IncludeDirectory("libs");

function DetectiveMode() return GetGlobalBool("ttt_detective", false) end
function HasteMode() return GetGlobalBool("ttt_haste", false) end

-- Create teams
TEAM_TERROR = 1
TEAM_SPEC = TEAM_SPECTATOR

-- Include all of our roles.
-- We don't want to be an ass, so we allow
-- adding as much roles as you want.
util.IncludeDirectory("roles");

function GM:CreateTeams()
   team.SetUp(TEAM_TERROR, "Terrorists", Color(0, 200, 0, 255), false)
   team.SetUp(TEAM_SPEC, "Spectators", Color(200, 200, 0, 255), true)

   -- Not that we use this, but feels good
   team.SetSpawnPoint(TEAM_TERROR, "info_player_deathmatch")
   team.SetSpawnPoint(TEAM_SPEC, "info_player_deathmatch")
end

-- Everyone's model
local ttt_playermodels = {
   Model("models/player/phoenix.mdl"),
   Model("models/player/arctic.mdl"),
   Model("models/player/guerilla.mdl"),
   Model("models/player/leet.mdl")
};

function GetRandomPlayerModel()
   return table.Random(ttt_playermodels)
end

function GM:TTTShouldColorModel(mdl)
   local colorable =  {
      "models/player/phoenix.mdl",
      "models/player/guerilla.mdl",
      "models/player/leet.mdl"
   };
   return table.HasValue(colorable, mdl)
end

-- A function to create a new meta table.
function NewMetaTable(baseTable)
	local obj = {};
		setmetatable(obj, baseTable);
		baseTable.__index = baseTable;
	return obj;
end;

local ttt_playercolors = {
   all = {
      COLOR_WHITE,
      COLOR_BLACK,
      COLOR_GREEN,
      COLOR_DGREEN,
      COLOR_RED,
      COLOR_YELLOW,
      COLOR_LGRAY,
      COLOR_BLUE,
      COLOR_NAVY,
      COLOR_PINK,
      COLOR_OLIVE,
      COLOR_ORANGE
   },

   serious = {
      COLOR_WHITE,
      COLOR_BLACK,
      COLOR_NAVY,
      COLOR_LGRAY,
      COLOR_DGREEN,
      COLOR_OLIVE
   }
};

CreateConVar("ttt_playercolor_mode", "1")
function GM:TTTPlayerColor(model)
   if hook.Call("TTTShouldColorModel", GAMEMODE, model) then
      local mode = GetConVarNumber("ttt_playercolor_mode") or 0
      if mode == 1 then
         return table.Random(ttt_playercolors.serious)
      elseif mode == 2 then
         return table.Random(ttt_playercolors.all)
      elseif mode == 3 then
         -- Full randomness
         return Color(math.random(0, 255), math.random(0, 255), math.random(0, 255))
      end
   end
   -- No coloring
   return COLOR_WHITE
end

-- Kill footsteps on player and client
function GM:PlayerFootstep(ply, pos, foot, sound, volume, rf)
   if IsValid(ply) and (ply:Crouching() or ply:GetMaxSpeed() < 150) then
      -- do not play anything, just prevent normal sounds from playing
      return true
   end
end


-- Weapons and items that come with TTT. Weapons that are not in this list will
-- get a little marker on their icon if they're buyable, showing they are custom
-- and unique to the server.
DefaultEquipment = {
   -- traitor-buyable by default
   [ROLE_TRAITOR] = {
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
   },

   -- detective-buyable by default
   [ROLE_DETECTIVE] = {
      "weapon_ttt_binoculars",
      "weapon_ttt_defuser",
      "weapon_ttt_health_station",
      "weapon_ttt_stungun",
      "weapon_ttt_cse",
      "weapon_ttt_teleport",
      EQUIP_ARMOR,
      EQUIP_RADAR
   },

   -- non-buyable
   [ROLE_NONE] = {
      "weapon_ttt_confgrenade",
      "weapon_ttt_m16",
      "weapon_ttt_smokegrenade",
      "weapon_ttt_unarmed",
      "weapon_ttt_wtester",
      "weapon_tttbase",
      "weapon_tttbasegrenade",
      "weapon_zm_carry",
      "weapon_zm_improvised",
      "weapon_zm_mac10",
      "weapon_zm_molotov",
      "weapon_zm_pistol",
      "weapon_zm_revolver",
      "weapon_zm_rifle",
      "weapon_zm_shotgun",
      "weapon_zm_sledge",
      "weapon_ttt_glock"
   }
};
