-- These are the main functions of InteractionEngine.
-- Anything you could need for a simple script.

-- Contains functions:
-- movement.setPos(vec3)
-- movement.setVel(vec3)
-- movement.setRot(vec2)

-- Plugin requirements:
-- plugin:setPos(vec3)
-- plugin:setVelocity(vec3)
-- plugin:setRot(vec2)

local lib = require("../setup")



---@param x Vector3|number
---@param y? number
---@param z? number
function lib.funcs.setPos(x, y, z)
  if not lib.host then return end
  if lib.funcs.immune then return end
  if type(x) == "Vector3" then
    if x.x ~= x.x then return end
    if x.y ~= x.y then return end
    if x.z ~= x.z then return end
    lib.config.api:setPos(x)
  else
    if not (x and y and z) then return end
    if x ~= x then return end
    if y ~= y then return end
    if z ~= z then return end
    lib.config.api:setPos(x, y, z)
  end
end



---@param x Vector3|number
---@param y? number
---@param z? number
function lib.funcs.setVel(x, y, z)
  if not lib.host then return end
  if lib.funcs.immune then return end
  if type(x) == "Vector3" then
    if x.x ~= x.x then return end
    if x.y ~= x.y then return end
    if x.z ~= x.z then return end
    lib.config.api:setVelocity(x:clamped(nil, lib.config.speedLimit))
  else
    if not (x and y and z) then return end
    if x ~= x then return end
    if y ~= y then return end
    if z ~= z then return end
    lib.config.api:setVelocity(vec(x, y, z):clamped(nil, lib.config.speedLimit))
  end
end



---@param x Vector2|number
---@param y? number
function lib.funcs.setRot(x, y)
  if not lib.host then return end
  if lib.funcs.immune then return end
  if type(x) == "Vector2" then
    if x.x ~= x.x then return end
    if x.y ~= x.y then return end
    lib.config.api:setRot(x)
  else
    if not (x and y) then return end
    if x ~= x then return end
    if y ~= y then return end
    lib.config.api:setRot(x, y)
  end
end