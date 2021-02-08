GM_IRC = {}

if SERVER then 
	include( "sh_config.lua" )

	include( "gm-irc/sv_msgGet.lua" )
	include( "gm-irc/sv_msgSend.lua" )

	AddCSLuaFile( "gm-irc/cl_msgRecive.lua" )
	AddCSLuaFile( "sh_config.lua" )

	print( "------------------\n" )
	print( "GM-IRC LOADED!\n" )
	print( "------------------" )
end

if CLIENT then 
	include( "sh_config.lua" )
	include( "gm-irc/cl_msgRecive.lua" )
end