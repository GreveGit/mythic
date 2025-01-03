AddEventHandler("Finance:Shared:DependencyUpdate", RetrieveComponents)
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
	Crypto = exports["mancave-core"]:FetchComponent("Crypto")
    Banking = exports["mancave-core"]:FetchComponent("Banking")
	Billing = exports["mancave-core"]:FetchComponent("Billing")
	Loans = exports["mancave-core"]:FetchComponent("Loans")
    Wallet = exports["mancave-core"]:FetchComponent("Wallet")
	Tasks = exports["mancave-core"]:FetchComponent("Tasks")
	Jobs = exports["mancave-core"]:FetchComponent("Jobs")
	Vehicles = exports["mancave-core"]:FetchComponent("Vehicles")
	Inventory = exports["mancave-core"]:FetchComponent("Inventory")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mancave-core"]:RequestDependencies("Finance", {
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
        "Wallet",
        "Banking",
		"Billing",
		"Loans",
		"Crypto",
		"Jobs",
		"Tasks",
		"Vehicles",
		"Inventory",
	}, function(error)
		if #error > 0 then
			exports["mancave-core"]:FetchComponent("Logger"):Critical("Finance", "Failed To Load All Dependencies")
			return
		end
		RetrieveComponents()

		TriggerEvent('Finance:Server:Startup')
	end)
end)