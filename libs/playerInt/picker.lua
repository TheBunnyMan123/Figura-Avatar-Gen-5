-- This script just makes running functions on others easier.

local lib = require("./setup")

---Toggles immunity, meaning none of the movement functions do anything.
---@param state boolean
function lib.setImmune(state)
  lib.funcs.immune = state
end



---Gets every function an entity has
---
---`uuid` is the entity to get functions from
---@param uuid string
---@return table?
function lib.getFunc(uuid)
  if not world.avatarVars()[uuid] then return end
  return world.avatarVars()[uuid].movement
end



---Runs a function on an entity with this uuid.
---
---`func` is the function to run,
---`uuid` is the entity to run it on.
---
---Any argument after is passed to the function.
---
---Returns result as a boolean,
---and a detailed error if it fails.
---@param uuid string
---@param func string
---@return boolean success
---@return string? result
function lib.runFunc(uuid, func, ...)
  if not world.avatarVars()[uuid] then
    return false, "Target ("..uuid..") does not exist"
  end
  local vars = world.avatarVars()[uuid].movement
  if vars then
    if type(vars[func]) ~= "function" then
      return false, "Couldn't find '"..func.."' function on target ("..uuid..")"
    elseif vars.immune then
      return false, "Target ("..uuid..") is immune"
    end
    vars[func](...)
    return true
  else
    return false, "Target ("..uuid..") does not have MovementAPI"
  end
end



---Runs a CI movement function on an entity with this uuid.
---
---This is just for compatibility with CharterIntegration.
---
---`func` is the function to run,
---`uuid` is the entity to run it on.
---
---Any argument after is passed to the function.
---@param uuid string
---@param func string
function lib.runCI(uuid, func, ...)
  if not world.avatarVars()[uuid] then return end
  local vars = world.avatarVars()[uuid].MovementAPI
  if vars and (type(vars[func]) == "function") then
    vars[func](...)
  end
end



---Runs a CI charter function on an entity with this uuid.
---
---This is just for compatibility with CharterIntegration.
---
---`func` is the function to run,
---`uuid` is the entity to run it on.
---
---Any argument after is passed to the function.
---@param uuid string
---@param func string
function lib.runCharter(uuid, func, ...)
  if not world.avatarVars()[uuid] then return end
  local vars = world.avatarVars()[uuid].CharterIntegration
  if vars and (type(vars[func]) == "function") then
    vars[func](...)
  end
end

return lib
