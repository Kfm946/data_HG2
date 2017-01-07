--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")

debug_on = false
check_map = false

GetRandomNumber = function(self)

	local a = ScriptCB_random()
	if a == 0 then
		a = .0001
	end
	return a

end

loadscreen = math.ceil(GetRandomNumber()*4)
	
---------------------------------------------------------------------------
-- ScriptPostLoad
---------------------------------------------------------------------------
function ScriptPostLoad()
	
	-- local WeatherMode
	
	-- function createObj()
		
		-- local objPos = CreateMatrix(0,0,0,0,-300,1,-300)		
		
		-- if WeatherMode <= 2 then 
			-- CreateEntity("com_item_healthrecharge_dummy", objPos, "nightObj")
			-- print("Creating nightObj...")
		-- else
			-- CreateEntity("com_item_weaponrecharge_dummy", objPos, "dayObj")
			-- print("Not creating nightObj...")
		-- end
	-- end

	
	
		
	-- loadSky = OnObjectCreate(
		-- function(object)
			-- name = GetEntityName(object)
			-- if name == "nightObj" then 
				-- ReadDataFile("dc:HGS\\HGS_sky.lvl", "night")
				-- print("Night time")
			-- else
				-- ReadDataFile("dc:HGS\\HGS_sky.lvl", "norm")
				-- print("Day time")
			-- end
		-- end
	-- )

	

	-- function GetWeatherMode()
		-- print("ScriptCB_GetAmHost() = ")
		-- print(ScriptCB_GetAmHost())
		-- WeatherMode = math.ceil(GetRandomNumber()*4)
		-- return WeatherMode
	-- end
	
	-- if ScriptCB_GetAmHost() then
		-- print("I AM THE HOST.")
		-- WeatherMode = GetWeatherMode()
		-- createObj()
	-- end
	
	-- ReleaseObjectCreate(loadSky)
	-- loadSky = nil
	
	-- 
	-- weather()
		
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
			ShowMessageText("level.HGS.cheater1")
			ShowMessageText("level.HGS.cheater2")

			return RealFreeCamFn(unpack(arg))
		end
	end
	
	
	--SET ALL POINTS TO 0
		--Points will be given to players when they die according to their ranking in the round
		local Player_Stats_Points_post = {
		{ point_gain =  0  },			--//	PS_GLB_KILL_AI_PLAYER = 0,
		{ point_gain =  0  },			--//	PS_GLB_KILL_HUMAN_PLAYER,
		{ point_gain =  0  },			--//	PS_GLB_KILL_HUMAN_PLAYER_AI_OFF,
		{ point_gain =  0	},			--//	PS_GLB_KILL_SUICIDE,		
		{ point_gain =   0  },			--//	PS_GLB_KILL_TEAMMATE,
		{ point_gain =  0  },			--//	PS_GLB_VEHICLE_KILL_INFANTRY_VS_VEHICLE,
		{ point_gain =  0  },			--//	PS_GLB_VEHICLE_KILL_LIGHT_VS_HEAVY,
		{ point_gain =  0  },			--//	PS_GLB_VEHICLE_KILL_LIGHT_VS_MEDIUM,
		{ point_gain =  0  },			--//	PS_GLB_VEHICLE_KILL_HEAVY_VS_LIGHT,
		{ point_gain =  0  },			--//	PS_GLB_VEHICLE_KILL_HEAVY_VS_MEDIUM,
		{ point_gain =  0  },			--//	PS_GLB_VEHICLE_KILL_MEDIUM_VS_LIGHT,
		{ point_gain =  0  },			--//	PS_GLB_VEHICLE_KILL_MEDIUM_VS_HEAVY,
		{ point_gain =  0  },			--//	PS_GLB_VEHICLE_KILL_ATAT,
		{ point_gain =  0  },			--//	PS_GLB_VEHICLE_KILL_EMPTY,
		{ point_gain =   0  },			--//	PS_GLB_HEAL,
		{ point_gain =   0  },			--//	PS_GLB_REPAIR,
		{ point_gain =   0  },			--//	PS_GLB_SNIPER_ACCURACY,
		{ point_gain =   0  },			--//	PS_GLB_HEAVY_WEAPON_MULTI_KILL,
		{ point_gain =  0  },			--//	PS_GLB_RAMPAGE,
		{ point_gain =   0  },			--//	PS_GLB_HEAD_SHOT,
		{ point_gain =   0  },			--//	PS_GLB_KILL_HERO,
		{ point_gain =  0  },			--//	PS_CON_CAPTURE_CP,
		{ point_gain =  0  },			--//	PS_CON_ASSIST_CAPTURE_CP,
		{ point_gain =  0  },			--//	PS_CON_KILL_ENEMY_CAPTURING_CP,
		{ point_gain =  0  },			--//	PS_CON_DEFEND_CP,
		{ point_gain =  0  },			--//	PS_CON_KING_HILL,
		{ point_gain =  0  },			--//	PS_CAP_PICKUP_FLAG,
		{ point_gain =  0  },			--//	PS_CAP_DEFEND_FLAG,
		{ point_gain =  0  },			--//	PS_CAP_CAPTURE_FLAG,
		{ point_gain =  0  },			--//	PS_CAP_DEFEND_FLAG_CARRIER,
		{ point_gain =  0  },			--//	PS_CAP_KILL_ENEMY_FLAG_CARRIER,
		{ point_gain =  0  },			--//	PS_CAP_KILL_ALLY_FLAG_CARRIER,
		{ point_gain =  0  },			--//	PS_ASS_DESTROY_ASSAULT_OBJ,
		{ point_gain =  0  },			--//	PS_ESC_DEFEND,
		{ point_gain =  0  },			--//	PS_DEF_DEFEND,
	}
	
	--save the new points
	ScriptCB_SetPlayerStatsPoints( Player_Stats_Points_post )
	
	Player_Stats_Points_post = nil

	ScriptCB_SetCanSwitchSides(1)
	
	
	--NORMAL CONQUEST OBJECTIVE SETUP
	
	cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}
    cp4 = CommandPost:New{name = "cp4"}
	cp5 = CommandPost:New{name = "cp5"}
    cp6 = CommandPost:New{name = "cp6"}
    cp_center = CommandPost:New{name = "cp_center"}
    cp_center1 = CommandPost:New{name = "cp_center1"}
    cp_center2 = CommandPost:New{name = "cp_center2"}
    
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
	conquest:AddCommandPost(cp5) 
	conquest:AddCommandPost(cp6) 
	conquest:AddCommandPost(cp_center)
	conquest:AddCommandPost(cp_center1)
	conquest:AddCommandPost(cp_center2)
	
	
	

