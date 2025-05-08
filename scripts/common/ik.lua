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
      {part = models.models.model.root.LeftLeg, length = 8, oldRot = vec(0, 0, 0), rot = vec(0, 0, 0)},
      {part = models.models.model.root.LeftLeg.Lower2, length = 8, oldRot = vec(0, 0, 0), rot = vec(0, 0, 0)}
   },
   RightLeg = {
      {part = models.models.model.root.RightLeg, length = 8, oldRot = vec(0, 0, 0), rot = vec(0, 0, 0)},
      {part = models.models.model.root.RightLeg.Lower, length = 8, oldRot = vec(0, 0, 0), rot = vec(0, 0, 0)}
   },
   LeftArm = {
      {part = models.models.model.root.LeftArm, length = 8, oldRot = vec(0, 0, 0), rot = vec(0, 0, 0)},
      {part = models.models.model.root.LeftArm.below, length = 8, oldRot = vec(0, 0, 0), rot = vec(0, 0, 0)}
   },
   RightArm = {
      {part = models.models.model.root.RightArm, length = 8, oldRot = vec(0, 0, 0), rot = vec(0, 0, 0)},
      {part = models.models.model.root.RightArm.below2, length = 8, oldRot = vec(0, 0, 0), rot = vec(0, 0, 0)}
   }
}

local pointList = {
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
---@return Vector3
local function angleBetweenPoints(pos1, pos2)
   local dir = pos2 - pos1

   return vec(
      math.deg(math.atan2(dir.y, dir.x)),
      math.deg(math.atan2(dir.x, dir.z)),
      0
   )
end

local function backwards(points, goal)
   points[#points] = goal

   for i = #points - 1, 1, -1 do
      local rot = points[i] - points[i + 1]
      rot = rot:normalize()
      local len = 8

      points[i] = points[i + 1] + rot * len
   end

   print(points, "T")
end

local function forwards(points, root)
   points[1] = root

   for i = 1, #points - 1 do
      local rot = points[i] - points[i + 1]
      rot = rot:normalize()
      local len = 8

      points[i] = points[i + 1] + rot * len
   end
end

local function calculate(root, goal, points)
   if (goal - root):length() >= 16 then
      return {
         angleBetweenPoints(root, goal),
         vec(0, 0, 0)
      }
   end

   while (points[#points] - goal):length() > 0.4 do
      backwards(points, goal)
      forwards(points, root)
   end

   local ret = {}
   for i = 1, #points - 1 do
      ret[#ret + 1] = angleBetweenPoints(points[i], points[i + 1])
   end
   return ret
end

function events.TICK()
   for key, points in pairs(pointList) do
      local start = parts[key][1].part:partToWorldMatrix():apply()
      local _, hit = raycast:block(start, start - vec(0, 1, 0), "COLLIDER", "NONE")
      local rots = calculate(vec(0, 0, 0), (start - hit) * 16, points);

      rots[1] = rots[1]:sub(90, 90, 0):mul(-1, 1, 1)
      for k, v in pairs(parts[key]) do
         v.part:setRot(rots[k])
      end
   end
end

