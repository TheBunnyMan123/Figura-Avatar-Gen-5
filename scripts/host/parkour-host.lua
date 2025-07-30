local function particles(type, pos, intensity)
   if pings.parkour_particles then
      pings.parkour_particles(type, pos, intensity or 1)
   end
end

local function allowed()
   if true then return false end
   if player:isLoaded() and player:getPermissionLevel() > 1 then
      return true
   elseif client.getServerData().ip == "plaza.figuramc.org" then
      return true
   end
end

local space = keybinds:fromVanilla("key.jump");
local forward = keybinds:fromVanilla("key.forward");
local shift = keybinds:fromVanilla("key.sneak");
local sprint = keybinds:fromVanilla("key.sprint");

local longjumping = false
local slamming = false
local jumps = 2

space:setOnPress(function()
   if not allowed() then return end

   if jumps > 0 and not player:isOnGround() and not host:isFlying() then
      jumps = jumps - 1
      goofy:setVelocity(player:getVelocity().x_z + vec(0, 0.5, 0))
      slamming = false

      particles("cloud", player:getPos())
      longjumping = false

      return true
   elseif player:isOnGround() and not longjumping and shift:isPressed() then
      goofy:setVelocity(player:getLookDir().x_z:normalize() * 1.5 + vec(0, 0.5, 0))
      longjumping = true
      jumps = jumps - 1
      
      particles("gust", player:getPos())

      return true
   elseif slamming then
      return true
   end
end)

shift:setOnPress(function()
   if not allowed() then return end

   if not host:isFlying() and player:getVelocity().y > -2 and not longjumping and not player:getVehicle() and not player:isOnGround() and not player:isGliding() and not space:isPressed() then
      goofy:setVelocity(player:getVelocity().x_z:add(0, -2, 0))
      slamming = -0.5

      return true
   end
end)

function events.TICK()
   if not allowed() then return end

   if player:isOnGround() then
      jumps = 2
      longjumping = false
   end

   if player:getVelocity().y <= -1 then
      slamming = player:getVelocity().y
   end

   if slamming then
      if player:isOnGround() then
         particles("slam", player:getPos(), (math.abs(slamming) - 2) * 0.75 + 1.75)
         slamming = false
      end
   end
end

