VEHICLE_INSIDE = nil
LOCAL_CACHED_EVIDENCE = {}

_ammoNames = {
    AMMO_STUNGUN = 'Stungun Ammo',
    AMMO_PISTOL = 'Pistol Ammo',
    AMMO_SMG = 'SMG Ammo',
    AMMO_RIFLE = 'Rifle Ammo',
    AMMO_SHOTGUN = 'Shotgun Ammo',
    AMMO_SNIPER = 'Sniper Ammo',
    AMMO_FLARE = 'Flare Ammo',
    AMMO_MG = 'Machine Gun Ammo',
}

AddEventHandler('Evidence:Shared:DependencyUpdate', RetrieveComponents)
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
end

AddEventHandler('Core:Shared:Ready', function()
    exports['mancave-core']:RequestDependencies('Evidence', {
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
    }, function(error)
        if #error > 0 then return; end
        RetrieveComponents()

        Polyzone.Create:Box('evidence_ballistics_mrpd', vector3(483.41, -993.34, 30.69), 1.6, 2.4, {
            heading = 359,
            minZ = 29.69,
            maxZ = 31.89
        }, {
            ballistics = true,
        })

        Polyzone.Create:Box('evidence_dna_mrpd', vector3(486.98, -993.51, 30.69), 1.0, 1.2, {
            heading = 0,
            minZ = 29.69,
            maxZ = 32.09
        }, {
            dna = true,
        })

        Polyzone.Create:Box('evidence_ballistics_dpd', vector3(369.46, -1590.37, 25.45), 1.2, 1.6, {
            heading = 359,
            minZ = 24.45,
            maxZ = 27.25
        }, {
            ballistics = true,
        })

        Polyzone.Create:Box('evidence_dna_dpd', vector3(367.9, -1592.18, 25.45), 1.2, 1.6, {
            heading = 0,
            minZ = 24.45,
            maxZ = 27.25
        }, {
            dna = true,
        })

        Polyzone.Create:Box('evidence_ballistics_lmpd', vector3(849.52, -1311.05, 28.24), 1.8, 2, {
            heading = 0,
            --debugPoly=true,
            minZ = 27.24,
            maxZ = 29.84
        }, {
            ballistics = true,
        })

        Polyzone.Create:Box('evidence_dna_lmpd', vector3(853.45, -1292.58, 28.24), 1.8, 1, {
            heading = 0,
            --debugPoly=true,
            minZ = 27.24,
            maxZ = 29.64
        }, {
            dna = true,
        })

        Polyzone.Create:Box('evidence_dna_mt_zona_1', vector3(-444.11, -296.49, 34.91), 3.6, 1.6, {
            heading = 290,
            --debugPoly=true,
            minZ = 33.91,
            maxZ = 36.11
        }, {
            dna = true,
        })

        Polyzone.Create:Box('evidence_dna_mt_zona_2', vector3(-442.69, -299.56, 34.91), 3.6, 1.6, {
            heading = 290,
            --debugPoly=true,
            minZ = 33.91,
            maxZ = 36.11
        }, {
            dna = true,
        })
    end)
end)

AddEventHandler('Vehicles:Client:EnterVehicle', function(veh)
	VEHICLE_INSIDE = veh
end)

AddEventHandler("Vehicles:Client:ExitVehicle", function()
	VEHICLE_INSIDE = nil
end)

local pendingEvidenceUpdate = false

function UpdateCachedEvidence()
    if not pendingEvidenceUpdate then
        pendingEvidenceUpdate = true
        SetTimeout(5000, function()
            pendingEvidenceUpdate = false
            SendCachedEvidence()
        end)
    end
end

function SendCachedEvidence()
    TriggerServerEvent('Evidence:Server:RecieveEvidence', LOCAL_CACHED_EVIDENCE)
    LOCAL_CACHED_EVIDENCE = {}
end