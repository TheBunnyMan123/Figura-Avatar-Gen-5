---@class NtUI.Drawable
---@field children NtUI.Drawable[]
---@field _pos Vector2
---@field z_index integer
local drawable = {}

function drawable:draw(parent, pos)
   for _, v in pairs(self.children) do
      v:draw(self, self._pos + pos)
   end
end

function drawable:remove()
   for _, v in pairs(self.children) do
      v:remove()
   end
end

function drawable:addChild(child)
   self.children[#self.children + 1] = child
   self:draw(nil, self._pos)
end

function drawable:pos(pos)
   self._pos = pos
   self:draw(nil, pos)
end

function drawable.new(pos)
   return setmetatable({
      children = {},
      _pos = pos,
      z_index = 0
   }, {
      __index = drawable,
      __type = "NtUI.Drawable"
   })
end

return drawable.new()

