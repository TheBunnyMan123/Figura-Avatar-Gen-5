local _register = figuraMetatables.Event.__index.register

local times = {}

figuraMetatables.Event.__index.register = function(self, callback, name)
   local _, script = pcall(function() e() end)
   script = script:match("stack traceback:.-%s-scripts/debug/executionTimes:[0-9]-:.-%s-scripts/debug/executionTimes:[0-9]-:.-\n%s+([^:]+)")

   local index = #times + 1
   _register(self, function(...)
      local startTime = client.getSystemTime()
      local ret = table.pack(callback(...))
      local endTime = client.getSystemTime()

      times[index] = {
         script = script,
         time = endTime - startTime
      }

      return table.unpack(ret, 1, ret.n)
   end, name)
end

figuraMetatables.EventsAPI.__newindex = function(self, key, callback)
   local evnt = self[key]
   local _, script = pcall(function() e() end)
   script = script:match("stack traceback:.-%s-scripts/debug/executionTimes:[0-9]-:.-%s-scripts/debug/executionTimes:[0-9]-:.-\n%s+([^:]+:[0-9]+)")

   table.insert(times, {script=script,time=0})
   local index = #times
   _register(evnt, function(...)
      local startTime = client.getSystemTime()
      local ret = table.pack(callback(...))
      local endTime = client.getSystemTime()

      times[index] = {
         script = script,
         event = key,
         time = endTime - startTime
      }

      return table.unpack(ret, 1, ret.n)
   end)
end

local ui = models:newPart("executionTimeUI", "HUD")
function events.WORLD_TICK()
   if host:isAvatarUploaded() then
      ui:setVisible(false)
      return
   end

   for i, v in ipairs(times) do
      ui:newText(v.script .. tostring(i))
         :setPos(-5, -5 - 8 * (i - 1))
         :setOutline(true)
         :setScale(0.8)
         :setText(v.script .. " [" .. (v.event or "UNKNOWN") .. "] - " .. v.time .. "ms")
   end
end

