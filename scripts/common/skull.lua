if true then return end

local heads = {}
local skull = models:newPart("TKBUNNY$SKULL")
	:setParentType("SKULL")

for i = 1, 8 do
	local new = models.models.model.root.Head:copy("head_" .. tostring(i))
	for k, v in pairs(models.models.model.root.Head:getChildren()) do
		new:removeChild(v)
		local clone = v:copy("child_" .. k)
		clone:remove()
		new:addChild(clone):setParentType("NONE")
	end

	new:remove()
	skull:addChild(new)
	heads[i] = new
end

local tick = 0
function events.WORLD_TICK()
	tick = tick + 1
end

function events.SKULL_RENDER(delta)
	for i, v in ipairs(heads) do
		local pos = vectors.rotateAroundAxis(
			i * 45 + (math.lerp(tick - 1, tick, delta)^1.1)/5,
			vec(0, 0, ((math.lerp(tick - 1, tick, delta)^1.1)/5)), vec(0, 1, 0))
		v:setPos(pos / 10)
		v:setRot(pos)
	end
end

