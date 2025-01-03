AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['mancave-core']:RegisterComponent('Pwnzor', PWNZOR)
end)

PWNZOR = PWNZOR or {}