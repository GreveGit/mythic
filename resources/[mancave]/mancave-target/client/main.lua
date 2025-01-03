local IS_SPAWNED = false

TargetableObjectModels, TargetableEntities = {}, {}
InteractionZones, InteractablePeds, InteractableModels = {}, {}, {}

AddEventHandler('Targeting:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
	Utils = exports['mancave-core']:FetchComponent('Utils')
	Keybinds = exports['mancave-core']:FetchComponent('Keybinds')
	Targeting = exports['mancave-core']:FetchComponent('Targeting')
	UISounds = exports['mancave-core']:FetchComponent('UISounds')
	Jobs = exports['mancave-core']:FetchComponent('Jobs')
	Vehicles = exports['mancave-core']:FetchComponent('Vehicles')
	Fetch = exports['mancave-core']:FetchComponent('Fetch')
	EMS = exports['mancave-core']:FetchComponent('EMS')
	Inventory = exports['mancave-core']:FetchComponent('Inventory')
	Reputation = exports['mancave-core']:FetchComponent('Reputation')
	Mechanic = exports['mancave-core']:FetchComponent('Mechanic')
	Polyzone = exports['mancave-core']:FetchComponent('Polyzone')
	Tow = exports['mancave-core']:FetchComponent('Tow')
end

AddEventHandler('Core:Shared:Ready', function()
	exports['mancave-core']:RequestDependencies('Targeting', {
		'Utils',
		'Keybinds',
		'Targeting',
		'UISounds',
		'Jobs',
		'Vehicles',
		'Fetch',
		'EMS',
		'Inventory',
		'Reputation',
		'Mechanic',
		'Polyzone',
		'Tow',
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()

		Keybinds:Add("targeting_starts", "LMENU", "keyboard", "Targeting (Third Eye) (Hold)", function()
            if IS_SPAWNED then
                StartTargeting()
            end
		end, function()
			if not InTargetingMenu then
				StopTargeting()
			end
		end)

		if LocalPlayer.state.loggedIn then
			DeInitPolyzoneTargets()
			Wait(100)
			InitPolyzoneTargets()
		end
	end)
end)

RegisterNetEvent("Characters:Client:Spawn")
AddEventHandler("Characters:Client:Spawn", function()
	local lastEntity = nil
	CreateThread(function()
		while LocalPlayer.state.loggedIn do
			Wait(500)
			local hitting, endCoords, entity = GetEntityPlayerIsLookingAt(25.0, LocalPlayer.state.ped, 286)
			if hitting and GetEntityType(entity) > 0 and entity ~= lastEntity then
				lastEntity = entity
				TriggerEvent("Targeting:Client:TargetChanged", entity, endCoords)
			elseif not hitting and lastEntity then
				lastEntity = nil
				TriggerEvent("Targeting:Client:TargetChanged", false)
			end
		end
	end)

	Wait(2000)
	IS_SPAWNED = true
	InitPolyzoneTargets()
end)

RegisterNetEvent("Characters:Client:Logout")
AddEventHandler("Characters:Client:Logout", function()
	DeInitPolyzoneTargets()
	IS_SPAWNED = false
end)

TARGETING = {
	GetEntityPlayerIsLookingAt = function(self)
		local hitting, endCoords, entity = GetEntityPlayerIsLookingAt(25.0, LocalPlayer.state.ped, 286)
		if hitting then
			return {
				entity = entity,
				endCoords = endCoords,
			}
		end
		return false
	end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	-- ? Clear targets since they should be being reregistered on component update anyways
	table.wipe(TargetableObjectModels)
	table.wipe(TargetableEntities)
	table.wipe(InteractablePeds)
	table.wipe(InteractableModels)
	table.wipe(InteractionZones)
	exports['mancave-core']:RegisterComponent('Targeting', TARGETING)
end)