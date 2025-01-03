_openCd = false -- Prevents spamm open/close
_settings = {}
_loggedIn = false

local _ignoreEvents = {
	"Health",
	"HP",
	"Armor",
	"Status",
	"Damage",
	"Wardrobe",
	"Animations",
	"Ped",
}

AddEventHandler("Laptop:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["mancave-core"]:FetchComponent("Callbacks")
	Logger = exports["mancave-core"]:FetchComponent("Logger")
	Notification = exports["mancave-core"]:FetchComponent("Notification")
	UISounds = exports["mancave-core"]:FetchComponent("UISounds")
	Sounds = exports["mancave-core"]:FetchComponent("Sounds")
	Hud = exports["mancave-core"]:FetchComponent("Hud")
	Keybinds = exports["mancave-core"]:FetchComponent("Keybinds")
	Interaction = exports["mancave-core"]:FetchComponent("Interaction")
	Inventory = exports["mancave-core"]:FetchComponent("Inventory")
	Hud = exports["mancave-core"]:FetchComponent("Hud")
	Targeting = exports["mancave-core"]:FetchComponent("Targeting")
	ListMenu = exports["mancave-core"]:FetchComponent("ListMenu")
	Labor = exports["mancave-core"]:FetchComponent("Labor")
	Jail = exports["mancave-core"]:FetchComponent("Jail")
	Blips = exports["mancave-core"]:FetchComponent("Blips")
	Reputation = exports["mancave-core"]:FetchComponent("Reputation")
	Polyzone = exports["mancave-core"]:FetchComponent("Polyzone")
	NetSync = exports["mancave-core"]:FetchComponent("NetSync")
	Vehicles = exports["mancave-core"]:FetchComponent("Vehicles")
	Progress = exports["mancave-core"]:FetchComponent("Progress")
	Jobs = exports["mancave-core"]:FetchComponent("Jobs")
	Utils = exports["mancave-core"]:FetchComponent("Utils")
	Minigame = exports["mancave-core"]:FetchComponent("Minigame")
	PedInteraction = exports["mancave-core"]:FetchComponent("PedInteraction")
	Laptop = exports["mancave-core"]:FetchComponent("Laptop")
	Properties = exports["mancave-core"]:FetchComponent("Properties")
	Admin = exports["mancave-core"]:FetchComponent("Admin")
	Animations = exports["mancave-core"]:FetchComponent("Animations")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mancave-core"]:RequestDependencies("Laptop", {
		"Callbacks",
		"Logger",
		"Notification",
		"UISounds",
		"Sounds",
		"Hud",
		"Keybinds",
		"Interaction",
		"Inventory",
		"Hud",
		"Targeting",
		"ListMenu",
		"Labor",
		"Jail",
		"Blips",
		"Reputation",
		"Polyzone",
		"NetSync",
		"Vehicles",
		"Progress",
		"Jobs",
		"Utils",
		"Minigame",
		"PedInteraction",
		"Properties",
		"Admin",
		"Laptop",
		"Animations",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()

		Keybinds:Add("laptop_open", "", "keyboard", "Laptop - Open", function()
			OpenLaptop()
		end)

		RegisterBoostingCallbacks()
	end)
end)

function OpenLaptop()
	if
		_loggedIn
		and not Hud:IsDisabled()
		and not Jail:IsJailed()
		and hasValue(LocalPlayer.state.Character:GetData("States"), "LAPTOP")
		and not LocalPlayer.state.laptopOpen
	then
		Laptop:Open()
	end
end

RegisterNetEvent("Laptop:Client:Open", OpenLaptop)

AddEventHandler("Inventory:Client:ItemsLoaded", function()
	while Laptop == nil do
		Wait(10)
	end
	Laptop.Data:Set("items", Inventory.Items:GetData())
end)

AddEventHandler("Characters:Client:Updated", function(key)
	if hasValue(_ignoreEvents, key) then
		return
	end
	_settings = LocalPlayer.state.Character:GetData("LaptopSettings")
	Laptop.Data:Set("player", LocalPlayer.state.Character:GetData())

	if
		key == "States"
		and LocalPlayer.state.laptopOpen
		and (not hasValue(LocalPlayer.state.Character:GetData("States"), "LAPTOP"))
	then
		Laptop:Close(true)
	end
end)

AddEventHandler("Ped:Client:Died", function()
	Laptop:Close(true)
end)

RegisterNetEvent("Job:Client:DutyChanged", function(state)
	Laptop.Data:Set("onDuty", state)
end)

RegisterNetEvent("UI:Client:Reset", function(manual)
	SetNuiFocus(false, false)
	SendNUIMessage({
		type = "UI_RESET",
		data = {},
	})

	if manual then
		TriggerServerEvent("Laptop:Server:UIReset")
		if LocalPlayer.state.laptopOpen then
			Laptop:Close()
		end
	end
end)

AddEventHandler("UI:Client:Close", function(context)
	if context ~= "laptop" then
		Laptop:Close()
	end
end)

AddEventHandler("Ped:Client:Died", function()
	if LocalPlayer.state.laptopOpen then
		Laptop:Close()
	end
end)

RegisterNetEvent("Laptop:Client:SetApps", function(apps)
	LAPTOP_APPS = apps
	SendNUIMessage({
		type = "SET_APPS",
		data = apps,
	})
end)

AddEventHandler("Characters:Client:Spawn", function()
	_loggedIn = true

	CreateThread(function()
		while _loggedIn do
			SendNUIMessage({
				type = "SET_TIME",
				data = GlobalState["Sync:Time"],
			})
			Wait(15000)
		end
	end)
end)

RegisterNetEvent("Characters:Client:Logout", function()
	_loggedIn = false
end)

function hasValue(tbl, value)
	for k, v in ipairs(tbl or {}) do
		if v == value or (type(v) == "table" and hasValue(v, value)) then
			return true
		end
	end
	return false
end

RegisterNUICallback("AcceptPopup", function(data, cb)
	cb("OK")
	if data.data ~= nil and data.data.server then
		TriggerServerEvent(data.event, data.data)
	else
		TriggerEvent(data.event, data.data)
	end
end)

RegisterNUICallback("CancelPopup", function(data, cb)
	cb("OK")
	if data.data ~= nil and data.data.server then
		TriggerServerEvent(data.event, data.data)
	else
		TriggerEvent(data.event, data.data)
	end
end)

RegisterNUICallback("CDExpired", function(data, cb)
	cb("OK")
	_openCd = false
end)
