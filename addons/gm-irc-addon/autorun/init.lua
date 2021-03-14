if SERVER then 
	GM_IRC = {}
	include( "sv_config.lua" )

	util.AddNetworkString( "GM_netcfg" )
	net.Start( "GM_netcfg" )
		net.WriteTable( GM_IRC )
	net.Broadcast()

	include( "gm-irc/sv_msgGet.lua" )
	include( "gm-irc/sv_msgSend.lua" )

	AddCSLuaFile( "gm-irc/cl_msgRecive.lua" )
	AddCSLuaFile( "sh_config.lua" )

	print( "------------------\n" )
	print( "GM-IRC LOADED!\n" )
	print( "------------------" )
end

if CLIENT then 
	GM_IRC = {}
	net.Receive("GM_netcfg", function () GM_IRC = net.ReadTable() end)

	include( "gm-irc/cl_msgRecive.lua" )
end