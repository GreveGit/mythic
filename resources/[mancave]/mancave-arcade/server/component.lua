AddEventHandler("Arcade:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Fetch = exports["mancave-core"]:FetchComponent("Fetch")
	Database = exports["mancave-core"]:FetchComponent("Database")
	Callbacks = exports["mancave-core"]:FetchComponent("Callbacks")
	Logger = exports["mancave-core"]:FetchComponent("Logger")
	Chat = exports["mancave-core"]:FetchComponent("Chat")
	Middleware = exports["mancave-core"]:FetchComponent("Middleware")
	Execute = exports["mancave-core"]:FetchComponent("Execute")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mancave-core"]:RequestDependencies("Arcade", {
		"Fetch",
		"Database",
		"Callbacks",
		"Logger",
		"Chat",
		"Middleware",
		"Execute",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()
        
        Callbacks:RegisterServerCallback("Arcade:Open", function(source, data, cb)
            local plyr = Fetch:Source(source)
            if plyr ~= nil then
                local char = plyr:GetData("Character")
                if char ~= nil then
                    if Player(source).state.onDuty == "avast_arcade" then
                        GlobalState["Arcade:Open"] = true
                    end
                end
            end
        end)
        
        Callbacks:RegisterServerCallback("Arcade:Close", function(source, data, cb)
            local plyr = Fetch:Source(source)
            if plyr ~= nil then
                local char = plyr:GetData("Character")
                if char ~= nil then
                    if Player(source).state.onDuty == "avast_arcade" then
                        GlobalState["Arcade:Open"] = false
                    end
                end
            end
        end)
	end)
end)