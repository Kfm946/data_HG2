--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("HG2PlayerManagement")


debug_on = true

GetRandomNumber = function(self)

  local a = ScriptCB_random()
  if a == 0 then
    a = .0001
  end
  return a

end


-----------------------------
--MAP CONFIGURATION VARIABLES
-----------------------------
num_powerups = 20   --number of normal powerups to spawn
num_armor = 20      --number of armor powerups to spawn
pup_tMin = 90       --minimums and ranges for spawn times of each powerup type 
pup_tRng = 180
arm_tMin = 90
arm_tRng = 180
arm_tDur = 90       --armor pickup lifespan
spr_tMin = 180
spr_tRng = 240
pup_int = 10        --interval at which the powerupSpawner performs a check
pup_fake = 8        --probability (out of 10) that a normal powerup will NOT be fake

max_shields = 1000  --

minChange = 10      --movement distance for camper checker 
campTime = 90            --number of seconds a player is allowed to camp

loadscreen = math.ceil(GetRandomNumber()*4)


	--  Empire Attacking (attacker is always #1)
    local ALL = 2
    local IMP = 1
    --  These variables do not change
    local ATT = 1
    local DEF = 2
    
local game_state = 0
    
function ScriptPostLoad()	   
	
	
	 --normal mission script stuff  
    
    --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp_suburb"}
    cp2 = CommandPost:New{name = "cp_heights"}
    cp3 = CommandPost:New{name = "cp_canyon"}
    cp4 = CommandPost:New{name = "cp_slums"}
    cp_center = CommandPost:New{name = "cp_center"}
    cp_t1spawn = CommandPost:New{name = "cp_t1spawn"}
    cp_t2spawn = CommandPost:New{name = "cp_t2spawn"}
    
    
	    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
                                     textATT = "level.HGS.games1", 
                                     textDEF = "level.HGS.games2",
                                     multiplayerRules = true}
									 
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)    
    conquest:AddCommandPost(cp_center)
    conquest:AddCommandPost(cp_t1spawn)
    conquest:AddCommandPost(cp_t2spawn)    
    
    
    
    
--//****************************************************************************************\\
--||****************************Hunger Games Script*****************************************||
--\\****************************************************************************************//

    PlayerManager = HG2PlayerManagement:New{}
    teleCenter = GetPathPoint("center_spawn", 0)
    teleLobby = GetPathPoint("lobby_teleport", 0)
    
    --get nodes for superpowerup spawning
    local super_nodes = superpowers("super_spawn")
    
    team_mode = false
    SD_mode = false
    
    --Game state enumeration
    local IDLE = 0
    local REG = 1
    local GRACE = 2
    local GAMES = 3
    
    
    
--//**************************************************************\\
--||***********************Initial Setup**************************||
--\\**************************************************************//
    if ScriptCB_InMultiplayer() then
      print("Online; disabling bots.")
      AllowAISpawn(1, 0)
      AllowAISpawn(2, 0)
    end
      
    --save real Freecam function
    RealFreeCamFn = ScriptCB_Freecamera
    
    --save real Fake Console function
    RealFakeConFn = ff_DoCommand
    
    --overwrite fake console to prevent cheating
    ff_DoCommand = function(...)
      print("Used fake console.")
      return RealFakeConFn(unpack(arg))
    end
  
  --set new player points to zero; points will be set manually later
  local Player_Stats_Points_post = {
    { point_gain =  0  },     --//  PS_GLB_KILL_AI_PLAYER = 0,
    { point_gain =  0  },     --//  PS_GLB_KILL_HUMAN_PLAYER,
    { point_gain =  0  },     --//  PS_GLB_KILL_HUMAN_PLAYER_AI_OFF,
    { point_gain =  0  },     --//  PS_GLB_KILL_SUICIDE,    
    { point_gain =   0  },      --//  PS_GLB_KILL_TEAMMATE,
    { point_gain =  0  },     --//  PS_GLB_VEHICLE_KILL_INFANTRY_VS_VEHICLE,
    { point_gain =  0  },     --//  PS_GLB_VEHICLE_KILL_LIGHT_VS_HEAVY,
    { point_gain =  0  },     --//  PS_GLB_VEHICLE_KILL_LIGHT_VS_MEDIUM,
    { point_gain =  0  },     --//  PS_GLB_VEHICLE_KILL_HEAVY_VS_LIGHT,
    { point_gain =  0  },     --//  PS_GLB_VEHICLE_KILL_HEAVY_VS_MEDIUM,
    { point_gain =  0  },     --//  PS_GLB_VEHICLE_KILL_MEDIUM_VS_LIGHT,
    { point_gain =  0  },     --//  PS_GLB_VEHICLE_KILL_MEDIUM_VS_HEAVY,
    { point_gain =  0  },     --//  PS_GLB_VEHICLE_KILL_ATAT,
    { point_gain =  0  },     --//  PS_GLB_VEHICLE_KILL_EMPTY,
    { point_gain =   0  },      --//  PS_GLB_HEAL,
    { point_gain =   0  },      --//  PS_GLB_REPAIR,
    { point_gain =   0  },      --//  PS_GLB_SNIPER_ACCURACY,
    { point_gain =   0  },      --//  PS_GLB_HEAVY_WEAPON_MULTI_KILL,
    { point_gain =  0  },     --//  PS_GLB_RAMPAGE,
    { point_gain =   0  },      --//  PS_GLB_HEAD_SHOT,
    { point_gain =   0  },      --//  PS_GLB_KILL_HERO,
    { point_gain =  0  },     --//  PS_CON_CAPTURE_CP,
    { point_gain =  0  },     --//  PS_CON_ASSIST_CAPTURE_CP,
    { point_gain =  0  },     --//  PS_CON_KILL_ENEMY_CAPTURING_CP,
    { point_gain =  0  },     --//  PS_CON_DEFEND_CP,
    { point_gain =  0  },     --//  PS_CON_KING_HILL,
    { point_gain =  0  },     --//  PS_CAP_PICKUP_FLAG,
    { point_gain =  0  },     --//  PS_CAP_DEFEND_FLAG,
    { point_gain =  0  },     --//  PS_CAP_CAPTURE_FLAG,
    { point_gain =  0  },     --//  PS_CAP_DEFEND_FLAG_CARRIER,
    { point_gain =  0  },     --//  PS_CAP_KILL_ENEMY_FLAG_CARRIER,
    { point_gain =  0  },     --//  PS_CAP_KILL_ALLY_FLAG_CARRIER,
    { point_gain =  0  },     --//  PS_ASS_DESTROY_ASSAULT_OBJ,
    { point_gain =  0  },     --//  PS_ESC_DEFEND,
    { point_gain =  0  },     --//  PS_DEF_DEFEND,
  }
  
  --save the new points
  ScriptCB_SetPlayerStatsPoints( Player_Stats_Points_post )
  
  Player_Stats_Points_post = nil
    
  ScriptCB_SetCanSwitchSides(1)
  
  --set teams as friends
  SetTeamAsFriend(1, 2)
  SetTeamAsFriend(2, 1)
  
  --deactivate registration regions 
  DeactivateRegion("registration1")
  DeactivateRegion("registration2")
  ActivateRegion("exp_region")
  
  BlockPlanningGraphArcs("Connection_reg1");
  BlockPlanningGraphArcs("Connection_reg2");

  --set up lobby shields
