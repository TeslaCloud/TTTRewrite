-- Role System File.
-- This file contains everything related to role picking and stuff like that.
-- Editing this is not a good idea, edit role files instead.

TTT.Role = TTT.Role or {};
TTT.Role.stored = TTT.Role.stored or {};
TTT.Role.picks = TTT.Role.picks or {};
TTT.Role.count = TTT.Role.count or {};

local CLASS_TABLE = {__index = CLASS_TABLE};

-- A function to create a new role object.
function TTT.Role:New(name)
	local obj = NewMetaTable(CLASS_TABLE)
		obj.name = name or "Unknown Role";
	return obj;
end;

-- A function to register role object.
function CLASS_TABLE:Register()
	return TTT.Role:Register(self.name, self);
end;

-- A function to register role object.
function TTT.Role:Register(name, data)
	if (!name or !data) then return false; end;
	
	local id = data.roleID;
	
	if (!id) then
		id = string.lower(string.Replace(name, " ", ""));
	end;
	
	self.stored[id] = data;
	
	-- If not defined role should be enabled.
	self.stored[id].active = data.active or true;
	
	print("registered role ID: "..id);
end;

-- A function to check if a role exists.
function TTT.Role:Exists(id)
	if (self.stored[id] and self.stored[id].name) then
		return true;
	else
		return false;
	end;
end;

-- A function to set a player's role.
function TTT.Role:SetRole(player, role)
	if (type(role) == "string") then
		if (TTT.Role:Exists(role)) then
			player:SetDTString(1, role);
		end;
	end;
end;

-- A function to get a player's role.
function TTT.Role:GetRole(player)
	return player:GetDTString(1);
end;

-- A function to get a role's color.
function TTT.Role:GetColor(role)
	if (self:Exists(role)) then
		return string.ToColor(self.stored[role].color) or Color(255, 255, 255, 255);
	end;
end;

-- A function to get a role's name.
function TTT.Role:GetName(role)
	if (self:Exists(role)) then
		return self.stored[role].name or "Unknown Role";
	end;
end;

-- A function to get if a role uses credits.
function TTT.Role:HasCredits(role)
	if (self:Exists(role)) then
		return self.stored[role].hasCredits or false;
	end;
end;

-- A function to get a role's starting credits.
function TTT.Role:GetStartingCredits(role)
	if (self:Exists(role)) then
		return self.stored[role].startCredits or 0;
	end;
end;

-- A function to get if a role can use the shop.
function TTT.Role:CanShop(role)
	if (self:Exists(role)) then
		return self.stored[role].shop or false;
	end;
end;

-- A function to get if a role can get shop items.
function TTT.Role:GetShopItems(role)
	if (self:Exists(role)) then
		return self.stored[role].shopItems or {};
	end;
end;

-- A function to determine if a player can see the real time based on their role.
function TTT.Role:ShouldSeeRealTime(player)
	if (self:Exists(self:GetRole(player))) then
		return self.stored[self:GetRole(player)].realTime or false;
	end;
end;

-- A function to check if a player is required to be dead for the round to be over.
function TTT.Role:RequiredDead(player, role)
	local roleStr = role;
	if (player) then roleStr = self:GetRole(player) end;
	
	if (self:Exists(roleStr)) then
		return self.stored[roleStr].requireDead or false;
	end;
	
	return false;
end;

-- A function to get a role's 'friends'.
function TTT.Role:Friends(firstRole, secondRole)
	if (self:Exists(firstRole) and self:Exists(secondRole)) then
		local fRole = self.stored[firstRole];
		local sRole = self.stored[secondRole];
		
		if (firstRole == secondRole) then return true end;
		if (fRole.noEnemies or sRole.noEnemies) then return true end;
		if (fRole.noFriends or sRole.noFriends) then return false end;
		
		for k, v in pairs (fRole.friends) do
			if (fRole.friends[k] == secondRole) then
				return true;
			end;
		end;
		
		for k, v in pairs (sRole.friends) do
			if (sRole.friends[k] == firstRole) then
				return true;
			end;
		end;
	end;
	
	return false;
end;

