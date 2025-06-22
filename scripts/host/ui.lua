local window = require("NtUI.window").new(vec(10, 10), vec(80, 60))
local drawable = require("NtUI.drawable").new(vec(1, 7))
local label2 = require("NtUI.label").new(vec(1.5, 1.5), 100, toJson {
   text = "Isn't this test window\nso cool?",
   color = "black"
})

drawable:addChild(label2)
window:addChild(drawable)
window:draw(nil, vec(0, 0))

