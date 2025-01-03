AddEventHandler("Billboards:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
    Logger = exports["mancave-core"]:FetchComponent("Logger")
    Fetch = exports["mancave-core"]:FetchComponent("Fetch")
    Callbacks = exports["mancave-core"]:FetchComponent("Callbacks")
    Game = exports["mancave-core"]:FetchComponent("Game")
    Targeting = exports["mancave-core"]:FetchComponent("Targeting")
    Utils = exports["mancave-core"]:FetchComponent("Utils")
    Animations = exports["mancave-core"]:FetchComponent("Animations")
    Notification = exports["mancave-core"]:FetchComponent("Notification")
    Polyzone = exports["mancave-core"]:FetchComponent("Polyzone")
    Jobs = exports["mancave-core"]:FetchComponent("Jobs")
    Weapons = exports["mancave-core"]:FetchComponent("Weapons")
    Progress = exports["mancave-core"]:FetchComponent("Progress")
    Vehicles = exports["mancave-core"]:FetchComponent("Vehicles")
    ListMenu = exports["mancave-core"]:FetchComponent("ListMenu")
    Action = exports["mancave-core"]:FetchComponent("Action")
    Sounds = exports["mancave-core"]:FetchComponent("Sounds")
    PedInteraction = exports["mancave-core"]:FetchComponent("PedInteraction")
    Blips = exports["mancave-core"]:FetchComponent("Blips")
    Keybinds = exports["mancave-core"]:FetchComponent("Keybinds")
    Minigame = exports["mancave-core"]:FetchComponent("Minigame")
    Input = exports["mancave-core"]:FetchComponent("Input")
    Interaction = exports["mancave-core"]:FetchComponent("Interaction")
    Inventory = exports["mancave-core"]:FetchComponent("Inventory")
end

AddEventHandler("Core:Shared:Ready", function()
    exports["mancave-core"]:RequestDependencies("Billboards", {
        "Logger",
        "Fetch",
        "Callbacks",
        "Game",
        "Menu",
        "Targeting",
        "Notification",
        "Utils",
        "Animations",
        "Polyzone",
        "Jobs",
        "Weapons",
        "Progress",
        "Vehicles",
        "Targeting",
        "ListMenu",
        "Action",
        "Sounds",
        "PedInteraction",
        "Blips",
        "Keybinds",
        "Minigame",
        "Input",
        "Interaction",
        "Inventory",
    }, function(error)
        if #error > 0 then return; end
        RetrieveComponents()

        -- print('testing biatch')
        -- local dui = CreateBillboardDUI('https://i.imgur.com/Zlf40QZ.png', 1024, 512)
        -- AddReplaceTexture('ch2_03b_cg2_03b_bb', 'ch2_03b_bb_lowdown', dui.dictionary, dui.texture)

        -- Wait(10000)

        -- print(dui.id)

        -- ReleaseBillboardDUI(dui.id)
        -- RemoveReplaceTexture('ch2_03b_cg2_03b_bb', 'ch2_03b_bb_lowdown')

        StartUp()
    end)
end)

local started = false
local _billboardDUIs = {}

function StartUp()
    if started then
        return
    end

    started = true

    for k,v in pairs(_billboardConfig) do
        v.url = GlobalState[string.format("Billboards:%s", k)]
    end
end

AddEventHandler('Characters:Client:Spawn', function()
    CreateThread(function()
        while LocalPlayer.state.loggedIn do
            for k,v in pairs(_billboardConfig) do
                local dist = #(GetEntityCoords(LocalPlayer.state.ped) - v.coords)
                if dist <= v.range then
                    if not _billboardDUIs[k] and v.url then
                        local createdDui = CreateBillboardDUI(v.url, v.width, v.height)
                        AddReplaceTexture(v.originalDictionary, v.originalTexture, createdDui.dictionary, createdDui.texture)

                        _billboardDUIs[k] = createdDui
                    end
                elseif _billboardDUIs[k] then
                    ReleaseBillboardDUI(_billboardDUIs[k].id)
                    RemoveReplaceTexture(v.originalDictionary, v.originalTexture)
                    _billboardDUIs[k] = nil
                end
            end
            Wait(1500)
        end
    end)
end)


RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    for k,v in pairs(_billboardConfig) do
        if _billboardDUIs[k] then

            ReleaseBillboardDUI(_billboardDUIs[k].id)
            RemoveReplaceTexture(v.originalDictionary, v.originalTexture)
            _billboardDUIs[k] = nil
        end
    end
end)

RegisterNetEvent("Billboards:Client:UpdateBoardURL", function(id, url)
    if not _billboardConfig[id] then
        return
    end

    if _billboardDUIs[id] then
        if url then
            UpdateBillboardDUI(_billboardDUIs[id].id, url)
            AddReplaceTexture(_billboardConfig[id].originalDictionary, _billboardConfig[id].originalTexture, _billboardDUIs[id].dictionary, _billboardDUIs[id].texture)
        else
            ReleaseBillboardDUI(_billboardDUIs[id].id)
            RemoveReplaceTexture(_billboardConfig[id].originalDictionary, _billboardConfig[id].originalTexture)
            _billboardDUIs[id] = nil
        end
    end

    _billboardConfig[id].url = url
end)