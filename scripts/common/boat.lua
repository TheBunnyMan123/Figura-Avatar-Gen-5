local model = models:newPart("boat", "None")
model:newEntity("villager")
   :setNbt(toJson {
      id = "minecraft:villager"
   })
   :setRot(-90, 0)
   :setPos(0, 8, 12)

function events.tick()
   local vehicle = player:getVehicle()

   if vehicle and vehicle:getType():match("boat") then
      renderer:setRenderVehicle(false)
      model:setVisible(true)
      
      local vel = vehicle:getVelocity():length()
      if vel > 0.1 then
         sounds:playSound("minecraft:entity.villager.ambient", vehicle:getPos(), 1, vel % 1 + 1)
      end
   else
      renderer:setRenderVehicle(true)
      model:setVisible(false)
   end
end

