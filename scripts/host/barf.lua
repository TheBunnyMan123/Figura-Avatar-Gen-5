local enabled = false
wheel:newAction():setTitle("barf"):setItem("snowball"):setOnToggle(function(state)
	enabled = state
end)

function events.TICK()
	if not enabled then return end
	local entity = player:getHeldItem():getID():gsub("_spawn_egg$", "")
	for i = 1, 10 do
		local dir = (player:getPos() + player:getLookDir() * 10 + vec(math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1)) - player:getPos()
		dir:normalize():mul(2, 2, 2)
		local pos = player:getPos():add(0, player:getEyeHeight()) + (dir / 3)
		local command = string.format("summon %s %f %f %f {Motion:[%fd,%fd,%fd],Fuse:80,fuse:80}",
			entity, pos.x, pos.y, pos.z, dir.x, dir.y, dir.z)

		local block = pcall(world.newBlock, entity)
		if entity ~= "minecraft:tnt" and block then
			command = string.format("summon falling_block %f %f %f {BlockState:{Name:\"%s\"},Time:1,Motion:[%fd,%fd,%fd],HurtEntities:%s}",
				pos.x, pos.y, pos.z, entity, dir.x, dir.y, dir.z, entity:match("anvil") and "true" or "false")
		elseif entity == "minecraft:fire_charge" then
			dir = dir / 2
			command = string.format("summon fireball %f %f %f {power:[%fd,%fd,%fd],Motion:[%fd,%fd,%fd]}",
				pos.x, pos.y, pos.z, dir.x, dir.y, dir.z, dir.x, dir.y, dir.z)
			host:sendChatCommand(command)
			break
		end

		host:sendChatCommand(command)
	end
end

