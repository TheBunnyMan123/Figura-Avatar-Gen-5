local stored_items = {}
local page = action_wheel:newPage("Songs")
local storage_file = string.format("stored_items_%s.json", client.getVersion())
wheel:newAction()
	:setTitle("Saved Items")
	:setItem("diamond_sword")
	:setOnLeftClick(function()
		action_wheel:setPage(page)
end)
page:newAction()
	:setTitle("Back")
	:setItem("arrow")
	:setOnLeftClick(function()
		action_wheel:setPage(wheel)
end)

local function save()
	file:writeString(storage_file,
		toJson(stored_items))
end

do
	if not file:allowed() then return end
	if not file:exists(storage_file) then
		save()
	end

	local read = file:readString(storage_file)
	stored_items = parseJson(read)
end

local function append_item(item)
	local stack = world.newItem(item)
	local data = stack:getTag()
	local name = data["minecraft:custom_name"] or (data.display and data.display.Name)
	local lore = data["minecraft:lore"] or (data.display and data.display.Lore)
	
	local title = {}
	if name then
		for _, v in pairs({parseJson(name)}) do
			title[#title + 1] = v
		end
	else
		title[#title + 1] = stack:getName()
	end

	for _, v in ipairs(lore or {}) do
		title[#title + 1] = {
			text = "\n",
			color = "dark_purple",
			italic = true,
			extra = {parseJson(v)}
		}
	end
	
	page:newAction()
		:setTitle(toJson(title))
		:setItem(item)
		:setOnLeftClick(function()
			host:setSlot("hotbar.8", item)
	end)
end

page:newAction():setTitle("Store Item"):setItem("ender_chest"):setOnLeftClick(function()
	local item = host:getSlot("weapon.mainhand")
	stored_items[#stored_items + 1] = item:getID() .. toJson(item:getTag())
	if item:getID() == "minecraft:player_head" then
		stored_items[#stored_items] = stored_items[#stored_items]:gsub('"Id":%[','"Id":[I;')
	end
	append_item(stored_items[#stored_items])
	save()
end)

for k, v in ipairs(stored_items) do
	append_item(v)
end