--  print("Activating shields")
--  ActivateObject("reg_shield_blue1")
--  ActivateObject("reg_shield_blue2")
--  ActivateObject("reg_shield_red1")
--  ActivateObject("reg_shield_red2")
--  ActivateObject("exp_shield_blue1")
--  ActivateObject("exp_shield_blue2")
--  ActivateObject("exp_shield_red1")
--  ActivateObject("exp_shield_red2")

  KillObject("reg_shield_blue1")
  KillObject("reg_shield_blue2")
  KillObject("exp_shield_blue1")
  KillObject("exp_shield_blue2")
  RespawnObject("exp_shield_blue1")
  RespawnObject("exp_shield_blue2")
  KillObject("center_shield")
  
  --make CPs uncapturable
  SetClassProperty("com_bldg_controlzone", "NeutralizeTime", 999999)
  SetClassProperty("com_bldg_controlzone", "CaptureTime", 999999)
  
  VisualTimer = CreateTimer("VisualTimer")  --only one timer will be displayed 
  ShowTimer(VisualTimer)            --it will be stopped/started/reset to reflect the timers that control the actual game functions
  SetTimerValue(VisualTimer, 20)
  
  --add armor as drop item
  SetClassProperty("com_inf_default", "NextDropItem", "-")
  SetClassProperty("com_inf_default", "DropItemClass", "com_item_powerup_armor")
  SetClassProperty("com_inf_default", "DropItemProbability", 0.3)
  
  --set shield pickup function
  OnFlagPickUp(
    function(flag, character)
      print("\nOnFlagPickup() with args:", flag, character) 
      local charPtr = GetCharacterUnit(character)
       
      if GetEntityClass(flag) == FindEntityClass("com_item_powerup_armor") then
        local curShields = GetObjectShield(charPtr)
        
        if curShields >= max_shields/2 then
          SetProperty(charPtr, "CurShield", max_shields)
        else
          SetProperty(charPtr, "CurShield", curShields + max_shields/2)
        end
      
        KillObject(flag)
      end
    end
  )
  
    
    
  OnCharacterDeath( --THIS could happen anywhere, in or oustide the arena
    function(character, killer)
      print("\nOnCharacterDeath() with args:", character, killer) 
      if not character then print("\tNobody died...? Returning...") return
      --even if a guy dies, we still need to de-register him and stuff. 
      elseif not PlayerManager:PlayerExists(character)then 
        print("\tPlayer not registered, ignoring...")
        return 
      end
    
      --1. If the games haven't started, simply remove him from players_alive
      if game_state < GRACE then
        print("\tGames haven't started, removing the player from players_alive...")
        PlayerManager:DeRegisterPlayer(character)
        PlayerManager:RemovePlayer(character, false)
      
      --2. If the games have started, then this player must be assigned a rank
      else
        print("\tThe games have started, adding the player to players_eliminated")
        addPointsToChar(character, PlayerManager:RemovePlayer(character, true))
        print("\tThere are now this many players alive: ", PlayerManager:GetNumAlive())
        
        --SafetyCheck()
      end
    end
  )
  
  explore = OnEnterRegion(               
    function(region, character)
    print("\nOnEnterRegion() with args:", region, character) 
    if (game_state > IDLE) then return end  
    
    print("\tTeleporting player to the arena to explore...")
    local charUnit = GetCharacterUnit(character)
    SetEntityMatrix(charUnit, teleCenter)
    PlayerManager:SetIsExploring(character, true)
      
    end,
    "exp_region"
  )
  
  
