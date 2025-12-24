if true then return end
--[[
-- PROCEDURAL ANIMATIONS
-- Modifies:
--   Arms
--   Legs
--   Chest
--   Head
--
-- Description:
--   Adds leaning and overrides vanilla animations
--]]

local model = models.models.model.root
model.LeftArm:setParentType("NONE")
model.RightArm:setParentType("NONE")
model.LeftLeg:setParentType("NONE")
model.RightLeg:setParentType("NONE")

local prevlimbRot = 0
local limbRot = 0
local tick = 0

function events.TICK()
   tick = tick + 1
   prevlimbRot = limbRot
   limbRot = math.clamp(player:getVelocity():length(), -2, 2) * (math.sin(tick / 1.5) * 100)
end

function events.RENDER(delta)
   model.LeftArm:setRot(math.lerpAngle(prevlimbRot, limbRot, delta))
   model.RightArm:setRot(-math.lerpAngle(prevlimbRot, limbRot, delta))
   model.LeftLeg:setRot(-math.lerpAngle(prevlimbRot, limbRot, delta))
   model.RightLeg:setRot(math.lerpAngle(prevlimbRot, limbRot, delta))
end

