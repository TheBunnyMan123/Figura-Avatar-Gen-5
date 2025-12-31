-- These functions are made for use in the figura plaza.
-- Instead of a plugin, these require server commands.

-- Contains functions:
-- movement.setScale(number)
-- movement.sit(boolean)
-- movement.warpTo(string)

-- Server requirements:
-- /scale <number>
-- /sit
-- /warp <string>

local lib = require("../setup")



---Changes the player's scale
---
---Runs "/scale \<scale>"
---@param scale number
function lib.funcs.setScale(scale)
  if lib.funcs.immune or not lib.host then return end
  if type(scale) ~= "number" then return end
  host:sendChatCommand("scale "..scale)
end



---Makes the player sit or unsit
---
---Runs "/sit"
---@param state boolean
function lib.funcs.sit(state)
  if lib.funcs.immune or not lib.host then return end
  if (not not player:getVehicle()) ~= (not not state) then
    host:sendChatCommand("sit")
  end
end



---Teleports the player to a point in the world
---
---Runs "/warp \<area>"
---@param area string
function lib.funcs.warpTo(area)
  if lib.funcs.immune or not lib.host then return end
  host:sendChatCommand("warp "..tostring(area))
end