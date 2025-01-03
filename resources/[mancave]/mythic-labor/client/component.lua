AddEventHandler("Labor:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Logger = exports["mancave-core"]:FetchComponent("Logger")
	Callbacks = exports["mancave-core"]:FetchComponent("Callbacks")
	Game = exports["mancave-core"]:FetchComponent("Game")
	Phone = exports["mancave-core"]:FetchComponent("Phone")
	PedInteraction = exports["mancave-core"]:FetchComponent("PedInteraction")
	Interaction = exports["mancave-core"]:FetchComponent("Interaction")
	Progress = exports["mancave-core"]:FetchComponent("Progress")
	Minigame = exports["mancave-core"]:FetchComponent("Minigame")
	Notification = exports["mancave-core"]:FetchComponent("Notification")
	ListMenu = exports["mancave-core"]:FetchComponent("ListMenu")
	Blips = exports["mancave-core"]:FetchComponent("Blips")
	Polyzone = exports["mancave-core"]:FetchComponent("Polyzone")
	Targeting = exports["mancave-core"]:FetchComponent("Targeting")
	Hud = exports["mancave-core"]:FetchComponent("Hud")
	Inventory = exports["mancave-core"]:FetchComponent("Inventory")
	EmergencyAlerts = exports["mancave-core"]:FetchComponent("EmergencyAlerts")
	Status = exports["mancave-core"]:FetchComponent("Status")
	Labor = exports["mancave-core"]:FetchComponent("Labor")
	Sounds = exports["mancave-core"]:FetchComponent("Sounds")
	Properties = exports["mancave-core"]:FetchComponent("Properties")
	Action = exports["mancave-core"]:FetchComponent("Action")
	Sync = exports["mancave-core"]:FetchComponent("Sync")
	Confirm = exports["mancave-core"]:FetchComponent("Confirm")
	Utils = exports["mancave-core"]:FetchComponent("Utils")
	Keybinds = exports["mancave-core"]:FetchComponent("Keybinds")
	Reputation = exports["mancave-core"]:FetchComponent("Reputation")
	NetSync = exports["mancave-core"]:FetchComponent("NetSync")
	Vehicles = exports["mancave-core"]:FetchComponent("Vehicles")
	Animations = exports["mancave-core"]:FetchComponent("Animations")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mancave-core"]:RequestDependencies("Labor", {
		"Logger",
		"Callbacks",
		"Game",
		"Phone",
		"PedInteraction",
		"Interaction",
		"Progress",
		"Minigame",
		"Notification",
		"ListMenu",
		"Blips",
		"Polyzone",
		"Targeting",
		"Hud",
		"Inventory",
		"EmergencyAlerts",
		"Status",
		"Labor",
		"Sounds",
		"Properties",
		"Action",
		"Sync",
		"Confirm",
		"Utils",
		"Keybinds",
		"Reputation",
		"NetSync",
		"Vehicles",
		"Animations",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
		TriggerEvent("Labor:Client:Setup")
	end)
end)

function Draw3DText(x, y, z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local px, py, pz = table.unpack(GetGameplayCamCoords())

	SetTextScale(0.25, 0.25)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 245)
	SetTextOutline(true)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x, _y)
end

function PedFaceCoord(pPed, pCoords)
	TaskTurnPedToFaceCoord(pPed, pCoords.x, pCoords.y, pCoords.z)

	Wait(100)

	while GetScriptTaskStatus(pPed, 0x574bb8f5) == 1 do
		Wait(0)
	end
end

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mancave-core"]:RegisterComponent("Labor", LABOR)
end)

AddEventHandler("Labor:Client:AcceptRequest", function(data)
	Callbacks:ServerCallback("Labor:AcceptRequest", data)
end)

AddEventHandler("Labor:Client:DeclineRequest", function(data)
	Callbacks:ServerCallback("Labor:DeclineRequest", data)
end)

LABOR = {
	Get = {
		Jobs = function(self)
			local p = promise.new()
			Callbacks:ServerCallback("Labor:GetJobs", {}, function(jobs)
				p:resolve(jobs)
			end)
			return Citizen.Await(p)
		end,
		Groups = function(self)
			local p = promise.new()
			Callbacks:ServerCallback("Labor:GetGroups", {}, function(groups)
				p:resolve(groups)
			end)
			return Citizen.Await(p)
		end,
		Reputations = function(self)
			local p = promise.new()
			Callbacks:ServerCallback("Labor:GetReputations", {}, function(jobs)
				p:resolve(jobs)
			end)
			return Citizen.Await(p)
		end,
	},
}