--A function to clear all player's of roles but not reset them.
function TTT.Role:ClearNoReset()
	for k, v in pairs (player.GetAll()) do
		v:SetTeam(TEAM_TERROR);
		v:Freeze(false);
		v:UnSpectate();
		v:StripAll();
	end;
end;

local playerMeta = FindMetaTable("Player");

function playerMeta:GetRole()
	return TTT.Role:GetRole(self);
end;

function playerMeta:GetRoleName()
	local id = self:GetRole();
	
	return TTT.Role:GetName(id);
end;

function playerMeta:SetRole(role)
	return TTT.Role:SetRole(self, role);
end;

function playerMeta:GetRoleColor()
	return TTT.Role:GetColor(self:GetRole());
end;

function playerMeta:IsRole(role)
	return (self:GetRole() == role)
end;

function playerMeta:IsTraitor()
	return self:IsRole("traitor");
end;

function playerMeta:IsDetective()
	return self:IsRole("detective");
end;

function playerMeta:GetRoleGroup()
	return TTT.Role.stored[self:GetRole()].group or RG_NONE;
end;

function playerMeta:IsRoleGroup(rg)
	return self:GetRoleGroup() == rg;
end;

function playerMeta:GetTraitor()
	return self:IsTraitor();
end;

function playerMeta:GetDetective()
	return self:IsDetective();
end;

-- A function to count player count in certain role.
function TTT.Role:Count(roleID)
	local numToReturn = 0;
	
	for k, v in pairs(player.GetAll()) do
		if (v:IsRole(roleID)) then
			numToReturn = numToReturn + 1;
		end;
	end;
	
	return numToReturn;
end;

-- A function to count living player count in certain role.
function TTT.Role:CountAlive(roleID)
	local numToReturn = 0;
	
	for k, v in pairs(player.GetAll()) do
		if (v:IsRole(roleID) and v:Alive()) then
			numToReturn = numToReturn + 1;
		end;
	end;
	
	return numToReturn;
end;

-- A function to count player count in certain role group.
function TTT.Role:CountRG(rg)
	local numToReturn = 0;
	
	for k, v in pairs(player.GetAll()) do
		if (v:GetRoleGroup() == rg) then
			numToReturn = numToReturn + 1;
		end;
	end;
	
	return numToReturn;
end;

-- A function to count living player count in certain role group.
function TTT.Role:CountRGAlive(rg)
	local numToReturn = 0;
	
	for k, v in pairs(player.GetAll()) do
		if ((v:GetRoleGroup() == rg) and v:Alive()) then
			numToReturn = numToReturn + 1;
		end;
	end;
	
	return numToReturn;
end;

function TTT.Role:GetPlayers(roleID)
	local players = {};
	
	for k, v in pairs(player.GetAll()) do
		if (v:IsRole(roleID)) then
			table.insert(players, v);
		end;
	end;
	
	return players;
end;

