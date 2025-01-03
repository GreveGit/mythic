AddEventHandler("Billboards:Shared:DependencyUpdate", RetrieveComponents)
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
    Billboards = exports["mancave-core"]:FetchComponent("Billboards")
    Regex = exports["mancave-core"]:FetchComponent("Regex")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mancave-core"]:RequestDependencies("Billboards", {
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
        "Billboards",
        "Regex",
	}, function(error)
		if #error > 0 then 
            exports["mancave-core"]:FetchComponent("Logger"):Critical("Billboards", "Failed To Load All Dependencies")
			return
		end
		RetrieveComponents()

        FetchBillboardsData()

        Chat:RegisterAdminCommand("setbillboard", function(source, args, rawCommand)
            local billboardId, billboardUrl = args[1], args[2]

            if #billboardUrl <= 10 then
                billboardUrl = false
            end

            Billboards:Set(billboardId, billboardUrl)
        end, {
            help = "Set a Billboard URL",
            params = {
                {
                    name = "ID",
                    help = "Billboard ID",
                },
                {
                    name = "URL",
                    help = "Billboard URL",
                },
            },
        }, 2)

        Callbacks:RegisterServerCallback("Billboards:UpdateURL", function(source, data, cb)
            local billboardData = _billboardConfig[data?.id]
            if billboardData and billboardData.job and Player(source).state.onDuty == billboardData.job then
                local billboardUrl = data.link
                if #billboardUrl <= 5 then
                    billboardUrl = false
                end

                if not billboardUrl or Regex:Test(_billboardRegex, billboardUrl, "gim") then
                    cb(Billboards:Set(data.id, billboardUrl))
                else
                    cb(false, true)
                end
            else
                cb(false)
            end
        end)
	end)
end)

_BILLBOARDS = {
    Set = function(self, id, url)
        if id and _billboardConfig[id] then
            local updated = SetBillboardURL(id, url)
            if updated then
                GlobalState[string.format("Billboards:%s", id)] = url

                TriggerClientEvent('Billboards:Client:UpdateBoardURL', -1, id, url)

                return true
            end
        end
        return false
    end,
    Get = function(self, id)
        return GlobalState[string.format("Billboards:%s", id)]
    end,
    GetCategory = function(self, cat)
        local cIds = {}

        for k,v in pairs(_billboardConfig) do
            if v.category == cat then
                table.insert(cIds, k)
            end
        end

        return cIds
    end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function(component)
	exports["mancave-core"]:RegisterComponent("Billboards", _BILLBOARDS)
end)

local started = false
function FetchBillboardsData()
    if started then return; end

    started = true

    local fetchedBillboards = {}
    local billboardIds = {}

    Database.Game:find({
        collection = 'billboards',
        query = {}
    }, function(success, results)
        if success and #results > 0 then
            for k, v in ipairs(results) do
                if v.billboardId and v.billboardUrl then
                    fetchedBillboards[v.billboardId] = v.billboardUrl
                end
            end
        end

        for k,v in pairs(_billboardConfig) do
            GlobalState[string.format("Billboards:%s", k)] = fetchedBillboards[k]

            table.insert(billboardIds, k)
        end
    end)
end

function SetBillboardURL(billboardId, url)
    local p = promise.new()

    Database.Game:findOneAndUpdate({
        collection = 'billboards',
        query = {
            billboardId = billboardId,
        },
        update = {
            ['$set'] = {
                billboardUrl = url,
            },
        },
        options = {
            returnDocument = 'after',
            upsert = true,
        }
    }, function(success, results)
        if success and results then
            p:resolve(true)
        else
            p:resolve(false)
        end
    end)

    local res = Citizen.Await(p)
    return res
end