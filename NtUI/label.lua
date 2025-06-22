---@class NtUI.Label : NtUI.Drawable
---@field _text string
---@field _task TextTask
local label = {}

local drawable = require("NtUI.drawable")
local model = models:newPart("NtUI.Labels", "HUD")

local iter = 0
function label.new(pos, z_index, text)
   local new = setmetatable({}, {
      __index = function(self, key)
         return rawget(self, key) or label[key] or drawable[key] or function(...)
            local args = table.pack(...)
            table.remove(args, 1)

            if key == "getText" then
               self:text(table.unpack(args, 1, args.n))
            end

            return self._task[key](self._task, table.unpack(args, 1, args.n))
         end
      end,
      __type = "NtUI.Label"
   })

   new.children = {}
   new._text = text
   new._pos = pos
   new.z_index = z_index
   new._task = model:newText(tostring(iter)):setText(text):scale(0.65)
   iter = iter + 1

   return new
end

function label:remove()
   for _, v in pairs(self.children) do
      v:remove()
   end

   self._task:remove()
end

function label:text(text)
   if not text then return end
   self._text = text
   self._task:setText(text)
end

function label:draw(_, pos)
   self._task:pos(-pos.x - self._pos.x, -pos.y - self._pos.y, -self.z_index):text(self._text)
   
   for _, v in pairs(self.children) do
      v:draw(self, pos + self._pos)
   end
end

return label.new(vec(0, 0), "")

