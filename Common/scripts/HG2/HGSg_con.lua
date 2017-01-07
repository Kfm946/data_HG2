--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")

	loadscreen = math.random(3)

	debug_on = true

	players_alive = {}
	players_eliminated = {}
	players = {}

	spawnque = {}
	
	playerReg = true
	gracePeriod = false
	gamesStarted = false

	numPlayersAlive = 0
	numRegisteredPlayers = 0
	
---------------------------------------------------------------------------
-- ScriptPostLoad
---------------------------------------------------------------------------
function ScriptPostLoad()


	


	if uf_processPlayers then
		uf_processPlayers(players)
	end


	
	local Player_Stats_Points_post = {
		{ point_gain =  0  },			--//	PS_GLB_KILL_AI_PLAYER = 0,
		{ point_gain =  0  },			--//	PS_GLB_KILL_HUMAN_PLAYER,
		{ point_gain =  0  },			--//	PS_GLB_KILL_HUMAN_PLAYER_AI_OFF,
		{ point_gain =  0  },			--//	PS_GLB_KILL_SUICIDE,		
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

	
	cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}
    cp4 = CommandPost:New{name = "cp4"}
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
	conquest:AddCommandPost(cp_center)
	conquest:AddCommandPost(cp_center1)
	conquest:AddCommandPost(cp_center2)

	--Turn on the registration regions
	ActivateRegion("register2")
	ActivateRegion("team2_capture")
	
	--set up variables
	local destLoc = GetEntityMatrix("cp_center")
	local teleBack = GetPathPoint("cp_center1_spawn", 0)
	print("teleBack is: ", teleBack)
	local i = 1
	
	--if this is false, the timer shouldn't be running, and nobody should be registered
	regOpen = false
	--if this is true, no players have registered yet, so the timer shouldn't be running
	firstReg = true
	
		--timer for registration period
	registrationTimer = CreateTimer("registrationTimer")
	SetTimerValue(registrationTimer, 20)

	SetProperty("registration_switch", "CurHealth", 4)
	SetTeamAsFriend(1, 2)
	SetTeamAsFriend(2, 1)
	AllowAISpawn(1, false)
	AllowAISpawn(2, false)
	SetClassProperty("com_bldg_controlzone", "NeutralizeTime", 999999)
	SetClassProperty("com_bldg_controlzone", "CaptureTime", 999999)
	SetClassProperty("com_bldg_major_controlzone", "NeutralizeTime", 999999)
	SetClassProperty("com_bldg_major_controlzone", "CaptureTime", 999999)
		

	VisualTimer = CreateTimer("VisualTimer")
	ShowTimer(VisualTimer)
	SetTimerValue(VisualTimer, 20)
		

	--Spawn Timer: hopefully this will get rid of the #1 in spawn que issues on PC dedi servers
	
	spawntimer = CreateTimer("spawntimer")
	SetTimerValue(spawntimer, 15)
	OnTimerElapse(
		function( timer )
			print("\nSpawn timer elapsed")
			--lower forcefields
			local i
			local sizeof = table.getn( spawnque )
			print(sizeof)
			for i = 1, sizeof do
				--CHECK TO SEE IF HE's spawned yet.
				local unit = GetCharacterUnit(spawnque[i])
				if unit then 
					--crap
				else
					--only spawn if not unit
					SpawnCharacter(spawnque[i], teleBack)
					print("spawned")
				end
			end
			for i = 1, sizeof do
			table.remove(spawnque, 1)
			end
			SetTimerValue(spawntimer, 15)
			StartTimer(spawntimer)
		end, "spawntimer" 
	)

	StartTimer(spawntimer)
		
	--==============================--
	---***GRACE PERIOD TIMERS***---
	--==============================--

	ReadRules = CreateTimer("ReadRules")
		SetTimerValue(ReadRules, 6)
		OnTimerElapse(
			function(timer)
				ShowMessageText("level.HGS.gp2")
				DestroyTimer(ReadRules)
				StartTimer(ReadRules2)
			end,
			ReadRules
			)	
			
	ReadRules2 = CreateTimer("ReadRules2")
		SetTimerValue(ReadRules2, 6)
		OnTimerElapse(
			function(timer)
				ShowMessageText("level.HGS.gp3")
				DestroyTimer(ReadRules2)
				StartTimer(ReadRules3)
			end,
			ReadRules2
			) 
	
	ReadRules3 = CreateTimer("ReadRules3")
		SetTimerValue(ReadRules3, 5)
		OnTimerElapse(
			function(timer)
				print("Moving all players to team 1")
				for i = 1, table.getn(players_alive) do
					
					if not players_alive[i] then
						print("something went wrong, this player doesn't exist!")
					else
						SetProperty(players_alive[i].playerUnit, "Team", 1)
						SetProperty(players_alive[i].playerUnit, "PerceivedTeam", 1)
						print("This player's team is now: ", GetCharacterTeam(players_alive[i].playerChar))
					end
				end
				ShowMessageText("level.HGS.gp_count")
				DestroyTimer(ReadRules3)
				ShowMessageText("level.HGS.countdown3")
				StartTimer(countdown3_gp)
			end,
			ReadRules3
			) 
				
	countdown3_gp = CreateTimer("countdown3_gp")
		SetTimerValue(countdown3_gp, 1)
		OnTimerElapse(
			function(timer)
				ShowMessageText("level.HGS.countdown2")
				DestroyTimer(countdown3_gp)
				StartTimer(countdown2_gp)
			end,
			countdown3_gp
			) 
				
	countdown2_gp = CreateTimer("countdown2_gp")
		SetTimerValue(countdown2_gp, 1)
		OnTimerElapse(
			function(timer)
				ShowMessageText("level.HGS.countdown1")
				DestroyTimer(countdown2_gp)
				StartTimer(countdown1_gp)
			end,
			countdown2_gp
			) 
		
	countdown1_gp = CreateTimer("countdown1_gp")
		SetTimerValue(countdown1_gp, 1)
		OnTimerElapse(
			function(timer)
				ShowMessageText("level.HGS.gp_begin")
				MapRemoveEntityMarker("cp_center")
				DestroyTimer(countdown1_gp)
				StartTimer(GracePeriodTimer)
				SetTimerValue(VisualTimer, 30)
				StartTimer(VisualTimer)
				KillObject("com_inv_col_16_con1")
				KillObject("com_inv_col_16_con2")
				KillObject("com_inv_col_16_con3")
				KillObject("com_inv_col_16_con4")
				KillObject("com_inv_col_16_con")
			end,
			countdown1_gp
			) 

	GracePeriodTimer = CreateTimer("GracePeriodTimer")
		SetTimerValue(GracePeriodTimer, 27)
		OnTimerElapse(
			function(timer)
				ShowMessageText("level.HGS.countdown3")
				DestroyTimer(GracePeriodTimer)
				StartTimer(countdown3_hg)
			end,
			GracePeriodTimer
			) 	

	countdown1_hg = CreateTimer("countdown1_hg")
		SetTimerValue(countdown1_hg, 1)
		OnTimerElapse(
			function(timer)
				DestroyTimer(countdown1_hg)
				gracePeriod = false
				gamesStarted = true
						
				print("The Games have begun!\n")
				ShowMessageText("level.HGS.games_begun", 1)
				ShowMessageText("level.HGS.games_begun", 2)
				SetTeamAsEnemy(1, 1)
				SetTeamAsEnemy(1, 2)
				SetTeamAsEnemy(2, 2)
				SetTeamAsEnemy(2, 2)
				SetTeamAsEnemy(3, 3)
				
				cpAmmoSpawn()
				superpowers()
				--armorspawn()
				--ammospawn()
				
				end,
			countdown1_hg
			) 
			
	countdown2_hg = CreateTimer("countdown2_hg")
		SetTimerValue(countdown2_hg, 1)
		OnTimerElapse(
			function(timer)
				ShowMessageText("level.HGS.countdown1", 1)
				ShowMessageText("level.HGS.countdown1", 2)
				DestroyTimer(countdown2_hg)
				StartTimer(countdown1_hg)
			end,
			countdown2_hg
			) 
			
	countdown3_hg = CreateTimer("countdown3_hg")
		SetTimerValue(countdown3_hg, 1)
		OnTimerElapse(
			function(timer)
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
	
		-- ShowMessageText("level.HGS.gotostart")
	
		-- GoToMessage = CreateTimer("GoToMessage")
		-- SetTimerValue(GoToMessage, 15)
		-- OnTimerElapse(
			-- function(timer)
				-- ShowMessageText("level.HGS.gotostart", 1)
				-- ShowMessageText("level.HGS.gotostart", 2)
				-- SetTimerValue(GoToMessage, 15)
				-- StartTimer(GoToMessage)
			-- end,
			-- GoToMessage
			-- ) 
		-- StartTimer(GoToMessage)
		--StartTimer(CheckPlayerCount)
			
		
		
	onspawn = OnCharacterSpawn(
		function(character)
			local charUnit = GetCharacterUnit(character)
			--ShowObjectiveTextPopup("level.HGS.intro_popup")
			antipower(character)
			playerInfo = {
				playerChar = character, 
				playerUnit = charUnit, 
				playerTeam = GetCharacterTeam(character),
				registered = false--,
				--playerName = ReturnName(charUnit)
				}
			table.insert(players_alive, playerInfo)
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
		for i = 1, table.getn(players_alive) do
					
			if not players_alive[i] then
				print("something went wrong, this player doesn't exist!")
			else
				print("\tTeleporting character back to start: ", players_alive[i].playerUnit)
				local teleUnit = GetCharacterUnit(players_alive[i].playerChar)
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
	end


	OnTimerElapse(
		function(timer)
		
			--if there are enough players registered (more than 1), the games can start
			if (numRegisteredPlayers > 1) then
				
				ShowMessageText("level.HGS.entered")
				
				print("We have enough people, let's play.\n")
				
				--Destroy the registration zones/regions
				MapRemoveRegionMarker("register2")
				MapRemoveRegionMarker("team2_capture") 
		
				KillObject("com_bldg_ctfbase2")
				KillObject("com_bldg_ctfbase3")
				DeactivateRegion("register2")
				DeactivateRegion("team2_capture")
				
				--stop the registration message
				--StopTimer(GoToMessage)
				--DestroyTimer(GoToMessage)
				StopTimer(registrationTimer)
				DestroyTimer(registrationTimer)

				print("\nKilling unregistered players")
				for i = 1, table.getn(players_alive) do
					if not players_alive[i] then
						print("something went wrong, this player doesn't exist!")
				
					else if players_alive[i].registered == false then
					
						print("This player is not registered, kill them: ", players_alive[i].playerUnit)
						KillObject(players_alive[i].playerUnit)

					end
					end
					
				end
				
				regOpen = false
				playerReg = false
				gracePeriod = true
				
				numPlayersAlive = table.getn(players_alive)
				
				KillObject("registration_switch")
				ActivateObject("com_inv_col_16_con1")
				ActivateObject("com_inv_col_16_con2")
				ActivateObject("com_inv_col_16_con3")
				ActivateObject("com_inv_col_16_con4")
				ActivateObject("com_inv_col_16_con")
				SetClassProperty("com_bldg_controlzone", "NeutralizeTime", 1)
				SetClassProperty("com_bldg_major_controlzone", "NeutralizeTime", 1)
				
				SetProperty(players_alive[1].playerUnit, "Team", 1)
				SetProperty(players_alive[1].playerUnit, "PerceivedTeam", 1)				
				SetProperty(players_alive[2].playerUnit, "Team", 2)
				SetProperty(players_alive[2].playerUnit, "PerceivedTeam", 2)
				
				SetTimerValue(VisualTimer, 20)
				StartTimer(VisualTimer)
				StartTimer(ReadRules)
				
				ShowMessageText("level.HGS.gp1")
				
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
	
	OnObjectKill(
		function(object, killer)
		
			local name = GetEntityName(object)
			if name == "registration_switch" then
				if not gracePeriod then
					RespawnObject("registration_switch")
				end
				SetProperty("registration_switch", "CurHealth", 4)
				if not killer then return end	--do nothing if no killer
				if not IsCharacterHuman(killer) then return end --do nothing unless killer is a human
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
					MapAddRegionMarker("register2", "hud_objective_icon", 3.0, 1, "YELLOW", true, true, true) 
					MapAddRegionMarker("team2_capture", "hud_objective_icon", 3.0, 2, "YELLOW", true, true, true) 
		
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
			
				local charUnit = GetCharacterUnit(character)
				SetEntityMatrix(charUnit, destLoc)
		
				print("\tFinding the character in the players_alive list")
				for i = 1, table.getn(players_alive) do
						
					if not players_alive[i] then
						print("something went wrong, this player doesn't exist!")
					else if character == players_alive[i].playerChar then
						print("\tFound him, registering him now")
						players_alive[i].registered = true
						print("\tThe player is registered:", players_alive[i].registered)
						numRegisteredPlayers = GetNumRegisteredPlayers(players_alive)
						print("\tThere are now this many registered players: ", numRegisteredPlayers)
						ShowMessageText("level.HGS.entered")
					end
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
			
				local charUnit = GetCharacterUnit(character)
				SetEntityMatrix(charUnit, destLoc)
		
				print("\tFinding the character in the players_alive list")
				for i = 1, table.getn(players_alive) do
						
					if not players_alive[i] then
						print("something went wrong, this player doesn't exist!")
					else if character == players_alive[i].playerChar then
						print("\tFound him, registering him now")
						players_alive[i].registered = true
						print("\tThe player is registered:", players_alive[i].registered)
						numRegisteredPlayers = GetNumRegisteredPlayers(players_alive)
						print("\tThere are now this many registered players: ", numRegisteredPlayers)
						ShowMessageText("level.HGS.entered")
					end
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
			function(character)
				print("Ruh roh, someone died.")
				--even if a guy dies, we still need to de-register him and stuff. 
			
				--1. If the games haven't started, simply remove him from players_alive
				if playerReg == true then
					print("\tPlayer registration is open, so we'll just remove him from players_alive.")
					local e
					for e = 1, table.getn(players_alive) do
						if character == players_alive[e].playerChar then
							--print("(\tNow pretending to remove the player from players_alive, bla bla bla)\n")
							print("\tFound the player, is he registered?", players_alive[e].registered)
							print("\tRemoving the player from players_alive")
							table.insert(spawnque, players_alive[e].playerUnit)
							table.remove(players_alive, e)
							umRegisteredPlayers = GetNumRegisteredPlayers(players_alive)
							print("\tThere are now this many registered players: ", numRegisteredPlayers)
							print(" ")
						end
					end
				
				
				--2. If the games have started, then this player must be assigned a rank
				else
					print("\tThe games have started, so we need to add him to the dead people list.")
					local f
					for f = 1, table.getn(players_alive) do
						if character == players_alive[f].playerChar then
							print("\tFound him, creating his info table and adding him to players_eliminated")
							playerInfo = {playerChar = character,
										  playerRank = numPlayersAlive}
							table.insert(players_eliminated, playerInfo)
							print("\tRemoving him from players alive")
							table.remove(players_alive, f)
							numPlayersAlive = table.getn(players_alive)
							addPointsToChar(players_eliminated[j].playerChar, numPlayersAlive - playerInfo[f].playerRank)
							print("\tThere are now this many players alive: ", numPlayersAlive)
						end
					end
				
		
				--3. If there's only 1 player left alive, then the game is over, that player is the winner
					if  table.getn(players_alive) <= 1 then
						print("\n\tThere's only one person left alive!! He's the winner!")
						if not players_alive[i] then
							print("something went wrong, player not found")
						else 						
							local charUnit = players_alive[i].playerUnit
							addPointsToChar(players_alive[f].playerChar, 100)
							SetProperty(charUnit, "Team", 2)
							SetProperty(charUnit, "PerceivedTeam", 2)
							MissionVictory(2)
						end
					end
				end
			end
		)

		

	SafetyCheck = CreateTimer("SafetyCheck")
	SetTimerValue(SafetyCheck, 20)
	OnTimerElapse(
		function(timer)
			print("performing safety check")
			local f
			for f = 1, table.getn(players_alive) do
				if not players_alive[f] then
					print("something went wrong, player not found")
				else if IsObjectAlive(players_alive[f].playerUnit) then
					print("This player's safe!")
				else
					table.remove(players_alive, f)
					numRegisteredPlayers = numRegisteredPlayers - 1
				end
				end
				if not playerReg then
					if  table.getn(players_alive) <= 1 then
						print("\n\tThere's only one person left alive!! He's the winner!")
						if not players_alive[f] then
							print("something went wrong, player not found")
						else
							local charUnit = players_alive[f].playerUnit
							addPointsToChar(players_alive[f].playerChar, 100)
							SetProperty(charUnit, "Team", 2)
							SetProperty(charUnit, "PerceivedTeam", 2)
							MissionVictory(2)
						end
					end
					if GetPlayersAlive() <= 1 then
						print("Something's gone terribly wrong, ending the map now")
						MissionVictory(2)
					end
				else
					
				end
			end
	
		SetTimerValue(SafetyCheck, 20) 
		StartTimer(SafetyCheck)
		end,
		"SafetyCheck")
	StartTimer(SafetyCheck)
	
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

   	-- if loadscreen == 1 then
		-- ReadDataFile("dc:LoadS\\common.lvl")
	-- else if loadscreen == 2 then
		-- ReadDataFile("dc:LoadT\\common.lvl")
	-- else if loadscreen == 3 then
		-- ReadDataFile("dc:LoadF\\common.lvl")
	-- -- else 
		-- -- ReadDataFile("dc:LoadM\\common.lvl")
	-- end end end
	ReadDataFile("dc:LoadS\\common.lvl")

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
    
    SetMemoryPoolSize ("ClothData",20)
    SetMemoryPoolSize ("Combo",50)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",650)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",650) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",650)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",550)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",6000)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",100)     -- should be ~1x #combo  
    
	--ReadDataFile("dc:sound\\tat.lvl;tat2gcw")
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

	--ReadDataFile("dc:sound\\hgs.lvl;hgscw")
    --ReadDataFile("dc:sound\\kam.lvl;kam1cw")
    --ReadDataFile("dc:sound\\yav.lvl;yav1cw")
	ReadDataFile("sound\\dag.lvl;dag1cw")
    --ReadDataFile("sound\\dag.lvl;dag1gcw")
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
     
	AddUnitClass(CIS, "hgs_cis_inf_rifleman", 0, 16) 
	AddUnitClass(CIS, "hgs_cis_inf_officer", 0, 16) 
	AddUnitClass(REP, "hgs_imp_inf_officer", 0, 16)
	AddUnitClass(REP, "hgs_imp_inf_dark_trooper", 0, 16)
   

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
    SetMemoryPoolSize("EntitySoundStream", 64)
    SetMemoryPoolSize("EntitySoundStatic", 32)
    SetMemoryPoolSize("MountedTurret", 32)
	SetMemoryPoolSize("Music", 128)
	SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
	SetMemoryPoolSize("SoldierAnimation", 1800) 
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
    
    SetSpawnDelay(10.0, 0.25)
    --ReadDataFile("dc:HGS\\HGS.lvl", "HGS_conquest")
    ReadDataFile("dc:HGS\\HGS.lvl", "HGS_conquest")
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
    -- OpenAudioStream("sound\\yav.lvl",  "yav1")
    -- OpenAudioStream("sound\\yav.lvl",  "yav1")
    -- OpenAudioStream("sound\\yav.lvl",  "yav1_emt")
	--OpenAudioStream("dc:sound\\tat.lvl",  "tat2")
    --OpenAudioStream("dc:sound\\tat.lvl",  "tat2")
	OpenAudioStream("sound\\dag.lvl",  "dag1")
    OpenAudioStream("sound\\dag.lvl",  "dag1")
    OpenAudioStream("sound\\dag.lvl",  "dag1_emt")
	-- OpenAudioStream("sound\\kam.lvl",  "kam1")
    -- OpenAudioStream("sound\\kam.lvl",  "kam1")

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
	CreateEntity("com_item_powerup_antiammo", unitLocation, "antiammo")
	-- SetEntityMatrix("antiarmor", unitLocation)
	-- SetEntityMatrix("antiammo", unitLocation)
	SetProperty(unit, "CurShield", 0)

