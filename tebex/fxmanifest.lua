fx_version 'cerulean'
game 'gta5'

description 'Tebex.io API for FiveM'
discord     'https://discord.gg/hPvJ9vsnxw' -- Tebex Discord

server_only 'yes'

server_scripts {
    'lib/requests.lua',
    'lib/tebex.lua',
    'server/misc.lua',
}

--[[
Import to other scripts:

server_script '@tebex/lib/tebex.lua'

]]
