local previous = ""
local count = 0
function events.CHAT_RECEIVE_MESSAGE(raw, json)
	if raw == previous then
		count = count + 1
		host:setChatMessage(1, nil)
		local ret = {parseJson(json)}
		ret[#ret + 1] = {
			" ",
			{
				text = "(",
				color = "dark_gray"
			},
			{
				text = "x",
				color = "gray"
			},
			{
				text = tostring(count),
				color = "aqua"
			},
			{
				text = ")",
				color = "dark_gray"
			}
		}

		return toJson(ret)
	else
		count = 1
	end

	previous = raw
end

