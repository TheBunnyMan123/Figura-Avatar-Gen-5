local goof_table = getmetatable(goofy)
local goof_index = goof_table.__index

local allowed = {
	["4p5.nz"] = true,
	["plaza.figuramc.org"] = true
}

goof_table.__index = function(_, key, val)
	local data = client.getServerData()
	local permission = 0
	if key:match("^set") and ((permission <= 1 and not allowed[data.ip]) or allowed[data.ip] == false) then
		return function() end
	end

	return goof_index[key]
end

