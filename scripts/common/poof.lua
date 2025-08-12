local previouslySpectator = true
function events.TICK()
   local spectator = player:getGamemode() == "SPECTATOR"
   
   if spectator ~= previouslySpectator then
      for i = 1, 200 do
         particles:newParticle("minecraft:dust 1.0 1.0 1.0 1", player:getPos():add(math.random() * -1 + 0.5, math.random() * 2, math.random() * -1 + 0.5), vec(0, 0, 0)):setGravity(0):setVelocity(0, 0, 0)
      end

      previouslySpectator = spectator
   end
end

