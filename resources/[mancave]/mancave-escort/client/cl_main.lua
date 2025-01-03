AddEventHandler("Escort:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["mancave-core"]:FetchComponent("Callbacks")
	Utils = exports["mancave-core"]:FetchComponent("Utils")
	Logger = exports["mancave-core"]:FetchComponent("Logger")
	Game = exports["mancave-core"]:FetchComponent("Game")
	Stream = exports["mancave-core"]:FetchComponent("Stream")
	Keybinds = exports["mancave-core"]:FetchComponent("Keybinds")
	Notification = exports["mancave-core"]:FetchComponent("Notification")
	Targeting = exports["mancave-core"]:FetchComponent("Targeting")
	Progress = exports["mancave-core"]:FetchComponent("Progress")
	Hud = exports["mancave-core"]:FetchComponent("Hud")
	Escort = exports["mancave-core"]:FetchComponent("Escort")
	Vehicles = exports["mancave-core"]:FetchComponent("Vehicles")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mancave-core"]:RequestDependencies("Escort", {
		"Callbacks",
		"Utils",
		"Logger",
		"Game",
		"Stream",
		"Keybinds",
		"Notification",
		"Targeting",
		"Progress",
		"Hud",
		"Escort",
		"Vehicles",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()

		Keybinds:Add("escort", "k", "keyboard", "Escort", function()
			DoEscort()
		end)

		Callbacks:RegisterClientCallback("Escort:StopEscort", function(data, cb)
			DetachEntity(LocalPlayer.state.ped, true, true)
			cb(true)
		end)
	end)
end)

ESCORT = {
	DoEscort = function(self, target, tPlayer)
		if target ~= nil then
			Callbacks:ServerCallback("Escort:DoEscort", {
				target = target,
				inVeh = IsPedInAnyVehicle(GetPlayerPed(tPlayer))
			}, function(state)
				if state then
					StartEscortThread(tPlayer)
				end
			end)
		end
	end,
	StopEscort = function(self)
		Callbacks:ServerCallback("Escort:StopEscort", function()

		end)
	end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mancave-core"]:RegisterComponent("Escort", ESCORT)
end)

AddEventHandler('Interiors:Exit', function()
	if LocalPlayer.state.isEscorting ~= nil then
		Escort:StopEscort()
	end
end)

--[[ TODO 
Add Dragging When Dead 
Place In vehicle while Dead Slump Animation
Police Drag Maybe Cuff Also
Get In Trunk or Place in trunk???
]]
