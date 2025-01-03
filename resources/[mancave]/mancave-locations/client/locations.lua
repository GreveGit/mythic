local _logoutLocations = {
    {
        center = vector3(-435.59, -305.86, 35.0),
        length = 1.8,
        width = 2.2,
        options = {
            heading = 22,
            --debugPoly=true,
            minZ = 34.0,
            maxZ = 36.8
        },
    },
    {
        center = vector3(477.96, -981.89, 30.69),
        length = 5.0,
        width = 3.6,
        options = {
            heading = 0,
            --debugPoly=true,
            minZ = 29.69,
            maxZ = 32.09
        },
    },
    {
        center = vector3(1849.23, 3691.41, 29.82),
        length = 2.0,
        width = 2.0,
        options = {
            heading = 30,
            --debugPoly=true,
            minZ = 28.82,
            maxZ = 31.22
        },
    },
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['mancave-core']:RegisterComponent('Locations', LOCATIONS)
end)

AddEventHandler('Locations:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['mancave-core']:FetchComponent('Callbacks')
    Locations = exports['mancave-core']:FetchComponent('Locations')
    Targeting = exports['mancave-core']:FetchComponent('Targeting')
    Characters = exports['mancave-core']:FetchComponent('Characters')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['mancave-core']:RequestDependencies('Locations', {
        'Callbacks',
        'Locations',
        'Targeting',
        'Characters',
    }, function(error)
        if #error > 0 then
            return;
        end
        RetrieveComponents()

        for k, v in ipairs(_logoutLocations) do
            Targeting.Zones:AddBox("logout-location-" .. k, "person-walking-dashed-line-arrow-right", v.center, v.length, v.width, v.options, {
                {
                    icon = "person-walking-dashed-line-arrow-right",
                    text = "Logout",
                    event = "Locations:Client:LogoutLocation",
                },
            }, 2.0, true)
        end
    end)
end)

LOCATIONS = {
    GetAll = function(self, type, cb)
        Callbacks:ServerCallback('Locations:GetAll', {
            type = type
        }, cb)
    end
}

AddEventHandler('Locations:Client:LogoutLocation', function()
    Characters:Logout()
end)

AddEventHandler("Characters:Client:Spawn", function()
	CreateThread(function()
		while LocalPlayer.state.loggedIn do
			Wait(20000)

            if not LocalPlayer.state?.tpLocation then
                local coords = GetEntityCoords(PlayerPedId())

                if coords and #(coords - vector3(0.0, 0.0, 0.0)) >= 10.0 then
                    TriggerServerEvent('Characters:Server:LastLocation', coords)
                end
            end
        end
	end)
end)
