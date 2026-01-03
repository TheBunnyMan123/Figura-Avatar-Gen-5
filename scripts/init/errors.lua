if not goofy then return end

function events.ERROR(err)
	local newError = {
		{
			text = "Man I'm dead \xE2\x98\xA0\n\n",
			color = "red"
		}
	}
	
	local script, line, message, trace = string.match(err, "([^%s:]+):(%d+)%s*(.-)stack traceback:(.+)")
	local traceback = {}

	for v in trace:gmatch("%s-([^\n]+)") do
		local trimmed = v:gsub("^%s+", ""):gsub("%s+$", "")
		local script_trace, line_trace, chunk = trimmed:match("([^:]+):(%d+)%s*: (.*)")

		if trimmed:match("^%[Java%]") then
			traceback[#traceback + 1] = {
				{
					text = "• ",
					color = "gray"
				},
				{
					text = "Java",
					color = "gold"
				},
				{
					text = " (",
					color = "dark_gray"
				},
				{
					text = "?",
					color = "gray"
				},
				{
					text = ")\n",
					color = "dark_gray"
				}
			}
		else
			traceback[#traceback + 1] = {
				{
					text = "• ",
					color = "gray"
				},
				{
					text = script_trace,
					color = "green"
				},
				{
					text = " (",
					color = "dark_gray"
				},
				{
					text = "line ",
					color = "gray"
				},
				{
					text = line_trace,
					color = "aqua"
				},
				{
					text = ", ",
					color = "dark_gray"
				},
				{
					text = chunk,
					color = "light_purple"
				},
				{
					text = ")\n",
					color = "dark_gray"
				}
			}
		end
	end

	newError[#newError + 1] = {
		{
			text = script,
			color = "green"
		},
		{
			text = " (",
			color = "dark_gray",
		},
		{
			text = "line ",
			color = "gray"
		},
		{
			text = line,
			color = "aqua"
		},
		{
			text = ")\n",
			color = "dark_gray",
		},
		{
			text = "• ",
			color = "gray"
		},
		{
			text = message:gsub("%s*$", ""),
			color = "red"
		},
		{
			text = "\n\nStack Traceback:\n",
			color = "yellow"
		},
		traceback,
		{
			text = "\nWhat idiot wrote this shit?",
			color = "red"
		}
	}

	printJson(toJson {
		text = "[ERROR] ",
		color = "red",
		extra = {
			{
				text = "TheKillerBunny",
				color = "white"
			},
			": "
		}
	})

	local toPrint = toJson(newError)
	printJson(toPrint)
	goofy:stopAvatar(toPrint)
	return true
end

