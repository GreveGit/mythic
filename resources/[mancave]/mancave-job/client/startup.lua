AddEventHandler('Jobs:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['mancave-core']:FetchComponent('Callbacks')
    Logger = exports['mancave-core']:FetchComponent('Logger')
    Utils = exports['mancave-core']:FetchComponent('Utils')
    Notification = exports['mancave-core']:FetchComponent('Notification')
    Jobs = exports['mancave-core']:FetchComponent('Jobs')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['mancave-core']:RequestDependencies('Jobs', {
        'Callbacks',
        'Logger',
        'Utils',
        'Notification',
        'Jobs',
    }, function(error)
        if #error > 0 then return; end
        RetrieveComponents()
    end)
end)