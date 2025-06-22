local window = require("NtUI.window")
local button = require("NtUI.button")
local label = require("NtUI.label")
local textbox = require("NtUI.textbox")

do
   local introWindow = window.new(vec(5, 5), vec(80, 40))
   local introText = label.new(vec(40, 11), 100, toJson {
      text = "Welcome to my avatar!\n\nCodename: Starveil\nAuthor: TheKillerBunny",
      color = "black"
   })

   introText:setAlignment("CENTER")

   introWindow:addChild(label.new(vec(2.5, 2.25), 100, toJson {
      text = "Introduction",
      bold = true
   }))
   introWindow:addChild(introText)
   introWindow:draw(nil, vec(0, 0))
end

do
   local clickWindow = window.new(vec(90, 5), vec(50, 37))
   clickWindow:addChild(label.new(vec(2.5, 2.25), 100, toJson {
      text = "MagiClick",
      bold = true
   }))
   local clickText = label.new(vec(25, 11), 100, toJson {
      text = "Clicks: 0",
      color = "black"
   })
   local clickButton = button.new(vec(15, 18), vec(20, 15), 100)

   local clicks = 0
   clickText:setAlignment("CENTER")
   clickButton.events.CLICK:register(function()
      clicks = clicks + 1
      clickText:text(toJson {
         text = "Clicks: " .. clicks,
         color = "black"
      })
   end)

   clickWindow:addChild(clickButton)
   clickWindow:addChild(clickText)
   clickWindow:draw(nil, vec(0, 0))
end

do
   local serverWindow = window.new(vec(5, 50), vec(130, 50))
   local serverLabel = label.new(vec(3, 11), 100, "LOADING")
   
   serverWindow:addChild(label.new(vec(2.5, 2.25), 100, toJson {
      text = "Server Info",
      bold = true
   }))
   serverWindow:addChild(serverLabel)

   function events.WORLD_TICK()
      local serverData = client.getServerData()
      local text = ""

      for k, v in pairs(serverData) do
         text = text .. "\xC2\xA7r===== " .. k:gsub("^.", string.upper) .. " =====\n" .. v:gsub("\n *", "\n"):gsub("^ *", "") .. "\n"
      end

      serverLabel:text(toJson {
         text = text,
         color = "black"
      })

      local dims = client.getTextDimensions(text) * 0.65
      serverWindow.nineslice:size(dims:ceil() + vec(5, 12))
      serverWindow._size = client.getTextDimensions(text) + vec(5, 12)
   end

   serverWindow:draw(nil, vec(0, 0))
end

do
   local textWindow = window.new(vec(client.getScaledWindowSize().x - 85, 5), vec(80, 40))
   local textText = textbox.new(vec(2, 11), 76, 100)

   textWindow:addChild(label.new(vec(2.5, 2.25), 100, toJson {
      text = "Textbox Test",
      bold = true
   }))
   textWindow:addChild(textText)
   textWindow:draw(nil, vec(0, 0))
end

