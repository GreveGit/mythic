_plants = {}

AddEventHandler("Weed:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Database = exports["mancave-core"]:FetchComponent("Database")
	Callbacks = exports["mancave-core"]:FetchComponent("Callbacks")
	Logger = exports["mancave-core"]:FetchComponent("Logger")
	Middleware = exports["mancave-core"]:FetchComponent("Middleware")
	Logger = exports["mancave-core"]:FetchComponent("Logger")
	Utils = exports["mancave-core"]:FetchComponent("Utils")
	Locations = exports["mancave-core"]:FetchComponent("Locations")
	Game = exports["mancave-core"]:FetchComponent("Game")
	Weed = exports["mancave-core"]:FetchComponent("Weed")
	Routing = exports["mancave-core"]:FetchComponent("Routing")
	Fetch = exports["mancave-core"]:FetchComponent("Fetch")
	Inventory = exports["mancave-core"]:FetchComponent("Inventory")
	Execute = exports["mancave-core"]:FetchComponent("Execute")
	Routing = exports["mancave-core"]:FetchComponent("Routing")
	Tasks = exports["mancave-core"]:FetchComponent("Tasks")
	Wallet = exports["mancave-core"]:FetchComponent("Wallet")
	Reputation = exports["mancave-core"]:FetchComponent("Reputation")
	WaitList = exports["mancave-core"]:FetchComponent("WaitList")
	Chat = exports["mancave-core"]:FetchComponent("Chat")
	Status = exports["mancave-core"]:FetchComponent("Status")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mancave-core"]:RequestDependencies("Weed", {
		"Database",
		"Callbacks",
		"Logger",
		"Middleware",
		"Logger",
		"Execute",
		"Utils",
		"Locations",
		"Game",
		"Routing",
		"Fetch",
		"Weed",
		"Inventory",
		"Routing",
		"Tasks",
		"Wallet",
		"Reputation",
		"WaitList",
		"Chat",
		"Status",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()
		Startup()
		RegisterMiddleware()
		RegisterCallbacks()
		RegisterTasks()
		RegisterItems()
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mancave-core"]:RegisterComponent("Weed", WEED)
end)

function getStageByPct(pct)
	local stagePct = 100 / (#Plants - 1)
	return math.floor((pct / stagePct) + 1.5)
end

function checkNearPlant(source, id)
	local coords = GetEntityCoords(GetPlayerPed(source))
	if _plants[id] ~= nil then
		return #(
				vector3(coords.x, coords.y, coords.z)
				- vector3(_plants[id].plant.location.x, _plants[id].plant.location.y, _plants[id].plant.location.z)
			) <= 5
	else
		return false
	end
end

WEED = {
	Planting = {
		Set = function(self, id, isUpdate)
			if _plants[id] ~= nil then
				local stage = getStageByPct(_plants[id].plant.growth)
				_plants[id].stage = stage

				TriggerClientEvent('Weed:Client:Objects:Update', -1, id, _plants[id], isUpdate)
			end
		end,
		Delete = function(self, id, skipRemove)
			if _plants[id] ~= nil then
				_plants[id] = nil
				TriggerClientEvent('Weed:Client:Objects:Delete', -1, id)
			end
		end,
		Create = function(self, isMale, location, material)
			local p = promise.new()
			local weed = {
				isMale = isMale,
				location = location,
				growth = 0,
				output = 1,
				material = material,
				planted = os.time(),
				water = 100.0,
			}
			Database.Game:insertOne({
				collection = "weed",
				document = weed,
			}, function(success, results, insertedIds)
				if not success then
					return p:resolve(nil)
				end
				weed._id = insertedIds[1]
				return p:resolve(weed)
			end)
			return Citizen.Await(p)
		end,
	},
}
