function pings.parkour_particles(type, pos, intensity)
   if type == "slam" then
      sounds:playSound("minecraft:entity.generic.explode", pos, intensity)
      sounds:playSound("minecraft:entity.iron_golem.damage", pos, intensity)

      local textures = {}
      for _, v in pairs(world.getBlockState(pos - vec(0, 1, 0)):getTextures()) do
         textures[#textures + 1] = v
      end
   
      for i = 1, 1000 do
         if avatar:getRemainingParticles() < 1 then return end

         local vel = vec(math.random() - 0.5, math.random(), math.random() - 0.5):normalize()
         
         if i <= 50 then
            particles:newParticle("minecraft:explosion", pos + vel.x_z, vec(1, 1, 1))
         end
         
         if avatar:getRemainingParticles() < 1 then return end

         pcall(function()
            particles:newParticle("minecraft:block " ..
               world.getBlockState(pos - vec(0, 0.1, 0)):getID(), pos, vel):setVelocity(vel * intensity / 3)
         end)
      end
   elseif type == "cloud" then
      if client.compareVersions(client.getVersion(), "1.21") < 0 then
         sounds:playSound("minecraft:entity.ender_dragon.flap", pos, intensity)
      else
         sounds:playSound("minecraft:entity.wind_charge.wind_burst", pos, intensity)
      end

      for _ = 1, 100 do
         if avatar:getRemainingParticles() < 1 then return end

         local rand = vec(math.random() - 0.5, (math.random() - 0.5) / 4, math.random() - 0.5) * 2

         particles:newParticle("minecraft:cloud", pos + rand, vec(0, 0, 0))
      end
   elseif type == "gust" then
      for _ = 1, 100 do
         if avatar:getRemainingParticles() < 1 then return end

         local rand = vec(math.random() - 0.5, 0, math.random() - 0.5):normalize() * math.random() * 0.8 + vec(0, math.random() * 2, 0)

         if client.compareVersions(client.getVersion(), "1.21") < 0 then
            particles:newParticle("minecraft:cloud", pos + rand, vec(0, 0, 0)):setLifetime(10)
         else
            particles:newParticle("minecraft:small_gust", pos + rand, vec(0, 0, 0)):setLifetime(4)
         end
      end

      if client.compareVersions(client.getVersion(), "1.21") < 0 then
         sounds:playSound("minecraft:entity.ender_dragon.flap", pos, intensity)
      else
         sounds:playSound("minecraft:entity.wind_charge.wind_burst", pos, intensity)
      end
   end
end

