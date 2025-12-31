local ctrl = keybinds:newKeybind("ctrl", "key.keyboard.left.control")
local shift = keybinds:newKeybind("shift", "key.keyboard.left.shift")

local int = require("libs.playerInt.setup")
int.funcs.immune = true
int.config.speedLimit = 10

local page = action_wheel:newPage("interaction")
wheel:newAction():setTitle("Interaction Lib"):setItem("player_head")
	:setOnLeftClick(function()
		action_wheel:setPage(page)
	end)

page:newAction():setTitle("Back"):setItem("arrow")
	:setOnLeftClick(function()
		action_wheel:setPage(wheel)
	end)

page:newAction():setTitle("Velocity Limit [10]"):setItem("feather")
	:setOnScroll(function(dir, self)
		int.config.speedLimit = int.config.speedLimit + ((dir > 0) and 1 or -1) * (ctrl:isPressed() and 5 or 1) * (shift:isPressed() and 10 or 1)
		self:setTitle(string.format("Velocity Limit [%d]", int.config.speedLimit))
	end)
page:newAction():setTitle("Disabled"):setItem("lever"):setOnToggle(function(enabled, self)
	int.funcs.immune = not enabled
end):setToggleTitle("Enabled")

