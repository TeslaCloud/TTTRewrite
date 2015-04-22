include("shared.lua")

-- Define GM12 fonts for compatibility
surface.CreateFont("DefaultBold", {
	font = "Tahoma",
   size = 13,
   weight = 1000
})

surface.CreateFont("TabLarge", {
	font = "Tahoma",
   size = 13,
   weight = 700,
   shadow = true, antialias = false
})

surface.CreateFont("Trebuchet22", {
	font = "Trebuchet MS",
   size = 22,
   weight = 900
})

include("external/pon.lua");
include("external/netstream.lua");

include("libs/vgui/ColoredBox.lua")
include("libs/vgui/SimpleIcon.lua")
include("libs/vgui/ProgressBar.lua")
include("libs/vgui/ScrollLabel.lua")

function GM:Initialize()
   MsgN("TTT Client initializing...")

   GAMEMODE.round_state = ROUND_WAIT

   LANG.Init()

   self.BaseClass:Initialize()

   RunConsoleCommand("ttt_spectate", GetConVar("ttt_spectator_mode"):GetInt())
end

function GM:InitPostEntity()
   MsgN("TTT Client post-init...")

   if not game.SinglePlayer() then
      timer.Create("idlecheck", 5, 0, CheckIdle)
   end

   -- make sure player class extensions are loaded up, and then do some
   -- initialization on them
   if IsValid(LocalPlayer()) and LocalPlayer().GetTraitor then
      GAMEMODE:ClearClientState()
   end

   timer.Create("cache_ents", 1, 0, GAMEMODE.DoCacheEnts)

   RunConsoleCommand("_ttt_request_serverlang")
   RunConsoleCommand("_ttt_request_rolelist")
end

function GM:DoCacheEnts()
   RADAR:CacheEnts()
   TBHUD:CacheEnts()
end

function GM:HUDClear()
   RADAR:Clear()
   TBHUD:Clear()
end

KARMA = {}
function KARMA.IsEnabled() return GetGlobalBool("ttt_karma", false) end

function GetRoundState() return GAMEMODE.round_state end

local function RoundStateChange(o, n)
   if n == ROUND_PREP then
      -- prep starts
      GAMEMODE:ClearClientState()
      GAMEMODE:CleanUpMap()

      -- show warning to spec mode players
      if GetConVar("ttt_spectator_mode"):GetBool() and IsValid(LocalPlayer())then
         LANG.Msg("spec_mode_warning")
      end

      -- reset cached server language in case it has changed
      RunConsoleCommand("_ttt_request_serverlang")
   elseif n == ROUND_ACTIVE then
      -- round starts
      VOICE.CycleMuteState(MUTE_NONE)

      CLSCORE:ClearPanel()

      -- people may have died and been searched during prep
      for _, p in pairs(player.GetAll()) do
         p.search_result = nil
      end

      -- clear blood decals produced during prep
      RunConsoleCommand("r_cleardecals")

      GAMEMODE.StartingPlayers = #util.GetAlivePlayers()
   elseif n == ROUND_POST then
      RunConsoleCommand("ttt_cl_traitorpopup_close")
   end

   -- stricter checks when we're talking about hooks, because this function may
   -- be called with for example o = WAIT and n = POST, for newly connecting
   -- players, which hooking code may not expect
   if n == ROUND_PREP then
      -- can enter PREP from any phase due to ttt_roundrestart
      hook.Call("TTTPrepareRound", GAMEMODE)
   elseif (o == ROUND_PREP) and (n == ROUND_ACTIVE) then
      hook.Call("TTTBeginRound", GAMEMODE)
   elseif (o == ROUND_ACTIVE) and (n == ROUND_POST) then
      hook.Call("TTTEndRound", GAMEMODE)
   end

   -- whatever round state we get, clear out the voice flags
   for k,v in pairs(player.GetAll()) do
      v.traitor_gvoice = false
   end
end

concommand.Add("ttt_print_playercount", function() print(GAMEMODE.StartingPlayers) end)

--- optional sound cues on round start and end
CreateConVar("ttt_cl_soundcues", "0", FCVAR_ARCHIVE)

local cues = {
   Sound("ttt/thump01e.mp3"),
   Sound("ttt/thump02e.mp3")
};
local function PlaySoundCue()
   if GetConVar("ttt_cl_soundcues"):GetBool() then
      surface.PlaySound(table.Random(cues))
   end
end

GM.TTTBeginRound = PlaySoundCue
GM.TTTEndRound = PlaySoundCue

--- usermessages
netstream.Hook("TTT_Role", function(data)
	if (!LocalPlayer().SetRole) then return; end;
	
	LocalPlayer():SetRole(data.role);
	Msg("You are: "..string.upper(LocalPlayer():GetRoleName()));
end);

netstream.Hook("TTT_RoleList", function(data)
	local role = data.role;
	local entIndex = data.role_ids;
	
	for k, v in pairs(entIndex) do
		local curPlayer = player.GetByID(v);
		if (IsValid(curPlayer)) then
			curPlayer:SetRole(role);
		end;
		
		if (curPlayer:IsRoleGroup(RG_BAD)) then
			curPlayer.traitor_gvoice = false;
		end;
	end;
end);

netstream.Hook("TTT_RoundState", function(data)
   local o = GetRoundState();
   GAMEMODE.round_state = data.state;

   if (o != GAMEMODE.round_state) then
      RoundStateChange(o, GAMEMODE.round_state);
   end;

   MsgN("Round state: "..GAMEMODE.round_state);
end);

