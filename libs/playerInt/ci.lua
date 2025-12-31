-- Adds compatibility with CharterIntegration.

local lib = require("./setup")
lib.ci = {
  MovementAPI = {},
  CharterIntegration = {}
}
lib.ci.MovementAPI.note = "This is for compat with CI"
avatar:store("MovementAPI",lib.ci.MovementAPI)
avatar:store("CharterIntegration",lib.ci.CharterIntegration)



---@param x Vector3|number
---@param y? number
---@param z? number
function lib.ci.MovementAPI.SetPos(x, y, z)
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
function lib.ci.MovementAPI.SetVelocity(x, y, z)
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



---@param x Vector3|number
---@param y? number
---@param z? number
function lib.ci.MovementAPI.AddVelocity(x, y, z)
  if not lib.host then return end
  if lib.funcs.immune then return end
  if not player:isLoaded() then return end
  if type(x) == "Vector3" then
    if x.x ~= x.x then return end
    if x.y ~= x.y then return end
    if x.z ~= x.z then return end
    lib.config.api:setVelocity(player:getVelocity() + x:clamped(nil, lib.config.speedLimit))
  else
    if not (x and y and z) then return end
    if x ~= x then return end
    if y ~= y then return end
    if z ~= z then return end
    lib.config.api:setVelocity(player:getVelocity() + vec(x, y, z):clamped(nil, lib.config.speedLimit))
  end
end



---@param x Vector3|number
---@param y? number
---@param z? number
function lib.ci.MovementAPI.ThrowToPos(x, y, z)
  if not lib.host then return end
  if lib.funcs.immune then return end
  if not player:isLoaded() then return end
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



---  CHARTER  ---



function lib.ci.CharterIntegration:DD_ClampPos(c1,c2)
  if not lib.host then return end
  if lib.funcs.immune then return end
  if not player:isLoaded() then return end
  local p = player:getPos()
  local newVec = vec(
    math.clamp(p.x, c1.x, c2.x),
    math.clamp(p.y, c1.y, c2.y),
    math.clamp(p.z, c1.z, c2.z)
  )
  if newVec ~= p then
    c1 = c1 + 0.01
    c2 = c2 - 0.01
    newVec = vec(
      math.clamp(p.x, c1.x, c2.x),
      math.clamp(p.y, c1.y+0.1, c2.y),
      math.clamp(p.z, c1.z, c2.z)
    )
    lib.config.api:setPos(newVec)
    if p.y ~= newVec.y then
      lib.ci.MovementAPI.AddVelocity(0,0.1,0)
    end
  end
end



function lib.ci.CharterIntegration:DD_Collapse()
  if not lib.host then return end
  if lib.funcs.immune then return end
  lib.ci.MovementAPI:AddVelocity(0,math.clamp(60,0,lib.config.speedLimit),0)
end
lib.ci.CharterIntegration.LD_Hit = lib.ci.CharterIntegration.DD_Collapse



function lib.ci.CharterIntegration:BLD_Hit()
  if not lib.host then return end
  if lib.funcs.immune then return end
  lib.ci.MovementAPI:AddVelocity(vec(-30,30,0):clamped(0,lib.config.speedLimit)--[[@as number]])
end