--******************************************************************--
--WARNING: DO NOT MODIFY THIS FILE UNLESS YOU KNOW WHAT YOU'RE DOING--
--******************************************************************--

---------------------------------
-- HG2Player
--  Class containing player info tables and data to monitor the status of the game
---------------------------------
HG2PlayerManagement = {
  unit_locations = {},              --used by camper killer to track players
  players_alive = {},              --used for tracking various data related to each player alive
  players_eliminated = {},         --used to store ranking for dead players
  
  num_alive = 0,                   --number of players alive.
  num_registered = 0,              --number of players that have registered to play
}

function HG2PlayerManagement:New(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end


---------------------------------
-- HG2Player
--  Class representing a player in the hunger games, stores properties
--  of the player throughout the match
---------------------------------
local HG2Player = {
  char = -1, 
  unit = nil,
  team = -1,
  registered = false,
  spamCount = 0,
  isCamping = false,
  campCount = 0,
  hurtCount = 0
}


function HG2Player:New(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

--------------------------------------------------------------
-- Called on player spawn, adds player to self.players_alive
--
-- @param #int character     character number
-- @param #bool started    true if the games have started and the player needs a rank
function HG2PlayerManagement:AddPlayer(character, _unit, _team)
  print("\nCALLED HG2PlayerManagement:AddPlayer() with args:", character, _unit, _team) 
  self.players_alive[character] = nil 
  self.players_alive[character] = HG2Player:New{
    char = character,
    unit = _unit,
    team = _team
  }
  self.num_alive = self.num_alive + 1
end


--------------------------------------------------------------
-- Called on player death, removes player from self.players_alive and sets rank if needed
--
-- @param #int character     character number
-- @param #bool started    true if the games have started and the player needs a rank
function HG2PlayerManagement:RemovePlayer(character, started)
  print("\nCALLED HG2PlayerManagement:RemovePlayer(character, started) with args:", character, started) 
  self.players_alive[character] = nil
  self.num_alive = self.num_alive - 1
  if started then
    self.players_eliminated[character] = {char = character, rank = -(self.num_alive + 1)}
    return self.players_eliminated[character].rank
  else return 0 end
end



--------------------------------------------------------------
-- Called on player death, removes player from self.players_alive and sets rank if needed
--
-- @param #int character     character number
function HG2PlayerManagement:RegisterPlayer(character)
  print("\nCALLED HG2PlayerManagement:DeRegisterPlayer(character) with args:", character) 
  self.players_alive[character].registered = true
  self.num_registered = self.num_registered + 1
end

--------------------------------------------------------------
-- Called when player deregisters from the game; sets player.registered to false
--
-- @param #int character     character number
function HG2PlayerManagement:DeRegisterPlayer(character)
  print("\nCALLED HG2PlayerManagement:DeRegisterPlayer(character) with args:", character) 
  self.players_alive[character].registered = false
  self.num_registered = self.num_registered - 1
end

--------------------------------------------------------------
-- Called when player shoots a switch; increments and returns spamCount
--
-- @param #int character     character number
function HG2PlayerManagement:IsSpammingSwitch(character)
  self.players_alive[character].spamCount = self.players_alive[character].spamCount + 1
  return self.players_alive[character].spamCount
end


--------------------------------------------------------------
-- Called when the grace period begins 
--    Kills all players with registered == false
function HG2PlayerManagement:KillUnregisteredPlayers()
  print("\nCALLED HG2PlayerManagement:KillUnregisteredPlayers()") 
  local i, v
  for i, v in pairs(self.players_alive) do
    print("\tChecking player: ", i)
    if self.players_alive[i] == nil then
      print("\tSomething went wrong, this player doesn't exist!")
    elseif GetCharacterUnit(i) == nil then
      print("\tThis player's not alive or something.")
    elseif self.players_alive[i].registered == false then
      print("\tThis player is not registered, kill them.")
      KillObject(self.players_alive[i].unit)
      self.players_alive[i] = nil
    end
  end
  print("Done killing unregistered players.\n")
end


--------------------------------------------------------------
-- Called when the registration needs to be reset
--    Sets registered = false for all players alive
function HG2PlayerManagement:ResetRegistration(teleLobby)
  print("\nCALLED HG2PlayerManagement:ResetRegistration()") 
  local i, v
  for i, v in pairs(self.players_alive) do
    if self.players_alive[i].registered == true then
      print("\tDeregistered player:", i)
      self.players_alive[i].registered = false
      SetEntityMatrix(self.players_alive[i].unit, teleLobby)
    end
  end
  self.num_registered = 0
end

function HG2PlayerManagement:PrintPlayerInfo(character)
  print("\tPlayer "..character..":")
  print("\t\tchar = ", self.players_alive[character].char)
  print("\t\tunit = ", self.players_alive[character].unit)
  print("\t\tteam = ", self.players_alive[character].team)
  print("\t\tregistered = ", self.players_alive[character].registered)
  print("\t\tspamCount = ", self.players_alive[character].spamCount)
  print("\t\tisCamping = ", self.players_alive[character].isCamping)
  print("\t\tcampCount = ", self.players_alive[character].campCount)
  print("\t\thurtCount = ", self.players_alive[character].hurtCount)
end


--------------------------------------------------------------
-- Returns number of players alive
function HG2PlayerManagement:GetNumAlive() return self.num_alive end

--------------------------------------------------------------
-- Returns number of players registered
function HG2PlayerManagement:GetNumRegistered() return self.num_registered end

--------------------------------------------------------------
-- Returns registration status of character
function HG2PlayerManagement:IsRegistered(character) return self.players_alive[character].registered end

--------------------------------------------------------------
-- Returns registration status of character
function HG2PlayerManagement:PlayerExists(character) return not (self.players_alive[character] == nil) end




--------------------------------------------------------------
-- Monitors positions of players and hurts them if they have been camping
--
-- @param self.unit_locations          table of tables containing x, y, and z coordinates
-- @param #int min_distance    min distance a player must move to avoid damage
-- @param self.players_alive             table containing player info entries
function HG2PlayerManagement:CamperKiller(min_distance, camp_time)
  print("\nCALLED HG2PlayerManagement:CamperKiller() with args:", min_distance, camp_time) 
   
   local CampCheck = function( player, unit )
      print("Checking player ", player)
      if (player == nil) or (unit == nil) then return end   --check input
      local x, y, z = GetWorldPosition(unit)
      local currentPosition = {x, y, z}
      local previousPosition
      
      
      --start tracking a new player
      if self.unit_locations[player] == nil then
         print("\tStarting to track player")
         self.unit_locations[player] = currentPosition
         --PrintMatrix(self.unit_locations[player])
         return
      else
         --previous location = last stored location
         print("\tPlayer is already being tracked.")
         previousPosition = self.unit_locations[player]
      end
     
     --see if the player has been camping
      if math.abs(previousPosition[1] - currentPosition[1]) < min_distance
         and math.abs(previousPosition[2] - currentPosition[2]) < 20
         and math.abs(previousPosition[3] - currentPosition[3]) < min_distance then
         print("\tPlayer has not moved.")
         --they've now been stationary for another interval, raise interval count
         self.players_alive[player].campCount = self.players_alive[player].campCount + 1
         print("\tPlayer has been in stationary for this many intervals:", self.players_alive[player].campCount)
         
         --If they've been camping for long enough, then they're in trouble.
         if self.players_alive[player].campCount >= (camp_time/10) then
            print("\tPlayer is camping, applying health degen.")
            
            --They might have full health, so the health degen has to be triggered; take away 1 health unit
            if self.players_alive[player].hurtCount == 0 then
               unitHealth = (GetObjectHealth(unit) - 1)
               SetProperty(unit, "CurHealth", unitHealth)
            end
            SetProperty(unit, "AddHealth", -10)
            
            --they are now camping
            if not self.players_alive[player].isCamping then
               self.players_alive[player].isCamping = true
            end
      
         end
         
         
         print(" ")
         return
         
      else      -- their position has changed more than 10 units
         print("\tPlayer has moved.")
         
         --if they WERE camping
         if self.players_alive[player].isCamping then
            
            -- they're moving now so reduce the damage
            SetProperty(unit, "AddHealth", -5)
            
            --increase the number of intervals they've been hurt but moving
            print("\tThe player was camping, so track amount of time they're still being hurt for.")
            self.players_alive[player].hurtCount = self.players_alive[player].hurtCount + 1
            
            --if they've kept moving while being hurt for 3 intervals, then they've had enough
            if self.players_alive[player].hurtCount > 3 then
               print("\tThey've kept moving, so stop hurting them and reset their info.")
               -- reset everything
               SetProperty(unit, "AddHealth", 0)
               self.players_alive[player].isCamping = false
               self.players_alive[player].campCount = 0
               self.players_alive[player].hurtCount = 0
            
            else   -- if they haven't been hurt for long enough, keep hurting them
               print("\tPlayer has been hurt for "..self.players_alive[player].hurtCount.." intervals.")
            end
               
         end
            -- they've moved, so we need to record their new position
            print("\tRecording their current position.\n")
            self.unit_locations[player] = currentPosition
         return
      end
   end
   
   --run camp check for each player alive
   local i, v
   for i, v in pairs(self.players_alive) do
      CampCheck(i, GetCharacterUnit(i) )
   end   
      
end