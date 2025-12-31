-- Random other functions you probably won't often use.
-- Doesn't have a lot yet.

-- Contains functions:
-- movement.setBodyRot(number)

-- Plugin requirements:
-- plugin:setBodyRot(number)

local lib = require("../setup")



---@param angle number
function lib.funcs.setBodyRot(angle)
  if not lib.host then return end
  if lib.funcs.immune then return end
  if type(angle) ~= "number" then return end
  lib.config.api:setBodyRot(angle)
end