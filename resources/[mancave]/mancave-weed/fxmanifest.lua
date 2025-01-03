fx_version 'cerulean'
client_script "@mancave-core/components/cl_error.lua"
client_script "@mancave-lib/client/check.lua"

game 'gta5'
lua54 'yes'

client_scripts {
    'config/cl_*.lua',
    'client/**/*.lua',
}

shared_scripts {
    'config/sh_*.lua',
}

server_scripts {
    'config/sv_*.lua',
    'server/**/*.lua',
}