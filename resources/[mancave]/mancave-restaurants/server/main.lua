AddEventHandler("Restaurant:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Database = exports["mancave-core"]:FetchComponent("Database")
	Callbacks = exports["mancave-core"]:FetchComponent("Callbacks")
	Middleware = exports["mancave-core"]:FetchComponent("Middleware")
	Logger = exports["mancave-core"]:FetchComponent("Logger")
	Fetch = exports["mancave-core"]:FetchComponent("Fetch")
	Inventory = exports["mancave-core"]:FetchComponent("Inventory")
	Crafting = exports["mancave-core"]:FetchComponent("Crafting")
	Jobs = exports["mancave-core"]:FetchComponent("Jobs")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mancave-core"]:RequestDependencies("Restaurant", {
		"Database",
		"Callbacks",
		"Middleware",
		"Logger",
		"Fetch",
		"Inventory",
		"Crafting",
		"Jobs",
	}, function(error)
		if error then
		end

		RetrieveComponents()
		Startup()

		Middleware:Add("Characters:Spawning", function(source)
			RunRestaurantJobUpdate(source, true)
		end, 2)
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mancave-core"]:RegisterComponent("Restaurant", _RESTAURANT)
end)

_RESTAURANT = {}

function RunRestaurantJobUpdate(source, onSpawn)
	local charJobs = Jobs.Permissions:GetJobs(source)
	local warmersList = {}
	for k, v in ipairs(charJobs) do
		local jobWarmers = _warmers[v.Id]
		if jobWarmers then
			table.insert(warmersList, jobWarmers)
		end
	end
	TriggerClientEvent(
		"Restaurant:Client:CreatePoly",
		source,
		_pickups,
		warmersList,
		onSpawn
	)
end

AddEventHandler('Jobs:Server:JobUpdate', function(source)
	RunRestaurantJobUpdate(source)
end)