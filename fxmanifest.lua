fx_version 'cerulean'
game 'gta5'

author 'Sloppy Designs'
description 'Simple Stash System [FREE RELEASE]'
version '1.0.1'

shared_scripts {
    -- '@es_extended/imports.lua', -- Uncomment For ESX
    'config.lua',
}

client_scripts {
    'client/sd-menu.lua',
    'client/main.lua'
}
server_script 'server/main.lua'

lua54 'yes'