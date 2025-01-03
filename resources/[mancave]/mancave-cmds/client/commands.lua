Callbacks = nil
Game = nil

AddEventHandler("Commands:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["mancave-core"]:FetchComponent("Callbacks")
	Game = exports["mancave-core"]:FetchComponent("Game")
	Notification = exports["mancave-core"]:FetchComponent("Notification")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mancave-core"]:RequestDependencies("Commands", {
		"Callbacks",
		"Game",
		"Notification",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()

		Callbacks:RegisterClientCallback("Commands:SS", function(d, cb)
			exports["screenshot-basic"]:requestScreenshotUpload(string.format("https://discord.com/api/webhooks/%s", d), "files[]", function(data)
				local image = json.decode(data)
				cb(json.encode({ url = image.attachments[1].proxy_url }))
			end)
		end)
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mancave-core"]:RegisterComponent("Commands", CMDS)
end)

CMDS = {}

RegisterNetEvent("Commands:Client:TeleportToMarker", function()
	local WaypointHandle = GetFirstBlipInfoId(8)
	if DoesBlipExist(WaypointHandle) then
		local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
		for height = 1, 1000 do
			SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

			local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

			if foundGround then
				SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
				break
			end

			Wait(5)
		end
		Notification:Success("Teleported")
	else
		Notification:Error("Please place your waypoint.")
	end
end)