end 

superpowers = function(self)

	sammo_spawn1 = GetPathPoint("special_ammo_spawn", 0)
	sammo_spawn2 = GetPathPoint("special_ammo_spawn", 1)
	sammo_spawn3 = GetPathPoint("special_ammo_spawn", 2)
	sammo_spawn4 = GetPathPoint("special_ammo_spawn", 3)

	spec_powerup1 = CreateTimer("spec_powerup1")
		SetTimerValue(spec_powerup1, 1)
		OnTimerElapse(
			function(timer)
		CreateEntity("com_item_powerup_full", sammo_spawn1, "full") --CreateEntity(class, node, name)
			DestroyTimer(spec_powerup1)
			end,
			spec_powerup1
			) 
			
	spec_powerup2 = CreateTimer("spec_powerup2")
		SetTimerValue(spec_powerup2, 1)
		OnTimerElapse(
			function(timer)
		CreateEntity("com_item_powerup_inv", sammo_spawn2, "invinc") --CreateEntity(class, node, name)
			DestroyTimer(spec_powerup2)
			end,
			spec_powerup2
			) 
			
	spec_powerup3 = CreateTimer("spec_powerup3")
		SetTimerValue(spec_powerup3, 1)
		OnTimerElapse(
			function(timer)
		CreateEntity("com_item_powerup_onehit", sammo_spawn3, "onehit") --CreateEntity(class, node, name)
			DestroyTimer(spec_powerup3)
			end,
			spec_powerup3
			) 
			
	spec_powerup4 = CreateTimer("spec_powerup4")
		SetTimerValue(spec_powerup4, 1)
		OnTimerElapse(
			function(timer)
		CreateEntity("com_item_powerup_armor", sammo_spawn4, "armor") --CreateEntity(class, node, name)
			DestroyTimer(spec_powerup4)
			end,
			spec_powerup4
			) 
			
	StartTimer(spec_powerup1)
	StartTimer(spec_powerup2)
	StartTimer(spec_powerup3)
	StartTimer(spec_powerup4)

