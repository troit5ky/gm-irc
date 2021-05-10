GM_IRC = {}

if SERVER then 
	include( "sv_config.lua" )

	include( "gm-irc/sv_msgGet.lua" )
	include( "gm-irc/sv_msgSend.lua" )

	AddCSLuaFile( "gm-irc/cl_msgRecive.lua" )

	print( "------------------\n" )
	print( "GM-IRC LOADED!\n" )
	print( "------------------" )

	hook.Add("Initialize", "irc_serverstarted", function () 
		local embed = {
			title = "Сервер запущен!",
			description = "Можешь смело подключаться :)",
			color = GM_IRC.PlayersCountColor
		}

		local json = util.TableToJSON ({
			username = GM_IRC.Username,
			embeds = { embed }
		})
		
		sendMsgToDiscord( json )
	end)
end

if CLIENT then 
	include( "gm-irc/cl_msgRecive.lua" )
end