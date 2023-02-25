fx_version "adamant"
games { "rdr3" }
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
author 'RicX'
dependency 'doc_modelt'
lua54 'yes'

files {
    'not.js',
}

client_scripts {
    'client.lua',
    'not.js',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua', --delete this line if you are using VORP, FOR QBR: '@oxmysql/lib/MySQL.lua', FOR REDEMRP: '@mysql-async/lib/MySQL.lua' | FOR REDEMRP-REBOOT: '@oxmysql/lib/MySQL.lua',
    'server.lua',
}

shared_scripts {
    'config.lua',
}

export 'GetRedMCar' 