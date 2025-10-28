fx_version 'cerulean'
game 'gta5'

author 'Crown Scripts'
description 'Crown Job Creator'
version '1.0.0'

name 'crownjobcreator'

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua'
}

server_scripts {
    'server/discord.lua',
    'server/main.lua'
}

client_scripts {
    'client/main.lua'
}

ui_page 'ui/build/index.html'

files {
    'ui/build/**/*'
}

dependencies {
    'es_extended',
    'ox_lib'
}

lua54 'yes'
