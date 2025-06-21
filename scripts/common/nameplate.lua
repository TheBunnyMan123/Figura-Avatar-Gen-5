nameplate.ENTITY:setVisible(true)

local json = {
   {
      text = "${badges}"
   },
   {
      text = "\nTheKillerBunny",
      color = "#32FF96"
   }
}

nameplate.ALL:setText(toJson(json))

local nameText = "\xE2\x9C\xA8TheKillerBunny\xE2\x9C\xA8"
local name = {}

for char in string.gmatch(nameText, "([%z\1-\127\128-\255][\128-\191]*)") do
   name[#name + 1] = char
end

local entityTasks = {}
local width = 0
local holder = models.models.model:newPart("NAMEPLATE", "CAMERA")
for i = 1, #name do
   entityTasks[#entityTasks+1] = {
      char = name[i],
      task = holder:newText("task" .. i):setText(toJson {
         text = name[i],
         color = "#32FF96"
      }):setOutline(true):setPos(-width, 0):setScale(3/8):setLight(15),
      offset = i,
      prevWidth = width
   }

   width = width + client.getTextWidth(name[i] or "") * (3/8)
end

for _, v in pairs(entityTasks) do
   v.task:setPos(v.task:getPos().x + width / 2, 0)
end
holder:setPivot(0, 40, 0)

local tick = 0
function events.TICK()
   tick = tick + 1
end

function events.RENDER(delta)
   for _, v in pairs(entityTasks) do
      v.task:setPos(-v.prevWidth + width / 2, math.lerp(
         math.sin((tick + v.offset - 1) / 4),
         math.sin((tick + v.offset) / 4),
         delta
      ))
   end
end