-- Cleanup at start of new round
function GM:ClearClientState()
   GAMEMODE:HUDClear()

   local client = LocalPlayer()
   if not client.SetRole then return end -- code not loaded yet

   client:SetRole(ROLE_INNOCENT)

   client.equipment_items = EQUIP_NONE
   client.equipment_credits = 0
   client.bought = {}
   client.last_id = nil
   client.radio = nil
   client.called_corpses = {}

   VOICE.InitBattery()

   for _, p in pairs(player.GetAll()) do
      if IsValid(p) then
         p.sb_tag = nil
         p:SetRole(ROLE_INNOCENT)
         p.search_result = nil
      end
   end

   VOICE.CycleMuteState(MUTE_NONE)
   RunConsoleCommand("ttt_mute_team_check", "0")

   if GAMEMODE.ForcedMouse then
      gui.EnableScreenClicker(false)
   end
end
net.Receive("TTT_ClearClientState", GM.ClearClientState)

function GM:CleanUpMap()
   -- Ragdolls sometimes stay around on clients. Deleting them can create issues
   -- so all we can do is try to hide them.
   for _, ent in pairs(ents.FindByClass("prop_ragdoll")) do
      if IsValid(ent) and CORPSE.GetPlayerNick(ent, "") != "" then
         ent:SetNoDraw(true)
         ent:SetSolid(SOLID_NONE)
         ent:SetColor(Color(0,0,0,0))

         -- Horrible hack to make targetid ignore this ent, because we can't
         -- modify the collision group clientside.
         ent.NoTarget = true
      end
   end

   -- This cleans up decals since GMod v100
   game.CleanUpMap()
end

-- server tells us to call this when our LocalPlayer has spawned
local function PlayerSpawn()
   local as_spec = net.ReadBit() == 1
   if as_spec then
      TIPS.Show()
   else
      TIPS.Hide()
   end
end
net.Receive("TTT_PlayerSpawned", PlayerSpawn)

local function PlayerDeath()
   TIPS.Show()
end
net.Receive("TTT_PlayerDied", PlayerDeath)

function GM:ShouldDrawLocalPlayer(ply) return false end

local view = {origin = vector_origin, angles = angle_zero, fov=0}
function GM:CalcView( ply, origin, angles, fov )
   view.origin = origin
   view.angles = angles
   view.fov    = fov

   -- first person ragdolling
   if ply:Team() == TEAM_SPEC and ply:GetObserverMode() == OBS_MODE_IN_EYE then
      local tgt = ply:GetObserverTarget()
      if IsValid(tgt) and (not tgt:IsPlayer()) then
         -- assume if we are in_eye and not speccing a player, we spec a ragdoll
         local eyes = tgt:LookupAttachment("eyes") or 0
         eyes = tgt:GetAttachment(eyes)
         if eyes then
            view.origin = eyes.Pos
            view.angles = eyes.Ang
         end
      end
   end


   local wep = ply:GetActiveWeapon()
   if IsValid(wep) then
      local func = wep.CalcView
      if func then
         view.origin, view.angles, view.fov = func( wep, ply, origin*1, angles*1, fov )
      end
   end

   return view
end

function GM:AddDeathNotice() end
function GM:DrawDeathNotice() end

function GM:Tick()
   local client = LocalPlayer()
   if IsValid(client) then
      if client:Alive() and client:Team() != TEAM_SPEC then
         WSWITCH:Think()
         RADIO:StoreTarget()
      end

      VOICE.Tick()
   end
end


-- Simple client-based idle checking
local idle = {ang = nil, pos = nil, mx = 0, my = 0, t = 0}
function CheckIdle()
   local client = LocalPlayer()
   if not IsValid(client) then return end

   if not idle.ang or not idle.pos then
      -- init things
      idle.ang = client:GetAngles()
      idle.pos = client:GetPos()
      idle.mx = gui.MouseX()
      idle.my = gui.MouseY()
      idle.t = CurTime()

      return
   end

   if GetRoundState() == ROUND_ACTIVE and client:IsTerror() and client:Alive() then
      local idle_limit = GetGlobalInt("ttt_idle_limit", 300) or 300
      if idle_limit <= 0 then idle_limit = 300 end -- networking sucks sometimes


      if client:GetAngles() != idle.ang then
         -- Normal players will move their viewing angles all the time
         idle.ang = client:GetAngles()
         idle.t = CurTime()
      elseif gui.MouseX() != idle.mx or gui.MouseY() != idle.my then
         -- Players in eg. the Help will move their mouse occasionally
         idle.mx = gui.MouseX()
         idle.my = gui.MouseY()
         idle.t = CurTime()
      elseif client:GetPos():Distance(idle.pos) > 10 then
         -- Even if players don't move their mouse, they might still walk
         idle.pos = client:GetPos()
         idle.t = CurTime()
      elseif CurTime() > (idle.t + idle_limit) then
         RunConsoleCommand("say", "(AUTOMATED MESSAGE) I have been moved to the Spectator team because I was idle/AFK.")

         timer.Simple(0.3, function()
                              RunConsoleCommand("ttt_spectator_mode", 1)
                              RunConsoleCommand("ttt_cl_idlepopup")
                           end)
      elseif CurTime() > (idle.t + (idle_limit / 2)) then
         -- will repeat
         LANG.Msg("idle_warning")
      end
   end
end
