-- These functions are just for convenience.
-- You probably won't need these for anything.

-- Contains functions:
-- movement.throwTo(vec3)
-- movement.lookTo(vec3)

-- Plugin requirements:
-- plugin:setVelocity(vec3)
-- plugin:setRot(vec2)

local lib = require("../setup")



---@param x Vector3|number
---@param y? number
---@param z? number
function lib.funcs.throwTo(x, y, z)
  if not lib.host then return end
  if lib.funcs.immune then return end
  if type(x) == "Vector3" then
    if x.x ~= x.x then return end
    if x.y ~= x.y then return end
    if x.z ~= x.z then return end
    lib.config.api:setVelocity((x - player:getPos()):clamped(nil, lib.config.speedLimit))
  else
    if not (x and y and z) then return end
    if x ~= x then return end
    if y ~= y then return end
    if z ~= z then return end
    lib.config.api:setVelocity((vec(x, y, z) - player:getPos()):clamped(nil, lib.config.speedLimit))
  end
end



---Gets a rotation pointing from point A to point B
---
---Full credit to NikoSolstice for this function,
---im too bad at math to make something like this
---@param pointA Vector3
---@param pointB Vector3
---@return Vector3
local function getRotationToPoint(pointA, pointB)
  local diffXZ = pointB.xz - pointA.xz
  local final_rot = vec(0, -math.deg(math.atan2(diffXZ.y--[[@as number]], diffXZ.x--[[@as number]])) + 90, 0)

  local diffXY = vec(diffXZ:length(), pointB.y) - vec(0, pointA.y)
  local diffY_Rot = vec(-math.deg(math.atan2(diffXY.y, diffXY.x)), 0, 0)

  final_rot = final_rot + diffY_Rot
  return final_rot
end



---@param x Vector3|number
---@param y? number
---@param z? number
function lib.funcs.lookTo(x,y,z)
  if not lib.host then return end
  if lib.funcs.immune then return end
  local cpos = player:getPos():add(0,player:getEyeHeight())
  if type(x) == "Vector3" then
    if x.x ~= x.x then return end
    if x.y ~= x.y then return end
    if x.z ~= x.z then return end
    lib.config.api:setRot(getRotationToPoint(cpos, x).xy)
  else
    if not (x and y and z) then return end
    if x ~= x then return end
    if y ~= y then return end
    if z ~= z then return end
    lib.config.api:setRot(getRotationToPoint(cpos, vec(x,y,z)).xy)
  end
end