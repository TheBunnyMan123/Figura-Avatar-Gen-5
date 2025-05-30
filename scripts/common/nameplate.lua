nameplate.ENTITY:setOutline(true)

function events.TICK()
   local json = {
      {
         text = "${badges}"
      },
      {
         text = "\nTheKillerBunny",
         color = "#32FF96"
      }
   }

   nameplate.ALL:setText(toJson(json))

   if avatar:getMaxParticles() < 2000 then
      json[#json + 1] = {
         text = "\nPlease raise my particle limit",
         color = "red"
      }

      nameplate.ENTITY:setText(toJson(json))
   end
end

