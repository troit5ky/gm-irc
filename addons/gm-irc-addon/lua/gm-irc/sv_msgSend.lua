require("chttp")

function onSucces(body, size, headers, code) end

function onFailure(message)
	print("-------------\nSEND failure\n-------------\n"..message)	
end

function sendMsgToDiscord( body )
	CHTTP( { failed = onFailure, succes = onSucces, method = "POST", url = GM_IRC.WebhookAdress, body = body, type = "application/json" } )
end

function sendPost(sender, text)
	http.Fetch("http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key="..GM_IRC.SteamapiKey.."&steamids="..sender:SteamID64(), 
		function ( body, length, headers, code  )
		local user = util.JSONToTable(body)
		local json = util.TableToJSON( { username = sender:GetName(), content = text, avatar_url = user.response.players[1].avatarfull } )
		sendMsgToDiscord( json )
	end, function ( message )
		print("-------------\nSteam API failed!\n-------------\n".."-------------\n"..message.."\n-------------")
		local json = util.TableToJSON( { username = sender:GetName(), content = text } )
		sendMsgToDiscord( json )
	end, { } )
	
	return
end

function playerSpawnForTheFirstTime(ply, transit)
	local embed = {
		title = "Игрок " .. ply:GetName() .." (".. ply:SteamID() .. ") подключился к серверу",
		color = 4915018
	}

	local json = util.TableToJSON ({
			username = GM_IRC.Username,
			embeds = {embed}
		})
	
	sendMsgToDiscord( json )
end

function playerConnect(ply, ip)
	local embed = {
		title = "Игрок " .. ply .. " инициировал подключение",
		color = 16763979
	}

	local json = util.TableToJSON ({
			username = GM_IRC.Username,
			embeds = {embed}
		})
	
	sendMsgToDiscord( json )
end

function playerDisconnected(ply)
	local embed = {
		title = "Игрок " .. ply.name .." (".. ply.networkid .. ") отключился от сервера (" .. ply.reason .. ")",
		color = 16730698
	}

	local json = util.TableToJSON ({
			username = GM_IRC.Username,
			embeds = {embed}
		})
	sendMsgToDiscord( json )
end

function playersCount()
	if (#player.GetAll() != 0) then

		local embed = {
			title = "Игроков на сервере: " .. tostring(#player.GetAll()),
			color = GM_IRC.PlayersCountColor
		}

		local json = util.TableToJSON ({
			username = GM_IRC.Username,
			embeds = { embed }
		})
		
		sendMsgToDiscord( json )
	end
end

hook.Add("PlayerConnect", "irc_onplayerconnect", playerConnect)
hook.Add("PlayerInitialSpawn", "irc_onplayerinitspawn", playerSpawnForTheFirstTime)
hook.Add( "PlayerSay", "irc_onplayersay", sendPost)
gameevent.Listen( "player_disconnect" )
hook.Add("player_disconnect", "irc_ondisconnect", playerDisconnected)
if GM_IRC.SendPlayersCount then timer.Create("irc_players_count", GM_IRC.PlayersCountDelay, 0, playersCount) end