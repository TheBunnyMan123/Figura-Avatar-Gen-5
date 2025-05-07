--[[
-- MODIFIES:
--   models - moves models.models children up
--]]

vanilla_model.PLAYER:setVisible(false)

for _, v in pairs(models.models:getChildren()) do
   models:addChild(v)
end
models.models:remove()

