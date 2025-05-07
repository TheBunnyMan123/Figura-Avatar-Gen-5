--[[
-- Inverse Kinematics
-- Modifies: leg animations, arm animations
--
-- FABRIK
--   Vectors --> points on a line
--   Easy --> fast
--   Best guess method
--
--   lengths
--     start position
--     goal
--     previous points in the system
--]]


local parts = {
   LeftLeg = {
      {part = models.model.root.LeftLeg, length = 8},
      {part = models.model.root.LeftLeg.Lower2, length = 8}
   },
   RightLeg = {
      {part = models.model.root.RightLeg, length = 8},
      {part = models.model.root.RightLeg.Lower, length = 8}
   },
   LeftArm = {
      {part = models.model.root.LeftArm, length = 8},
      {part = models.model.root.LeftArm.below, length = 8}
   },
   RightArm = {
      {part = models.model.root.RightArm, length = 8},
      {part = models.model.root.RightArm.below2, length = 8}
   }
}

local points = {
   LeftLeg = {
      vec(0, 0, 0),
      vec(0, -8, 0),
      vec(0, -16, 0)
   },
   RightLeg = {
      vec(0, 0, 0),
      vec(0, -8, 0),
      vec(0, -16, 0)
   },
   LeftArm = {
      vec(0, 0, 0),
      vec(0, -8, 0),
      vec(0, -16, 0)
   },
   RightArm = {
      vec(0, 0, 0),
      vec(0, -8, 0),
      vec(0, -16, 0)
   },
}

for _, v in pairs(parts) do
   for _, l in pairs(v) do
      l.part:setParentType("NONE")
   end
end

---Calculates the Vector2 angle between 2 points
---@param pos1 Vector3
---@param pos2 Vector3
---@param offset Vector2
---@return Vector2
local function angleBetweenPoints(pos1, pos2, offset)
   local delta = pos2 - pos1

   return vec(math.deg(math.atan2(delta.x, delta.y)), math.deg(math.atan2(delta.z, delta.y))) - offset
end

local function copy(tbl)
   local newTbl = {}

   for key, value in pairs(tbl) do
      newTbl[key] = value
   end

   return newTbl
end

---Calculates part rotations
---@param key string
---@param goal Vector3
---@return Vector2[]
local function calculate(key, goal)
   local partList = parts[key]
   local length = 0
   local start = vec(0, 0, 0)

   for _, v in pairs(partList) do
      length = length + v.length
   end

   if length <= (goal - start):length() then
      return {angleBetweenPoints(start, goal, vec(180, 180)), vec(0, 0)}
   end
      
   local oldPoints = copy(points[key])
   local currentParts = parts[key]
   local newPoints = copy(oldPoints)

   newPoints[#newPoints] = goal

   for i = #newPoints - 1, 1, -1 do
      newPoints[i] = newPoints[i + 1] - (newPoints[i + 1] - newPoints[i]):normalize() * currentParts[i].length
   end


   newPoints[1] = start
   for i = 1, #newPoints - 1 do
      newPoints[i + 1] = newPoints[i] + (newPoints[i + 1] - newPoints[i]):normalize() * currentParts[i].length
   end

   local ret = {}
   local offset = vec(180, 180)
   for i = 1, #newPoints - 1 do
      ret[#ret + 1] = angleBetweenPoints(newPoints[i], newPoints[i + 1], offset)
      offset = offset - ret[#ret]
   end

   return ret
end

function events.TICK()
   for key in pairs(points) do
      local rots = calculate(key, vec(0, 14, 0))
      
      for i = 1, #rots do
         parts[key][i].part:setRot(rots[i].xy_)
      end
   end
end

