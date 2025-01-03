_insideCasino = false
_insideCasinoAudio = false
_CASINO = _CASINO or {}

AddEventHandler("Casino:Shared:DependencyUpdate", RetrieveComponents)
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
    InfoOverlay = exports["mancave-core"]:FetchComponent("InfoOverlay")
    Casino = exports["mancave-core"]:FetchComponent("Casino")
end

AddEventHandler("Core:Shared:Ready", function()
    exports["mancave-core"]:RequestDependencies("Casino", {
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
        "InfoOverlay",
        "Casino",
    }, function(error)
        if #error > 0 then return; end
        RetrieveComponents()

        TriggerEvent("Casino:Client:Startup")
    end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mancave-core"]:RegisterComponent("Casino", _CASINO)
end)

RegisterNetEvent("Characters:Client:Spawn")
AddEventHandler("Characters:Client:Spawn", function()
    Blips:Add("casino", "Diamond Casino & Resort", vector3(956.586, 36.004, 71.429), 680, 22, 1.0, 2, 11)

    LocalPlayer.state.playingCasino = false
end)

AddEventHandler("Casino:Client:Startup", function()

    local casinoDesks = {
        {
            center = vector3(965.62, 46.99, 71.7),
            length = 3.0,
            width = 1.0,
            options = {
                heading = 58,
                --debugPoly=true,
                minZ = 71.1,
                maxZ = 72.1
            }
        },
        {
            center = vector3(998.08, 53.86, 75.07),
            length = 1.4,
            width = 1.8,
            options = {
                heading = 328,
                --debugPoly=true,
                minZ = 74.47,
                maxZ = 75.67
            }
        },
    }

    for k, v in ipairs(casinoDesks) do
        Targeting.Zones:AddBox("casino-employee-" .. k, "circle-dollar-to-slot", v.center, v.length, v.width, v.options, {
            {
                icon = "clipboard-check",
                text = "Clock In",
                event = "Casino:Client:ClockIn",
                data = { job = "casino" },
                jobPerms = {
                    {
                        job = "casino",
                        reqOffDuty = true,
                    }
                },
            },
            {
                icon = "clipboard",
                text = "Clock Out",
                event = "Casino:Client:ClockOut",
                data = { job = "casino" },
                jobPerms = {
                    {
                        job = "casino",
                        reqDuty = true,
                    }
                },
            },
            {
                icon = "circle-dollar-to-slot",
                text = "Close Casino",
                event = "Casino:Client:OpenClose",
                data = { state = false },
                jobPerms = {
                    {
                        job = "casino",
                        reqDuty = true,
                    }
                },
                isEnabled = function()
                    return GlobalState["CasinoOpen"]
                end,
            },
            {
                icon = "circle-dollar-to-slot",
                text = "Open Casino",
                event = "Casino:Client:OpenClose",
                data = { state = true },
                jobPerms = {
                    {
                        job = "casino",
                        reqDuty = true,
                    }
                },
                isEnabled = function()
                    return not GlobalState["CasinoOpen"]
                end,
            },
        }, 3.0, true)
    end

    PedInteraction:Add("CasinoStaff1", `u_f_m_casinoshop_01`, vector3(965.357, 48.067, 70.701), 146.416, 25.0, false, "question", "WORLD_HUMAN_STAND_IMPATIENT")
    PedInteraction:Add("CasinoStaff2", `s_m_y_casino_01`, vector3(951.773, 21.896, 70.904), 346.697, 25.0, false, "question", "WORLD_HUMAN_GUARD_STAND")

    Polyzone.Create:Box('casino_inside', vector3(1004.77, 38.26, 77.91), 129.2, 90.0, {
        heading = 305,
        --debugPoly=true,
        minZ = 62.71,
        maxZ = 78.11
    }, {})

    Polyzone.Create:Poly('casino_audio', {
        vector2(1031.4703369141, 69.031555175781),
        vector2(1029.1315917969, 70.45630645752),
        vector2(1020.2162475586, 74.967506408691),
        vector2(1018.774230957, 67.163162231445),
        vector2(1016.8631591797, 63.980415344238),
        vector2(1010.8873291016, 63.975051879883),
        vector2(1008.0106811523, 63.327266693115),
        vector2(997.93920898438, 54.817604064941),
        vector2(998.31079101562, 57.504776000977),
        vector2(989.02960205078, 59.375911712646),
        vector2(983.41088867188, 58.477466583252),
        vector2(982.99322509766, 52.2580909729),
        vector2(963.95635986328, 51.413318634033),
        vector2(952.62396240234, 48.958881378174),
        vector2(956.68328857422, 34.952949523926),
        vector2(961.76043701172, 31.73747253418),
        vector2(955.79132080078, 8.4615421295166),
        vector2(981.96832275391, 14.115256309509),
        vector2(991.46240234375, 21.801073074341),
        vector2(1017.1166992188, 30.705118179321),
        vector2(1023.4791870117, 34.56270980835),
        vector2(1028.4720458984, 30.613445281982),
        vector2(1037.5812988281, 34.075561523438),
        vector2(1040.0360107422, 37.743408203125),
        vector2(1042.3696289062, 42.986534118652),
        vector2(1046.3763427734, 43.615371704102),
        vector2(1049.4754638672, 57.303512573242),
        vector2(1048.7061767578, 61.635692596436)
	}, {
		--debugPoly=true,
        minZ = 60.95,
        maxZ = 74.785
	})

    PedInteraction:Add("CasinoCashier", `s_m_y_casino_01`, vector3(990.372, 31.271, 70.466), 56.249, 25.0, {}, "question")

    Targeting.Zones:AddBox("casino-cashier", "credit-card", vector3(990.35, 31.18, 71.47), 5.4, 2, {
        heading = 330,
        --debugPoly=true,
        minZ = 70.47,
        maxZ = 73.27
    }, {
        {
            icon = "inbox",
            text = "Cash Out Chips",
            event = "Casino:Client:StartChipSell",
            isEnabled = function()
                return Casino.Chips:Get() > 0
            end
        },
        {
            icon = "inbox",
            text = "Purchase Chips",
            event = "Casino:Client:StartChipPurchase",
        },
        {
            icon = "address-card",
            text = "Purchase VIP Card ($10,000, 1 Week)",
            event = "Casino:Client:PurchaseVIP",
        },
    }, 3.0, true)
end)

AddEventHandler("Polyzone:Enter", function(id, testedPoint, insideZones, data)
	if id == 'casino_inside' then
        _insideCasino = true
        TriggerEvent("Casino:Client:Enter")
    elseif id == 'casino_audio' then
        _insideCasinoAudio = true
        StartCasinoBackgroundAudioThread()
    end
end)

AddEventHandler("Polyzone:Exit", function(id, testedPoint, insideZones, data)
	if id == 'casino_inside' then
        _insideCasino = false
        TriggerEvent("Casino:Client:Exit")
    elseif id == 'casino_audio' then
        _insideCasinoAudio = false
        StopCasinoBackgroundAudio()
    end
end)

AddEventHandler("Casino:Client:ClockIn", function(_, data)
	if data and data.job then
		Jobs.Duty:On(data.job)
	end
end)

AddEventHandler("Casino:Client:ClockOut", function(_, data)
	if data and data.job then
		Jobs.Duty:Off(data.job)
	end
end)

AddEventHandler("Casino:Client:OpenClose", function(_, data)
    Callbacks:ServerCallback("Casino:OpenClose", data)
end)

AddEventHandler("Casino:Client:PurchaseVIP", function(_, data)
    Callbacks:ServerCallback("Casino:PurchaseVIP", data)
end)

RegisterNetEvent("Casino:Client:RefreshInt", function()
    RefreshInterior(121090)
end)