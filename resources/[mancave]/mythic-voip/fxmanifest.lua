game 'gta5'
fx_version 'cerulean'
client_script "@mancave-core/components/cl_error.lua"
client_script "@mancave-lib/client/check.lua"

lua54 'yes'

client_scripts {
    'shared/**/*.lua',
    'client/**/*.lua',
}

server_scripts {
    'shared/**/*.lua',
    'server/**/*.lua',
}