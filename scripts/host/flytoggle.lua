local toggle = wheel:newAction():setTitle("Fly"):setItem("elytra"):setOnToggle(function() end)



function events.TICK()
	local enabled = player:getGamemode() == "CREATIVE"
		or (toggle:isToggled() and host:getSlot("armor.chest"):getID() ~= "minecraft:elytra")
	goofy:setCanFly(enabled)

	if host:isFlying() and not enabled then
		toggle:setToggled(true)
	end
end

