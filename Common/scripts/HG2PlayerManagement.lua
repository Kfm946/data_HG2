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
  hurtCount = 0,
  isExploring = false
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
  print("\tHG2PlayerManagement:AddPlayer() with args:", character, _unit, _team) 
  self.players_alive[character] = nil 
  self.players_alive[character] = HG2Player:New{
    char = character,
    unit = _unit,
    team = _team
  }
  self.num_alive = self.num_alive + 1
  print("\tNew player count:", self.num_alive)
end


--------------------------------------------------------------
-- Called on player death, removes player from self.players_alive and sets rank if needed
--
-- @param #int character     character number
-- @param #bool started    true if the games have started and the player needs a rank
function HG2PlayerManagement:RemovePlayer(character, started)
  print("\tHG2PlayerManagement:RemovePlayer(character, started) with args:", character, started) 
  self.players_alive[character] = nil
  self.num_alive = self.num_alive - 1
  if started then
    return self.num_registered - self.num_alive + 1
  else return 0 end
  print("\tNew player count:", self.num_alive)
end



--------------------------------------------------------------
-- Called on player death, removes player from self.players_alive and sets rank if needed
--
-- @param #int character     character number
function HG2PlayerManagement:RegisterPlayer(character)
  print("\tHG2PlayerManagement:DeRegisterPlayer(character) with args:", character) 
  self.players_alive[character].registered = true
  self.num_registered = self.num_registered + 1
end

--------------------------------------------------------------
-- Called when player deregisters from the game; sets player.registered to false
--
-- @param #int character     character number
function HG2PlayerManagement:DeRegisterPlayer(character)
  print("\tHG2PlayerManagement:DeRegisterPlayer(character) with args:", character) 
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
-- Called on player death, removes player from self.players_alive and sets rank if needed
--
-- @param #int character     character number
function HG2PlayerManagement:SetIsExploring(character, status)
  print("\tHG2PlayerManagement:SetIsExploring(character) with args:", character, status) 
  self.players_alive[character].isExploring = status
end


--------------------------------------------------------------
-- Called when the grace period begins 
--    Kills all players with registered == false
function HG2PlayerManagement:KillUnregisteredPlayers()
  print("\tHG2PlayerManagement:KillUnregisteredPlayers()") 
  local i, v
  for i, v in pairs(self.players_alive) do
    print("\t\tChecking player: ", i)
    if self.players_alive[i] == nil then
      print("\t\tSomething went wrong, this player doesn't exist!")
    elseif GetCharacterUnit(i) == nil then
      print("\t\tThis player's not alive or something.")
      self.players_alive[i] = nil
    elseif self.players_alive[i].registered == false then
      print("\t\tThis player is not registered, kill them.")
      SetProperty(self.players_alive[i].unit, "Team", 2)
      SetProperty(self.players_alive[i].unit, "PerceivedTeam", 2)
      KillObject(self.players_alive[i].unit)
      self.players_alive[i] = nil
    else
      SetProperty(self.players_alive[i].unit, "Team", 1)
      SetProperty(self.players_alive[i].unit, "PerceivedTeam", 1)
    end
  end
  print("\tDone killing unregistered players.")
end

--------------------------------------------------------------
-- Called when the registration needs to be reset
--    Sets registered = false for all players alive
function HG2PlayerManagement:ReturnExploringPlayers(teleLobby)
  print("\tHG2PlayerManagement:ReturnExploringPlayers()") 
  local i, v
  for i, v in pairs(self.players_alive) do
    if self.players_alive[i].isExploring == true then
      print("\t\tReturning player:", i)
      SetEntityMatrix(self.players_alive[i].unit, teleLobby)
      self.players_alive[i].isExploring = false
    end
  end
end


--------------------------------------------------------------
-- Called when the registration needs to be reset
--    Sets registered = false for all players alive
function HG2PlayerManagement:ResetRegistration(teleLobby)
  print("\tHG2PlayerManagement:ResetRegistration()") 
  local i, v
  for i, v in pairs(self.players_alive) do
    if self.players_alive[i].registered == true then
      print("\t\tDeregistered player:", i)
      self.players_alive[i].registered = false
      SetEntityMatrix(self.players_alive[i].unit, teleLobby)
    end
  end
  self.num_registered = 0
end


--------------------------------------------------------------
-- Called when a player dies or when playercheck timer expires
--    Checks number of players alive and returns the char number
--    of the last player alive if only 1 player is left alive
function HG2PlayerManagement:PlayerCheck()
  print("\tHG2PlayerManagement:PlayerCheck()")
  local i, v, winner
  self.num_alive = 0
  for i, v in pairs(self.players_alive) do
    print("\t\tChecking player:", i)
    if GetCharacterUnit(self.players_alive[i].char) ~= nil then
      self.num_alive = self.num_alive + 1
      winner = self.players_alive[i].char
    else
      print("\t\t\tPlayer in list is not alive, removing them:", i)
      self.players_alive[i] = nil
    end
  end
  print("\t"..self.num_alive.." players remaining.")
  --if more than 1 player is left, return -1, else return winner char #
  if self.num_alive > 1 then return -1
  else return winner end
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
-- Returns exploration status of character
function HG2PlayerManagement:IsExploring(character) return self.players_alive[character].isExploring end


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
  print("\nHG2PlayerManagement:CamperKiller() with args:", min_distance, camp_time) 
   
   local CampCheck = function( player, unit )
      print("\tChecking player ", player)
      if (player == nil) or (unit == nil) then return end   --check input
      local x, y, z = GetWorldPosition(unit)
      local currentPosition = {x, y, z}
      local previousPosition
      
      
      --start tracking a new player
      if self.unit_locations[player] == nil then
         print("\t\tStarting to track player")
         self.unit_locations[player] = currentPosition
         --PrintMatrix(self.unit_locations[player])
         return
      else
         --previous location = last stored location
         previousPosition = self.unit_locations[player]
      end
     
     --see if the player has been camping
      if math.abs(previousPosition[1] - currentPosition[1]) < min_distance
         and math.abs(previousPosition[2] - currentPosition[2]) < 20
         and math.abs(previousPosition[3] - currentPosition[3]) < min_distance then
         --they've now been stationary for another interval, raise interval count
         self.players_alive[player].campCount = self.players_alive[player].campCount + 1
         print("\t\tPlayer has been stationary for this many intervals:", self.players_alive[player].campCount)
         
         --If they've been camping for long enough, then they're in trouble.
         if self.players_alive[player].campCount >= (camp_time/10) then
            print("\t\tPlayer is camping, applying health degen.")
            
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
         print("\t\tPlayer has moved.")
         
         --if they WERE camping
         if self.players_alive[player].isCamping then
            
            -- they're moving now so reduce the damage
            SetProperty(unit, "AddHealth", -5)
            
            --increase the number of intervals they've been hurt but moving
            self.players_alive[player].hurtCount = self.players_alive[player].hurtCount + 1
            
            --if they've kept moving while being hurt for 3 intervals, then they've had enough
            if self.players_alive[player].hurtCount > 3 then
               print("\t\tThey've kept moving, so stop hurting them and reset their info.")
               -- reset everything
               SetProperty(unit, "AddHealth", 0)
               self.players_alive[player].isCamping = false
               self.players_alive[player].campCount = 0
               self.players_alive[player].hurtCount = 0
            
            else   -- if they haven't been hurt for long enough, keep hurting them
               print("\t\tPlayer has been hurt for "..self.players_alive[player].hurtCount.." intervals.")
            end
               
         end
            -- they've moved, so we need to record their new position
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