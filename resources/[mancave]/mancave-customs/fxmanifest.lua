fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'
client_script "@mancave-core/components/cl_error.lua"
client_script "@mythic-pwnzor/client/check.lua"

client_scripts {
    'config/**/*.lua',
    'client/**/*.lua'
}