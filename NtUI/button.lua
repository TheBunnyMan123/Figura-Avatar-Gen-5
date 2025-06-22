local buttons = {}
local drawable = require("NtUI.drawable")
local eventlib = require("libs.TheKillerBunny.BunnyEventLib")
local nineslice = require("NtUI.nineslice")

local click = keybinds:newKeybind("Click", "key.mouse.left", true)

local texture = textures["NtUI.theme"]

---@class NtUI.Button : NtUI.Drawable
---@field _pos Vector2
---@field _size Vector2
---@field parentPos Vector2
---@field events = {CLICK: Event}
---@field nineslice NtUI.Nineslice
---@field children NtUI.Drawable[]
local button = {}

function button.new(pos, size, z_index)
   local new = setmetatable({}, {
      __index = function(self, key)
         return button[key] or drawable[key]
      end,
      __type = "NtUI.Button"
   })

   buttons[#buttons + 1] = new

   new._pos = pos
   new._size = size

   new.events = eventlib.newEvents()
   new.events.CLICK = eventlib.newEvent()
   new.children = {}
   new.parentPos = vec(0, 0)

   new.events.CLICK:register(function()
      print("test")
   end)

   new.nineslice = nineslice.new(texture, vec(0, 0), vec(5, 5), 2, 4, z_index):pos(pos):size(size)

   return new
end

function button:draw(parent, pos)
   self.parentPos = pos
   self.nineslice:pos(self._pos + pos)
   for _, v in pairs(self.children) do
      v:draw(self, self._pos + pos)
   end
end

function button:addChild(child)
   self.children[#self.children + 1] = child
   self:draw(nil, self._pos / -client.getGuiScale())
end

---Sets the button's position
---@param pos Vector2
function button:pos(pos)
   self._pos = pos
   self.nineslice:pos(pos)
end

function button:remove()
   buttons[self.key or ""] = nil
   for _, w in pairs(self.nineslice.tasks) do
      w:remove()
   end

   for _, v in pairs(self.children) do
      v:remove()
   end
end

local mousePos = client.getMousePos() / client.getGuiScale()
local oldMousePos = client.getMousePos() / client.getGuiScale()
function events.RENDER()
   oldMousePos = mousePos
   mousePos = client.getMousePos() / client.getGuiScale()

   for k, v in pairs(buttons) do
      local relativeMousePos = oldMousePos - v._pos - v.parentPos
      
      if relativeMousePos.x < 0 or relativeMousePos.x > v._size.x then
         v.nineslice:updateUV(vec(0, 0))
         goto continue
      elseif relativeMousePos.y < 0 or relativeMousePos.y > v._size.y then
         v.nineslice:updateUV(vec(0, 0))
         goto continue
      elseif not click:isPressed() then
         v.nineslice:updateUV(vec(0, 0))
         v.held = false
         goto continue
      end
      v.nineslice:updateUV(vec(0, 5))
      if not v.held then
         v.events.CLICK:fire()
         v.held = true
      end
      v.key = k

      v:draw(v, v.parentPos)

      ::continue::
   end
end

return button