--=================================================================--
------*******************HUNGER GAMES SCRIPT*******************------
--=================================================================--
	
	players_alive = {}
		--this list contains ALL of the information for each player that is needed for the various
		--functions of the games.
	
	players_eliminated = {}
		--when a player is eliminated, they are added to this list along with their rank
		
	playerReg = true			-- if true, the round is currently in the registration stage
	gracePeriod = false		-- if true, the round is currently in the Grace Period stage
	gamesStarted = false		-- if true, the Hunger Games have begun
	
	numPlayersAlive = 0		-- total number of players alive
	numRegisteredPlayers = 0	-- total number of players that have registered for the games
	
	
	print("Conquest is about to start")
    conquest:Start() 

	--Turn on the registration regions
	ActivateRegion("register2")
	ActivateRegion("team2_capture")
	KillObject("com_bldg_ctfbase2")
	KillObject("com_bldg_ctfbase3")
	
	--set up REGISTRATION variables
	destLoc = GetEntityMatrix("cp_center")
	teleBack = GetPathPoint("cp_center2_spawn", 0)
	
	--if this is false, the timer shouldn't be running, and nobody should be registered
	regOpen = false
	--if this is true, no players have registered yet, so the timer shouldn't be running
	firstReg = true
	
	
	--timer for registration period
	registrationTimer = CreateTimer("registrationTimer")
	SetTimerValue(registrationTimer, 20)

	
	SetProperty("registration_switch", "CurHealth", 4)
	SetProperty("registration_switch", "MaxHealth", 4)
	SetTeamAsFriend(1, 2)
	SetTeamAsFriend(2, 1)
	AllowAISpawn(1, false)
	AllowAISpawn(2, false)
	SetClassProperty("com_bldg_controlzone", "NeutralizeTime", 999999)
	SetClassProperty("com_bldg_controlzone", "CaptureTime", 999999)
	SetClassProperty("com_bldg_major_controlzone", "NeutralizeTime", 999999)
	SetClassProperty("com_bldg_major_controlzone", "CaptureTime", 999999)
		

	VisualTimer = CreateTimer("VisualTimer")	--only one timer will be displayed 
	ShowTimer(VisualTimer)						--it will be stopped/started/reset to reflect the timers that control the actual game functions
	SetTimerValue(VisualTimer, 20)
		
	
	
	--------|||||| SET UP POWERUP FUNCTIONS |||||| ------------
    
	SetClassProperty("com_inf_default", "NextDropItem", "-")
	SetClassProperty("com_inf_default", "DropItemClass", "com_item_powerup_armor")
	SetClassProperty("com_inf_default", "DropItemProbability", 0.3)

	-- local shieldDropCnt = 0   -- debug variable used to count # times item is dropped

	OnFlagPickUp(
		function(flag, character)
			local charPtr = GetCharacterUnit(character)
		   
			if GetEntityClass(flag) == FindEntityClass("com_item_powerup_armor") then
									
				local curShields = GetObjectShield(charPtr)
				
			  --SetProperty(charPtr, "AddShield", 175) 
				
				local newShields = 0
				--print("ShieldRegen: Unit's current shields: ", curShields)
				if curShields >= 500 then
					newShields = 1000
				else
					newShields = curShields + 500
				end
				SetProperty(charPtr, "CurShield", newShields)
		  
				KillObject(flag)
				
				--shieldDropCnt = shieldDropCnt + 1

			end
		end
	)
		
		
	
	
	CheckPlayer = function(f, playersInAliveList)
	
			if not players_alive[f] then
				print("\tsomething went wrong, player not found")
				return false
			elseif (GetCharacterUnit(f) == nil) then 
				print("\tThis player doesn't exist or they're not alive.")
				RemoveFromList(f)
				return false
			else
				numRegisteredPlayers = GetNumRegisteredPlayers(players_alive)
			end
			if not playerReg then
				if (GetPlayersAlive() > 1) then
					return false
				end
				if  playersInAliveList <= 1 then
					print("\n\tThere's only one person left alive!! He's the winner!")
					if (players_alive[f]==nil) then
						print("\tSomething went wrong, player not found")
					else
						local charUnit = players_alive[f].playerUnit
						addPointsToChar(players_alive[f].playerChar, 100)
						SetProperty(charUnit, "Team", 2)
						SetProperty(charUnit, "PerceivedTeam", 2)
					end
					return true
				end
				if GetPlayersAlive() <= 1 then
					print("Something's gone terribly wrong, ending the map now")
					print("Setting Team 1 reinforcements to 0. The round SHOULD end now.")
					return true
				end
			end
		
	end
		
		
	--==============================--
	---***GRACE PERIOD TIMERS***---
	--==============================--

	ReadRules = CreateTimer("ReadRules")
		SetTimerValue(ReadRules, 7)
	rules1 = OnTimerElapse(
			function(timer)
				ReleaseTimerElapse(registerExpire)
				registerExpire = nil
				DestroyTimer(ReadRules)

				print("Doing a safety check")
				SafetyCheck()

				print("Moving all players to team 1")
				local i, v
				for i, v in pairs(players_alive) do
					
					if players_alive[i] == nil then
						print("something went wrong, this player doesn't exist!")
					else
						SetProperty(GetCharacterUnit(i), "PerceivedTeam", 1)
						SetProperty(GetCharacterUnit(i), "Team", 1)
						print("This player's team is now: ", GetCharacterTeam(players_alive[i].playerChar))
					end
				end
				
				ShowMessageText("level.HGS.gp_count")
				ShowMessageText("level.HGS.countdown3")
				
				local beesPos = CreateMatrix(0,0,0,0,171,.1, 108)
				CreateEntity("com_snd_amb_bees", beesPos, "bees_emitter")
				beesPos = nil
				
				StartTimer(countdown3_gp)
				
			end,
			ReadRules
			)
				
	countdown3_gp = CreateTimer("countdown3_gp")
		SetTimerValue(countdown3_gp, 1)
	countdown3_gpt = OnTimerElapse(
			function(timer)
				ReleaseTimerElapse(rules3)
				rules3 = nil
				ShowMessageText("level.HGS.countdown2")
				DestroyTimer(countdown3_gp)
				StartTimer(countdown2_gp)
			end,
			countdown3_gp
			) 
				
	countdown2_gp = CreateTimer("countdown2_gp")
		SetTimerValue(countdown2_gp, 1)
	countdown2_gpt = OnTimerElapse(
			function(timer)
				ReleaseTimerElapse(countdown3_gpt)
				countdown3_gpt = nil
				ShowMessageText("level.HGS.countdown1")
				DestroyTimer(countdown2_gp)
				StartTimer(countdown1_gp)
			end,
			countdown2_gp
			) 
		
	countdown1_gp = CreateTimer("countdown1_gp")
		SetTimerValue(countdown1_gp, 1)
	countdown1_gpt = OnTimerElapse(
			function(timer)
				ReleaseTimerElapse(countdown2_gpt)
				countdown2_gpt = nil
				print("The grace period has begun.")
				armorspawn()
				ShowMessageText("level.HGS.gp_begin")
				MapRemoveEntityMarker("cp_center")
				
				DestroyTimer(countdown1_gp)
				StartTimer(GracePeriodTimer)
				SetTimerValue(VisualTimer, 30)
				StartTimer(VisualTimer)
				
				KillObject("com_inv_col_16_con1")
				KillObject("com_inv_col_64_con2")
				KillObject("com_inv_col_16_con3")
				KillObject("com_inv_col_16_con4")
				KillObject("com_inv_col_16_con")

			end,
			countdown1_gp
			) 

	GracePeriodTimer = CreateTimer("GracePeriodTimer")
		SetTimerValue(GracePeriodTimer, 27)
	GracePeriodTimerE = OnTimerElapse(
			function(timer)
				ReleaseTimerElapse(countdown1_gpt)
				countdown1_gpt = nil
				ShowMessageText("level.HGS.countdown3")
				DestroyTimer(GracePeriodTimer)
				StartTimer(countdown3_hg)
			end,
			GracePeriodTimer
			) 	

	countdown1_hg = CreateTimer("countdown1_hg")
		SetTimerValue(countdown1_hg, 1)
	countdown1_hgt = OnTimerElapse(
			function(timer)
				ReleaseTimerElapse(countdown2_gpt)
				countdown2_gpt = nil
				DestroyTimer(countdown1_hg)
				gracePeriod = false
				gamesStarted = true
				SetTimerRate(VisualTimer, -1)
				StartTimer(VisualTimer)
						
				print("The Games have begun!\n")
				ShowMessageText("level.HGS.games_begun")
				SetTeamAsEnemy(1, 1)
				SetTeamAsEnemy(1, 2)
				SetTeamAsEnemy(2, 1)
				SetTeamAsEnemy(2, 2)
				SetTeamAsEnemy(3, 3)
				
				SetHGPoints()
				
				cpAmmoSpawn()
				superpowers()
				ammospawn()
				feast()
				
				StartTimer(CamperKillerTimer)
				
				end,
			countdown1_hg
			) 
			
	countdown2_hg = CreateTimer("countdown2_hg")
		SetTimerValue(countdown2_hg, 1)
	countdown2_hgt = OnTimerElapse(
			function(timer)
				ReleaseTimerElapse(countdown3_hgt)
				countdown3_hgt = nil
				ShowMessageText("level.HGS.countdown1", 1)
				ShowMessageText("level.HGS.countdown1", 2)
				DestroyTimer(countdown2_hg)
				StartTimer(countdown1_hg)
			end,
			countdown2_hg
			) 
			
	countdown3_hg = CreateTimer("countdown3_hg")
		SetTimerValue(countdown3_hg, 1)
	countdown3_hgt = OnTimerElapse(
			function(timer)
				ReleaseTimerElapse(GracePeriodTimerE)
				GracePeriodTimerE = nil
				ShowMessageText("level.HGS.countdown2", 1)
				ShowMessageText("level.HGS.countdown2", 2)
				DestroyTimer(countdown3_hg)
				StartTimer(countdown2_hg)
			end,
			countdown3_hg
			)  	
		
		
--=================================================================--
------*******************PLAYER REGISTRATION*******************------
--=================================================================--
	
	charSpawn = OnCharacterSpawn(
		function(character)
			print("Someone spawned.")
			local charUnit = GetCharacterUnit(character)
			--ShowObjectiveTextPopup("level.HGS.intro_popup")
			if check_map then 
				SetEntityMatrix(charUnit, destLoc)
				KillObject("com_inv_col_16_con1")
				KillObject("com_inv_col_64_con2")
				KillObject("com_inv_col_16_con3")
				KillObject("com_inv_col_16_con4")
				KillObject("com_inv_col_16_con")
			end
			print("\tTaking away their sheilds")
			antipower(character)
			if not (players_alive[character] == nil) then return
			else players_alive[character] = {
				playerChar = character, 
				playerUnit = charUnit, 
				playerTeam = GetCharacterTeam(character),
				registered = false,
				spamCount = 0,
				isCamping = false,
				intervalCount = 0,
				hurtCount = 0 
				}
			end
			print("\tAdded to players_alive.")
			number = RefreshListSize(players_alive)
			--ShowMessageText("level.HGS.debug.npa."..number)

		end
	)		
		
		
		
		
	function ResetRegistration()
		print("Resetting registration")
		
		--resetting the registration timer
		StopTimer(registrationTimer)
		SetTimerValue(registrationTimer, 20)
		StopTimer(VisualTimer)
		SetTimerValue(VisualTimer, 20)
		
		MapRemoveRegionMarker("register2")
		MapRemoveRegionMarker("team2_capture") 
		
		regOpen = false
		firstReg = true
		
		print("\tregOpen is now ", regOpen)
		print("\tfirstReg is now ", firstReg)
		print(" ")
		
		--teleport each player that is registered back to the waiting room
		local i, v
		for i, v in pairs(players_alive) do
			print("Unregistering players")	
			if players_alive[i] == nil then
				print("person not found.")
			elseif GetCharacterUnit(i) == nil then
				print("something went wrong, this player doesn't exist!")
				RemoveFromList(i)
			elseif players_alive[i].registered == true then
				local teleUnit = GetCharacterUnit(i)
				print("\tTeleporting character back to start: ", teleUnit)
				SetEntityMatrix(teleUnit, teleBack)
				
				print("\tUnregistering him now")
				players_alive[i].registered = false
				print("\tthe player's registration is now ", players_alive[i].registered)
				print("\tthe player has been safely teleported back")	
				
				numRegisteredPlayers = GetNumRegisteredPlayers(players_alive)
				print("\tThere are now this many registered players: ", numRegisteredPlayers)
				print(" ")
			end	
		end
		RestoreAmmo()
	end


	registerExpire = OnTimerElapse(
		function(timer)
			numRegisteredPlayers = GetNumRegisteredPlayers(players_alive)
			--if there are enough players registered (more than 1), the games can start
			if (numRegisteredPlayers > 1) then
			
				SetProperty("cp5", "Team", 0)
				SetProperty("cp5", "PerceivedTeam", 0)
				SetProperty("cp6", "Team", 0)
				SetProperty("cp6", "PerceivedTeam", 0)
				
				ReleaseCharacterSpawn(charSpawn)
				ReleaseEnterRegion(regTele1)
				ReleaseEnterRegion(regTele2)
				ReleaseObjectKill(regSwitch)
				
				print("We have enough people, let's play.\n")
				
				--Destroy the registration zones/regions
				RemoveRegion("register2")
				RemoveRegion("team2_capture")
				
				StopTimer(registrationTimer)
				DestroyTimer(registrationTimer)
				
				print("\nKilling unregistered players")
				local i, v
				for i, v in pairs(players_alive) do
					if players_alive[i] == nil then
						print("\tsomething went wrong, this player doesn't exist!")
					elseif GetCharacterUnit(i) == nil then
						print("\tThis player's not alive or something.")
						RemoveFromList(i)
					elseif players_alive[i].registered == false then
					
						print("\tThis player is not registered, kill them: ", players_alive[i].playerUnit)
						KillObject(players_alive[i].playerUnit)

					end
					print("\tchecked a player")
				end
				print("Done killing unregistered players.\n")
				
				regOpen = false
				playerReg = false
				gracePeriod = true
								
				KillObject("registration_switch")
				ActivateObject("com_inv_col_16_con1")
				ActivateObject("com_inv_col_64_con2")
				ActivateObject("com_inv_col_16_con3")
				ActivateObject("com_inv_col_16_con4")
				ActivateObject("com_inv_col_16_con")

				
				SetTimerValue(VisualTimer, 10)
				StartTimer(VisualTimer)
				StartTimer(ReadRules)
				
				RestoreAmmo()
				ShowMessageText("level.HGS.gp1")
				ShowMessageText("level.HGS.gp2")
				print("Moving on to the grace period.")
				
			else
				print("Not enough people.")
				ResetRegistration()
				print("Registration is now CLOSED", regOpen)
				print("\n")
				ShowMessageText("level.HGS.regclosed")
				ShowMessageText("level.HGS.reset")
			end
		end,
		registrationTimer
	) 
	
	regSwitch = OnObjectKill(
		function(object, killer)
		
			local name = GetEntityName(object)
			if name == "registration_switch" then
				if not gracePeriod then
					SwitchRespawn = CreateTimer("SwitchRespawn")
					SetTimerValue(SwitchRespawn, 1)
					SwitchRespawnE = OnTimerElapse(
						function(timer)
							DestroyTimer(SwitchRespawn)
							RespawnObject("registration_switch")
							SetProperty("registration_switch", "CurHealth", 4)
							ReleaseTimerElapse(SwitchRespawnE)
							SwitchRespawnE = nil
						end,
						SwitchRespawn
					)
					StartTimer(SwitchRespawn)
				end
				if not killer then return end	--do nothing if no killer
				if not IsCharacterHuman(killer) then return end --do nothing unless killer is a human
				if players_alive[killer].spamCount > 10 then return
				else
					players_alive[killer].spamCount = players_alive[killer].spamCount + 1
				end
				print("Someone hit the switch. Registration is now: ")
				if regOpen == true then
					regOpen = false
					firstReg = true
					ResetRegistration()
					print("Registration is now CLOSED", regOpen)
					print("\n")
					ShowMessageText("level.HGS.regclosed")
					ShowMessageText("level.HGS.reset")
				
				elseif regOpen == false then
					--MapAddRegionMarker("register2", "hud_objective_icon", 3.0, 1, "YELLOW", true, true, true) 
					--MapAddRegionMarker("team2_capture", "hud_objective_icon", 3.0, 2, "YELLOW", true, true, true) 
		
					regOpen = true
					print("OPEN", regOpen)
					print("\n")
					ShowMessageText("level.HGS.regopen")
				end
			end
		end
	)
	

	regTele1 = OnEnterRegion(               
		function(region, character)
		if regOpen == true then
			print("A player has entered the player 1 region")
			--deactivating regions temporarily to prevent double-registration
			DeactivateRegion("register2")
			DeactivateRegion("team2_capture")
			
			if IsCharacterHuman(character) then
		
				print("\tFinding the character in the players_alive list")		
				if not players_alive[character] then
					print("\tSomething went wrong, this player doesn't exist!")
					return
				
				elseif players_alive[character].registered == true then
					print("\tSomething's not right, this person's already registered!")
				
				else
					print("Teleporting player to the arena...")
					local charUnit = GetCharacterUnit(character)
					SetEntityMatrix(charUnit, destLoc)
					
					print("\tRegistering him now")
					players_alive[character].registered = true
					print("\tThe player is registered:", players_alive[character].registered)
					
					numRegisteredPlayers = GetNumRegisteredPlayers(players_alive)
					print("\tThere are now this many registered players: ", numRegisteredPlayers)
					
					ShowMessageText("level.HGS.entered")
					
				end
			end
				
			if firstReg then
				print("\tFirst player registered, starting timer.\n")
				firstReg = false
				StartTimer(registrationTimer)
				StartTimer(VisualTimer)
			else
				print("\tNew player registered, resetting timer value\n")
				SetTimerValue(registrationTimer, 20)
				SetTimerValue(VisualTimer, 20)
			end
			
		ActivateRegion("register2")
		ActivateRegion("team2_capture")
		end
	end, 
	"team2_capture")
	
	regTele2 = OnEnterRegion(
		function(region, character)
		if regOpen == true then
		
			print("A player has entered the player 2 region")
			--deactivating regions temporarily to prevent double-registration
			DeactivateRegion("register2")
			DeactivateRegion("team2_capture")
			
			if IsCharacterHuman(character) then
		
				print("\tFinding the character in the players_alive list")		
				if not players_alive[character] then
					print("\tSomething went wrong, this player doesn't exist!")
					return
				
				elseif players_alive[character].registered == true then
					print("\tSomething's not right, this person's already registered!")
				
				else
					print("Teleporting player to the arena...")
					local charUnit = GetCharacterUnit(character)
					SetEntityMatrix(charUnit, destLoc)
					
					print("\tRegistering him now")
					players_alive[character].registered = true
					print("\tThe player is registered:", players_alive[character].registered)
					
					numRegisteredPlayers = GetNumRegisteredPlayers(players_alive)
					print("\tThere are now this many registered players: ", numRegisteredPlayers)
					
					ShowMessageText("level.HGS.entered")
					
				end
			end
				
			if firstReg then
				print("\tFirst player registered, starting timer.\n")
				firstReg = false
				StartTimer(registrationTimer)
				StartTimer(VisualTimer)
			else
				print("\tNew player registered, resetting timer value\n")
				SetTimerValue(registrationTimer, 20)
				SetTimerValue(VisualTimer, 20)
			end
		ActivateRegion("register2")
		ActivateRegion("team2_capture")
		end
	end, 
	"register2")
	--RespawnObject("com_bldg_ctfbase2")
	--MapRemoveEntityMarker("cp_center")

	-- if uf_processPlayers then
		-- uf_processPlayers(players_alive)
		-- print(players_alive)
	-- else
		-- show("Player list wasn't created")
	-- end
	
		-- SetClassProperty("com_bldg_major_controlzone", "CaptureTime", 999999)
		-- SetProperty("cp_center", "CaptureRegion", "cp_center_capture")
		-- SetObjectTeam("cp_center", 0)