end

GetPlayersAlive = function(self)

	return (GetNumTeamMembersAlive(1) + GetNumTeamMembersAlive(2))
	
end

ReturnName = function(charUnit)
	if uf_processPlayers then
		local players = uf_processPlayers(GetName)
		return players[charUnit].namestr
	else
		return "nil"
	end
end
	
GetName = function(players)
	return players
end
-- DeclareWinner = function(players_alive)


-- if uf_processPlayers then
	-- --a function to kill [RDH]Zerted, the function takes a single table 'players' as an argument/parameter
	-- local DeclareWinner = function( players )
		-- --can't do anything if the player data table is missing
		-- if not players then return end
	
		-- --for each player ingame,
		-- local i
		-- for i=1,table.getn(players) do
			-- --search for the player with the name [RDH]Zerted
			-- if players[i].namestr == "[RDH]Zerted" then
				-- --get [RDH]Zerted's unit
				-- local unit = GetCharacterUnit(players[i].indexstr)
				-- if not unit then return end	--[RDH]Zerted is already dead, so there is nothing more for us to do
				
				-- --kill [RDH]Zerted's ingame unit
				-- KillObject( unit )
				-- return
			-- end
		-- end
	-- end
	
	-- --gets the player list, then calls the given function with the player data
	-- uf_processPlayers( killZerted )
