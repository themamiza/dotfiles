local hovered = ya.sync(function()
	local h = cx.active.current.hovered
	return h and tostring(h.url)
end)

return {
	entry = function()
		local path = hovered()
		if not path then
			return
		end

		local output = Command("du") :arg({ "-hs", path }) :output()

		if output then
			local size = output.stdout:match("^(%S+)")
			ya.notify { title = "Size", content = size or "?", timeout = 3 }
		end
	end,
}
