fx_version 'cerulean'
lua54 'yes'
game 'gta5'
client_script "@mancave-core/components/cl_error.lua"
client_script "@mancave-lib/client/check.lua"

files {
	'defaultsettings.dat',
	'visualsettings.dat',
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
}
