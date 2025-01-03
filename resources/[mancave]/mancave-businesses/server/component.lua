_pickups = {}

AddEventHandler("Businesses:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Fetch = exports["mancave-core"]:FetchComponent("Fetch")
	Utils = exports["mancave-core"]:FetchComponent("Utils")
    Execute = exports["mancave-core"]:FetchComponent("Execute")
	Database = exports["mancave-core"]:FetchComponent("Database")
	Middleware = exports["mancave-core"]:FetchComponent("Middleware")
	Callbacks = exports["mancave-core"]:FetchComponent("Callbacks")
    Chat = exports["mancave-core"]:FetchComponent("Chat")
	Logger = exports["mancave-core"]:FetchComponent("Logger")
	Generator = exports["mancave-core"]:FetchComponent("Generator")
	Phone = exports["mancave-core"]:FetchComponent("Phone")
	Jobs = exports["mancave-core"]:FetchComponent("Jobs")
	Vehicles = exports["mancave-core"]:FetchComponent("Vehicles")
    Inventory = exports["mancave-core"]:FetchComponent("Inventory")
	Wallet = exports["mancave-core"]:FetchComponent("Wallet")
	Crafting = exports["mancave-core"]:FetchComponent("Crafting")
	Banking = exports["mancave-core"]:FetchComponent("Banking")
	MDT = exports["mancave-core"]:FetchComponent("MDT")
	Laptop = exports["mancave-core"]:FetchComponent("Laptop")
	StorageUnits = exports["mancave-core"]:FetchComponent("StorageUnits")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mancave-core"]:RequestDependencies("Businesses", {
		"Fetch",
		"Utils",
        "Execute",
        "Chat",
		"Database",
		"Middleware",
		"Callbacks",
		"Logger",
		"Generator",
		"Phone",
		"Jobs",
		"Vehicles",
        "Inventory",
		"Wallet",
		"Crafting",
		"Banking",
		"MDT",
		"StorageUnits",
		"Laptop",
	}, function(error)
		if #error > 0 then 
            exports["mancave-core"]:FetchComponent("Logger"):Critical("Businesses", "Failed To Load All Dependencies")
			return
		end
		RetrieveComponents()

        TriggerEvent("Businesses:Server:Startup")

		Middleware:Add("Characters:Spawning", function(source)
			TriggerClientEvent("Businesses:Client:CreatePoly", source, _pickups)
		end, 2)

		Startup()
	end)
end)

function Startup()
	for k, v in ipairs(Config.Businesses) do
		Logger:Trace("Businesses", string.format("Registering Business ^3%s^7", v.Name))
		if v.Benches then
			for benchId, bench in pairs(v.Benches) do
				Logger:Trace("Businesses", string.format("Registering Crafting Bench ^2%s^7 For ^3%s^7", bench.label, v.Name))

				if bench.targeting.manual then
					Crafting:RegisterBench(string.format("%s-%s", v.Job, benchId), bench.label, bench.targeting, {}, {
						job = {
							id = v.Job,
							onDuty = true,
						},
					}, bench.recipes)
				else
					Crafting:RegisterBench(string.format("%s-%s", k, benchId), bench.label, bench.targeting, {
						x = 0,
						y = 0,
						z = bench.targeting.poly.coords.z,
						h = bench.targeting.poly.options.heading,
					}, {
						job = {
							id = v.Job,
							onDuty = true,
						},
					}, bench.recipes)
				end
			end
		end

		if v.Storage then
			for _, storage in pairs(v.Storage) do
				Logger:Trace("Businesses", string.format("Registering Poly Inventory ^2%s^7 For ^3%s^7", storage.id, v.Name))
				Inventory.Poly:Create(storage)
			end
		end

		if v.Pickups then
			for num, pickup in pairs(v.Pickups) do
				table.insert(_pickups, pickup.id)
				pickup.num = num
				pickup.job = v.Job
				pickup.jobName = v.Name
				GlobalState[string.format("Businesses:Pickup:%s", pickup.id)] = pickup
			end
		end
	end
end
