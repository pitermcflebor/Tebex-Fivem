fx_version 'cerulean'
game 'gta5'

author 		'PiterMcFlebor'
description 'Tebex Payments handler for FiveM Community'
version 	'1.0'

--tebexSecret '' -- uncomment this line if you aren't using the 'sv_tebexSecret' at server.cfg file

server_only 'yes'
server_scripts {
    'sha256.lua',
    'web_service.lua'
}