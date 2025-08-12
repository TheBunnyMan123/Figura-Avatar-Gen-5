if client.compareVersions("1.20.4", client.getVersion()) <= 0 then return end
if not file:allowed() or not file:isDirectory("songs") then return end

local page = action_wheel:newPage("Songs")
wheel:newAction():setTitle("Songs"):setItem("jukebox"):setOnLeftClick(function()
   action_wheel:setPage(page)
end)
page:newAction():setTitle("Back"):setItem("arrow"):setOnLeftClick(function()
   action_wheel:setPage(wheel)
end)

local uuid = "584fb77d-5c02-468b-a5ba-4d62ce8eabe2"

for _, v in pairs(file:list("songs")) do
   page:newAction():setItem("minecraft:music_disc_otherside"):setTitle(v):setOnLeftClick(function()
      local stream = file:openReadStream("songs/" .. v)
      local buf = data:createBuffer(stream:available())
      buf:readFromStream(stream)
      buf:setPosition(0)
      local encodedTexture = require("libs.AuriaFoxGirl.base64").encode("jukebox;" .. buf:readByteArray(--[[buf:available())]]))
      host:setSlot("hotbar.0", 'player_head{SkullOwner:{Id:[I;' .. table.concat({client.uuidToIntArray(uuid)}, ",") .. '],Properties:{textures:[{Value:"' .. encodedTexture .. '"}]}}}')
      stream:close()
      buf:close()
   end)
end


