_evald = {}

AddEventHandler("Police:Shared:DependencyUpdate", EMSComponents)
function EMSComponents()
	Callbacks = exports["mancave-core"]:FetchComponent("Callbacks")
	Damage = exports["mancave-core"]:FetchComponent("Damage")
	Inventory = exports["mancave-core"]:FetchComponent("Inventory")
	Progress = exports["mancave-core"]:FetchComponent("Progress")
	Notification = exports["mancave-core"]:FetchComponent("Notification")
	ListMenu = exports["mancave-core"]:FetchComponent("ListMenu")
	Interaction = exports["mancave-core"]:FetchComponent("Interaction")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mancave-core"]:RequestDependencies("EMS", {
		"Callbacks",
		"Damage",
		"Inventory",
		"Progress",
		"Notification",
		"ListMenu",
		"Interaction",
	}, function(error)
		if #error > 0 then
			return
		end
		EMSComponents()

		Interaction:RegisterMenu("call-911", "Call For Help", "land-mine-on", function(data)
			Interaction:Hide()
			TriggerServerEvent("EMS:Server:RequestHelp")
		end, function()
			return LocalPlayer.state.onDuty ~= "ems"
				and LocalPlayer.state.onDuty ~= "police"
				and LocalPlayer.state.isDead
				and GetCloudTimeAsInt() > LocalPlayer.state.isDeadTime + (60 * 2)
		end)

		Interaction:RegisterMenu("ems", false, "land-mine-on", function(data)
			Interaction:ShowMenu({
				{
					icon = "land-mine-on",
					label = "13-A",
					action = function()
						Interaction:Hide()
						TriggerServerEvent("EMS:Server:Panic", true)
					end,
					shouldShow = function()
						return LocalPlayer.state.isDead
					end,
				},
				{
					icon = "land-mine-on",
					label = "13-B",
					action = function()
						Interaction:Hide()
						TriggerServerEvent("EMS:Server:Panic", false)
					end,
					shouldShow = function()
						return LocalPlayer.state.isDead
					end,
				},
			})
		end, function()
			return LocalPlayer.state.onDuty == "ems" and LocalPlayer.state.onDuty and LocalPlayer.state.isDead
		end)

		Interaction:RegisterMenu("ems-utils", "EMS Utilities", "tablet-rugged", function(data)
			Interaction:ShowMenu({
				{
					icon = "tablet-screen-button",
					label = "MDT",
					action = function()
						Interaction:Hide()
						TriggerEvent("MDT:Client:Toggle")
					end,
					shoudlShow = function()
						return LocalPlayer.state.onDuty == "ems"
					end,
				},
				{
					icon = "video",
					label = "Toggle Body Cam",
					action = function()
						Interaction:Hide()
						TriggerEvent("MDT:Client:ToggleBodyCam")
					end,
					shoudlShow = function()
						return LocalPlayer.state.onDuty == "ems"
					end,
				},
			})
		end, function()
			return LocalPlayer.state.onDuty == "ems"
		end)

		Callbacks:RegisterClientCallback("EMS:ApplyBandage", function(data, cb)
			SetEntityHealth(LocalPlayer.state.ped, GetEntityHealth(LocalPlayer.state.ped) + 10)
			cb(true)
		end)

		Callbacks:RegisterClientCallback("EMS:Heal", function(data, cb)
			SetEntityHealth(LocalPlayer.state.ped, GetEntityHealth(LocalPlayer.state.ped) + data)
			cb(true)
		end)
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mancave-core"]:RegisterComponent("EMS", _EMS)
end)

_EMS = {
	HaveEvaluated = function(self, id)
		return _evald[id] ~= nil and _evald[id] > GetGameTimer()
	end,
}

RegisterNetEvent("Characters:Client:Spawn", function()
	Blips:Add("mt_zonah", "Hospital", vector3(-457.019, -333.263, 69.521), 61, 42, 0.8)
end)
