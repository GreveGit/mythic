FLAGGED_PLATES = {}

AddEventHandler('Radar:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Database = exports['mancave-core']:FetchComponent('Database')
    Callbacks = exports['mancave-core']:FetchComponent('Callbacks')
    Logger = exports['mancave-core']:FetchComponent('Logger')
    Utils = exports['mancave-core']:FetchComponent('Utils')
    Chat = exports['mancave-core']:FetchComponent('Chat')
    Jobs = exports['mancave-core']:FetchComponent('Jobs')
    Fetch = exports['mancave-core']:FetchComponent('Fetch')
    Radar = exports['mancave-core']:FetchComponent('Radar')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['mancave-core']:RequestDependencies('Radar', {
        'Database',
        'Callbacks',
        'Logger',
        'Utils',
        'Chat',
        'Jobs',
        'Fetch',
        'Radar',
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
        RegisterChatCommands()
    end)
end)

CreateThread(function()
    GlobalState.RadarFlaggedPlates = {}
end)

function RegisterChatCommands()
    Chat:RegisterCommand('flagplate', function(src, args, raw)
        local plate = args[1]
        local reason = args[2]
    
        if plate then
            Radar:AddFlaggedPlate(plate:upper(), reason)
        end
    end, {
        help = 'Flag a Plate',
        params = {
            { name = 'Plate', help = 'The Plate to Flag' },
            { name = 'Reason', help = 'Reason Why the Plate is Flagged' },
        },
    }, 2, {
        { Id = 'police', Level = 1 }
    })

    Chat:RegisterCommand('unflagplate', function(src, args, raw)
        local plate = args[1]
        local reason = args[2]
    
        if plate and reason then
            Radar:RemoveFlaggedPlate(plate)
        end
    end, {
        help = 'Unflag a Plate',
        params = {
            { name = 'Plate', help = 'The Plate to Unflag' },
        },
    }, 1, {
        { Id = 'police', Level = 1 }
    })

    Chat:RegisterCommand('radar', function(src)
        TriggerClientEvent('Radar:Client:ToggleRadarDisabled', src)
    end, {
        help = 'Toggle Radar'
    }, 0, {
        { Id = 'police', Level = 1 }
    })
end

RADAR = {
    AddFlaggedPlate = function(self, plate, reason)
        if not reason then reason = 'No Reason Specified' end

        Logger:Trace('Radar', string.format('New Flagged Plate: %s, Reason: %s', plate, reason))
        FLAGGED_PLATES[plate] = reason

        GlobalState.RadarFlaggedPlates = FLAGGED_PLATES
    end,
    RemoveFlaggedPlate = function(self, plate)
        Logger:Trace('Radar', string.format('Plate Unflagged: %s', plate))
        FLAGGED_PLATES[plate] = nil

        GlobalState.RadarFlaggedPlates = FLAGGED_PLATES
    end,
    ClearFlaggedPlates = function(self)
        Logger:Trace('Radar', 'All Plates Unflagged')
        FLAGGED_PLATES = {}

        GlobalState.RadarFlaggedPlates = FLAGGED_PLATES
    end,
    GetFlaggedPlates = function(self)
        return FLAGGED_PLATES
    end,
    CheckPlate = function(self, plate)
        return FLAGGED_PLATES[plate]
    end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['mancave-core']:RegisterComponent('Radar', RADAR)
end)

RegisterNetEvent('Radar:Server:StolenVehicle', function(plate)
    if type(plate) == "string" then
        Radar:AddFlaggedPlate(plate, 'Vehicle Reported Stolen')
    end
end)