---//**************************************************************\\
-- ||***********************Registration***************************||
---\\**************************************************************//
   
  registrationTimer = CreateTimer("registrationTimer")
  SetTimerValue(registrationTimer, 20)
  
  SwitchRespawn = CreateTimer("SwitchRespawn")
  SetTimerValue(SwitchRespawn, 5)
  
  charSpawn = OnCharacterSpawn(
    function(character)
      print("\nOnCharacterSpawn() with args:", character) 
      local charUnit = GetCharacterUnit(character)
      print("\tTaking away their sheilds")
      --TODO: Figure out what's wrong with this
      --SetProperty(charPtr, "CurShield", 0)
      PlayerManager:AddPlayer(character, charUnit, GetCharacterTeam(character))
      
      print("\tAdded player "..character.." to players_alive.\n")
      
    end
  ) 
  
  regSwitch = OnObjectKill(
    function(object, killer)
      if (killer ~= nil) then
        print("\nOnObjectKill() with args:", object, killer)
      end 
      --TODO: Teleport exploring players back to lobby.
      local name = GetEntityName(object)
      if name == "reg_switch" then
        if game_state < GRACE then
        
          --respawn the switch in 5 seconds
          SwitchRespawnElapse = OnTimerElapse(
            function(timer)
              RespawnObject("reg_switch")
              StopTimer(SwitchRespawn)
              SetTimerValue(SwitchRespawn, 5)
            end,
            SwitchRespawn
          )
          StartTimer(SwitchRespawn)
        end
        
        --do nothing if no killer
        if not killer then return end
        --do nothing unless killer is a human
        if not IsCharacterHuman(killer) then return end  
        --if killer is spamming, ignore it
        if PlayerManager:IsSpammingSwitch(killer) > 10 then return end
        
        print("Someone hit the switch.")
        
        --Close registration and reset
        if game_state == REG then
          ResetRegistration()
          print("\tRegistration is now CLOSED", game_state)
          print("\n")
          ShowMessageText("level.HG2.reg.closed")
        
        --open registration
        elseif game_state == IDLE then
          game_state = REG
          --MapAddRegionMarker("register2", "hud_objective_icon", 3.0, 1, "YELLOW", true, true, true) 
          --MapAddRegionMarker("team2_capture", "hud_objective_icon", 3.0, 2, "YELLOW", true, true, true) 
          --OpenRegistraton()    
          --Activate regions and start timers
          ActivateRegion("registration1")
          ActivateRegion("registration2")
          DeactivateRegion("exp_region")
          UnblockPlanningGraphArcs("Connection_reg1");
          UnblockPlanningGraphArcs("Connection_reg2");
          DisableBarriers("Barrier_reg1");
          DisableBarriers("Barrier_reg2");
          
          SwitchShields(true)
          PlayerManager:ReturnExploringPlayers(teleLobby)
          
          StartTimer(registrationTimer)
          StartTimer(VisualTimer)

          print("\tRegistration is now OPEN", game_state)
          print("\n")
          ShowMessageText("level.HG2.reg.open")
        end
        
      --TODO: Implement this maybe.
--      elseif name == "team_switch" then
--        team_mode = true
--      elseif name == "SD_switch" then
--        SD_mode = true
      end
    end
  )
    
    
  regTele1 = OnEnterRegion(               
    function(region, character)
    print("\nOnEnterRegion() with args:", region, character) 
    if game_state == REG then
      print("\tA player has entered the 1st registration region.")
      --deactivating regions temporarily to prevent double-registration
      DeactivateRegion("registration1")
      DeactivateRegion("registration2")
      
      print("\tFinding the character in the players_alive list")    
      if not PlayerManager:PlayerExists(character) then
        print("\tSomething went wrong, this player doesn't exist!")
        return
      
      elseif PlayerManager:IsRegistered(character) then
        print("\tSomething's not right, this person's already registered!")
        local charUnit = GetCharacterUnit(character)
        SetEntityMatrix(charUnit, teleCenter)
      
      else
        print("\tTeleporting player to the arena...")
        local charUnit = GetCharacterUnit(character)
        SetEntityMatrix(charUnit, teleCenter)
        
        print("\tDeactivating freecam")
        --overwrite Freecam to prevent cheaters from using it to find other people
        --REDEFINE FREE CAM FUNCTION (Thanks Zerted)
        ScriptCB_Freecamera = function(...)
          print("\nALERT: ScriptCB_Freecamera(): SOMEONE'S CHEATING!!!")
          print("\tInflicting punishment: ")
      
          print("\tKilling the player.")
          ScriptCB_PlayerSuicide(0)
          print("\tScolding them for their poor decisions.")
          ShowMessageText("level.HG2.cheater1")
          ShowMessageText("level.HG2.cheater2")
            
          return RealFreeCamFn(unpack(arg))
        end
        
        print("\tRegistering him now")
        PlayerManager:RegisterPlayer(character)
        print("\tThe player is registered:", PlayerManager:IsRegistered(character))
        print("\tThere are now this many registered players: ", PlayerManager:GetNumRegistered())
        
        ShowMessageText("level.HG2.reg.player")
      
        print("\tNew player registered, resetting timer value\n")
        SetTimerValue(registrationTimer, 20)
        SetTimerValue(VisualTimer, 20)
      end
  
      ActivateRegion("registration1")
      ActivateRegion("registration2")
    end
  end, 
  "registration1")
  
  regTele2 = OnEnterRegion(               
    function(region, character)
    print("\nOnEnterRegion() with args:", region, character)
    if game_state == REG then
      print("\tA player has entered the 2nd registration region.")
      --deactivating regions temporarily to prevent double-registration
      DeactivateRegion("registration1")
      DeactivateRegion("registration2")
      
      print("\tFinding the character in the players_alive list")    
      if not PlayerManager:PlayerExists(character) then
        print("\tSomething went wrong, this player doesn't exist!")
        return
      
      elseif PlayerManager:IsRegistered(character) then
        print("\tSomething's not right, this person's already registered!")
        local charUnit = GetCharacterUnit(character)
        SetEntityMatrix(charUnit, teleCenter)
      
      else
        print("\tTeleporting player to the arena...")
        local charUnit = GetCharacterUnit(character)
        SetEntityMatrix(charUnit, teleCenter)
        
        print("\tDeactivating freecam")
        --overwrite Freecam to prevent cheaters from using it to find other people
        --REDEFINE FREE CAM FUNCTION (Thanks Zerted)
        ScriptCB_Freecamera = function(...)
          print("\nALERT: ScriptCB_Freecamera(): SOMEONE'S CHEATING!!!")
          print("\tInflicting punishment: ")
      
          print("\tKilling the player.")
          ScriptCB_PlayerSuicide(0)
          print("\tScolding them for their poor decisions.")
          ShowMessageText("level.HG2.cheater1")
          ShowMessageText("level.HG2.cheater2")
            
          return RealFreeCamFn(unpack(arg))
        end
        
        print("\tRegistering him now")
        PlayerManager:RegisterPlayer(character)
        print("\tThe player is registered:", PlayerManager:IsRegistered(character))
        print("\tThere are now this many registered players: ", PlayerManager:GetNumRegistered())
        
        ShowMessageText("level.HG2.reg.player")
      
        print("\tNew player registered, resetting timer value\n")
        SetTimerValue(registrationTimer, 20)
        SetTimerValue(VisualTimer, 20)
      end
  
      ActivateRegion("registration1")
      ActivateRegion("registration2")
    end
  end, 
  "registration2")
    
  registerExpire = OnTimerElapse(
    function(timer)
      print("\nOnTimerElapse(registrationTimer)") 
      --if there are enough players registered (more than 1), the games can start
      if (PlayerManager:GetNumRegistered() > 1) then
                
        PlayerManager:KillUnregisteredPlayers()
        
        game_state = GRACE
      
        KillObject("cp_t1spawn")
        KillObject("cp_t2spawn")
        
        ReleaseCharacterSpawn(charSpawn)
        ReleaseEnterRegion(regTele1)
        ReleaseEnterRegion(regTele2)
        ReleaseObjectKill(regSwitch)
        
        print("\tWe have enough people, let's play.\n")
        
        --Destroy the registration zones/regions
        RemoveRegion("registration1")
        RemoveRegion("registration2")
        
        StopTimer(registrationTimer)
        DestroyTimer(SwitchRespawn)
        ReleaseTimerElapse(SwitchRespawnElapse)
        SwitchRespawnElapse = nil
        
                
        KillObject("reg_switch")
        --TODO: Set up these objects.
--        ActivateObject("com_inv_col_16_con1")
--        ActivateObject("com_inv_col_64_con2")
--        ActivateObject("com_inv_col_16_con3")
--        ActivateObject("com_inv_col_16_con4")
--        ActivateObject("com_inv_col_16_con")

        
        SetTimerValue(VisualTimer, 10)
        StartTimer(VisualTimer)
        StartTimer(RulesTimer)
        
        --TODO: Implement this.
        --RestoreAmmo()
        ShowMessageText("level.HG2.grace.rule3")
        ShowMessageText("level.HG2.grace.rule1")
        ShowMessageText("level.HG2.grace.rule2")
        print("Moving on to the grace period.\n\n")
        ResetRegistration = nil
      else
        print("Not enough people.")
        ResetRegistration()
        print("\tRegistration is now CLOSED", game_state)
        print("\n")
        ShowMessageText("level.HG2.reg.noplayers")
      end
    end,
    "registrationTimer"
  ) 
    
    
  function SwitchShields(reg)
    if (reg == true) then
      RespawnObject("reg_shield_blue1")
      RespawnObject("reg_shield_blue2")
      KillObject("exp_shield_blue1")
      KillObject("exp_shield_blue2")
      RespawnObject("center_shield")
    else
      KillObject("reg_shield_blue1")
      KillObject("reg_shield_blue2")
      RespawnObject("exp_shield_blue1")
      RespawnObject("exp_shield_blue2")
      KillObject("center_shield")
    end
  end
    
    
  function ResetRegistration()
    print("\nResetRegistration()") 
    game_state = IDLE
    StopTimer(registrationTimer)
    StopTimer(VisualTimer)
    SetTimerValue(registrationTimer, 20)
    SetTimerValue(VisualTimer, 20)
    
    --switch the shields back
    SwitchShields(false)
    
    --reactivate freecam
    ScriptCB_Freecamera = RealFreeCamFn
    
    PlayerManager:ResetRegistration(teleLobby)
    DeactivateRegion("registration1")
    DeactivateRegion("registration2")
    
    --reenable exploration
    ActivateRegion("exp_region")
      
    BlockPlanningGraphArcs("Connection_reg1");
    BlockPlanningGraphArcs("Connection_reg2");
    EnableBarriers("Barrier_reg1");
    EnableBarriers("Barrier_reg2");
    
    ShowMessageText("level.HG2.reg.reset")
  end
  
