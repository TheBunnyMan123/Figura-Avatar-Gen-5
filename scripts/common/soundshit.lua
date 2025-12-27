local modes = {
   "None",
   "Speed Up",
   "Random Pitch"
}

local mode = "None"

function pings.newSoundMode(newMode)
   mode = newMode
end

wheel:action(-1, require("libs.TheKillerBunny.BunnyActionLib").newMulti(
   "Sound Shit",
   modes,
   pings.newSoundMode
):setItem("minecraft:jukebox"))

local playing = {}

function events.on_play_sound(id, pos, volume, _, _, _, path)
   if mode == "None" or not path then return end
   if not player:isLoaded() or (pos - player:getPos()):length() > 10 then return end

   playing[#playing + 1] = {
      sound = sounds[id],
      mode = mode,
      time = 0
   }

   if not playing[#playing] then return end
   playing[#playing].sound:setPos(pos):setVolume(volume):setPitch(0):play()

   return true
end

function events.WORLD_TICK()
   for k, v in pairs(playing) do
      if not v.sound:isPlaying() then
         playing[k] = nil
      else
         if v.mode == "Speed Up" then
            v.sound:setPitch(v.time / 100)
         elseif v.mode == "Random Pitch" then
            v.sound:setPitch(math.random() * 3)
         end

         v.time = v.time + 1
      end
   end
end

