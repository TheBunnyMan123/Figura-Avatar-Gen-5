local particles = require("libs.TheKillerBunny.BunnyParticles")
local holder = models:newPart("skull"):setParentType("SKULL")
local head = models.models.model.root.Head:copy("SkullHead")
head:remove()
head:setParentType("SKULL"):setScale(0.27):setPos(0, -22, 0)
models:addChild(head)

local positions = {}
local star_angles = {
	18,
	90,
	162,
	234,
	306
}
local star_connections = {
	{1, 3},
	{3, 5},
	{5, 2},
	{2, 4},
	{4, 1}
}

for angle = 0, 359, 9 do
	positions[#positions + 1] = vec(math.cos(math.rad(angle)) * 4, math.sin(math.rad(angle)) * 4)
end

for _, v in ipairs(star_connections) do
	local curr = star_angles[v[2]]
	local prev = star_angles[v[1]]
	local curr_pos = vec(math.cos(math.rad(curr)) * 4, math.sin(math.rad(curr)) * 4)
	local prev_pos = vec(math.cos(math.rad(prev)) * 4, math.sin(math.rad(prev)) * 4)

	local delta = curr_pos - prev_pos
	local delta_div = delta / 14

	for i = 1, 14 do
		positions[#positions + 1] = prev_pos + (delta_div * i)

		print(prev_pos + (delta_div * i))
	end
end

for i, v in ipairs(positions) do
	holder:newPart("particle_" .. tostring(i))
		:setPos(v.x_y)
		:newSprite("sprite")
			:setTexture(textures["models.model.particle"], 5, 5)
			:setSize(5, 5)
			:setScale(1 / 10)
			:setRot(90)
			:setPos(0.25, 0.1, 0.25)
			:setRenderType("EMISSIVE")
			:setColor(0.9, 0, 0)
end

local tick = 0
function events.WORLD_TICK()
	tick = tick + 1
end

local rendered = true
function events.WORLD_RENDER()
	rendered = false
end

function events.SKULL_RENDER(delta, _, _, _, ctx)
	local offset = (ctx == "HEAD") and 8 or 0
	holder:setPos(0, offset)
	head:setPos(0, -22 + offset)

	if rendered then return end
	rendered = true

	local rot = -math.lerp(tick - 1, tick, delta)
	holder:setRot(0, -rot)

	for _, v in pairs(holder:getChildren()) do
		v:setRot(0, rot)
	end
end

