local action = wheel:newAction():setTitle("Player Mover [RMB to throw]"):setItem("fishing_rod"):setOnToggle(function() end)
local click = keybinds:newKeybind("move", "key.mouse.left")
local throw = keybinds:newKeybind("throw", "key.mouse.right")
local movelib = require("libs.playerInt.picker")

local throw_strength = 10
local ctrl = keybinds:newKeybind("ctrl", "key.keyboard.left.control")
local shift = keybinds:newKeybind("shift", "key.keyboard.left.shift")
wheel:newAction():setTitle("Throw Strength [10]"):setItem("firework_rocket")
	:setOnScroll(function(dir, self)
		throw_strength = throw_strength + ((dir > 0) and 1 or -1) * (ctrl:isPressed() and 5 or 1) * (shift:isPressed() and 10 or 1)
		self:setTitle(string.format("Throw Strength [%d]", throw_strength))
	end)

local moved_uuid
local movement_distance = 5
local func
function pings.movement_info(uuid, distance)
	if not uuid and distance and moved_uuid and player then
		movelib.runFunc(moved_uuid, "setVel", player:getLookDir() * distance)
	end

	moved_uuid = uuid
	movement_distance = distance
	func = movelib.getFunc(uuid)
end

click:setOnPress(function()
	if not action:isToggled() then return end
	local target, hitpos = player:getTargetedEntity(20)
	if target then
		pings.movement_info(target:getUUID(), math.abs((player:getPos() - target:getPos()):length()))
	end
end)
click:setOnRelease(function()
	pings.movement_info(nil)
end)

throw:setOnPress(function()
	if not moved_uuid then return end
	pings.movement_info(nil, throw_strength)
end)

function events.MOUSE_SCROLL(dir)
	if not moved_uuid then return end
	pings.movement_info(moved_uuid, movement_distance + ((dir > 0) and 2 or -2))
end

function events.TICK()
	if not moved_uuid then return end
	if not func then return end

	local ent = world.getEntity(moved_uuid)
	if not ent then return end

	local vel = player:getPos():add(0, player:getEyeHeight()):add(player:getLookDir() * movement_distance) - ent:getPos()
	local success, error = movelib.runFunc(moved_uuid, "setVel", vel)

	if not success then
		pings.movement_info(nil)
		print(error)
	end
end

