--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")

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
check_map = false

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

max_shields = 1000

minChange = 10      --movement distance for camper checker 

loadscreen = math.ceil(GetRandomNumber()*4)



  --  REP Attacking (attacker is always #1)
    REP = 1;
    CIS = 2;
    --  These variables do not change
    ATT = REP;
    DEF = CIS;

    
function ScriptPostLoad()    
  
  
   --normal mission script stuff  
    
    --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}
    cp4 = CommandPost:New{name = "cp4"}
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
    
    ---------------------------------
    --VARIABLE/TABLE INITIALIZATION--
    ---------------------------------
    local unitLocations = {}              --used by camper killer to track players
    local players_alive = {}              --used for tracking various data related to each player alive
    local players_eliminated = {}         --used to store ranking for dead players
    
    
    
    
    --//**************************************************************\\
    --||***********************Initial Setup**************************||
    --\\**************************************************************//
    if ScriptCB_InMultiplayer() then
      print("Online; disabling bots.")
      AllowAISpawn(1, 0)
      AllowAISpawn(2, 0)
    end
      
   ---------------------------------------
   --If we're not in exploration mode, 
   --overwrite Freecam to prevent cheating
   ---------------------------------------
   if not check_map then 
    --REDEFINE FREE CAM FUNCTION
      --prevent cheaters from free caming to find other people
    RealFreeCamFn = ScriptCB_Freecamera

    ScriptCB_Freecamera = function(...)
      
      print("\nSOMEONE'S CHEATING!!!")
      print("Inflicting punishment: ")

       print("\tKilling the player.")
      ScriptCB_PlayerSuicide(0)
       print("\tScolding them for their poor decisions.")
      ShowMessageText("level.HG2.cheater1")
      ShowMessageText("level.HG2.cheater2")

      return RealFreeCamFn(unpack(arg))
    end
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
  
  
  --add armor as drop item
  SetClassProperty("com_inf_default", "NextDropItem", "-")
  SetClassProperty("com_inf_default", "DropItemClass", "com_item_powerup_armor")
  SetClassProperty("com_inf_default", "DropItemProbability", 0.3)
  
  --set shield pickup function
  OnFlagPickUp(
    function(flag, character)
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
  
  
  
  
  
  
    ---//**************************************************************\\
    -- ||***********************Registration***************************||
    ---\\**************************************************************//
    
    charSpawn = OnCharacterSpawn(
      function(character)
        print("Someone spawned.")
        local charUnit = GetCharacterUnit(character)
        --ShowObjectiveTextPopup("level.HGS.intro_popup")
        if check_map then 
        --TODO: Fix this once map is complete
  --        SetEntityMatrix(charUnit, destLoc)
  --        KillObject("com_inv_col_16_con1")
  --        KillObject("com_inv_col_64_con2")
  --        KillObject("com_inv_col_16_con3")
  --        KillObject("com_inv_col_16_con4")
  --        KillObject("com_inv_col_16_con")
        end
        print("\tTaking away their sheilds")
        --antipower(character)
        SetProperty(charPtr, "CurShield", 0)
        if not (players_alive[character] == nil) then return
        else players_alive[character] = {
          playerChar = character, 
          playerUnit = charUnit, 
          playerTeam = GetCharacterTeam(character),
          registered = false,
          spamCount = 0,
          isCamping = false,
          campCount = 0,
          hurtCount = 0 
          }
        end
        print("\tAdded "..character.." to players_alive.")
        number = RefreshListSize(players_alive)
        --ShowMessageText("level.HGS.debug.npa."..number)
  
      end
    )   
    
    OnCharacterDeath( --THIS could happen anywhere, in or oustide the arena
      function(character, killer)
        print("Ruh roh, someone died.")
        numPlayersAlive = GetPlayersAlive()
        
        if not character then print("What happened... nobody died...?") return end
        --even if a guy dies, we still need to de-register him and stuff. 
      
        --1. If the games haven't started, simply remove him from players_alive
        if playerReg == true then
          print("\tPlayer registration is open, so we'll just remove him from players_alive.")
          print("\tFound the player, is he registered?", players_alive[character].registered)
          print("\tRemoving the player from players_alive")
          RemoveFromList(character)
          numRegisteredPlayers = GetNumRegisteredPlayers(players_alive)
          print("\tThere are now this many registered players: ", numRegisteredPlayers)
          print(" ")
        
        
        
        --2. If the games have started, then this player must be assigned a rank
        else
          print("\tThe games have started, so we need to add him to the dead people list.")
          print("\tCreating his info table and adding him to players_eliminated")
          players_eliminated[character] = {playerChar = character,
                           playerRank = GetSize(players_eliminated)+1
                          }
          print("\tRemoving him from players alive")
          --players_alive[character] = nil
          RemoveFromList(character)
          numPlayersAlive = RefreshListSize(players_alive)
          addPointsToChar(character, players_eliminated[character].playerRank)
          print("\tThere are now this many players alive: ", numPlayersAlive)
    
        --3. If there's only 1 player left alive, then the game is over, that player is the winner
          -- if  RefreshListSize(players_alive) <= 1 then
            
            -- local j, k
            -- for j, k in pairs(players_alive) do
            -- print("\n\tThere's only one person left alive!! He's the winner!")
              -- if (players_alive[j] == nil) then
                -- print("something went wrong, player not found")
              -- else             
                -- local charUnit = players_alive[j].playerUnit
                -- addPointsToChar(players_alive[j].playerChar, 100)
                -- SetProperty(charUnit, "Team", 2)
                -- SetProperty(charUnit, "PerceivedTeam", 2)
                -- SetReinforcementCount(1, 1)
                -- AddReinforcements(1, -1)
              -- end
              -- SetReinforcementCount(1, 1)
              -- AddReinforcements(1, -1)
            -- end
          -- end
          SafetyCheck()
        end
      end
    )
    
    
    
    
    ---//**************************************************************\\
    -- ||***********************Grace Period***************************||
    ---\\**************************************************************//
    
    
    
    
    
    
    
    
    ---//**************************************************************\\
    -- ||***********************During round***************************||
    ---\\**************************************************************//
    
    CamperKillerTimer = CreateTimer("CamperKillerTimer")
    SetTimerValue(CamperKillerTimer , 10)
    OnTimerElapse(
       function(timer)
          CamperKiller(unitLocations, minChange, players_alive)
          SetTimerValue(CamperKillerTimer, 10)
          StartTimer(CamperKillerTimer)
       end,
       "CamperKillerTimer"
    )
  
  
  
  
  
    StartTimer(CamperKillerTimer)
    PowerupSpawner()
  
  
  
  
    print("Conquest is about to start")
    conquest:Start() 
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
    
    ReadDataFile("sound\\yav.lvl;yav1cw")
    ReadDataFile("SIDE\\rep.lvl",
                             "rep_inf_ep3_rifleman",
                             "rep_inf_ep3_rocketeer",
                             "rep_inf_ep3_engineer",
                             "rep_inf_ep3_sniper",
                             "rep_inf_ep3_officer",
                             "rep_inf_ep3_jettrooper",
                             "rep_hover_fightertank",
                             "rep_hero_anakin",
                             "rep_hover_barcspeeder")
    ReadDataFile("SIDE\\cis.lvl",
                             "cis_inf_rifleman",
                             "cis_inf_rocketeer",
                             "cis_inf_engineer",
                             "cis_inf_sniper",
                             "cis_inf_officer",
                             "cis_inf_droideka",
                             "cis_hero_darthmaul",
                             "cis_hover_aat")
                             
                             
    ReadDataFile("SIDE\\tur.lvl", 
          "tur_bldg_laser",
          "tur_bldg_tower")          
                             
  SetupTeams{
    rep = {
      team = REP,
      units = 20,
      reinforcements = 150,
      soldier  = { "rep_inf_ep3_rifleman",9, 25},
      assault  = { "rep_inf_ep3_rocketeer",1, 4},
      engineer = { "rep_inf_ep3_engineer",1, 4},
      sniper   = { "rep_inf_ep3_sniper",1, 4},
      officer = {"rep_inf_ep3_officer",1, 4},
      special = { "rep_inf_ep3_jettrooper",1, 4},
          
    },
    cis = {
      team = CIS,
      units = 20,
      reinforcements = 150,
      special = { "cis_inf_droideka",1, 4},
    }
  }
     
    SetHeroClass(CIS, "cis_hero_darthmaul")
    SetHeroClass(REP, "rep_hero_anakin")
   

    --  Level Stats
    --  ClearWalkers()
    AddWalkerType(0, 4) -- special -> droidekas
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
    --ReadDataFile("dc:HG2\\HG2.lvl", "HG2_conquest")
    ReadDataFile("dc:HG2\\HG2.lvl", "HG2_conquest")
    SetDenseEnvironment("false")




    --  Sound
    
    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")

    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)
    
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    OpenAudioStream("sound\\yav.lvl",  "yav1")
    OpenAudioStream("sound\\yav.lvl",  "yav1")
    OpenAudioStream("sound\\yav.lvl",  "yav1_emt")

    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(2, "cisleaving")
    SetOutOfBoundsVoiceOver(1, "repleaving")

    SetAmbientMusic(REP, 1.0, "rep_yav_amb_start",  0,1)
    SetAmbientMusic(REP, 0.8, "rep_yav_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2, "rep_yav_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_yav_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.8, "cis_yav_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2, "cis_yav_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_yav_amb_victory")
    SetDefeatMusic (REP, "rep_yav_amb_defeat")
    SetVictoryMusic(CIS, "cis_yav_amb_victory")
    SetDefeatMusic (CIS, "cis_yav_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",      "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut",     "binocularzoomout")
    --SetSoundEffect("BirdScatter",             "birdsFlySeq1")
    --SetSoundEffect("WeaponUnableSelect",      "com_weap_inf_weaponchange_null")
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
-- Monitors positions of players and hurts them if they have been camping
--
-- @param unit_locations          table of tables containing x, y, and z coordinates
-- @param #int min_distance    min distance a player must move to avoid damage
-- @param player_list             table containing player info entries
function CamperKiller(unit_locations, min_distance, player_list)
   print("\nChecking for campers...")
   
   local CampCheck = function( player, unit )
      print("Checking player ", player)
      if (player == nil) or (unit == nil) then return end   --check input
      local x, y, z = GetWorldPosition(unit)
      local currentPosition = {x, y, z}
      local previousPosition
      
      
      --start tracking a new player
      if unit_locations[player] == nil then
         print("\tStarting to track player")
         unit_locations[player] = currentPosition
         --PrintMatrix(unit_locations[player])
         return
      else
         --previous location = last stored location
         print("\tPlayer is already being tracked.")
         previousPosition = unit_locations[player]
      end
     
     --see if the player has been camping
      if math.abs(previousPosition[1] - currentPosition[1]) < min_distance
         and math.abs(previousPosition[2] - currentPosition[2]) < 20
         and math.abs(previousPosition[3] - currentPosition[3]) < min_distance then
         print("\tPlayer has not moved.")
         --they've now been stationary for another interval, raise interval count
         player_list[player].campCount = player_list[player].campCount + 1
         print("\tPlayer has been in stationary for this many intervals:", player_list[player].campCount)
         
         --If they've been camping for long enough (90 seconds), then they're in trouble.
         if player_list[player].campCount >= 9 then
            print("\tPlayer is camping, applying health degen.")
            
            --They might have full health, so the health degen has to be triggered; take away 1 health unit
            if player_list[player].hurtCount == 0 then
               unitHealth = (GetObjectHealth(unit) - 1)
               SetProperty(unit, "CurHealth", unitHealth)
            end
            SetProperty(unit, "AddHealth", -10)
            
            --they are now camping
            if not player_list[player].isCamping then
               player_list[player].isCamping = true
            end
      
         end
         
         
         print(" ")
         return
         
      else      -- their position has changed more than 10 units
         print("\tPlayer has moved.")
         
         --if they WERE camping
         if player_list[player].isCamping then
            
            -- they're moving now so reduce the damage
            SetProperty(unit, "AddHealth", -5)
            
            --increase the number of intervals they've been hurt but moving
            print("\tThe player was camping, so track amount of time they're still being hurt for.")
            player_list[player].hurtCount = player_list[player].hurtCount + 1
            
            --if they've kept moving while being hurt for 3 intervals, then they've had enough
            if player_list[player].hurtCount > 3 then
               print("\tThey've kept moving, so stop hurting them and reset their info.")
               -- reset everything
               SetProperty(unit, "AddHealth", 0)
               player_list[player].isCamping = false
               player_list[player].campCount = 0
               player_list[player].hurtCount = 0
            
            else   -- if they haven't been hurt for long enough, keep hurting them
               print("\tPlayer has been hurt for "..player_list[player].hurtCount.." intervals.")
            end
               
         end
            -- they've moved, so we need to record their new position
            print("\tRecording their current position.\n")
            unit_locations[player] = currentPosition
         return
      end
   end
   
   --run camp check for each player alive
   local i, v
   for i, v in pairs(player_list) do
      CampCheck(i, GetCharacterUnit(i) )
   end   
      
end


--------------------------------------------------------------
-- Manages spawning of normal/fake powerups
-- 
function PowerupSpawner(self)
  print("Started PowerupSpawner()")
  local powerupTable = {}
  for i=0,num_powerups-1 do
    local item = {timer = 0, spawn = NIL, type = "normal"}
    item.timer = math.ceil(GetRandomNumber()*pup_tMin/pup_int)+pup_tRng
    item.spawn = GetPathPoint("normal_ammo_spawn", i)
    powerupTable[i] = item
  end
  
  for i=num_powerups,num_powerups+num_armor-1 do
    local item = {timer = 0, spawn = NIL, type = "armor", spawned = false}
    --TODO: Change these values after the model is finished
    item.timer = math.ceil(GetRandomNumber()*1/pup_int)*pup_int+10
    --TODO: Change this once the armor spawn path is created
    item.spawn = GetPathPoint("normal_ammo_spawn", i-num_powerups)
    powerupTable[i] = item
  end
  
  for i=num_powerups+num_armor,num_powerups+num_armor+3 do
    local item = {timer = 0, spawn = NIL, type = "armor", spawned = false}
    --TODO: Change these values after powerups are made
    item.timer = math.ceil(GetRandomNumber()*1/pup_int)*pup_int+10
    --TODO: Change this once the super spawn path is created
    item.spawn = GetPathPoint("normal_ammo_spawn", i)
    powerupTable[i] = item
  end
  
  PowerupSpawnTimer = CreateTimer("PowerupSpawnTimer")
  SetTimerValue(PowerupSpawnTimer , pup_int)
  OnTimerElapse(
     function(timer)
        --iterate through the powerup table
        for i, v in pairs(powerupTable) do
          
          if (powerupTable[i].type == "normal") then
            --if the timer is up for this powerup, spawn it and reset it
            if powerupTable[i].timer == 0 then
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
              powerupTable[i].timer = math.ceil(GetRandomNumber()*180/pup_int)*pup_int+90
            else
              powerupTable[i].timer = powerupTable[i].timer - pup_int
            end
            
          elseif (powerupTable[i].type == "armor") then
            --if the timer is up for this powerup, spawn it and reset it
            if powerupTable[i].timer == 0 then
              --if the armor hasn't been spawned, spawn it
              if powerupTable[i].spawned == false then
                print("MESSAGE: PowerupSpawner(): Timer expired for armor powerup "..i.."; Spawning armor now.") 
                CreateEntity("com_item_powerup_armor", powerupTable[i].spawn, "armor"..i)
                powerupTable[i].timer = arm_tDur
                powerupTable[i].spawned = true
              --if it has been spawned, kill it 
              else
                print("MESSAGE: PowerupSpawner(): Timer expired for armor powerup "..i.."; Killing armor now.")
                KillObject("armor"..i)
                powerupTable[i].timer = math.ceil(GetRandomNumber()*arm_tRng/pup_int)*pup_int+90
                powerupTable[i].spawned = false 
              end
            else
              powerupTable[i].timer = powerupTable[i].timer - pup_int
            end
          
          elseif (powerupTable[i].type == "super") then
            --if the timer is up for this powerup, spawn it and reset it
            if powerupTable[i].timer == 0 then
              print("MESSAGE: PowerupSpawner(): Timer expired for armor powerup "..i.."; Spawning armor now.") 
              CreateEntity("com_item_powerup_armor", powerupTable[i].spawn, "armor"..i)
              powerupTable[i].timer = arm_tDur
              powerupTable[i].spawned = true 
            else
              powerupTable[i].timer = powerupTable[i].timer - pup_int
            end
              
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


