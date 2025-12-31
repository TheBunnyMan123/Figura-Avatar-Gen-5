local ctrl = keybinds:newKeybind("ctrl", "key.keyboard.left.control")
local shift = keybinds:newKeybind("shift", "key.keyboard.left.shift")

local page = action_wheel:newPage("coords")
wheel:newAction():setTitle("Coordinate Converter"):setItem("compass")
	:setOnLeftClick(function()
		action_wheel:setPage(page)
	end)

page:newAction():setTitle("Back"):setItem("arrow")
	:setOnLeftClick(function()
		action_wheel:setPage(wheel)
	end)

local x = 0
local y = 0
local z = 0
local x_action = page:newAction():setTitle("X [0]"):setItem("compass")
	:setOnScroll(function(dir, self)
		x = x + ((dir > 0) and 1 or -1) * (ctrl:isPressed() and 1000 or 1) * (shift:isPressed() and 100 or 1)
		self:setTitle(string.format("X [%d]", x))
	end)
local y_action = page:newAction():setTitle("Y [0]"):setItem("compass")
	:setOnScroll(function(dir, self)
		y = y + ((dir > 0) and 1 or -1) * (ctrl:isPressed() and 1000 or 1) * (shift:isPressed() and 100 or 1)
		self:setTitle(string.format("Y [%d]", y))
	end)
local z_action = page:newAction():setTitle("Z [0]"):setItem("compass")
	:setOnScroll(function(dir, self)
		z = z + ((dir > 0) and 1 or -1) * (ctrl:isPressed() and 1000 or 1) * (shift:isPressed() and 100 or 1)
		self:setTitle(string.format("Z [%d]", z))
	end)

page:newAction():setTitle("Set to Player Coords"):setItem(
	string.format((client.compareVersions(client.getVersion(), "1.20.5") >= 1) and "minecraft:player_head[profile={id:[I;%d,%d,%d,%d]}]" or "player_head{SkullOwner:{Id:[I;%d,%d,%d,%d]}}",
		client.uuidToIntArray(avatar:getUUID())))
	:setOnLeftClick(function()
		local pos = player:getPos():floor()

		x = math.floor(pos.x)
		y = math.floor(pos.y)
		z = math.floor(pos.z)

		x_action:setTitle(string.format("X [%d]", x))
		y_action:setTitle(string.format("Y [%d]", y))
		z_action:setTitle(string.format("Z [%d]", z))
	end)

page:newAction():setTitle("Convert to Overworld Coords"):setItem("minecraft:grass_block")
	:setOnLeftClick(function()
		x = math.floor(x * 8)
		y = math.floor(y * 8)
		z = math.floor(z * 8)

		x_action:setTitle(string.format("X [%d]", x))
		y_action:setTitle(string.format("Y [%d]", y))
		z_action:setTitle(string.format("Z [%d]", z))
	end)
page:newAction():setTitle("Convert to Nether Coords"):setItem("minecraft:netherrack")
	:setOnLeftClick(function()
		x = math.floor(x / 8)
		y = math.floor(y / 8)
		z = math.floor(z / 8)

		x_action:setTitle(string.format("X [%d]", x))
		y_action:setTitle(string.format("Y [%d]", y))
		z_action:setTitle(string.format("Z [%d]", z))
	end)

