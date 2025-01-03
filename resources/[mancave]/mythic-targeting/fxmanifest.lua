fx_version 'cerulean'
game 'gta5'
lua54 'yes'
version '1.0.1'

client_script "@mancave-core/components/cl_error.lua"
client_script "@mancave-lib/client/check.lua"

client_scripts {
    '@mancave-polyboundaries/client.lua',
    '@mancave-polyboundaries/BoxZone.lua',
    '@mancave-polyboundaries/EntityZone.lua',
    '@mancave-polyboundaries/CircleZone.lua',
    '@mancave-polyboundaries/ComboZone.lua',

    'client/*.lua',
    'client/targets/*.lua',
}