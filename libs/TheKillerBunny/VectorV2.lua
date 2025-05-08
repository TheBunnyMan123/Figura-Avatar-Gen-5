local module = {}
local metatable = {}
metatable.__index = module

function module.new(direction, magnitude)
   return setmetatable({dir=direction, mag=magnitude}, metatable)
end

return module.new(vec(0, 0), 0)

