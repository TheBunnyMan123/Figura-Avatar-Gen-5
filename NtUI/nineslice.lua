---@class NtUI.Nineslice
---@field tasks SpriteTask[]
---@field texture Texture
---@field offset Vector2
---@field region Vector2
---@field xOffset integer
---@field yOffset integer
---@field _pos Vector2
---@field _size Vector2
local nineslice = {}

local model = models:newPart("NtUI.Nineslices", "HUD")
local z_index = 0

---Creates a new nineslice
---@param texture Texture
---@param offset Vector2
---@param region Vector2
---@param xOffset integer
---@param yOffset integer
---@return NtUI.Nineslice
function nineslice.new(texture, offset, region, xOffset, yOffset)
   local new = setmetatable({}, {
      __index = nineslice,
      type = "NtUI.Nineslice"
   })

   new.texture = texture
   new.offset = offset:copy()
   new.region = region:copy()
   new.xOffset = xOffset
   new.yOffset = yOffset

   new.tasks = {
      model:newSprite("sprite_" .. #model:getChildren() + 1)
         :setTexture(texture, texture:getDimensions():unpack())
         :uvPixels(offset.x, offset.y)
         :region(xOffset, yOffset)
         :pos(0, 0, z_index),
      model:newSprite("sprite_" .. #model:getChildren() + 2)
         :setTexture(texture, texture:getDimensions():unpack())
         :uvPixels(offset.x + xOffset, offset.y)
         :region(region.x - xOffset * 2, yOffset)
         :pos(xOffset, 0, z_index),
      model:newSprite("sprite_" .. #model:getChildren() + 3)
         :setTexture(texture, texture:getDimensions():unpack())
         :uvPixels(offset.x + region.x - xOffset, offset.y)
         :region(xOffset, yOffset)
         :pos(region.x - xOffset, 0, z_index),
      model:newSprite("sprite_" .. #model:getChildren() + 4)
         :setTexture(texture, texture:getDimensions():unpack())
         :uvPixels(offset.x, offset.y + yOffset)
         :region(xOffset, region.y - yOffset * 2)
         :pos(0, 0, z_index),
      model:newSprite("sprite_" .. #model:getChildren() + 5)
         :setTexture(texture, texture:getDimensions():unpack())
         :uvPixels(offset.x + xOffset, offset.y + yOffset)
         :region(region.x - xOffset * 2, region.y - yOffset * 2)
         :pos(0, 0, z_index),
      model:newSprite("sprite_" .. #model:getChildren() + 6)
         :setTexture(texture, texture:getDimensions():unpack())
         :uvPixels(offset.x + region.x - xOffset, offset.y + yOffset)
         :region(xOffset, region.y - yOffset * 2)
         :pos(0, 0, z_index),
      model:newSprite("sprite_" .. #model:getChildren() + 7)
         :setTexture(texture, texture:getDimensions():unpack())
         :uvPixels(offset.x, offset.y + region.y - yOffset)
         :region(xOffset, yOffset)
         :pos(0, 0, z_index),
      model:newSprite("sprite_" .. #model:getChildren() + 8)
         :setTexture(texture, texture:getDimensions():unpack())
         :uvPixels(offset.x + xOffset, offset.y + region.y - yOffset)
         :region(region.x - xOffset * 2, yOffset)
         :pos(0, 0, z_index),
      model:newSprite("sprite_" .. #model:getChildren() + 9)
         :setTexture(texture, texture:getDimensions():unpack())
         :uvPixels(offset.x + region.x - xOffset, offset.y + region.y - yOffset)
         :region(xOffset, yOffset)
         :pos(0, 0, z_index),
   }
   z_index = z_index - 1

   nineslice.z_index = z_index
   nineslice.pos(new, vec(100, 100))
   nineslice.size(new, region)

   return new
end

---Resizes the nineslice
---@param self NtUI.Nineslice
---@param size Vector2
---@return NtUI.Nineslice
function nineslice:size(size)
   self.tasks[1]:size(self.xOffset, self.yOffset):pos(self._pos.x, self._pos.y, self.z_index)
   self.tasks[2]:size(size.x - self.xOffset * 2, self.yOffset):pos(self._pos.x + self.xOffset, self._pos.y, self.z_index)
   self.tasks[3]:size(self.xOffset, self.yOffset):pos(self._pos.x + size.x - self.xOffset, self._pos.y)
   self.tasks[4]:size(self.xOffset, size.y - self.yOffset * 2):pos(self._pos.x, self._pos.y + self.yOffset)
   self.tasks[5]:size(size.x - self.xOffset * 2, size.y - self.yOffset * 2):pos(self._pos.x + self.xOffset, self._pos.y + self.yOffset)
   self.tasks[6]:size(self.xOffset, size.y - self.yOffset * 2):pos(self._pos.x + size.x - self.xOffset, self._pos.y + self.yOffset)
   self.tasks[7]:size(self.xOffset, self.yOffset):pos(self._pos.x, self._pos.y + size.y - self.yOffset)
   self.tasks[8]:size(size.x - self.xOffset * 2, self.yOffset):pos(self._pos.x + self.xOffset, self._pos.y + size.y - self.yOffset)
   self.tasks[9]:size(self.xOffset, self.yOffset):pos(self._pos.x + size.x - self.xOffset, self._pos.y + size.y - self.yOffset)

   self._size = size

   for _, v in pairs(self.tasks) do
      v:pos(v:getPos() * -1)
   end

   return self
end

---Positions the nineslice
---@param self NtUI.Nineslice
---@param pos Vector2
---@return NtUI.Nineslice
function nineslice:pos(pos)
   self._pos = pos
   self:size(self._size or vec(0, 0))
   return self
end

return setmetatable({}, {
   __index = nineslice,
   __type = "NtUI.Nineslice"
})

