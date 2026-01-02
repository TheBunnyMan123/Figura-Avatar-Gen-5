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
		int.config.speedLimit = int.config.speedLimit + ((dir > 0) and 1 or -1) * (ctrl:isPressed() and 5 or 1) * (shift:isPressed() and 3 or 1)
		self:setTitle(string.format("Velocity Limit [%d]", int.config.speedLimit))
	end)
page:newAction():setTitle("Disabled"):setItem("lever"):setOnToggle(function(enabled, self)
	int.funcs.immune = not enabled
end):setToggleTitle("Enabled")

local action = page:newAction():setTitle("Player Mover [RMB to throw]"):setItem("fishing_rod"):setOnToggle(function() end)
local click = keybinds:newKeybind("move", "key.mouse.left")
local throw = keybinds:newKeybind("throw", "key.mouse.right")
local movelib = require("libs.playerInt.picker")

local throw_strength = 3
page:newAction():setTitle("Throw Strength [3]"):setItem("firework_rocket")
	:setOnScroll(function(dir, self)
		throw_strength = throw_strength + ((dir > 0) and 1 or -1) * (ctrl:isPressed() and 5 or 1) * (shift:isPressed() and 3 or 1)
		self:setTitle(string.format("Throw Strength [%d]", throw_strength))
	end)

local moved_uuid
local movement_distance = 5
local func
function pings.movement_info(uuid, distance)
	if not uuid and distance and moved_uuid and player then
		local success = movelib.runFunc(moved_uuid, "setVel", player:getLookDir() * distance)
		if not success then
			movelib.runCI(moved_uuid, "SetVelocity", player:getLookDir() * distance)
		end
	end

	moved_uuid = uuid
	movement_distance = distance
	func = movelib.getFunc(uuid)
end

click:setOnPress(function()
	if not action:isToggled() then return end
	local eyePos = player:getPos():add(0, player:getEyeHeight())
	local target, hitpos = raycast:entity(eyePos, eyePos + player:getLookDir() * 100, function(ent)
		return ent ~= player
	end)
	local block, blockpos = raycast:block(eyePos, eyePos + player:getLookDir() * 190)

	if block then
		local entLength = (hitpos - eyePos):length()
		local blkLength = (blockpos - eyePos):length()

		if blkLength < entLength then
			return
		end
	end

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
	pings.movement_info(moved_uuid, math.max(2, movement_distance + ((dir > 0) and 1 or -1)))
end

local tick = 0
local line = require("libs.TheKillerBunny.BunnyLineLib")
local center
local halfBox
local eye
function events.TICK()
	if not moved_uuid then return end

	local ent = world.getEntity(moved_uuid)
	if not ent then return end


	center = ent:getPos():add(0, ent:getBoundingBox().y / 2)
	halfBox = ent:getBoundingBox():div(2, 2, 2)
	eye = player:getPos():add(0, player:getEyeHeight())

	tick = tick + 1
	if tick % 5 == 0 then
		if not host:isHost() then
			line.line(eye:copy(), center:copy(), math.round((center - eye):length() * 1.5),
				vec(1, 1, 1), 10, 1)
		end

		line.box(center - halfBox, center + halfBox, 10, 1.5)
	end
end

function events.RENDER()
	if not center or not moved_uuid then return end
	local vel = eye:copy():add(player:getLookDir() * movement_distance) - center
	local success, error = movelib.runFunc(moved_uuid, "setVel", vel)
	if not success then
		movelib.runCI(moved_uuid, "SetVelocity", vel)
	end
end