---//**************************************************************\\
-- ||***********************Grace Period***************************||
---\\**************************************************************//
  
  RulesTimer = CreateTimer("RulesTimer")
  SetTimerValue(RulesTimer, 7)
  RulesTimer3 = CreateTimer("RulesTimer3")
  SetTimerValue(RulesTimer3, 1)
  RulesTimer2 = CreateTimer("RulesTimer2")
  SetTimerValue(RulesTimer2, 1)
  RulesTimer1 = CreateTimer("RulesTimer1")
  SetTimerValue(RulesTimer1, 1)
  GraceTimer3 = CreateTimer("GraceTimer3")
  SetTimerValue(GraceTimer3, 1)
  GraceTimer2 = CreateTimer("GraceTimer2")
  SetTimerValue(GraceTimer2, 1)
  GraceTimer1 = CreateTimer("GraceTimer1")
  SetTimerValue(GraceTimer1, 1)
  GraceTimer = CreateTimer("GraceTimer") 
  SetTimerValue(GraceTimer, 27)
  
  --set countdown to beginning of grace period
  RulesElapse = OnTimerElapse(
    function(timer)
      print("Countdown: 3")
      ShowMessageText("level.HG2.grace.countdown")
      ShowMessageText("level.HG2.grace.3")
      StartTimer(RulesTimer3)
      
      --clean up previous timer
      DestroyTimer(registrationTimer)
      registrationTimer = nil
      ReleaseTimerElapse(registerExpire)
      registerExpire = nil
    end,
    "RulesTimer"
  )
  
  RulesElapse3 = OnTimerElapse(
    function(timer) 
      print("Countdown: 2")
      ShowMessageText("level.HG2.grace.2")
      StartTimer(RulesTimer2)
      
      --clean up previous timer
      ReleaseTimerElapse(RulesElapse)
      RulesElapse = nil
      DestroyTimer(RulesTimer)
      RulesTimer = nil
    end,
    "RulesTimer3"
  )
  
  RulesElapse2 = OnTimerElapse(
    function(timer)
      print("Countdown: 1")
      ShowMessageText("level.HG2.grace.1")
      StartTimer(RulesTimer1)
      
      --clean up previous timer
      ReleaseTimerElapse(RulesElapse3)
      RulesElapse3 = nil
      DestroyTimer(RulesTimer3)
      RulesTimer3 = nil
    end,
    "RulesTimer2"
  )
  
  RulesElapse1 = OnTimerElapse(
    function(timer)
      print("\nOnTimerElapse(RulesElapse1)") 
      print("The grace period has begun.\n")
      StartTimer(GraceTimer)
      PowerupSpawner(super_nodes)
      ShowMessageText("level.HG2.grace.begin")
      SetTimerValue(VisualTimer, 30)
      StartTimer(VisualTimer)
      
      --TODO: Destroy invisible barrier.
      
      --clean up previous timer
      ReleaseTimerElapse(RulesElapse2)
      RulesElapse2 = nil
      DestroyTimer(RulesTimer2)
      RulesTimer2 = nil
    end,
    "RulesTimer1"
  )

  --set countdown to beginning of grace period
  GraceElapse = OnTimerElapse(
    function(timer)
      print("GP Countdown: 3")
      ShowMessageText("level.HG2.grace.3")
      StartTimer(GraceTimer3)
    end,
    "GraceTimer"
  )

  GraceElapse3 = OnTimerElapse(
    function(timer) 
      print("GP Countdown: 2")
      ShowMessageText("level.HG2.grace.2")
      StartTimer(GraceTimer2)
      
      --clean up previous timer
      ReleaseTimerElapse(GraceElapse)
      GraceElapse = nil
      DestroyTimer(GraceTimer)
      GraceTimer = nil
    end,
    "GraceTimer3"
  )
  
  GraceElapse2 = OnTimerElapse(
    function(timer)
      print("GP Countdown: 1")
      ShowMessageText("level.HG2.grace.1")
      StartTimer(GraceTimer1)
      
      --clean up previous timer
      ReleaseTimerElapse(GraceElapse3)
      GraceElapse3 = nil
      DestroyTimer(GraceTimer3)
      GraceTimer3 = nil
    end,
    "GraceTimer2"
  )
  
  GraceElapse1 = OnTimerElapse(
    function(timer)
      print("\nOnTimerElapse(GraceElapse1)") 

      game_state = GAMES
      print("\nThe Games have begun!\n")
      ShowMessageText("level.HG2.games.begin")
      
      
      ClearAIGoals(1)
      ClearAIGoals(2)
      
      SetTeamAsEnemy(1, 1)
      SetTeamAsEnemy(1, 2)
      SetTeamAsEnemy(2, 1)
      SetTeamAsEnemy(2, 2)
      SetTeamAsEnemy(3, 3)
      
      StartTimer(CamperKillerTimer)
      SetTimerRate(VisualTimer, -1)
      StartTimer(VisualTimer)
      
      --clean up previous timer
      ReleaseTimerElapse(GraceElapse2)
      GraceElapse2 = nil
      DestroyTimer(GraceTimer2)
      GraceTimer2 = nil
    end,
    "GraceTimer1"
  )



