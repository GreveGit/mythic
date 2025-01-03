AddEventHandler("Apartments:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Database = exports["mancave-core"]:FetchComponent("Database")
	Callbacks = exports["mancave-core"]:FetchComponent("Callbacks")
	Logger = exports["mancave-core"]:FetchComponent("Logger")
	Utils = exports["mancave-core"]:FetchComponent("Utils")
	Fetch = exports["mancave-core"]:FetchComponent("Fetch")
	Mechanic = exports["mancave-core"]:FetchComponent("Mechanic")
	Jobs = exports["mancave-core"]:FetchComponent("Jobs")
	Inventory = exports["mancave-core"]:FetchComponent("Inventory")
	Crafting = exports["mancave-core"]:FetchComponent("Crafting")
	Vehicles = exports["mancave-core"]:FetchComponent("Vehicles")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mancave-core"]:RequestDependencies("Mechanic", {
		"Database",
		"Callbacks",
		"Logger",
		"Utils",
		"Fetch",
		"Mechanic",
		"Jobs",
		"Inventory",
		"Crafting",
		"Vehicles",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
		RegisterCallbacks()

		RegisterMechanicItems()

		for k, v in ipairs(_mechanicShopStorageCrafting) do
			if v.partCrafting then
				for benchId, bench in ipairs(v.partCrafting) do
					Crafting:RegisterBench(string.format("mech-%s-%s", v.job, benchId), bench.label, bench.targeting, {
						x = bench.targeting.poly.coords.x,
						y = bench.targeting.poly.coords.y,
						z = bench.targeting.poly.coords.z,
						h = bench.targeting.poly.options.heading,
					}, {
						job = {
							id = v.job,
							onDuty = true,
						},
					}, bench.recipes, bench.canUseSchematics)
				end
			end

			if v.partStorage then
				for storageId, storage in ipairs(v.partStorage) do
					Inventory.Poly:Create(storage)
				end
			end
		end
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mancave-core"]:RegisterComponent("Mechanic", MECHANIC)
end)

MECHANIC = {}
