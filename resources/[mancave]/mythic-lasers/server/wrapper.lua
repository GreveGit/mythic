AddEventHandler('Lasers:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports['mancave-core']:FetchComponent('Callbacks')
	Chat = exports['mancave-core']:FetchComponent('Chat')
end

AddEventHandler('Core:Shared:Ready', function()
	exports['mancave-core']:RequestDependencies('Lasers', {
        'Callbacks',
		'Chat',
	}, function(error)
		if #error > 0 then return; end
		RetrieveComponents()

        Chat:RegisterAdminCommand("lasers", function(source, args, rawCommand)
            if args[1] == "start" then
                Callbacks:ClientCallback(source, "Lasers:Create:Start")
            elseif args[1] == "end" then
                Callbacks:ClientCallback(source, "Lasers:Create:End")
            elseif args[1] == "save" then
                Callbacks:ClientCallback(source, "Lasers:Create:Save")
            else
                Chat.Send.System:Single(source, "Invalid action")
            end
        end, {
            help = "Create Lasers",
            params = {
                {
                    name = "Action",
                    help = "Action to perform (start, end, save)",
                },
            }
        }, 1)
	end)
end)