---//**************************************************************\\
-- ||***********************During round***************************||
---\\**************************************************************//


    CamperKillerTimer = CreateTimer("CamperKillerTimer")
    SetTimerValue(CamperKillerTimer , 10)
    OnTimerElapse(
       function(timer)
          HG2PlayerManagement:CamperKiller(minChange, campTime)
          SetTimerValue(CamperKillerTimer, 10)
          StartTimer(CamperKillerTimer)
       end,
       "CamperKillerTimer"
    )


    print("Conquest is about to start")
    conquest:Start() 

    ClearAIGoals(1)
    ClearAIGoals(2)
    AddAIGoal(1, "Deathmatch", 100)
    AddAIGoal(2, "Deathmatch", 100)
    print("End of post script\n")
	
 end


---------------------------------------------------------------------------
-- FUNCTION:    ScriptInit
-- PURPOSE:     This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
--              mission script must contain a version of this function, as
--              it is called from C to start the mission.
---------------------------------------------------------------------------

function ScriptInit()
    
    ReadDataFile("ingame.lvl")
    ReadDataFile("dc:ingame.lvl")



    SetMaxFlyHeight(40)
	SetMaxPlayerFlyHeight(40)
    
	
    SetMemoryPoolSize ("ClothData",20)
    SetMemoryPoolSize ("Combo",50)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",650)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",650) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",650)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",550)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",6000)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",100)     -- should be ~1x #combo  
    
    
    ReadDataFile("sound\\tat.lvl;tat2gcw")
    ReadDataFile("SIDE\\all.lvl",
                    "all_inf_rifleman",
                    "all_inf_rocketeer",
                    "all_inf_sniper",
                    "all_inf_engineer",
                    "all_inf_officer",
                    "all_inf_wookiee",
                    "all_hero_hansolo_tat")
                    
    ReadDataFile("SIDE\\imp.lvl",
                    "imp_inf_rifleman",
                    "imp_inf_rocketeer",
                    "imp_inf_engineer",
                    "imp_inf_sniper",
                    "imp_inf_officer",
                    "imp_inf_dark_trooper",
                    "imp_hero_bobafett",
                    "imp_fly_destroyer_dome" )
 
	SetupTeams{
		all = {
			team = ALL,
			units = 20,
			reinforcements = 150,
			soldier	= { "all_inf_rifleman",9, 25},
			assault	= { "all_inf_rocketeer",1,4},
			engineer = { "all_inf_engineer",1,4},
			sniper	= { "all_inf_sniper",1,4},
			officer	= { "all_inf_officer",1,4},
			special	= { "all_inf_wookiee",1,4},

		},
		imp = {
			team = IMP,
			units = 20,
			reinforcements = 150,
			soldier	= { "imp_inf_rifleman",9, 25},
			assault	= { "imp_inf_rocketeer",1,4},
			engineer = { "imp_inf_engineer",1,4},
			sniper	= { "imp_inf_sniper",1,4},
			officer	= { "imp_inf_officer",1,4},
			special	= { "imp_inf_dark_trooper",1,4},
		},
	}
    
    SetHeroClass(ALL, "all_hero_hansolo_tat")
    SetHeroClass(IMP, "imp_hero_bobafett")

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    
    local weaponCnt = 1024
    SetMemoryPoolSize("Aimer", 75)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 1024)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 32)
	SetMemoryPoolSize("EntityFlyer", 32)
    SetMemoryPoolSize("EntityHover", 32)
    SetMemoryPoolSize("EntityLight", 200)
    SetMemoryPoolSize("EntitySoundStream", 4)
    SetMemoryPoolSize("EntitySoundStatic", 32)
    SetMemoryPoolSize("MountedTurret", 32)
	SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
    SetMemoryPoolSize ("SoldierAnimation",512)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
  SetMemoryPoolSize("FlagItem", 512)
  SetMemoryPoolSize("PowerupItem", 512)

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("dc:HG2\\HG2.lvl", "HG2_conquest")
    SetDenseEnvironment("false")


    --  Sound Stats
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "all_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "des_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "imp_unit_vo_quick", voiceQuick)    
    
    OpenAudioStream("sound\\global.lvl",  "gcw_music")
    OpenAudioStream("sound\\tat.lvl",  "tat2")
    OpenAudioStream("sound\\tat.lvl",  "tat2")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")

    SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

    SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

    SetOutOfBoundsVoiceOver(2, "Allleaving")
    SetOutOfBoundsVoiceOver(1, "Impleaving")

    SetAmbientMusic(ALL, 1.0, "all_tat_amb_start",  0,1)
    SetAmbientMusic(ALL, 0.8, "all_tat_amb_middle", 1,1)
    SetAmbientMusic(ALL, 0.2, "all_tat_amb_end",    2,1)
    SetAmbientMusic(IMP, 1.0, "imp_tat_amb_start",  0,1)
    SetAmbientMusic(IMP, 0.8, "imp_tat_amb_middle", 1,1)
    SetAmbientMusic(IMP, 0.2, "imp_tat_amb_end",    2,1)

    SetVictoryMusic(ALL, "all_tat_amb_victory")
    SetDefeatMusic (ALL, "all_tat_amb_defeat")
    SetVictoryMusic(IMP, "imp_tat_amb_victory")
    SetDefeatMusic (IMP, "imp_tat_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")

    --  Camera Stats
    --Tat2 Mos Eisley
	AddCameraShot(0.974338, -0.222180, 0.035172, 0.008020, -82.664650, 23.668301, 43.955681);
	AddCameraShot(0.390197, -0.089729, -0.893040, -0.205362, 23.563562, 12.914885, -101.465561);
	AddCameraShot(0.169759, 0.002225, -0.985398, 0.012916, 126.972809, 4.039628, -22.020613);
	AddCameraShot(0.677453, -0.041535, 0.733016, 0.044942, 97.517807, 4.039628, 36.853477);
	AddCameraShot(0.866029, -0.156506, 0.467299, 0.084449, 7.685640, 7.130688, -10.895234);
