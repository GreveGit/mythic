local _ran = false

function DefaultData()
	if _ran then
		return
	end
	local Default = exports["mancave-core"]:FetchComponent("Default")
end
