local utils = require("libs.TheKillerBunny.BunnyUtils")
local gradient = utils.gradient(vec(255, 255, 0), vec(255, 0, 0), 10)
local holder = models:newPart("TKBUNNY$DAMAGE", "WORLD")

---@type {task: TextTask, vel: Vector3, life: integer}
local indicators = {}

function events.WORLD_TICK()
	if player:isLoaded() then return end
	if #indicators >= 1 then
		for _, v in pairs(indicators) do
			v.task:remove()
		end

		indicators = {}
	end
end

local health = 20
function events.TICK()
	if setDamage then
		local idx = #indicators
		indicators[#indicators].task:getTask(tostring(#indicators))
			:setText(toJson {
				text = "-" .. tostring(math.round(health - player:getHealth())),
				color = "#" .. vectors.rgbToHex(gradient[math.clamp(math.round(health - player:getHealth()), 1, 20)] / 255)
			})

		setDamage = false
	end

	local remove = {}
	for k, v in pairs(indicators) do
		if v.life <= 0 then
			remove[#remove + 1] = k
			goto continue
		end

		v.life = v.life - 1
		v.oldPos = v.pos:copy()
		v.pos = v.pos + v.vel
		v.vel:sub(0, 1.5, 0):mul(0.95, 0.95, 0.95)

		::continue::
	end

	for _, v in pairs(remove) do
		indicators[v].task:remove()
		indicators[v] = nil
	end
end

function events.DAMAGE(_, ent)
	if not player:isLoaded() then return end
	pos = ent and ent:getPos() or player:getPos()

	indicators[#indicators + 1] = {
		vel = (player:getPos() - pos + vec(0, 1, 0)):normalize() * 12,
		task = holder:newPart(tostring(#indicators + 1), "CAMERA"),
		life = 15,
		pos = player:getPos():add(0, 1, 0) * 16,
		oldPos = player:getPos():add(0, 1, 0) * 16
	}

	indicators[#indicators].task
		:newText(tostring(#indicators))
			:setLight(15)
			:setScale(0.5)
			:setOutline(true)
			:setAlignment("CENTER")
	
	health = player:getHealth()
	setDamage = true
end

function events.RENDER(delta)
	for _, v in pairs(indicators) do
		v.task:setPivot(math.lerp(v.oldPos, v.pos, delta))
	end
end

