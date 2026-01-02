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

	if block and target then
		local entLength = (hitpos - eyePos):length()
		local blkLength = (blockpos - eyePos):length()

		if blkLength < entLength then
			return
		end
	end

	if target then
		pings.movement_info(target:getUUID(), math.abs((player:getPos() - target:getPos()):length()))
		return true
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
local line = require("libs.GNamimates.line")
local width = 0.025
local lines = {
	upper_north = line.new():setColor(1, 1, 1):setWidth(width):update(),
	lower_north = line.new():setColor(1, 0, 0):setWidth(width):update(),
	upper_south = line.new():setColor(1, 1, 1):setWidth(width):update(),
	lower_south = line.new():setColor(1, 1, 1):setWidth(width):update(),
	upper_east = line.new():setColor(1, 1, 1):setWidth(width):update(),
	lower_east = line.new():setColor(1, 1, 1):setWidth(width):update(),
	upper_west = line.new():setColor(1, 1, 1):setWidth(width):update(),
	lower_west = line.new():setColor(0, 0, 1):setWidth(width):update(),
	north_west = line.new():setColor(0, 1, 0):setWidth(width):update(),
	north_east = line.new():setColor(1, 1, 1):setWidth(width):update(),
	south_west = line.new():setColor(1, 1, 1):setWidth(width):update(),
	south_east = line.new():setColor(1, 1, 1):setWidth(width):update(),
	follow = line.new():setColor(1, 1, 1):setWidth(width):update()
}
local center
local halfBox
local eye
function events.TICK()
	if not center then return end
	if not moved_uuid then
		if lines.north_west.visible then
			for _, v in pairs(lines) do
				v:setVisible(false)
			end
		end
		
		return
	end

	if not lines.north_west.visible then
		for _, v in pairs(lines) do
			v:setVisible(true)
		end
	end
end

function events.RENDER(delta)
	if not moved_uuid then return end
	local ent = world.getEntity(moved_uuid)
	if not ent then return end

	center = ent:getPos(delta):add(0, ent:getBoundingBox().y / 2)
	halfBox = ent:getBoundingBox():div(2, 2, 2)
	eye = player:getPos(delta):add(0, player:getEyeHeight())
	local target = eye + player:getLookDir(delta) * movement_distance - vec(0, halfBox.y, 0)
	
	local isPlayer = ent:isPlayer()
	if isPlayer then
		local vel = target:copy():sub(center):add(0, halfBox.y)
		local success, error = movelib.runFunc(moved_uuid, "setVel", vel)
		if not success then
			movelib.runCI(moved_uuid, "SetVelocity", vel)
		end
	elseif player:getPermissionLevel() >= 2 then
		host:sendChatCommand(string.format("tp %s %f %f %f", ent:getUUID(), target.x, target.y, target.z))
	end
	
	local var = ent:getVariable() or {}
	if not var.movement and not var.MovementAPI and isPlayer then
		pings.movement_info(nil)
	end

	local min = center - halfBox
	local max = center + halfBox

	lines.upper_north:setA(min.x, max.y, min.z):setB(max.x, max.y, min.z):immediateUpdate()
	lines.lower_north:setA(min.x, min.y, min.z):setB(max.x, min.y, min.z):immediateUpdate()
	lines.upper_south:setA(min.x, max.y, max.z):setB(max.x, max.y, max.z):immediateUpdate()
	lines.lower_south:setA(min.x, min.y, max.z):setB(max.x, min.y, max.z):immediateUpdate()
	lines.upper_east:setA(max.x, max.y, min.z):setB(max.x, max.y, max.z):immediateUpdate()
	lines.lower_east:setA(max.x, min.y, min.z):setB(max.x, min.y, max.z):immediateUpdate()
	lines.upper_west:setA(min.x, max.y, min.z):setB(min.x, max.y, max.z):immediateUpdate()
	lines.lower_west:setA(min.x, min.y, min.z):setB(min.x, min.y, max.z):immediateUpdate()
	lines.north_west:setA(min.x, min.y, min.z):setB(min.x, max.y, min.z):immediateUpdate()
	lines.north_east:setA(max.x, min.y, min.z):setB(max.x, max.y, min.z):immediateUpdate()
	lines.south_west:setA(min.x, min.y, max.z):setB(min.x, max.y, max.z):immediateUpdate()
	lines.south_east:setA(max.x, min.y, max.z):setB(max.x, max.y, max.z):immediateUpdate()
	lines.follow:setA(eye):setB(center):immediateUpdate()
end