-- else
	-- --of course, the player won't see this debug message, but it doesn't hurt to have it...
	-- ShowMessageText("level.HGS.plist")
	-- print("WARNING: Cannot kill [RDH]Zerted: The uf_processPlayers function is missing.  Please update your game to the latest UnOfficial v1.3 patch")
-- end
-- end

cpAmmoSpawn = function(self)

 --get the path point
	cp1_ammospawn1 = GetPathPoint("cp1_spawn", 0) --GetPathPoint(Pathname, node)
	cp1_ammospawn2 = GetPathPoint("cp1_spawn", 1) 
	cp2_ammospawn1 = GetPathPoint("cp2_spawn", 0) 
	cp2_ammospawn2 = GetPathPoint("cp2_spawn", 1)
	cp3_ammospawn1 = GetPathPoint("cp3_spawn", 0) 
	cp3_ammospawn2 = GetPathPoint("cp3_spawn", 1) 
	cp4_ammospawn1 = GetPathPoint("cp4_spawn", 0) 
	cp4_ammospawn2 = GetPathPoint("cp4_spawn", 1) 

	cp1_powerspawn1 = CreateTimer("cp1_powerspawn1")
		SetTimerValue(cp1_powerspawn1, 90)
		OnTimerElapse(
			function(timer)
		CreateEntity("com_item_powerup_dual", cp1_ammospawn1, "ammo1") --CreateEntity(class, node, name)
			SetTimerValue(cp1_powerspawn1, 90)
			StartTimer(cp1_powerspawn1)
			end,
			cp1_powerspawn1
			) 

	cp1_powerspawn2 = CreateTimer("cp1_powerspawn2")
		SetTimerValue(cp1_powerspawn2, 90)
		OnTimerElapse(
			function(timer)
		CreateEntity("com_item_powerup_dual", cp1_ammospawn2, "ammo2") 
			SetTimerValue(cp1_powerspawn2, 110)
			StartTimer(cp1_powerspawn2)
			end,
			cp1_powerspawn2
			) 
			
	cp2_powerspawn1 = CreateTimer("cp2_powerspawn1")
		SetTimerValue(cp2_powerspawn1, 90)
		OnTimerElapse(
			function(timer)
		CreateEntity("com_item_powerup_dual", cp2_ammospawn1, "ammo3") 
			SetTimerValue(cp2_powerspawn1, 80)
			StartTimer(cp2_powerspawn1)
			end,
			cp2_powerspawn1
			) 
			
	cp2_powerspawn2 = CreateTimer("cp2_powerspawn2")
		SetTimerValue(cp2_powerspawn2, 90)
		OnTimerElapse(
			function(timer)
		CreateEntity("com_item_powerup_dual", cp2_ammospawn2, "ammo4")
			SetTimerValue(cp2_powerspawn2, 120)
			StartTimer(cp2_powerspawn2)
			end,
			cp2_powerspawn2
			) 
			
	cp3_powerspawn1 = CreateTimer("cp3_powerspawn1")
		SetTimerValue(cp3_powerspawn1, 90)
		OnTimerElapse(
			function(timer)
		CreateEntity("com_item_powerup_dual", cp3_ammospawn1, "ammo5")
			SetTimerValue(cp3_powerspawn1, 150)
			StartTimer(cp3_powerspawn1)
			end,
			cp3_powerspawn1
			) 

	cp3_powerspawn2 = CreateTimer("cp3_powerspawn2")
		SetTimerValue(cp3_powerspawn2, 90)
		OnTimerElapse(
			function(timer)
		CreateEntity("com_item_powerup_dual", cp3_ammospawn2, "ammo6") 
			SetTimerValue(cp3_powerspawn2, 90)
			StartTimer(cp3_powerspawn2)
			end,
			cp3_powerspawn2
			) 
			
	cp4_powerspawn1 = CreateTimer("cp4_powerspawn1")
		SetTimerValue(cp4_powerspawn1, 90)
		OnTimerElapse(
			function(timer)
		CreateEntity("com_item_powerup_dual", cp4_ammospawn1, "ammo7")
			SetTimerValue(cp4_powerspawn1, 100)
			StartTimer(cp4_powerspawn1)
			end,
			cp4_powerspawn1
			) 
			
	cp4_powerspawn2 = CreateTimer("cp4_powerspawn2")
		SetTimerValue(cp4_powerspawn2, 90)
		OnTimerElapse(
			function(timer)
		CreateEntity("com_item_powerup_dual", cp4_ammospawn2, "ammo8")
			SetTimerValue(cp4_powerspawn2, 60)
			StartTimer(cp4_powerspawn2)
			end,
			cp4_powerspawn2
			) 

	StartTimer(cp1_powerspawn1)
	StartTimer(cp1_powerspawn2)
	StartTimer(cp2_powerspawn1)
	StartTimer(cp2_powerspawn2)
	StartTimer(cp3_powerspawn1)
	StartTimer(cp3_powerspawn2)
	StartTimer(cp4_powerspawn1)
	StartTimer(cp4_powerspawn2)


