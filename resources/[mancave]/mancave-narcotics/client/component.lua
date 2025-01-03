AddEventHandler("Drugs:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["mancave-core"]:FetchComponent("Callbacks")
	Inventory = exports["mancave-core"]:FetchComponent("Inventory")
	Targeting = exports["mancave-core"]:FetchComponent("Targeting")
	Progress = exports["mancave-core"]:FetchComponent("Progress")
	Hud = exports["mancave-core"]:FetchComponent("Hud")
	Notification = exports["mancave-core"]:FetchComponent("Notification")
	ObjectPlacer = exports["mancave-core"]:FetchComponent("ObjectPlacer")
	Minigame = exports["mancave-core"]:FetchComponent("Minigame")
	ListMenu = exports["mancave-core"]:FetchComponent("ListMenu")
	PedInteraction = exports["mancave-core"]:FetchComponent("PedInteraction")
	Polyzone = exports["mancave-core"]:FetchComponent("Polyzone")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mancave-core"]:RequestDependencies("Drugs", {
        "Callbacks",
        "Inventory",
        "Targeting",
        "Progress",
        "Hud",
        "Notification",
        "ObjectPlacer",
		"Minigame",
		"ListMenu",
		"PedInteraction",
		"Polyzone",
	}, function(error)
		if #error > 0 then 
            exports["mancave-core"]:FetchComponent("Logger"):Critical("Drugs", "Failed To Load All Dependencies")
			return
		end
		RetrieveComponents()

        TriggerEvent("Drugs:Client:Startup")
	end)
end)