-- A function to pick a role for players at the beginning of a round.
function TTT.Role:PickPlayers()
	-- Respawn dead players, set all living player's health to 100.
	-- Slay people who should be slain. Set everyone to innocent.
	for k, v in pairs(player.GetAll()) do
		if (!v:Alive()) then
			v:SetTeam(TEAM_TERROR);
			v:Freeze(false);
			v:UnSpectate();
			v:StripAll();

			v:Flashlight(true);
			v:Spawn();
		elseif (v:Health() < 100) then
			v:SetHealth(100);
		end;
		
		if (v.slaynr) then
			v.slaynr = false;
			v:Kill();
		end;
		
		self:SetRole(v, "innocent");
	end;
	
	GAMEMODE.LastRole = {}
	
	-- I am kind of proud for that one.
	-- This is a fully dynamic role management system which supports
	-- creating of unlimited amount of roles, but I'd strongly recommend
	-- keeping the number of roles under 6, because anything above 6 will
	-- leave too few innocents around.
	-- Unlike TTT, where there were separate "for" cycles for each role and it was
	-- a huge pain to add a new role, this system can be expanded much more
	-- than TTT's and it supports lots of customization without much Lua knowledge.
	-- ~ Mr. Meow.
	
	local rolesTable = self.stored;
	local pickedTable = self.picks;
	
	for k, v in pairs(rolesTable) do
		local curRole = rolesTable[k];
		local maxAmt = math.Round(#player.GetAll() / curRole.ratio, 0);
		
		if (curRole.roleID == "innocent") then return end;
		if (maxAmt < 1 and curRole.roleID == "traitor") then maxAmt = 1 end;
		if (maxAmt > curRole.maxPly) then maxAmt = curRole.maxPly end;
		if (!pickedTable[curRole.roleID]) then pickedTable[curRole.roleID] = {} end;
		
		self.count[curRole.roleID] = self.count[curRole.roleID] or 0;
		
		local chance = math.random(0, 100);
		local pickedPly = {};
		
		for i=1,maxAmt do
			-- If role's pick chance is equal or higher than random roll - then pick the player.
			if (curRole.chance >= chance) then
				table.insert(pickedPly, i, math.random(1, #player.GetAll()));
				
				-- Sometimes it doesn't pick enough players, or picks the same player twice.
				-- So we just pick again if max amount is not yet reached.
				if (table.Count(pickedPly) < maxAmt) then
					table.insert(pickedPly, i, math.random(1, #player.GetAll()))
				end;
			end;
		end;
		
		for i=1,#pickedPly do
			local curPly = player.GetAll()[pickedPly[i]];
			
			-- Don't pick dead players.
			if (!curPly:Alive()) then return; end;
			
			-- Only pick if chosen player's role is Innocent, because he could've been chosen to be two roles at the same time, which is impossible.
			if (TTT.Role:GetRole(curPly) == "innocent") then
				if ((maxAmt >= 1) and (self.count[curRole.roleID] < maxAmt)) then
					if ((curRole.roleID == "detective") and curPly:GetAvoidDetective()) then
						TTT.Role:SetRole(curPly, "innocent");
					end;
					
					-- We don't set player's role to 'none', and if role's minumum player's amount we don't pick it.
					if ((curRole.roleID == "none") or !curRole.active or (curRole.minPly > #player.GetAll())) then
						TTT.Role:SetRole(curPly, "innocent");
					else
						table.insert(pickedTable[curRole.roleID], table.Count(pickedTable[curRole.roleID]) + 1, curPly);
						self.count[curRole.roleID] = self.count[curRole.roleID] + 1;
						
						GAMEMODE.LastRole[curPly:UniqueID()] = curRole.roleID;
						
						TTT.Role:SetRole(curPly, curRole.roleID);
						
						if (TTT.Role:HasCredits(curRole.roleID)) then
							curPly:SetCredits(TTT.Role:GetStartingCredits(curRole.roleID));
						end;
						
						hook.Call("OnPlayerPicked", GM, curPly, curRole.roleID);
					end;
				end;
			end;
		end;
		
		-- We still have to pick someone as traitor, duh.
		if (self.count["traitor"] == 0) then
			for k, v in pairs (player.GetAll()) do
				local chance = math.random(1, #player.GetAll());
				local ply = player.GetAll()[chance];

				if (self.count["traitor"] >= 1) then return; end;
				
				table.insert(pickedTable["traitor"], table.Count(pickedTable["traitor"]) + 1, ply);
				self.count["traitor"] = self.count["traitor"] + 1;
				
				GAMEMODE.LastRole[ply:UniqueID()] = "traitor";
				
				TTT.Role:SetRole(ply, "traitor");
				ply:SetCredits(TTT.Role:GetStartingCredits("traitor"));
				
				hook.Call("OnPlayerPicked", GM, ply, "traitor");
			end;
		end;
	end;
end;

-- A function to clear all players of their roles.
function TTT.Role:Clear()
	for k, v in pairs (player.GetAll()) do
		TTT.Role:SetRole(v, "none");
		v:SetTeam(TEAM_TERROR);
		v:Freeze(false);
		v:UnSpectate();
		v:StripAll();
		
		v:Spawn();
	end;
	
	table.Empty(self.count);
	table.Empty(self.picks);
end;

-- A function to clear all players of roles, but not respawn them.
function TTT.Role:ClearNoRespawn()
	for k, v in pairs (player.GetAll()) do
		TTT.Role:SetRole(v, "none");
		v:SetTeam(TEAM_TERROR);
		v:Freeze(false);
	end;
	
	table.Empty(self.count);
	table.Empty(self.picks);
end;