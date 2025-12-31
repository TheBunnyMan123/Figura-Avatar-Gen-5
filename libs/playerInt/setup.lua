---Sets up the config and variables.
---This is the only script you actually need for InteractionEngine to work,
---but obviously without the modules it won't do anything.

--[[ Possible features in the future
  Individual function overrides
   - (an alternative to config.api)
]]

local lib = {
  config = {
    speedLimit = 1000, -- Clamps all velocity functions to a max of this value, set to nil to disable
    api = goofy -- Where to pull movement functions from, each module has a list of required functions from the plugin
  },
  funcs = {immune=false},
  host = host:isHost()
}

avatar:store("movement", lib.funcs)



---Adds a new function to the list, meaning anyone can run it
---@param name string
---@param func function
function lib.new(name, func)
  lib.funcs[name] = func
end

return lib
