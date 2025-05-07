--[[
-- MODIFIES:
--   All render methods - max 60fps
--   All tick methods - adds tick value
--]]

local eventMetatable = {
   __index = {
      register = function(self, func, name)
         self._registered = self._registered or {}
         self._registered[#self._registered + 1] = {
            func = func,
            name = name
         }
      end,
      fire = function(self, ...)
         for _, v in ipairs(self._registered or {}) do
            v.func(...)
         end
      end
   }
}

local customEvents = {
   render = setmetatable({}, eventMetatable),
   world_render = setmetatable({}, eventMetatable),
   post_render = setmetatable({}, eventMetatable),
   post_world_render = setmetatable({}, eventMetatable),
   skull_render = setmetatable({}, eventMetatable),
   tick = setmetatable({}, eventMetatable),
   world_tick = setmetatable({}, eventMetatable),
}

local _events = events
local eventsMetatable = {
   __index = function(self, key)
      assert(type(key) == "string", "Key must be a string")
      return customEvents[key:lower()] or events[key]
   end,
   __newindex = function(self, key, value)
      assert(type(key) == "string", "Key must be a string")
      if customEvents[key:lower()] then
         customEvents[key:lower()]:register(value)
      else
         _events[key] = value
      end
   end
}

local lastRenderTime = 0
local lastWorldRenderTime = 0
local lastPostRenderTime = 0
local lastPostWorldRenderTime = 0
local lastSkullRenderTime = 0

function events.RENDER(...)
   if lastRenderTime + (1/60) <= client.getSystemTime() then
      lastRenderTime = client.getSystemTime()
      customEvents.render:fire(...)
   end
end
function events.WORLD_RENDER(...)
   if lastWorldRenderTime + (1/60) <= client.getSystemTime() then
      lastWorldRenderTime = client.getSystemTime()
      customEvents.world_render:fire(...)
   end
end
function events.POST_RENDER(...)
   if lastPostRenderTime + (1/60) <= client.getSystemTime() then
      lastPostRenderTime = client.getSystemTime()
      customEvents.render:fire(...)
   end
end
function events.POST_WORLD_RENDER(...)
   if lastPostWorldRenderTime + (1/60) <= client.getSystemTime() then
      lastPostWorldRenderTime = client.getSystemTime()
      customEvents.world_render:fire(...)
   end
end
function events.SKULL_RENDER(...)
   if lastSkullRenderTime + (1/60) <= client.getSystemTime() then
      lastSkullRenderTime = client.getSystemTime()
      customEvents.skull_render:fire(...)
   end
end

local tick = 0
local worldTick = 0

function events.WORLD_TICK()
   worldTick = worldTick + 1
   customEvents.world_tick:fire(worldTick)
end
function events.TICK()
   tick = tick + 1
   customEvents.tick:fire(tick)
end

