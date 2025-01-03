EDITING_VEHICLE = nil

AddEventHandler('Fitment:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Logger = exports['mancave-core']:FetchComponent('Logger')
    Fetch = exports['mancave-core']:FetchComponent('Fetch')
    Callbacks = exports['mancave-core']:FetchComponent('Callbacks')
    Game = exports['mancave-core']:FetchComponent('Game')
    Targeting = exports['mancave-core']:FetchComponent('Targeting')
    Utils = exports['mancave-core']:FetchComponent('Utils')
    Animations = exports['mancave-core']:FetchComponent('Animations')
    Notification = exports['mancave-core']:FetchComponent('Notification')
    Polyzone = exports['mancave-core']:FetchComponent('Polyzone')
    Jobs = exports['mancave-core']:FetchComponent('Jobs')
    Weapons = exports['mancave-core']:FetchComponent('Weapons')
    Progress = exports['mancave-core']:FetchComponent('Progress')
    Vehicles = exports['mancave-core']:FetchComponent('Vehicles')
    Targeting = exports['mancave-core']:FetchComponent('Targeting')
    ListMenu = exports['mancave-core']:FetchComponent('ListMenu')
    Action = exports['mancave-core']:FetchComponent('Action')
    Sounds = exports['mancave-core']:FetchComponent('Sounds')
    Menu = exports['mancave-core']:FetchComponent('Menu')
    Interaction = exports['mancave-core']:FetchComponent('Interaction')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['mancave-core']:RequestDependencies('Fitment', {
        'Logger',
        'Fetch',
        'Callbacks',
        'Game',
        'Menu',
        'Targeting',
        'Notification',
        'Utils',
        'Animations',
        'Polyzone',
        'Jobs',
        'Weapons',
        'Progress',
        'Vehicles',
        'Targeting',
        'ListMenu',
        'Action',
        'Sounds',
        'Menu',
        'Interaction',
    }, function(error)
        if #error > 0 then return; end
        RetrieveComponents()

        Interaction:RegisterMenu("veh_wheels", "Wheel Fitment", "truck-monster", function()
            OpenWheelMenu()
            Interaction:Hide()
        end, function()
            local pedCoords = GetEntityCoords(LocalPlayer.state.ped)

            local insideZone = Polyzone:IsCoordsInZone(pedCoords, false, 'veh_customs_wheels')
            if insideZone?.veh_customs_wheels and LocalPlayer.state.onDuty and insideZone.veh_customs_wheels == LocalPlayer.state.onDuty then
                return true
            end
            return false
        end)
    end)
end)

local fitmentVehicles = {}

RegisterNetEvent('Characters:Client:Spawn')
AddEventHandler('Characters:Client:Spawn', function()
    StartFitmentThread()
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    RunVehicleCleanup()
end)

RegisterNetEvent('Fitment:Client:Update', function(netId, data)
    if LocalPlayer.state.loggedIn then
        if fitmentVehicles[netId] and fitmentVehicles[netId].veh then
            if data then
                fitmentVehicles[netId] = {
                    veh = fitmentVehicles[netId].veh,
                    data = data,
                }

                if v ~= EDITING_VEHICLE then
                    SetVehicleWheelWidth(v, data.width + 0.0)
                end
            else
                fitmentVehicles[netId] = nil
            end
        end
    end
end)

function RunVehicleCleanup()
    for k, v in pairs(fitmentVehicles) do
        if not v?.veh or not DoesEntityExist(v?.veh) then
            fitmentVehicles[k] = nil
        end
    end
end

function RunFitmentDataUpdate()
    local vPool = GetGamePool('CVehicle')
    for k, v in ipairs(vPool) do
        if NetworkGetEntityIsNetworked(v) then
            local fitmentData = Entity(v)?.state?.WheelFitment
            if fitmentData then
                fitmentVehicles[VehToNet(v)] = {
                    veh = v,
                    data = fitmentData,
                }

                if fitmentData.width and v ~= EDITING_VEHICLE then
                    SetVehicleWheelWidth(v, fitmentData.width + 0.0)
                end
            end
        end
    end
end

function StartFitmentThread()
    CreateThread(function()
        local tick = 0
        while LocalPlayer.state.loggedIn do
            RunFitmentDataUpdate()
            Wait(5000)

            if tick >= 5 then
                tick = 0
                RunVehicleCleanup()
            else
                tick = tick + 1
            end
        end
    end)

    CreateThread(function()
        while LocalPlayer.state.loggedIn do
            Wait(1)
            for k, v in pairs(fitmentVehicles) do
                if v?.veh and v.veh ~= EDITING_VEHICLE and DoesEntityExist(v.veh) then
                    SetVehicleFrontTrackWidth(v.veh, v?.data?.frontTrack)
                    SetVehicleRearTrackWidth(v.veh, v?.data?.rearTrack)
                end
            end
        end
    end)
end