fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'
client_script "@mancave-core/components/cl_error.lua"
client_script "@mancave-lib/client/check.lua"

loadscreen 'ui/html/index.html'

loadscreen_manual_shutdown 'yes'

files {
    "ui/html/*.*",
}