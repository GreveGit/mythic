fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'
client_script "@mancave-core/components/cl_error.lua"
client_script "@mancave-lib/client/check.lua"

client_scripts {
    'shared/**/*.lua',
    'client/**/*.lua'
}

server_scripts {
    'shared/**/*.lua',
    'server/**/*.lua',
}