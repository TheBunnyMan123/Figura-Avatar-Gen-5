local window = require("NtUI.window")
local button = require("NtUI.button")
local label = require("NtUI.label")

do
   local introWindow = window.new(vec(5, 5), vec(80, 40))
   local introText = label.new(vec(40, 11), 100, toJson {
      text = "Welcome to my avatar!\n\nCodename: Starveil\nAuthor: TheKillerBunny",
      color = "black"
   })

   introText:setAlignment("CENTER")

   introWindow:addChild(introText)
   introWindow:draw(nil, vec(0, 0))
end

do
   local clickWindow = window.new(vec(90, 5), vec(50, 37))
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

