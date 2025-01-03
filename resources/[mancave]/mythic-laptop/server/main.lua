function defaultApps()
	-- local defApps = {}
	-- for k, v in pairs(LAPTOP_APPS) do
	-- 	if not v.canUninstall then
	-- 		table.insert(defApps, v.name)
	-- 	end
	-- end
	-- return {
	-- 	installed = defApps,
	-- 	home = defApps,
	-- }

	return {
		installed = {
			"recyclebin",
			"settings",
			"files",
			"internet",
			"bizwiz",
			"teams",
			"lsunderground",
		},
		home = {
			"recyclebin",
			"settings",
			"files",
			"internet",
			"bizwiz",
			"teams",
			"lsunderground",
		},
	}
end

function hasValue(tbl, value)
	for k, v in ipairs(tbl) do
		if v == value or (type(v) == "table" and hasValue(v, value)) then
			return true
		end
	end
	return false
end

function table.copy(t)
	local u = {}
	for k, v in pairs(t) do
		u[k] = v
	end
	return setmetatable(u, getmetatable(t))
end

function defaultSettings()
	return {
		wallpaper = "wallpaper",
		texttone = "notification.ogg",
		colors = {
			accent = "#1a7cc1",
		},
		zoom = 75,
		volume = 100,
		notifications = true,
		appNotifications = {},
	}
end

local defaultPermissions = {
	redline = {
		create = false,
	},
	lsunderground = {
		admin = false,
	},
}

AddEventHandler("onResourceStart", function(resource)
	if resource == GetCurrentResourceName() then
		TriggerClientEvent("Laptop:Client:SetApps", -1, LAPTOP_APPS)
	end
end)

AddEventHandler("Laptop:Shared:DependencyUpdate", RetrieveComponents)

function RetrieveComponents()
	Fetch = exports["mancave-core"]:FetchComponent("Fetch")
	Database = exports["mancave-core"]:FetchComponent("Database")
	Callbacks = exports["mancave-core"]:FetchComponent("Callbacks")
	Logger = exports["mancave-core"]:FetchComponent("Logger")
	Utils = exports["mancave-core"]:FetchComponent("Utils")
	Chat = exports["mancave-core"]:FetchComponent("Chat")
	Middleware = exports["mancave-core"]:FetchComponent("Middleware")
	Execute = exports["mancave-core"]:FetchComponent("Execute")
	Config = exports["mancave-core"]:FetchComponent("Config")
	MDT = exports["mancave-core"]:FetchComponent("MDT")
	Jobs = exports["mancave-core"]:FetchComponent("Jobs")
	Labor = exports["mancave-core"]:FetchComponent("Labor")
	Crypto = exports["mancave-core"]:FetchComponent("Crypto")
	VOIP = exports["mancave-core"]:FetchComponent("VOIP")
	Generator = exports["mancave-core"]:FetchComponent("Generator")
	Properties = exports["mancave-core"]:FetchComponent("Properties")
	Vehicles = exports["mancave-core"]:FetchComponent("Vehicles")
	Inventory = exports["mancave-core"]:FetchComponent("Inventory")
	Loot = exports["mancave-core"]:FetchComponent("Loot")
	Loans = exports["mancave-core"]:FetchComponent("Loans")
	Billing = exports["mancave-core"]:FetchComponent("Billing")
	Banking = exports["mancave-core"]:FetchComponent("Banking")
	Reputation = exports["mancave-core"]:FetchComponent("Reputation")
	Robbery = exports["mancave-core"]:FetchComponent("Robbery")
	Wallet = exports["mancave-core"]:FetchComponent("Wallet")
	Sequence = exports["mancave-core"]:FetchComponent("Sequence")
	Phone = exports["mancave-core"]:FetchComponent("Phone")
	Laptop = exports["mancave-core"]:FetchComponent("Laptop")
	RegisterChatCommands()
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mancave-core"]:RequestDependencies("Laptop", {
		"Fetch",
		"Database",
		"Callbacks",
		"Logger",
		"Utils",
		"Chat",
		"Laptop",
		"Middleware",
		"Execute",
		"Config",
		"MDT",
		"Jobs",
		"Labor",
		"Crypto",
		"VOIP",
		"Generator",
		"Properties",
		"Vehicles",
		"Inventory",
		"Loot",
		"Loans",
		"Billing",
		"Banking",
		"Reputation",
		"Robbery",
		"Wallet",
		"Sequence",
		"Phone",
	}, function(error)
		if #error > 0 then
			return
		end
		-- Do something to handle if not all dependencies loaded
		RetrieveComponents()
		Startup()
		TriggerEvent("Laptop:Server:RegisterMiddleware")
		TriggerEvent("Laptop:Server:RegisterCallbacks")

		Inventory.Items:RegisterUse("laptop", "Laptop", function(source, itemData)
			TriggerClientEvent("Laptop:Client:Open", source)
		end)

		Reputation:Create("Boosting", "Boosting", {
			{ label = "D", value = 0 },
			{ label = "C", value = 6000 },
			{ label = "B", value = 15000 },
			{ label = "A", value = 50000 },
			{ label = "A+", value = 120000 }, -- Get Scratching
			{ label = "S+", value = 150000 },
		}, true)
	end)
end)

AddEventHandler("Laptop:Server:RegisterMiddleware", function()
	Middleware:Add("Characters:Spawning", function(source)
		Laptop:UpdateJobData(source)
		TriggerClientEvent("Laptop:Client:SetApps", source, LAPTOP_APPS)

		local char = Fetch:Source(source):GetData("Character")
		local myPerms = char:GetData("LaptopPermissions") or {}
		local modified = false
		for app, perms in pairs(defaultPermissions) do
			if myPerms[app] == nil then
				myPerms[app] = perms
				modified = true
			else
				for perm, state in pairs(perms) do
					if myPerms[app][perm] == nil then
						myPerms[app][perm] = state
						modified = true
					end
				end
			end
		end

		if modified then
			char:SetData("LaptopPermissions", myPerms)
		end

		if not char:GetData("LaptopSettings") then
			char:SetData("LaptopSettings", defaultSettings())
		end

		if not char:GetData("LaptopApps") then
			char:SetData("LaptopApps", defaultApps())
		end
	end, 1)
	Middleware:Add("Laptop:UIReset", function(source)
		Laptop:UpdateJobData(source)
		TriggerClientEvent("Laptop:Client:SetApps", source, LAPTOP_APPS)
	end)
	Middleware:Add("Characters:Creating", function(source, cData)
		local t = Middleware:TriggerEventWithData("Laptop:CharacterCreated", source, cData)

		return {
			{
				LaptopApps = defaultApps(),
				LaptopSettings = defaultSettings(),
				LaptopPermissions = defaultPermissions,
			},
		}
	end)
end)

RegisterNetEvent("Laptop:Server:UIReset", function()
	Middleware:TriggerEvent("Laptop:UIReset", source)
end)

AddEventHandler("Laptop:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("Laptop:Permissions", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")

		if char ~= nil then
			local perms = char:GetData("LaptopPermissions")

			for k, v in pairs(data) do
				for k2, v2 in ipairs(v) do
					if not perms[k][v2] then
						cb(false)
						return
					end
				end
			end
			cb(true)
		else
			cb(false)
		end
	end)
end)