end


function addPointsToChar(character, dpoints)
  --=======================================
  -- Point changes
  --=======================================
  local Player_Stats_Points = {
    { point_gain =  0  },     --//  PS_GLB_KILL_AI_PLAYER = 0,
    { point_gain =  0  },     --//  PS_GLB_KILL_HUMAN_PLAYER,
    { point_gain =  0  },     --//  PS_GLB_KILL_HUMAN_PLAYER_AI_OFF,
    { point_gain =  -dpoints  },      --//  PS_GLB_KILL_SUICIDE,    
    { point_gain =   0  },      --//  PS_GLB_KILL_TEAMMATE,
    { point_gain =  0  },     --//  PS_GLB_VEHICLE_KILL_INFANTRY_VS_VEHICLE,
    { point_gain =  0  },     --//  PS_GLB_VEHICLE_KILL_LIGHT_VS_HEAVY,
    { point_gain =  0  },     --//  PS_GLB_VEHICLE_KILL_LIGHT_VS_MEDIUM,
    { point_gain =  0  },     --//  PS_GLB_VEHICLE_KILL_HEAVY_VS_LIGHT,
    { point_gain =  0  },     --//  PS_GLB_VEHICLE_KILL_HEAVY_VS_MEDIUM,
    { point_gain =  0  },     --//  PS_GLB_VEHICLE_KILL_MEDIUM_VS_LIGHT,
    { point_gain =  0  },     --//  PS_GLB_VEHICLE_KILL_MEDIUM_VS_HEAVY,
    { point_gain =  0  },     --//  PS_GLB_VEHICLE_KILL_ATAT,
    { point_gain =  0  },     --//  PS_GLB_VEHICLE_KILL_EMPTY,
    { point_gain =   0  },      --//  PS_GLB_HEAL,
    { point_gain =   0  },      --//  PS_GLB_REPAIR,
    { point_gain =   0  },      --//  PS_GLB_SNIPER_ACCURACY,
    { point_gain =   0  },      --//  PS_GLB_HEAVY_WEAPON_MULTI_KILL,
    { point_gain =  0  },     --//  PS_GLB_RAMPAGE,
    { point_gain =   0  },      --//  PS_GLB_HEAD_SHOT,
    { point_gain =   0  },      --//  PS_GLB_KILL_HERO,
    { point_gain =  0  },     --//  PS_CON_CAPTURE_CP,
    { point_gain =  0  },     --//  PS_CON_ASSIST_CAPTURE_CP,
    { point_gain =  0  },     --//  PS_CON_KILL_ENEMY_CAPTURING_CP,
    { point_gain =  0  },     --//  PS_CON_DEFEND_CP,
    { point_gain =  0  },     --//  PS_CON_KING_HILL,
    { point_gain =  0  },     --//  PS_CAP_PICKUP_FLAG,
    { point_gain =  0  },     --//  PS_CAP_DEFEND_FLAG,
    { point_gain =  0  },     --//  PS_CAP_CAPTURE_FLAG,
    { point_gain =  0  },     --//  PS_CAP_DEFEND_FLAG_CARRIER,
    { point_gain =  0  },     --//  PS_CAP_KILL_ENEMY_FLAG_CARRIER,
    { point_gain =  0  },     --//  PS_CAP_KILL_ALLY_FLAG_CARRIER,
    { point_gain =  dpoints  },     --//  PS_ASS_DESTROY_ASSAULT_OBJ,
    { point_gain =  0  },     --//  PS_ESC_DEFEND,
    { point_gain =  0  },     --//  PS_DEF_DEFEND,
  }
  
  --save the new points
  ScriptCB_SetPlayerStatsPoints( Player_Stats_Points )
  
  --clean up some memory  --is this needed as its about to go out of scope?
  Player_Stats_Points = nil

  AddAssaultDestroyPoints(character)

