_DRUGS = _DRUGS or {}
local _addictionTemplate = {
	Meth = {
		LastUse = false,
		Factor = 0.0,
	},
	Coke = {
		LastUse = false,
		Factor = 0.0,
	},
}

AddEventHandler("Drugs:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Fetch = exports["mancave-core"]:FetchComponent("Fetch")
	Logger = exports["mancave-core"]:FetchComponent("Logger")
	Callbacks = exports["mancave-core"]:FetchComponent("Callbacks")
	Middleware = exports["mancave-core"]:FetchComponent("Middleware")
	Execute = exports["mancave-core"]:FetchComponent("Execute")
	Chat = exports["mancave-core"]:FetchComponent("Chat")
	Inventory = exports["mancave-core"]:FetchComponent("Inventory")
	Crypto = exports["mancave-core"]:FetchComponent("Crypto")
	Vehicles = exports["mancave-core"]:FetchComponent("Vehicles")
	Drugs = exports["mancave-core"]:FetchComponent("Drugs")
	Vendor = exports["mancave-core"]:FetchComponent("Vendor")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mancave-core"]:RequestDependencies("Drugs", {
        "Fetch",
        "Logger",
        "Callbacks",
        "Middleware",
        "Execute",
        "Chat",
        "Inventory",
        "Crypto",
        "Vehicles",
        "Drugs",
		"Vendor",
	}, function(error)
		if #error > 0 then 
            exports["mancave-core"]:FetchComponent("Logger"):Critical("Drugs", "Failed To Load All Dependencies")
			return
		end
		RetrieveComponents()
        RegisterItemUse()
        RunDegenThread()

		Middleware:Add("Characters:Spawning", function(source)
            local plyr = Fetch:Source(source)
            if plyr ~= nil then
                local char = plyr:GetData("Character")
                if char ~= nil then
                    if char:GetData("Addiction") == nil then
                        char:SetData("Addiction", _addictionTemplate)
                    end
                end
            end
		end, 1)

        TriggerEvent("Drugs:Server:Startup")
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mancave-core"]:RegisterComponent("Drugs", _DRUGS)
end)