--=================================================================--
------*******************HUNGER GAMES STUFFS*******************------
--=================================================================--
		
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


		
	function SafetyCheck(self) 
		local playersInAliveList = RefreshListSize(players_alive)

		local f, g
		for f, g in pairs(players_alive) do			
			if CheckPlayer(f, playersInAliveList) then
				SetReinforcementCount(1, 1)
				AddReinforcements(1, -1)
				MissionVictory(2)
			end
		end
		
		if (not playerReg and playersInAliveList <= 1) then
			SetReinforcementCount(1, 1)
			AddReinforcements(1, -1)
			MissionVictory(2)
		end
	end

	SafetyCheckTimer = CreateTimer("SafetyCheckTimer")
	SetTimerValue(SafetyCheckTimer, 20)
	OnTimerElapse(
		function(timer)
			print("performing safety check")
			SafetyCheck()
			SetTimerValue(SafetyCheckTimer, 20) 
			StartTimer(SafetyCheckTimer)
		end,
		"SafetyCheckTimer")
	
	StartTimer(SafetyCheckTimer)
	
	
	
	local unitLocations = {}
	local minChange = 10

	CamperKiller = function(self)
		print("\nChecking for campers...")
	   
		local CampCheck = function( player, unit )
			print("Checking player ", player)
			if (player == nil) or (unit == nil) then return end   --check input
			local x, y, z = GetWorldPosition(unit)
			local currentPosition = {x, y, z}
			local previousPosition
			
			
			--start tracking a new player
			if unitLocations[player] == nil then
				print("\tStarting to track player")
				unitLocations[player] = currentPosition
				--PrintMatrix(unitLocations[player])
				return
			else
				--previous location = last stored location
				print("\tPlayer is already being tracked.")
				previousPosition = unitLocations[player]
			end
		  
		  --see if the player has been camping
			if math.abs(previousPosition[1] - currentPosition[1]) < minChange
				and math.abs(previousPosition[2] - currentPosition[2]) < 20
				and math.abs(previousPosition[3] - currentPosition[3]) < minChange then
				print("\tPlayer has not moved.")
				--they've now been stationary for another interval, raise interval count
				players_alive[player].intervalCount = players_alive[player].intervalCount + 1
				print("\tPlayer has been in stationary for this many intervals:", players_alive[player].intervalCount)
				
				--If they've been camping for long enough (90 seconds), then they're in trouble.
				if players_alive[player].intervalCount >= 12 then
					print("\tPlayer is camping, applying health degen.")
					
					--They might have full health, so the health degen has to be triggered; take away 1 health unit
					if players_alive[player].hurtCount == 0 then
						unitHealth = (GetObjectHealth(unit) - 1)
						SetProperty(unit, "CurHealth", unitHealth)
					end
					SetProperty(unit, "AddHealth", -10)
					
					--they are now camping
					if not players_alive[player].isCamping then
						players_alive[player].isCamping = true
					end
			
				end
				
				
				print(" ")
				return
				
			else		-- their position has changed more than 10 units
				print("\tPlayer has moved.")
				
				--if they WERE camping
				if players_alive[player].isCamping then
					
					-- they're moving now so reduce the damage
					SetProperty(unit, "AddHealth", -5)
					
					--increase the number of intervals they've been hurt but moving
					print("\tThe player was camping, so track amount of time they're still being hurt for.")
					players_alive[player].hurtCount = players_alive[player].hurtCount + 1
					
					--if they've kept moving while being hurt for 3 intervals, then they've had enough
					if players_alive[player].hurtCount > 3 then
						print("\tThey've kept moving, so stop hurting them and reset their info.")
						-- reset everything
						SetProperty(unit, "AddHealth", 0)
						players_alive[player].isCamping = false
						players_alive[player].hurtCount = 0
					
					else	-- if they haven't been hurt for long enough, keep hurting them
						print("\tPlayer has been hurt for "..players_alive[player].hurtCount.." intervals.")
					end
						
				end
					-- they've moved, so we need to record their new position
					print("\tRecording their current position.\n")
					players_alive[player].intervalCount = 0
					unitLocations[player] = currentPosition
				return
			end
		end
	   
		--run camp check for each player alive
		local i, v
		for i, v in pairs(players_alive) do
			CampCheck(i, GetCharacterUnit(i) )
		end	
			
	end


	CamperKillerTimer = CreateTimer("CamperKillerTimer")
	SetTimerValue(CamperKillerTimer , 10)
	OnTimerElapse(
		function(timer)
			CamperKiller()
			SetTimerValue(CamperKillerTimer, 10)
			StartTimer(CamperKillerTimer)
		end,
		"CamperKillerTimer"
	)
	
	
	
	--Now call checkForCampers() from a timer every minute or so
	--Note: uf_applyFunctionsOnTeamUnits() only exists in v1.3.  If you don't want to require v1.3 then you'll have to 
	--manually write the code to loop over the teams and each player's unit

	--TODO make sure the player id is unique to the game and not to each team.  
	--If it's unique to the team, then the first players on both teams will be 
	--overriding the other player's position.  To fix this, create a different 
	--unitLocations table for each team and change the teams variable depending 
	--on which unitLocations table you're checking.  Or an easier fix:  Grab 
	--the player's team and prepend it to the player variable before using it 
	--as an index into unitLocations.
	
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

	ScriptCB_SetNumBots(0)

   	if loadscreen == 1 then
		ReadDataFile("dc:LoadS\\common.lvl")
	elseif loadscreen == 2 then
		ReadDataFile("dc:LoadT\\common.lvl")
	elseif loadscreen == 3 then
		ReadDataFile("dc:LoadF\\common.lvl")
	else 
		ReadDataFile("dc:LoadM\\common.lvl")
	end 	

    ReadDataFile("ingame.lvl")
    ReadDataFile("dc:ingame.lvl")
    
   	CIS = 1
	REP = 2
	--HGS = 3
	--  These variables do not change
	--ATT = 1 and 2
	--DEF = 3
   
   
    SetMaxFlyHeight(33)
    SetMaxPlayerFlyHeight (33)
    
	SetMemoryPoolSize("Music", 128)
    SetMemoryPoolSize ("ClothData",20)
    SetMemoryPoolSize ("Combo",50)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",650)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",650) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",650)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",550)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",6000)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",100)     -- should be ~1x #combo  
    
	ReadDataFile("sound\\dag.lvl;dag1gcw")
	ReadDataFile("dc:sound\\hgs.lvl;hgscw")
    ReadDataFile("SIDE\\all.lvl",
                    "all_inf_rifleman_jungle",
                    "all_inf_rocketeer_jungle",
                    "all_inf_sniper_jungle",
                    "all_inf_engineer_jungle",
                    "all_inf_officer_jungle",
                    "all_inf_wookiee")
                    
    ReadDataFile("SIDE\\imp.lvl",
                    "imp_inf_officer",
                    "imp_inf_dark_trooper")	

	
    --ReadDataFile("dc:sound\\kam.lvl;kam1cw")
    --ReadDataFile("dc:sound\\end.lvl;end1cw")
	--ReadDataFile("dc:sound\\uta.lvl;uta1gcw")
	--ReadDataFile("sound\\dag.lvl;dag1cw")
	--ReadDataFile("dc:sound\\hgs.lvl;hgsgcw")
    ReadDataFile("SIDE\\rep.lvl",
                             "rep_inf_ep3_rifleman",
                             "rep_inf_ep3_rocketeer",
                             "rep_inf_ep3_engineer",
							 "rep_inf_ep3_sniper",
                             "rep_inf_ep3_sniper_felucia",
                             "rep_inf_ep3_officer",
                             "rep_inf_ep3_jettrooper")
							 
    ReadDataFile("SIDE\\cis.lvl",
                             "cis_inf_rifleman",
                             "cis_inf_officer")
                             
							 
	ReadDataFile("dc:SIDE\\hgs.lvl",
                             "hgs_rep_inf_ep3_rifleman",
                             "hgs_rep_inf_ep3_rocketeer",
                             "hgs_rep_inf_ep3_engineer",
                             "hgs_rep_inf_ep3_sniper_felucia",
                             "hgs_rep_inf_ep3_officer",
                             "hgs_rep_inf_ep3_jettrooper",
                             "hgs_all_inf_rifleman_jungle",
                             "hgs_all_inf_rocketeer_jungle",
                             "hgs_all_inf_engineer_jungle",
                             "hgs_all_inf_sniper_jungle",
                             "hgs_cis_inf_rifleman",
                             "hgs_cis_inf_officer",
							 "hgs_all_inf_officer_jungle",
                             "hgs_all_inf_wookiee",
							 "hgs_imp_inf_officer",
                             "hgs_imp_inf_dark_trooper")
                             
          
                             
	SetupTeams{
		rep = {
			team = REP,
			units = 16,
			reinforcements = -1,
			soldier  = { "hgs_rep_inf_ep3_rifleman",0, 25},
			assault  = { "hgs_rep_inf_ep3_rocketeer",0, 16},
			engineer = { "hgs_rep_inf_ep3_engineer",0, 16},
			sniper   = { "hgs_rep_inf_ep3_sniper_felucia",0, 16},
			officer  = {"hgs_rep_inf_ep3_officer",0, 16},
			special  = { "hgs_rep_inf_ep3_jettrooper",0, 16},
	        
		},
		cis = {
			team = CIS,
			units = 16,
			reinforcements = -1,
			soldier  = { "hgs_all_inf_rifleman_jungle",0, 25},
			assault  = { "hgs_all_inf_rocketeer_jungle",0, 16},
			engineer = { "hgs_all_inf_engineer_jungle",0, 16},
			sniper   = { "hgs_all_inf_sniper_jungle",0, 16},
			officer  = {"hgs_all_inf_officer_jungle",0, 16},
			special  = { "hgs_all_inf_wookiee",0, 16},
		}
	}
     
	AddUnitClass(REP, "hgs_cis_inf_rifleman", 0, 16) 
	AddUnitClass(REP, "hgs_cis_inf_officer", 0, 16) 
	AddUnitClass(CIS, "hgs_imp_inf_officer", 0, 16)
	AddUnitClass(CIS, "hgs_imp_inf_dark_trooper", 0, 16)

    --  Level Stats
    --  ClearWalkers()
    AddWalkerType(0, 4) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    local weaponCnt = 1024
    SetMemoryPoolSize("Aimer", 75)
	SetMemoryPoolSize("ActiveRegion", 100)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 1024)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 32)
	SetMemoryPoolSize("EntityFlyer", 32)
    SetMemoryPoolSize("EntityHover", 32)
    SetMemoryPoolSize("EntityLight", 200)
    SetMemoryPoolSize("EntitySoundStream", 64)
    SetMemoryPoolSize("EntitySoundStatic", 32)
    SetMemoryPoolSize("MountedTurret", 32)
	SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
	SetMemoryPoolSize("SoldierAnimation", 1800) 
    SetMemoryPoolSize("SoundSpaceRegion", 64)
	SetMemoryPoolSize("Timer", 100)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
	SetMemoryPoolSize("FlagItem", 512)
	SetMemoryPoolSize("PowerupItem", 512)
    
    SetSpawnDelay(10.0, 0.25)
    --ReadDataFile("dc:HGS\\HGS.lvl", "HGS_conquest")
	ReadDataFile("dc:HGS\\HGS.lvl", "HGS_conquest")
	ReadDataFile("dc:HGS\\HGS_sky.lvl", "dusk")
    SetDenseEnvironment("false")

	


    --  Sound
    
    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")

    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
	AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
	AudioStreamAppendSegments("sound\\global.lvl", "all_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)
	AudioStreamAppendSegments("sound\\global.lvl", "all_unit_vo_quick", voiceQuick)
	AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_quick", voiceQuick)
    
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    -- OpenAudioStream("sound\\yav.lvl",  "yav1")
    -- OpenAudioStream("sound\\yav.lvl",  "yav1")
    -- OpenAudioStream("sound\\yav.lvl",  "yav1_emt")
	--OpenAudioStream("dc:sound\\hgs.lvl",  "")
    --OpenAudioStream("dc:sound\\hgs.lvl",  "myg1")
	--OpenAudioStream("dc:sound\\hgs.lvl",  "end1")
	OpenAudioStream("dc:sound\\hgs.lvl",  "hgs_streams")
	OpenAudioStream("sound\\dag.lvl",  "dag1")
    OpenAudioStream("sound\\dag.lvl",  "dag1")
    OpenAudioStream("sound\\dag.lvl",  "dag1_emt")
	--OpenAudioStream("dc:sound\\kam.lvl",  "kam1")
    --OpenAudioStream("dc:sound\\kam.lvl",  "kam1")
	--OpenAudioStream("dc:sound\\end.lvl",  "end1")
    --OpenAudioStream("dc:sound\\uta.lvl",  "uta1")
	
	
    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(2, "cisleaving")
    SetOutOfBoundsVoiceOver(1, "repleaving")
	
	SetAmbientMusic(REP, 1.0, "rep_dag_amb_start",  0,1)
    SetAmbientMusic(REP, 0.8, "rep_dag_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2, "rep_dag_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_dag_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.8, "cis_dag_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2, "cis_dag_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_dag_amb_victory")
    SetDefeatMusic (REP, "rep_dag_amb_defeat")
    SetVictoryMusic(CIS, "cis_dag_amb_victory")
    SetDefeatMusic (CIS, "cis_dag_amb_defeat")

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

	
	
--OpeningSateliteShot
	AddCameraShot(0.953374, -0.267720, 0.134110, 0.037660, -54.391048, 22.637020, -112.560837);
	AddCameraShot(0.190180, -0.039485, -0.960472, -0.199413, -23.582567, 18.165585, -59.159462);
	AddCameraShot(0.166568, 0.008194, -0.984805, 0.048446, -52.621288, -3.707588, 71.935303);
	AddCameraShot(0.921100, 0.181319, -0.338038, 0.066543, 85.826782, -3.707588, 89.593933);
	AddCameraShot(0.760499, -0.074656, 0.641947, 0.063018, 48.234692, -1.620878, 7.359371);
end


antipower = function( player )

	local unit = GetCharacterUnit(player)
	local unitLocation = GetEntityMatrix( unit )
	--get the player's spawn position
	--local player_pos = GetEntityMatrix(player)
	--CreateEntity("com_item_powerup_antiammo", unitLocation, "antiammo")
	-- SetEntityMatrix("antiarmor", unitLocation)
	-- SetEntityMatrix("antiammo", unitLocation)
	SetProperty(unit, "CurShield", 0)

end 

superpowers = function(self)

	print("Superpowers has started.")
	node4 = math.ceil(GetRandomNumber()*3)-1
	print("The node for the swamp is:", node4)
	node2 = math.ceil(GetRandomNumber()*3)+2
	print("The node for the forest is:", node2)
	node3 = math.ceil(GetRandomNumber()*3)+5
	print("The node for the town is:", node3)
	node1 = math.ceil(GetRandomNumber()*3)+8
	print("The node for the mountain is:", node1)

	
	SPLocations = {"Swamp", "Forest", "Town", "Mountain"}
	
	local SPnodes = {node1, node2, node3, node4}

	local x = math.ceil(GetRandomNumber()*4)
	print("The area for the adrenaline is:", SPLocations[x])
	sammo_spawn4 = GetPathPoint("special_ammo_spawn2", SPnodes[x])
	table.remove(SPnodes, x)
	table.remove(SPLocations, x)
	local x = math.ceil(GetRandomNumber()*3)
	print("The area for the full restore is:", SPLocations[x])
	sammo_spawn1 = GetPathPoint("special_ammo_spawn2", SPnodes[x])
	table.remove(SPnodes, x)
	table.remove(SPLocations, x)
	x = math.ceil(GetRandomNumber()*2)
	print("The area for the invincibility is:", SPLocations[x])
	sammo_spawn2 = GetPathPoint("special_ammo_spawn2", SPnodes[x])
	table.remove(SPnodes, x)
	table.remove(SPLocations, x)
	sammo_spawn3 = GetPathPoint("special_ammo_spawn2", SPnodes[1])
	print("The area for the one hit kill is:", SPLocations[1])
	table.remove(SPnodes, 1)
	table.remove(SPLocations, 1)

	

	spec_powerup1 = CreateTimer("spec_powerup1")
		SetTimerValue(spec_powerup1, 120)
		OnTimerElapse(
			function(timer)
				 print("Spawning all super-powerups.")
				CreateEntity("com_item_powerup_inv", sammo_spawn1, "full")
				CreateEntity("com_item_powerup_inv", sammo_spawn2, "invinc")
				CreateEntity("com_item_powerup_onehit", sammo_spawn3, "onehit")
				CreateEntity("com_item_powerup_onehit", sammo_spawn4, "adren")		--CreateEntity(class, node, name)
				DestroyTimer(spec_powerup1)
			end,
			spec_powerup1
			) 
	StartTimer(spec_powerup1)
end

GetPlayersAlive = function(self)

	return (GetNumTeamMembersAlive(1) + GetNumTeamMembersAlive(2))
	
end

cpAmmoSpawn = function(self)
	print("The cp ammo spawn has started.")
	
 --get the path point
	cp1_ammospawn1 = GetPathPoint("cp1_spawn", 0) --GetPathPoint(Pathname, node)
	cp1_ammospawn2 = GetPathPoint("cp1_spawn", 1) 
	cp2_ammospawn1 = GetPathPoint("cp2_spawn", 0) 
	cp2_ammospawn2 = GetPathPoint("cp2_spawn", 1)
	cp3_ammospawn1 = GetPathPoint("cp3_spawn", 0) 
	cp3_ammospawn2 = GetPathPoint("cp3_spawn", 1) 
	cp4_ammospawn1 = GetPathPoint("cp4_spawn2", 0) 
	cp4_ammospawn2 = GetPathPoint("cp4_spawn2", 1) 
	cp_centerspawn = CreateMatrix(0, 0, 0, 0, 0, -3.8, 0)

	cp1_powerspawn1 = CreateTimer("cp1_powerspawn1")
		SetTimerValue(cp1_powerspawn1, 150)
		OnTimerElapse(
			function(timer)
			print("Spawning cp1 ammo 1.")
		CreateEntity("com_item_powerup_dual2", cp1_ammospawn1, "ammo1") --CreateEntity(class, node, name)
			SetTimerValue(cp1_powerspawn1, (math.ceil(GetRandomNumber()*90)+120))
			StartTimer(cp1_powerspawn1)
			end,
			cp1_powerspawn1
			) 

	cp1_powerspawn2 = CreateTimer("cp1_powerspawn2")
		SetTimerValue(cp1_powerspawn2, 150)
		OnTimerElapse(
			function(timer)
			print("Spawning cp1 ammo 2.")
		CreateEntity("com_item_powerup_dual2", cp1_ammospawn2, "ammo2") 
			SetTimerValue(cp1_powerspawn2, (math.ceil(GetRandomNumber()*90)+120))
			StartTimer(cp1_powerspawn2)
			end,
			cp1_powerspawn2
			) 
			
	cp2_powerspawn1 = CreateTimer("cp2_powerspawn1")
		SetTimerValue(cp2_powerspawn1, 150)
		OnTimerElapse(
			function(timer)
			print("Spawning cp2 ammo 1.")
		CreateEntity("com_item_powerup_dual2", cp2_ammospawn1, "ammo3") 
			SetTimerValue(cp2_powerspawn1, (math.ceil(GetRandomNumber()*90)+120))
			StartTimer(cp2_powerspawn1)
			end,
			cp2_powerspawn1
			) 
			
	cp2_powerspawn2 = CreateTimer("cp2_powerspawn2")
		SetTimerValue(cp2_powerspawn2, 150)
		OnTimerElapse(
			function(timer)
			print("Spawning cp2 ammo 2.")
		CreateEntity("com_item_powerup_dual2", cp2_ammospawn2, "ammo4")
			SetTimerValue(cp2_powerspawn2, (math.ceil(GetRandomNumber()*90)+120))
			StartTimer(cp2_powerspawn2)
			end,
			cp2_powerspawn2
			) 
			
	cp3_powerspawn1 = CreateTimer("cp3_powerspawn1")
		SetTimerValue(cp3_powerspawn1, 150)
		OnTimerElapse(
			function(timer)
			print("Spawning cp3 ammo 1.")
		CreateEntity("com_item_powerup_dual2", cp3_ammospawn1, "ammo5")
			SetTimerValue(cp3_powerspawn1, (math.ceil(GetRandomNumber()*90)+120))
			StartTimer(cp3_powerspawn1)
			end,
			cp3_powerspawn1
			) 

	cp3_powerspawn2 = CreateTimer("cp3_powerspawn2")
		SetTimerValue(cp3_powerspawn2, 150)
		OnTimerElapse(
			function(timer)
			print("Spawning cp3 ammo 2.")
		CreateEntity("com_item_powerup_dual2", cp3_ammospawn2, "ammo6") 
			SetTimerValue(cp3_powerspawn2, (math.ceil(GetRandomNumber()*90)+120))
			StartTimer(cp3_powerspawn2)
			end,
			cp3_powerspawn2
			) 
			
	cp4_powerspawn1 = CreateTimer("cp4_powerspawn1")
		SetTimerValue(cp4_powerspawn1, 150)
		OnTimerElapse(
			function(timer)
			print("Spawning cp4 ammo 1.")
		CreateEntity("com_item_powerup_dual2", cp4_ammospawn1, "ammo7")
			SetTimerValue(cp4_powerspawn1, (math.ceil(GetRandomNumber()*90)+120))
			StartTimer(cp4_powerspawn1)
			end,
			cp4_powerspawn1
			) 
			
	cp4_powerspawn2 = CreateTimer("cp4_powerspawn2")
		SetTimerValue(cp4_powerspawn2, 150)
		OnTimerElapse(
			function(timer)
			print("Spawning cp4 ammo 2.")
		CreateEntity("com_item_powerup_dual2", cp4_ammospawn2, "ammo8")
			SetTimerValue(cp4_powerspawn2, (math.ceil(GetRandomNumber()*90)+120))
			StartTimer(cp4_powerspawn2)
			end,
			cp4_powerspawn2
			) 
		
	cp_centerspawnT = CreateTimer("cp_centerspawnT")
		SetTimerValue(cp_centerspawnT, 180)
		OnTimerElapse(
			function(timer)
			print("Spawning cp_center ammo.")
		CreateEntity("com_item_powerup_dual2", cp_centerspawn, "center_ammo")
			SetTimerValue(cp_centerspawnT, (math.ceil(GetRandomNumber()*90)+210))
			StartTimer(cp_centerspawnT)
			end,
			cp_centerspawnT
			) 

	StartTimer(cp1_powerspawn1)
	StartTimer(cp1_powerspawn2)
	StartTimer(cp2_powerspawn1)
	StartTimer(cp2_powerspawn2)
	StartTimer(cp3_powerspawn1)
	StartTimer(cp3_powerspawn2)
	StartTimer(cp4_powerspawn1)
	StartTimer(cp4_powerspawn2)
	StartTimer(cp_centerspawnT)


end


ammospawn = function(self)
	print("The ammo spawn has started.")

 --get the path point
	ammospawn1 = GetPathPoint("normal_ammo_spawn2", 0) --GetPathPoint(Pathname, node)
	ammospawn2 = GetPathPoint("normal_ammo_spawn2", 1) 
	ammospawn3 = GetPathPoint("normal_ammo_spawn2", 2) 
	ammospawn4 = GetPathPoint("normal_ammo_spawn2", 3)
	ammospawn5 = GetPathPoint("normal_ammo_spawn2", 4) 
	ammospawn6 = GetPathPoint("normal_ammo_spawn2", 5) 
	ammospawn7 = GetPathPoint("normal_ammo_spawn2", 6) 
	ammospawn8 = GetPathPoint("normal_ammo_spawn2", 7) 
	ammospawn9 = GetPathPoint("normal_ammo_spawn2", 8) 
	ammospawn10 = GetPathPoint("normal_ammo_spawn2", 9) 
	ammospawn11 = GetPathPoint("normal_ammo_spawn2", 10) 
	ammospawn12 = GetPathPoint("normal_ammo_spawn2", 11)
	ammospawn13 = GetPathPoint("normal_ammo_spawn2", 12) 
	ammospawn14 = GetPathPoint("normal_ammo_spawn2", 13) 
	ammospawn15 = GetPathPoint("normal_ammo_spawn2", 14) 
	ammospawn16 = GetPathPoint("normal_ammo_spawn2", 15)
	ammospawn17 = GetPathPoint("normal_ammo_spawn2", 16)
	ammospawn18 = GetPathPoint("normal_ammo_spawn2", 17)
	ammospawn19 = GetPathPoint("normal_ammo_spawn2", 18)
	ammospawn20 = GetPathPoint("normal_ammo_spawn2", 19)
	

	powerspawn1 = CreateTimer("powerspawn1")
		SetTimerValue(powerspawn1, (math.ceil(GetRandomNumber()*90)+90))
		OnTimerElapse(
			function(timer)
			local item
			if (math.ceil(GetRandomNumber()*10) > 9) then
				item = "com_item_powerup_dual_fake"
				print("Fake:")
			else
				item = "com_item_powerup_dual2"
			end
			--ShowMessageText("level.HGS.debug.norm.1")
			print("Spawning normal ammo 1.")
			CreateEntity(item, ammospawn1, "nammo1")
			--ShowMessageText("level.HGS.debug.norm.15")
			print("Spawning normal ammo 15.")
			CreateEntity(item, ammospawn15, "nammo15")--CreateEntity(class, node, name)
			
			SetTimerValue(powerspawn1, (math.ceil(GetRandomNumber()*180)+120))
			StartTimer(powerspawn1)
			end,
			powerspawn1
			) 

	powerspawn2 = CreateTimer("powerspawn2")
		SetTimerValue(powerspawn2, (math.ceil(GetRandomNumber()*90)+90))
		OnTimerElapse(
			function(timer)
			local item
			if (math.ceil(GetRandomNumber()*10) > 9) then
				item = "com_item_powerup_dual_fake"
				print("Fake:")
			else
				item = "com_item_powerup_dual2"
			end
			--ShowMessageText("level.HGS.debug.norm.2")
			print("Spawning normal ammo 2.")
			CreateEntity(item, ammospawn2, "nammo2") 
			print("Spawning normal ammo 14.")
			--ShowMessageText("level.HGS.debug.norm.14")
			CreateEntity(item, ammospawn14, "nammo14")
			
			SetTimerValue(powerspawn2, (math.ceil(GetRandomNumber()*180)+120))
			StartTimer(powerspawn2)
			end,
			powerspawn2
			) 
			
	powerspawn3 = CreateTimer("powerspawn3")
		SetTimerValue(powerspawn3, (math.ceil(GetRandomNumber()*90)+90))
		OnTimerElapse(
			function(timer)
			local item
			if (math.ceil(GetRandomNumber()*10) > 9) then
				item = "com_item_powerup_dual_fake"
				print("Fake:")
			else
				item = "com_item_powerup_dual2"
			end
			--ShowMessageText("level.HGS.debug.norm.3")
			print("Spawning normal ammo 3.")
			CreateEntity(item, ammospawn3, "nammo3") 
			--ShowMessageText("level.HGS.debug.norm.20")
			print("Spawning normal ammo 20.")
			CreateEntity(item, ammospawn20, "nammo20")
			
			SetTimerValue(powerspawn3, (math.ceil(GetRandomNumber()*180)+120))
			StartTimer(powerspawn3)
			end,
			powerspawn3
			) 
			
	powerspawn4 = CreateTimer("powerspawn4")
		SetTimerValue(powerspawn4, (math.ceil(GetRandomNumber()*90)+90))
		OnTimerElapse(
			function(timer)
			local item
			if (math.ceil(GetRandomNumber()*10) > 9) then
				item = "com_item_powerup_dual_fake"
				print("Fake:")
			else
				item = "com_item_powerup_dual2"
			end
			--ShowMessageText("level.HGS.debug.norm.4")
			print("Spawning normal ammo 4.")
			CreateEntity(item, ammospawn4, "nammo4")
			print("Spawning normal ammo 12.")
			--ShowMessageText("level.HGS.debug.norm.12")
			CreateEntity(item, ammospawn12, "nammo12")
			
			SetTimerValue(powerspawn4, (math.ceil(GetRandomNumber()*180)+120))
			StartTimer(powerspawn4)
			end,
			powerspawn4
			) 
			
	powerspawn5 = CreateTimer("powerspawn5")
		SetTimerValue(powerspawn5, (math.ceil(GetRandomNumber()*90)+90))
		OnTimerElapse(
			function(timer)
			local item
			if (math.ceil(GetRandomNumber()*10) > 9) then
				item = "com_item_powerup_dual_fake"
				print("Fake:")
			else
				item = "com_item_powerup_dual2"
			end
			--ShowMessageText("level.HGS.debug.norm.5")
			print("Spawning normal ammo 5.")
			CreateEntity(item, ammospawn5, "nammo5")
			--ShowMessageText("level.HGS.debug.norm.18")
			print("Spawning normal ammo 18.")
			CreateEntity(item, ammospawn18, "nammo18")
			
			SetTimerValue(powerspawn5, (math.ceil(GetRandomNumber()*180)+120))
			StartTimer(powerspawn5)
			end,
			powerspawn5
			) 

	powerspawn6 = CreateTimer("powerspawn6")
		SetTimerValue(powerspawn6, (math.ceil(GetRandomNumber()*90)+90))
		OnTimerElapse(
			function(timer)
			local item
			if (math.ceil(GetRandomNumber()*10) > 9) then
				item = "com_item_powerup_dual_fake"
				print("Fake:")
			else
				item = "com_item_powerup_dual2"
			end
			print("Spawning normal ammo 6.")
			--ShowMessageText("level.HGS.debug.norm.6")
			CreateEntity(item, ammospawn6, "nammo6") 
			print("Spawning normal ammo 13.")
			--ShowMessageText("level.HGS.debug.norm.13")
			CreateEntity(item, ammospawn13, "nammo13")
			
			SetTimerValue(powerspawn6, (math.ceil(GetRandomNumber()*180)+120))
			StartTimer(powerspawn6)
			end,
			powerspawn6
			) 
			
	powerspawn7 = CreateTimer("powerspawn7")
		SetTimerValue(powerspawn7, (math.ceil(GetRandomNumber()*90)+90))
		OnTimerElapse(
			function(timer)
			local item
			if (math.ceil(GetRandomNumber()*10) > 9) then
				item = "com_item_powerup_dual_fake"
				print("Fake:")
			else
				item = "com_item_powerup_dual2"
			end
			--ShowMessageText("level.HGS.debug.norm.7")
			print("Spawning normal ammo 7.")
			CreateEntity(item, ammospawn7, "nammo7")
			print("Spawning normal ammo 11.")
			--ShowMessageText("level.HGS.debug.norm.11")
			CreateEntity(item, ammospawn11, "nammo11")
			
			SetTimerValue(powerspawn7, (math.ceil(GetRandomNumber()*180)+120))
			StartTimer(powerspawn7)
			end,
			powerspawn7
			) 
			
	powerspawn8 = CreateTimer("powerspawn8")
		SetTimerValue(powerspawn8, (math.ceil(GetRandomNumber()*90)+90))
		OnTimerElapse(
			function(timer)
			local item
			if (math.ceil(GetRandomNumber()*10) > 9) then
				item = "com_item_powerup_dual_fake"
				print("Fake:")
			else
				item = "com_item_powerup_dual2"
			end
			--ShowMessageText("level.HGS.debug.norm.8")
			print("Spawning normal ammo 8.")
			CreateEntity(item, ammospawn8, "nammo8")
			print("Spawning normal ammo 17.")
			--ShowMessageText("level.HGS.debug.norm.17")
			CreateEntity(item, ammospawn17, "nammo17")
			
			SetTimerValue(powerspawn8, (math.ceil(GetRandomNumber()*180)+120))
			StartTimer(powerspawn8)
			end,
			powerspawn8
			) 

		powerspawn9 = CreateTimer("powerspawn9")
		SetTimerValue(powerspawn9, (math.ceil(GetRandomNumber()*90)+90))
		OnTimerElapse(
			function(timer)
			local item
			if (math.ceil(GetRandomNumber()*10) > 9) then
				item = "com_item_powerup_dual_fake"
				print("Fake:")
			else
				item = "com_item_powerup_dual2"
			end
			print("Spawning normal ammo 9.")
			--ShowMessageText("level.HGS.debug.norm.9")
			CreateEntity(item, ammospawn9, "nammo9")
			print("Spawning normal ammo 19.")
			--ShowMessageText("level.HGS.debug.norm.19")
			CreateEntity(item, ammospawn19, "nammo19")		--CreateEntity(class, node, name)
			
			SetTimerValue(powerspawn9, (math.ceil(GetRandomNumber()*180)+120))
			StartTimer(powerspawn9)
			end,
			powerspawn9
			) 
			
	powerspawn10 = CreateTimer("powerspawn10")
		SetTimerValue(powerspawn10, (math.ceil(GetRandomNumber()*90)+90))
		OnTimerElapse(
			function(timer)
			local item
			if (math.ceil(GetRandomNumber()*10) > 9) then
				item = "com_item_powerup_dual_fake"
				print("Fake:")
			else
				item = "com_item_powerup_dual2"
			end
			print("Spawning normal ammo 10.")
			--ShowMessageText("level.HGS.debug.norm.10")
			CreateEntity(item, ammospawn10, "nammo10")
			print("Spawning normal ammo 16.")
			--ShowMessageText("level.HGS.debug.norm.16")
			CreateEntity(item, ammospawn16, "nammo16")--CreateEntity(class, node, name)
			
			SetTimerValue(powerspawn10, (math.ceil(GetRandomNumber()*180)+120))
			StartTimer(powerspawn10)
			end,
			powerspawn10
			) 
			
	StartTimer(powerspawn1)
	StartTimer(powerspawn2)
	StartTimer(powerspawn3)
	StartTimer(powerspawn5)
	StartTimer(powerspawn6)
	StartTimer(powerspawn7)
	StartTimer(powerspawn9)
	StartTimer(powerspawn10)

end


armorspawn = function(self)
	print("The armor spawn has started")

 --get the path point
	armorspawn1 = GetPathPoint("armor_spawn2", 0) --GetPathPoint(Pathname, node)
	armorspawn2 = GetPathPoint("armor_spawn2", 1) 
	armorspawn3 = GetPathPoint("armor_spawn2", 2) 
	armorspawn4 = GetPathPoint("armor_spawn2", 3)
	armorspawn5 = GetPathPoint("armor_spawn2", 4) 
	armorspawn6 = GetPathPoint("armor_spawn2", 5) 
	armorspawn7 = GetPathPoint("armor_spawn2", 6) 
	armorspawn8 = GetPathPoint("armor_spawn2", 7) 
	armorspawn9 = GetPathPoint("armor_spawn2", 8) 
	armorspawn10 = GetPathPoint("armor_spawn2", 9) 
	armorspawn11 = GetPathPoint("armor_spawn2", 10) 
	armorspawn12 = GetPathPoint("armor_spawn2", 11)
	armorspawn13 = GetPathPoint("armor_spawn2", 12) 
	armorspawn14 = GetPathPoint("armor_spawn2", 13) 
	armorspawn15 = GetPathPoint("armor_spawn2", 14) 
	armorspawn16 = GetPathPoint("armor_spawn2", 15)
	

	apowerspawn1 = CreateTimer("apowerspawn1")
		SetTimerValue(apowerspawn1, math.ceil(GetRandomNumber()*30))
		local kill1 = false
		OnTimerElapse(
			function(timer)
			if kill1 == false then
				print("Spawning armor 1.")
				CreateEntity("com_item_powerup_armor", armorspawn1, "armor1")
				print("Spawning armor 11.")	
				CreateEntity("com_item_powerup_armor", armorspawn11, "armor11")	
				SetTimerValue(apowerspawn1, 90)
				kill1 = true
			elseif kill1 == true then
				print("Armor 1 expired.")
				KillObject("armor1")
				print("Armor 11 expired.")
				KillObject("armor11")
				SetTimerValue(apowerspawn1, (math.ceil(GetRandomNumber()*180)+15))
				kill1 = false
			end
			StartTimer(apowerspawn1)
			end,
			apowerspawn1
			) 

	apowerspawn2 = CreateTimer("apowerspawn2")
		SetTimerValue(apowerspawn2, math.ceil(GetRandomNumber()*30))
		local kill2 = false
		OnTimerElapse(
			function(timer)
			if kill2 == false then
				print("Spawning armor 2.")
				CreateEntity("com_item_powerup_armor", armorspawn2, "armor2") 
				print("Spawning armor 13.")
				CreateEntity("com_item_powerup_armor", armorspawn13, "armor13")
				SetTimerValue(apowerspawn2, 90)
				kill2 = true
			elseif kill2 == true then
				print("Armor 2 expired.")	
				KillObject("armor2")
				print("Armor 13 expired.")
				KillObject("armor13")
				SetTimerValue(apowerspawn2, (math.ceil(GetRandomNumber()*180)+15))
				kill2 = false
			end
			StartTimer(apowerspawn2)
			end,
			apowerspawn2
			) 
			
	apowerspawn3 = CreateTimer("apowerspawn3")
		SetTimerValue(apowerspawn3, math.ceil(GetRandomNumber()*30))
		local kill3 = false
		OnTimerElapse(
			function(timer)
			if kill3 == false then
				print("Spawning armor 3.")
				CreateEntity("com_item_powerup_armor", armorspawn3, "armor3")
				print("Spawning armor 16.")
				CreateEntity("com_item_powerup_armor", armorspawn16, "armor16")		
				SetTimerValue(apowerspawn3, 90)
				kill3 = true
			elseif kill3 == true then
				print("Armor 3 expired.")
				KillObject("armor3")
				print("Armor 16 expired.")
				KillObject("armor16")
				SetTimerValue(apowerspawn3, (math.ceil(GetRandomNumber()*180)+15))
				kill3 = false
			end
			StartTimer(apowerspawn3)
			end,
			apowerspawn3
			) 
			
	apowerspawn4 = CreateTimer("apowerspawn4")
		SetTimerValue(apowerspawn4, math.ceil(GetRandomNumber()*30))
		local kill4 = false
		OnTimerElapse(
			function(timer)
			if kill4 == false then
				print("Spawning armor 4.")
				CreateEntity("com_item_powerup_armor", armorspawn4, "armor4")
				print("Spawning armor 9.")
				CreateEntity("com_item_powerup_armor", armorspawn9, "armor9")
				SetTimerValue(apowerspawn4, 90)
				kill4 = true
			elseif kill4 == true then
				print("Armor 4 expired.")
				KillObject("armor4")
				print("Armor 9 expired.")
				KillObject("armor9")
				SetTimerValue(apowerspawn4, (math.ceil(GetRandomNumber()*180)+15))
				kill4 = false
			end
			StartTimer(apowerspawn4)
			end,
			apowerspawn4
			) 
			
	apowerspawn5 = CreateTimer("apowerspawn5")
		SetTimerValue(apowerspawn5, math.ceil(GetRandomNumber()*30))
		local kill5 = false
		OnTimerElapse(
			function(timer)
			if kill5 == false then
				print("Spawning armor 5.")
				CreateEntity("com_item_powerup_armor", armorspawn5, "armor5")
				print("Spawning armor 15.")
				CreateEntity("com_item_powerup_armor", armorspawn15, "armor15")
				SetTimerValue(apowerspawn5, 90)
				kill5 = true
			elseif kill5 == true then
				print("Armor 5 expired.")
				KillObject("armor5")
				print("Armor 15 expired.")
				KillObject("armor15")
				SetTimerValue(apowerspawn5, (math.ceil(GetRandomNumber()*180)+15))
				kill5 = false
			end
			StartTimer(apowerspawn5)
			end,
			apowerspawn5
			) 

	apowerspawn6 = CreateTimer("apowerspawn6")
		SetTimerValue(apowerspawn6, math.ceil(GetRandomNumber()*30))
		local kill6 = false
		OnTimerElapse(
			function(timer)
			if kill6 == false then
				print("Spawning armor 6.")
				CreateEntity("com_item_powerup_armor", armorspawn6, "armor6") 
				print("Spawning armor 10.")
				CreateEntity("com_item_powerup_armor", armorspawn10, "armor10")
				SetTimerValue(apowerspawn6, 90)
				kill6 = true
			elseif kill6 == true then
				print("Armor 6 expired.")
				KillObject("armor6")
				print("Armor 10 expired.")
				KillObject("armor10")
				SetTimerValue(apowerspawn6, (math.ceil(GetRandomNumber()*180)+15))
				kill6 = false
			end
			StartTimer(apowerspawn6)
			end,
			apowerspawn6
			) 
			
	apowerspawn7 = CreateTimer("apowerspawn7")
		SetTimerValue(apowerspawn7, math.ceil(GetRandomNumber()*30))
		local kill7 = false
		OnTimerElapse(
			function(timer)
			if kill7 == false then
				print("Spawning armor 7.")
				CreateEntity("com_item_powerup_armor", armorspawn7, "armor7")
				print("Spawning armor 14.")
				CreateEntity("com_item_powerup_armor", armorspawn14, "armor14")
				SetTimerValue(apowerspawn7, 90)
				kill7 = true
			elseif kill7 == true then
				print("Armor 7 expired.")
				KillObject("armor7")
				print("Armor 14 expired.")
				KillObject("armor14")
				SetTimerValue(apowerspawn7, (math.ceil(GetRandomNumber()*180)+15))
				kill7 = false
			end
			StartTimer(apowerspawn7)
			end,
			apowerspawn7
			) 
			
	apowerspawn8 = CreateTimer("apowerspawn8")
		SetTimerValue(apowerspawn8, math.ceil(GetRandomNumber()*30))
		local kill8 = false
		OnTimerElapse(
			function(timer)
			if kill8 == false then
				print("Spawning armor 8.")
				CreateEntity("com_item_powerup_armor", armorspawn8, "armor8")
				print("Spawning armor 12.")
				CreateEntity("com_item_powerup_armor", armorspawn12, "armor12")
				SetTimerValue(apowerspawn8, 90)
				kill8 = true
			elseif kill8 == true then
				print("Armor 8 expired.")
				KillObject("armor8")
				print("Armor 12 expired.")
				KillObject("armor12")
				SetTimerValue(apowerspawn8, (math.ceil(GetRandomNumber()*180)+15))
				kill8 = false
			end
			StartTimer(apowerspawn8)
			end,
			apowerspawn8
			) 
			
	StartTimer(apowerspawn1)
	StartTimer(apowerspawn2)
	StartTimer(apowerspawn3)
	StartTimer(apowerspawn4)
	StartTimer(apowerspawn5)
	StartTimer(apowerspawn6)
	StartTimer(apowerspawn7)
	StartTimer(apowerspawn8)




end

feast = function(self)
	print("The feast function has started.")
	feastspawn1 = GetPathPoint("center_ammo_spawn", 0) 
	feastspawn2 = GetPathPoint("center_ammo_spawn", 1) 
	feastspawn3 = GetPathPoint("center_ammo_spawn", 2) 
	feastspawn4 = GetPathPoint("center_ammo_spawn", 3) 

	feasttimer = CreateTimer("feasttimer")
		SetTimerValue(feasttimer, 450)
		OnTimerElapse(
			function(timer)
			print("Feast time!")
			ShowMessageText("level.HGS.feast")
			option(math.ceil(GetRandomNumber()*8))
			SetTimerValue(feasttimer, (math.ceil(GetRandomNumber()*240)+360))
			StartTimer(feasttimer)
			end,
			feasttimer
			) 

	option = function(num)
		if num == 1 then
			print("\tOption 1 was picked; 1 dual.")
			CreateEntity("com_item_powerup_dual2", feastspawn4, "fammo1")
		
		elseif num == 2 then
			print("\tOption 2 was picked; 1 defense and 1 armor.")
			CreateEntity("com_item_powerup_defense", feastspawn1, "fbuff1")
			CreateEntity("com_item_powerup_armor", feastspawn2, "farmor1")
			
		elseif num == 3 then
			print("\tOption 3 was picked; one full restore.")
			CreateEntity("com_item_powerup_full", feastspawn3, "fammo1") 

		elseif num == 4 then
			print("\tOption 4 was picked; 1 offense and 3 ammos.")
			CreateEntity("com_item_powerup_offense", feastspawn2, "fbuff1") 
			CreateEntity("com_item_powerup_ammo", feastspawn1, "fammo1")
			CreateEntity("com_item_powerup_ammo", feastspawn3, "fammo2")
			CreateEntity("com_item_powerup_ammo", feastspawn4, "fammo3")
			
		elseif num == 5 then
			print("\tOption 5 was picked; two duals.")
			CreateEntity("com_item_powerup_dual2", feastspawn1, "fammo1") 
			CreateEntity("com_item_powerup_dual2", feastspawn3, "fammo2")
		
		elseif num == 6 then
			print("\tOption 6 was picked; two armors.")
			CreateEntity("com_item_powerup_armor", feastspawn4, "farmor1") 
			CreateEntity("com_item_powerup_armor", feastspawn2, "farmor2") 
		
		elseif num == 7 then
			print("\tOption 7 was picked; two duals.")
			CreateEntity("com_item_powerup_dual2", feastspawn3, "fammo1") 
			CreateEntity("com_item_powerup_dual2", feastspawn2, "fammo2") 
		
		elseif num == 8 then
			print("\tOption 8 was picked; offense, defense, and energy.")
			CreateEntity("com_item_powerup_offense", feastspawn4, "fbuff1") 
			CreateEntity("com_item_powerup_defense", feastspawn3, "fbuff2") 
			CreateEntity("com_item_powerup_energy", feastspawn1, "fener1") 
		end
	end		
	StartTimer(feasttimer)
end

function GetNumRegisteredPlayers(players_alive)
	local i, v
	local numRegPla = 0
	
	for i, v in pairs(players_alive) do
		if not players_alive[i] then
			print("Player not found, skipping.")
		else
			if players_alive[i].registered == true then
				numRegPla = numRegPla + 1
			end
		end	
	end
	return numRegPla
end

function RemoveFromList(player)
	print("Removing player "..player.." from players_alive.")
	local s, t
	local tempList = {}
	for s, t in pairs(players_alive) do
		if s ~= player then
			tempList[s] = players_alive[s]
		else
			print("\tFound him. NOT adding him to tempList.")
		end
	end
	players_alive = tempList
	number = RefreshListSize(players_alive)
	--ShowMessageText("level.HGS.debug.npa."..number)
	print("\tSize of list: "..number)
	print("\tDone.\n")
	
	tempList = nil
end
			
function RefreshListSize(players_alive)
	local playersInAliveList = 0
	local i, v
	for i, v in pairs(players_alive) do
		if (GetCharacterUnit(i) ~= nil) then
			playersInAliveList = playersInAliveList + 1
		else
			RemoveFromList(i)
		end
	end
	return playersInAliveList
end

function GetSize(players_eliminated)
	local playersInDeadList = 0
	local i, v
	for i, v in pairs(players_eliminated) do
		playersInDeadList = playersInDeadList + 1
	end
	return playersInDeadList
end

RestoreAmmo = function(self)
	print("Restoring ammo...\n")
	-- testspawn1 = GetPathPoint("center_ammo_spawn", 0) 
	-- testspawn2 = GetPathPoint("center_ammo_spawn", 1) 
	-- testspawn3 = GetPathPoint("center_ammo_spawn", 2) 
	-- testspawn4 = GetPathPoint("center_ammo_spawn", 3) 
	--restoreAmmoPoint = GetEntityMatrix("")
	
	local teleAmmo = GetPathPoint("cp_center2_spawn", 0)
	local center = CreateMatrix(0,0,0,0,0,0,0)
	
	for i, v in pairs(players_alive) do
		local playerPos = GetEntityMatrix(GetCharacterUnit(i))
		if playerReg == true then
			CreateEntity("com_item_powerup_adrenaline", teleAmmo, "testarmor"..i)
		else
			CreateEntity("com_item_powerup_adrenaline", playerPos, "testarmor"..i)
		end
	end
end

--if debug_on then
function spawn(path_name, num)
	local path_nm = path_name
	local path_unit = GetCharacterUnit(0)
	-- local testSpawnTimer = CreateTimer("testSpawnTimer")
	-- SetTimerValue(testSpawnTimer, 1)
	-- local testSpawnTimer2 = CreateTimer("testSpawnTimer2")
	-- SetTimerValue(testSpawnTimer2, 1)
	-- local i = 0
	-- local j = 0
	
	-- OnTimerElapse(
		-- function(timer)

		-- for i = 0, 19 do 
			-- local point = GetPathPoint("normal_ammo_spawn2", num)
			-- print("Spawning normal ammo ", num)
			-- CreateEntity("com_item_powerup_dual2", point, "powerup"..num)
		-- end
		
		-- SetTimerValue(testSpawnTimer, 30)
		-- StartTimer(testSpawnTimer)
		
		-- end,
		-- testSpawnTimer
	-- )
	
	-- OnTimerElapse(
		-- function(timer)
		-- local point = GetPathPoint("normal_ammo_spawn2", num)
		-- print("Spawning normal ammo ", num)
		-- CreateEntity("com_item_powerup_dual2", point, "powerup"..num)
		-- SetEntityMatrix(players_alive[1].playerUnit, point)
		-- i = i + 1
		-- if i > 19 then
			-- i = 0
			-- return --StartTimer(testSpawnTimer2)
		-- else
			-- SetTimerValue(testSpawnTimer, 5)
			-- StartTimer(testSpawnTimer)
		-- end
		-- end,
		-- testSpawnTimer
	-- )
	
	-- OnTimerElapse(
		-- function(timer)
		-- local point = GetPathPoint("special_ammo_spawn3", j)
		-- print("Spawning special ammo ", j)
		-- CreateEntity("com_item_powerup_antiammo", point, "powerup"..j)
		-- j = j + 1
		-- if j <= 11 then
			-- SetTimerValue(testSpawnTimer2, 1)
			-- StartTimer(testSpawnTimer2)
		-- end
		-- end,
		-- testSpawnTimer2
	-- )
	
	--StartTimer(testSpawnTimer)
	
	if path_nm == "norm" then
		local point = GetPathPoint("normal_ammo_spawn2", num)
		print("Spawning normal ammo ", num)
		CreateEntity("com_item_powerup_dual2", point, "powerup"..num)
		SetEntityMatrix(path_unit, point)
		
	elseif path_nm == "normp" then
		local point = GetPathPoint("normal_ammo_spawn2", num)
		if num == 7 then
			CreateEntity("com_snd_amb_alarm", GetPathPoint("normal_ammo_spawn2", 7), "alarm_emitter")
		end
		print("Spawning normal ammo ", num)
		CreateEntity("com_item_powerup_dual2", point, "powerup"..num)
		local powerupPtr = GetEntityPtr("powerup"..num)
		local p_point = GetEntityMatrix(powerupPtr)
		SetEntityMatrix(path_unit, p_point)
		
	elseif path_nm == "spec" then
		local point = GetPathPoint("special_ammo_spawn2", num)
		print("Spawning special ammo ", num)
		CreateEntity("com_item_powerup_antiammo", point, "spowerup"..num)
		SetEntityMatrix(path_unit, point)
		
	elseif path_nm == "specp" then
		local point = GetPathPoint("special_ammo_spawn2", num)
		print("Spawning special ammo ", num)
		CreateEntity("com_item_powerup_antiammo", point, "spowerup"..num)
		local powerupPtr = GetEntityPtr("spowerup"..num)
		local p_point = GetEntityMatrix(powerupPtr)
		SetEntityMatrix(path_unit, p_point)
		
	elseif path_nm == "city" then
		local point = GetPathPoint("armor_spawn2", num)
		print("Spawning armor", num)
		CreateEntity("com_item_powerup_armor", point, "apowerup"..num)
		SetEntityMatrix(path_unit, point)
		
	elseif path_nm == "cityp" then
		local point = GetPathPoint("armor_spawn2", num)
		print("Spawning armor", num)
		CreateEntity("com_item_powerup_armor", point, "apowerup"..num)
		local powerupPtr = GetEntityPtr("apowerup"..num)
		local p_point = GetEntityMatrix(powerupPtr)
		SetEntityMatrix(path_unit, p_point)	
		
	else
		print("Spawn: Bad input.")
		
	end
	
	
	local path_nm
	
	
	
	-- for j = 0, 11 do 
		-- local point = GetPathPoint("special_ammo_spawn3", j)
		-- print("Spawning special ammo ", j)
		-- CreateEntity("com_item_powerup_antiammo", point, "powerup"..j)
	-- end
	
	-- for i = 0, 15 do 
		-- local armorspawn = GetPathPoint("armor_spawn2", num)
		-- print("Spawning armor ", num)
		-- CreateEntity("com_item_powerup_armor", armorspawn, "armor"..num)
	-- end
	
	

	
	-- local cp1_ammospawn1 = GetPathPoint("cp1_spawn", 0)
	-- local cp1_ammospawn2 = GetPathPoint("cp1_spawn", 1) 
	-- local cp2_ammospawn1 = GetPathPoint("cp2_spawn", 0) 
	-- local cp2_ammospawn2 = GetPathPoint("cp2_spawn", 1)
	-- local cp3_ammospawn1 = GetPathPoint("cp3_spawn", 0) 
	-- local cp3_ammospawn2 = GetPathPoint("cp3_spawn", 1) 
	-- local cp4_ammospawn1 = GetPathPoint("cp4_spawn2", 0) 
	-- local cp4_ammospawn2 = GetPathPoint("cp4_spawn2", 1) 
	-- CreateEntity("com_item_powerup_dual2", cp1_ammospawn1, "ammo1")
	-- CreateEntity("com_item_powerup_dual2", cp1_ammospawn2, "ammo2")
	-- CreateEntity("com_item_powerup_dual2", cp2_ammospawn1, "ammo3")
	-- CreateEntity("com_item_powerup_dual2", cp2_ammospawn2, "ammo4")
	-- CreateEntity("com_item_powerup_dual2", cp2_ammospawn1, "ammo5")
	-- CreateEntity("com_item_powerup_dual2", cp3_ammospawn2, "ammo6")
	-- CreateEntity("com_item_powerup_dual2", cp4_ammospawn1, "ammo7")
	-- CreateEntity("com_item_powerup_dual2", cp4_ammospawn2, "ammo8")
	return
	
end
--end

function addPointsToChar(character, dpoints)
	--=======================================
	-- Point changes
	--=======================================
	local Player_Stats_Points = {
		{ point_gain =  0  },			--//	PS_GLB_KILL_AI_PLAYER = 0,
		{ point_gain =  0  },			--//	PS_GLB_KILL_HUMAN_PLAYER,
		{ point_gain =  0  },			--//	PS_GLB_KILL_HUMAN_PLAYER_AI_OFF,
		{ point_gain =  -999  },			--//	PS_GLB_KILL_SUICIDE,		
		{ point_gain =   0  },			--//	PS_GLB_KILL_TEAMMATE,
		{ point_gain =  0  },			--//	PS_GLB_VEHICLE_KILL_INFANTRY_VS_VEHICLE,
		{ point_gain =  0  },			--//	PS_GLB_VEHICLE_KILL_LIGHT_VS_HEAVY,
		{ point_gain =  0  },			--//	PS_GLB_VEHICLE_KILL_LIGHT_VS_MEDIUM,
		{ point_gain =  0  },			--//	PS_GLB_VEHICLE_KILL_HEAVY_VS_LIGHT,
		{ point_gain =  0  },			--//	PS_GLB_VEHICLE_KILL_HEAVY_VS_MEDIUM,
		{ point_gain =  0  },			--//	PS_GLB_VEHICLE_KILL_MEDIUM_VS_LIGHT,
		{ point_gain =  0  },			--//	PS_GLB_VEHICLE_KILL_MEDIUM_VS_HEAVY,
		{ point_gain =  0  },			--//	PS_GLB_VEHICLE_KILL_ATAT,
		{ point_gain =  0  },			--//	PS_GLB_VEHICLE_KILL_EMPTY,
		{ point_gain =   0  },			--//	PS_GLB_HEAL,
		{ point_gain =   0  },			--//	PS_GLB_REPAIR,
		{ point_gain =   0  },			--//	PS_GLB_SNIPER_ACCURACY,
		{ point_gain =   0  },			--//	PS_GLB_HEAVY_WEAPON_MULTI_KILL,
		{ point_gain =  0  },			--//	PS_GLB_RAMPAGE,
		{ point_gain =   0  },			--//	PS_GLB_HEAD_SHOT,
		{ point_gain =   0  },			--//	PS_GLB_KILL_HERO,
		{ point_gain =  0  },			--//	PS_CON_CAPTURE_CP,
		{ point_gain =  0  },			--//	PS_CON_ASSIST_CAPTURE_CP,
		{ point_gain =  0  },			--//	PS_CON_KILL_ENEMY_CAPTURING_CP,
		{ point_gain =  0  },			--//	PS_CON_DEFEND_CP,
		{ point_gain =  0  },			--//	PS_CON_KING_HILL,
		{ point_gain =  0  },			--//	PS_CAP_PICKUP_FLAG,
		{ point_gain =  0  },			--//	PS_CAP_DEFEND_FLAG,
		{ point_gain =  0  },			--//	PS_CAP_CAPTURE_FLAG,
		{ point_gain =  0  },			--//	PS_CAP_DEFEND_FLAG_CARRIER,
		{ point_gain =  0  },			--//	PS_CAP_KILL_ENEMY_FLAG_CARRIER,
		{ point_gain =  0  },			--//	PS_CAP_KILL_ALLY_FLAG_CARRIER,
		{ point_gain =  dpoints  },			--//	PS_ASS_DESTROY_ASSAULT_OBJ,
		{ point_gain =  0  },			--//	PS_ESC_DEFEND,
		{ point_gain =  0  },			--//	PS_DEF_DEFEND,
	}
	
	--save the new points
	ScriptCB_SetPlayerStatsPoints( Player_Stats_Points )
	
	--clean up some memory	--is this needed as its about to go out of scope?
	Player_Stats_Points = nil

	AddAssaultDestroyPoints(character)

end


SetHGPoints = function(self)

	local Player_Stats_Points_post = {
		{ point_gain =  0  },			--//	PS_GLB_KILL_AI_PLAYER = 0,
		{ point_gain =  0  },			--//	PS_GLB_KILL_HUMAN_PLAYER,
		{ point_gain =  0  },			--//	PS_GLB_KILL_HUMAN_PLAYER_AI_OFF,
		{ point_gain =  -999  },			--//	PS_GLB_KILL_SUICIDE,		
		{ point_gain =   0  },			--//	PS_GLB_KILL_TEAMMATE,
		{ point_gain =  0  },			--//	PS_GLB_VEHICLE_KILL_INFANTRY_VS_VEHICLE,
		{ point_gain =  0  },			--//	PS_GLB_VEHICLE_KILL_LIGHT_VS_HEAVY,
		{ point_gain =  0  },			--//	PS_GLB_VEHICLE_KILL_LIGHT_VS_MEDIUM,
		{ point_gain =  0  },			--//	PS_GLB_VEHICLE_KILL_HEAVY_VS_LIGHT,
		{ point_gain =  0  },			--//	PS_GLB_VEHICLE_KILL_HEAVY_VS_MEDIUM,
		{ point_gain =  0  },			--//	PS_GLB_VEHICLE_KILL_MEDIUM_VS_LIGHT,
		{ point_gain =  0  },			--//	PS_GLB_VEHICLE_KILL_MEDIUM_VS_HEAVY,
		{ point_gain =  0  },			--//	PS_GLB_VEHICLE_KILL_ATAT,
		{ point_gain =  0  },			--//	PS_GLB_VEHICLE_KILL_EMPTY,
		{ point_gain =   0  },			--//	PS_GLB_HEAL,
		{ point_gain =   0  },			--//	PS_GLB_REPAIR,
		{ point_gain =   0  },			--//	PS_GLB_SNIPER_ACCURACY,
		{ point_gain =   0  },			--//	PS_GLB_HEAVY_WEAPON_MULTI_KILL,
		{ point_gain =  0  },			--//	PS_GLB_RAMPAGE,
		{ point_gain =   0  },			--//	PS_GLB_HEAD_SHOT,
		{ point_gain =   0  },			--//	PS_GLB_KILL_HERO,
		{ point_gain =  0  },			--//	PS_CON_CAPTURE_CP,
		{ point_gain =  0  },			--//	PS_CON_ASSIST_CAPTURE_CP,
		{ point_gain =  0  },			--//	PS_CON_KILL_ENEMY_CAPTURING_CP,
		{ point_gain =  0  },			--//	PS_CON_DEFEND_CP,
		{ point_gain =  0  },			--//	PS_CON_KING_HILL,
		{ point_gain =  0  },			--//	PS_CAP_PICKUP_FLAG,
		{ point_gain =  0  },			--//	PS_CAP_DEFEND_FLAG,
		{ point_gain =  0  },			--//	PS_CAP_CAPTURE_FLAG,
		{ point_gain =  0  },			--//	PS_CAP_DEFEND_FLAG_CARRIER,
		{ point_gain =  0  },			--//	PS_CAP_KILL_ENEMY_FLAG_CARRIER,
		{ point_gain =  0  },			--//	PS_CAP_KILL_ALLY_FLAG_CARRIER,
		{ point_gain =  0  },			--//	PS_ASS_DESTROY_ASSAULT_OBJ,
		{ point_gain =  0  },			--//	PS_ESC_DEFEND,
		{ point_gain =  0  },			--//	PS_DEF_DEFEND,
	}
	
	--save the new points
	ScriptCB_SetPlayerStatsPoints( Player_Stats_Points_post )
	
	Player_Stats_Points_post = nil
	
end
	

	

