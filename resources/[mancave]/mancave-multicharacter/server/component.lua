AddEventHandler('Characters:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
	Middleware = exports['mancave-core']:FetchComponent('Middleware')
	Database = exports['mancave-core']:FetchComponent('Database')
	Callbacks = exports['mancave-core']:FetchComponent('Callbacks')
	DataStore = exports['mancave-core']:FetchComponent('DataStore')
	Logger = exports['mancave-core']:FetchComponent('Logger')
	Database = exports['mancave-core']:FetchComponent('Database')
	Fetch = exports['mancave-core']:FetchComponent('Fetch')
	Logger = exports['mancave-core']:FetchComponent('Logger')
	Chat = exports['mancave-core']:FetchComponent('Chat')
	GlobalConfig = exports['mancave-core']:FetchComponent('Config')
	Routing = exports['mancave-core']:FetchComponent('Routing')
	Sequence = exports['mancave-core']:FetchComponent('Sequence')
	Reputation = exports['mancave-core']:FetchComponent('Reputation')
	Apartment = exports['mancave-core']:FetchComponent('Apartment')
	RegisterCommands()
	_spawnFuncs = {}
end

AddEventHandler('Core:Shared:Ready', function()
	exports['mancave-core']:RequestDependencies('Characters', {
		'Callbacks',
		'Database',
		'Middleware',
		'DataStore',
		'Logger',
		'Database',
		'Fetch',
		'Logger',
		'Chat',
		'Config',
		'Routing',
		'Sequence',
		'Reputation',
		'Apartment',
	}, function(error)
		if #error > 0 then return end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()
		RegisterCallbacks()
		RegisterMiddleware()
		Startup()
	end)
end)