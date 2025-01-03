AddEventHandler("Robbery:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Logger = exports["mancave-core"]:FetchComponent("Logger")
	Callbacks = exports["mancave-core"]:FetchComponent("Callbacks")
	PedInteraction = exports["mancave-core"]:FetchComponent("PedInteraction")
	Progress = exports["mancave-core"]:FetchComponent("Progress")
	Phone = exports["mancave-core"]:FetchComponent("Phone")
	Notification = exports["mancave-core"]:FetchComponent("Notification")
	Polyzone = exports["mancave-core"]:FetchComponent("Polyzone")
	Targeting = exports["mancave-core"]:FetchComponent("Targeting")
	Progress = exports["mancave-core"]:FetchComponent("Progress")
	Minigame = exports["mancave-core"]:FetchComponent("Minigame")
	Keybinds = exports["mancave-core"]:FetchComponent("Keybinds")
	Properties = exports["mancave-core"]:FetchComponent("Properties")
	Sounds = exports["mancave-core"]:FetchComponent("Sounds")
	Interaction = exports["mancave-core"]:FetchComponent("Interaction")
	Inventory = exports["mancave-core"]:FetchComponent("Inventory")
	Action = exports["mancave-core"]:FetchComponent("Action")
	Blips = exports["mancave-core"]:FetchComponent("Blips")
	EmergencyAlerts = exports["mancave-core"]:FetchComponent("EmergencyAlerts")
	Doors = exports["mancave-core"]:FetchComponent("Doors")
	ListMenu = exports["mancave-core"]:FetchComponent("ListMenu")
	Input = exports["mancave-core"]:FetchComponent("Input")
	Game = exports["mancave-core"]:FetchComponent("Game")
	NetSync = exports["mancave-core"]:FetchComponent("NetSync")
	Damage = exports["mancave-core"]:FetchComponent("Damage")
	Lasers = exports["mancave-core"]:FetchComponent("Lasers")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mancave-core"]:RequestDependencies("Robbery", {
		"Logger",
		"Callbacks",
		"PedInteraction",
		"Progress",
		"Phone",
		"Notification",
		"Polyzone",
		"Targeting",
		"Progress",
		"Minigame",
		"Keybinds",
		"Properties",
		"Sounds",
		"Interaction",
		"Inventory",
		"Action",
		"Blips",
		"EmergencyAlerts",
		"Doors",
		"ListMenu",
		"Input",
		"Game",
		"NetSync",
		"Damage",
		"Lasers",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
		RegisterGamesCallbacks()
		TriggerEvent("Robbery:Client:Setup")

		CreateThread(function()
			PedInteraction:Add(
				"RobToolsPickup",
				GetHashKey("csb_anton"),
				vector3(393.724, -831.028, 28.292),
				228.358,
				25.0,
				{
					{
						icon = "hand",
						text = "Pickup Items",
						event = "Robbery:Client:PickupItems",
					},
				},
				"box-dollar"
			)
		end)
	end)
end)

AddEventHandler("Robbery:Client:PickupItems", function()
	Callbacks:ServerCallback("Robbery:Pickup", {})
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mancave-core"]:RegisterComponent("Robbery", _ROBBERY)
end)

RegisterNetEvent("Robbery:Client:State:Init", function(states)
	_bankStates = states

	for k, v in pairs(states) do
		TriggerEvent(string.format("Robbery:Client:Update:%s", k))
	end
end)

RegisterNetEvent("Robbery:Client:State:Set", function(bank, state)
	_bankStates[bank] = state
	TriggerEvent(string.format("Robbery:Client:Update:%s", bank))
end)

RegisterNetEvent("Robbery:Client:State:Update", function(bank, key, value, tableId)
	if tableId then
		_bankStates[bank][tableId] = _bankStates[bank][tableId] or {}
		_bankStates[bank][tableId][key] = value
	else
		_bankStates[bank][key] = value
	end
	TriggerEvent(string.format("Robbery:Client:Update:%s", bank))
end)

AddEventHandler("Robbery:Client:Holdup:Do", function(entity, data)
	Progress:ProgressWithTickEvent({
		name = "holdup",
		duration = 5000,
		label = "Robbing",
		useWhileDead = false,
		canCancel = true,
		ignoreModifier = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "random@shop_robbery",
			anim = "robbery_action_b",
			flags = 49,
		},
	}, function()
		if
			#(
				GetEntityCoords(LocalPlayer.state.ped)
				- GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(entity.serverId)))
			) <= 3.0
		then
			return
		end
		Progress:Cancel()
	end, function(cancelled)
		if not cancelled then
			Callbacks:ServerCallback("Robbery:Holdup:Do", entity.serverId, function(s)
				Inventory.Dumbfuck:Open(s)

				while not LocalPlayer.state.inventoryOpen do
					Wait(1)
				end

				CreateThread(function()
					while LocalPlayer.state.inventoryOpen do
						if
							#(
								GetEntityCoords(LocalPlayer.state.ped)
								- GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(entity.serverId)))
							) > 3.0
						then
							Inventory.Close:All()
						end
						Wait(2)
					end
				end)
			end)
		end
	end)
end)

_ROBBERY = {}