end


--------------------------------------------------------------
-- Manages spawning of normal/fake powerups
-- 
function PowerupSpawner(super_nodes)
  print("\nPowerupSpawner()")
  local powerupTable = {}
  
  --normal powerups
  for i=0,num_powerups-1 do
    local item = {timer = 0, spawn = NIL, type = "normal"}
    item.timer = math.ceil(GetRandomNumber()*1/pup_int)*pup_int+10
    item.spawn = GetPathPoint("normal_ammo_spawn", i)
    powerupTable[i] = item
  end
  
  --armor
  for i=num_powerups,num_powerups+num_armor-1 do
    local item = {timer = 0, spawn = NIL, type = "armor", spawned = false, goals = {}}
    --TODO: Change these values after the model is finished
    item.timer = math.ceil(GetRandomNumber()*1/pup_int)*pup_int+10
    item.spawn = GetPathPoint("armor_spawn", i-num_powerups)
    powerupTable[i] = item
  end
  
  --superpowerups
  local item = {timer = 0, spawn = NIL, type = "super"}
  --TODO: Change these values after powerups are made
  item.timer = math.ceil(GetRandomNumber()*1/pup_int)*pup_int+10
  item.spawn = super_nodes
  powerupTable[num_powerups+num_armor] = item
  
  PowerupSpawnTimer = CreateTimer("PowerupSpawnTimer")
  SetTimerValue(PowerupSpawnTimer , pup_int)
  OnTimerElapse(
     function(timer)
        --iterate through the powerup table
        for i, v in pairs(powerupTable) do
          
          --if the timer is up for this powerup, spawn it and reset it
          if powerupTable[i].timer == 0 then
            if (powerupTable[i].type == "normal") then
              local powerup
              if (math.ceil(GetRandomNumber()*10) > 8) then
                powerup = "com_item_powerup_dual_fake"
              else
                powerup = "com_item_powerup_dual2"
              end
              
              --TODO: Remove this after new powerups have been added
              powerup = "com_item_powerup_dual"
              
              print("MESSAGE: PowerupSpawner(): Timer expired for normal powerup "..i.."; Spawning powerup now: \t"..powerup)
              CreateEntity(powerup, powerupTable[i].spawn, "nammo"..i)
              powerupTable[i].timer = math.ceil(GetRandomNumber()*pup_tRng/pup_int)*pup_int+pup_tMin
            
            elseif (powerupTable[i].type == "armor") then
              --if the armor hasn't been spawned, spawn it
              if powerupTable[i].spawned == false then
                print("MESSAGE: PowerupSpawner(): Timer expired for armor powerup "..i.."; Spawning armor now.") 
                CreateEntity("com_item_powerup_armor", powerupTable[i].spawn, "armor"..i)
                powerupTable[i].timer = arm_tDur
                powerupTable[i].spawned = true
                powerupTable[i].goals[0] = AddAIGoal(1, "CTFOffense", 50, "armor"..i, "null_region")
                powerupTable[i].goals[1] = AddAIGoal(2, "CTFOffense", 50, "armor"..i, "null_region")
              --if it has been spawned, kill it 
              else
                print("MESSAGE: PowerupSpawner(): Timer expired for armor powerup "..i.."; Killing armor now.")
                DeleteAIGoal(powerupTable[i].goals[0])
                DeleteAIGoal(powerupTable[i].goals[1])
                KillObject("armor"..i)
                powerupTable[i].timer = math.ceil(GetRandomNumber()*arm_tRng/pup_int)*pup_int+arm_tMin
                powerupTable[i].spawned = false 
              end
          
            elseif (powerupTable[i].type == "super") then
              print("MESSAGE: PowerupSpawner(): Timer expired for super powerups; Spawning all superpowerups now.") 
              CreateEntity("com_item_powerup_dual", powerupTable[i].spawn[0], "super"..i)
              CreateEntity("com_item_powerup_dual", powerupTable[i].spawn[1], "super"..i)
              CreateEntity("com_item_powerup_dual", powerupTable[i].spawn[2], "super"..i)
              CreateEntity("com_item_powerup_dual", powerupTable[i].spawn[3], "super"..i)
              --we're done with superpowers now, remove them from the table
              powerupTable[i] = nil
            end
          --otherwise decrement the timer
          else
            powerupTable[i].timer = powerupTable[i].timer - pup_int
          end
        end
        
        --restart the timer
        SetTimerValue(PowerupSpawnTimer, pup_int)
        StartTimer(PowerupSpawnTimer)
     end,
     "PowerupSpawnTimer"
  )
  
  StartTimer(PowerupSpawnTimer)
