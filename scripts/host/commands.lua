local commands
commands = {
	help = function(full)
		local json = {}
		for k in pairs(commands) do
			json[#json + 1] = {
				{
					text = "!" .. k,
					color = "green"
				},
				{
					text = ", ",
					color = "gray"
				}
			}
		end
		printJson(toJson(json))
	end,
	testzone = function(full)
		host:sendChatCommand("tp @s 123980 65 198872 0 0")
	end,
	orbitallaser = function(full)
		host:sendChatCommand("tp @s 12783 155 1322 180 0")
	end
}

function events.CHAT_SEND_MESSAGE(msg)
	for cmd, func in pairs(commands) do
		if msg:match("^!" .. cmd .. " ") or  msg:match("^!" .. cmd .. "$") then
			func(msg)
			host:appendChatHistory(msg)
			return ""
		end
	end

	return msg
end