end

function GetNumRegisteredPlayers(players_alive)
	local i
	local numRegPla = 0
	
	for i = 1, table.getn(players_alive) do
		if not players_alive[i] then
			print("something went wrong, this player doesn't exist!")
		else if players_alive[i].registered == true then
			numRegPla = numRegPla + 1
		end
		end
	end
	return numRegPla
end

function addPointsToChar(character, dpoints)
	--=======================================
	-- Point changes
	--=======================================
	local Player_Stats_Points = {
		{ point_gain =  0  },			--//	PS_GLB_KILL_AI_PLAYER = 0,
		{ point_gain =  0  },			--//	PS_GLB_KILL_HUMAN_PLAYER,
		{ point_gain =  0  },			--//	PS_GLB_KILL_HUMAN_PLAYER_AI_OFF,
		{ point_gain =  0  },			--//	PS_GLB_KILL_SUICIDE,		
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

	--now try to update him in our record.
	local u
	local gotheem
	gotheem = false
	for u = 1, table.getn(playerpoints) do
		if playerpoints[u].ptr == character then
			playerpoints[u].points = playerpoints[u].points + dpoints
			gotheem = true
		end
	end
	if gotheem == false then
		guy = {ptr = character, points = dpoints}
		table.insert(playerpoints, guy)
	end
end