end

superpowers = function(path)

  print("Superpowers has started.")
  node4 = math.ceil(GetRandomNumber()*3)-1
  print("MESSAGE: superpowers(): The node for the swamp is:", node4)
  node2 = math.ceil(GetRandomNumber()*3)+2
  print("MESSAGE: superpowers(): The node for the forest is:", node2)
  node3 = math.ceil(GetRandomNumber()*3)+5
  print("MESSAGE: superpowers(): The node for the town is:", node3)
  node1 = math.ceil(GetRandomNumber()*3)+8
  print("MESSAGE: superpowers(): The node for the mountain is:", node1)

  
  SPLocations = {"Swamp", "Forest", "Town", "Mountain"}
  
  local SPnodes = {node1, node2, node3, node4}

  local x = math.ceil(GetRandomNumber()*4)
  print("MESSAGE: superpowers(): The area for the adrenaline is:", SPLocations[x])
  super_spawn4 = GetPathPoint(path, SPnodes[x])
  table.remove(SPnodes, x)
  table.remove(SPLocations, x)
  local x = math.ceil(GetRandomNumber()*3)
  print("MESSAGE: superpowers(): The area for the full restore is:", SPLocations[x])
  super_spawn1 = GetPathPoint(path, SPnodes[x])
  table.remove(SPnodes, x)
  table.remove(SPLocations, x)
  x = math.ceil(GetRandomNumber()*2)
  print("MESSAGE: superpowers(): The area for the invincibility is:", SPLocations[x])
  super_spawn2 = GetPathPoint(path, SPnodes[x])
  table.remove(SPnodes, x)
  table.remove(SPLocations, x)
  super_spawn3 = GetPathPoint(path, SPnodes[1])
  print("MESSAGE: superpowers(): The area for the one hit kill is:", SPLocations[1])
  table.remove(SPnodes, 1)
  table.remove(SPLocations, 1)
  
  return {super_spawn1, super_spawn2, super_spawn3, super_spawn4}
  
end
