local window = require("NtUI.window")
local button = require("NtUI.button")
local label = require("NtUI.label")
local textbox = require("NtUI.textbox")

do
   local introWindow = window.new(vec(5, 5), vec(80, 40))
   local introText = label.new(vec(40, 11), 100, "Welcome to my avatar!\n\nCodename: Starveil\nAuthor: TheKillerBunny")

   introText:setAlignment("CENTER")

   introWindow:addChild(label.new(vec(2.5, 2.25), 100, {
      text = "Introduction",
      bold = true,
      color = "white"
   }))
   introWindow:addChild(introText)
   introWindow:draw(nil, vec(0, 0))
end

do
   local clickWindow = window.new(vec(90, 5), vec(50, 29))
   clickWindow:addChild(label.new(vec(2.5, 2.25), 100, {
      text = "MagiClick",
      bold = true,
      color = "white"
   }))
   local clickText = label.new(vec(25, 11), 100, "Clicks: 0")
   local clickButton = button.new(vec(5, 18), 40, 100, "Click Me!")

   local clicks = 0
   clickText:setAlignment("CENTER")
   clickButton.events.PRESSED:register(function()
      clicks = clicks + 1
      clickText:text({
         text = "Clicks: " .. clicks,
         color = "black"
      })
   end)

   clickWindow:addChild(clickText)
   clickWindow:addChild(clickButton)
   clickWindow:draw(nil, vec(0, 0))
end

do
   local serverData = client.getServerData()
   local serverLabel = label.new(vec(3, 11), 100, "")
   local text = ""

   for k, v in pairs(serverData) do
      text = text .. "\xC2\xA7r===== " .. k:gsub("^.", string.upper) .. " =====\n" .. v:gsub("\n *", "\n"):gsub("^ *", "") .. "\n"
   end

   serverLabel:text(text)

   local dims = client.getTextDimensions(text) * 0.65

   local serverWindow = window.new(vec(5, 50), dims + vec(5, 8))
   serverLabel:pos(vec(math.ceil(dims:ceil().x / 2) + 2, 11))
   serverLabel:setAlignment("CENTER")

   serverWindow:addChild(label.new(vec(2.5, 2.25), 100, {
      text = "Server Info",
      bold = true,
      color = "white"
   }))
   serverWindow:addChild(serverLabel)

   serverWindow:draw(nil, vec(0, 0))
end

do
   local textWindow = window.new(vec(client.getScaledWindowSize().x - 85, 5), vec(80, 23))
   local textText = textbox.new(vec(3, 11), 74, 100)

   textWindow:addChild(label.new(vec(2.5, 2.25), 100, {
      text = "Textbox Test",
      bold = true,
      color = "white"
   }))
   textWindow:addChild(textText)
   textWindow:draw(nil, vec(0, 0))
end

