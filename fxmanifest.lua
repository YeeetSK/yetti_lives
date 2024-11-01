fx_version "cerulean"
game "gta5"
lua54 'yes'

author 'Yetti Development'
description 'Limit players life(s)'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

files {
    'locales/*.json'
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}