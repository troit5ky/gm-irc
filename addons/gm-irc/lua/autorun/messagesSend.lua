if SERVER then
	local discordwebhook = "DSICORD-WEBHOOK-URL"
	local apiKey = "STEAMAPI-KEY"

	require("chttp")

	function onSucces(body, size, headers, code)
			
		end

		function onFailure(message)
			
		end

	function sendMsgToDiscord( body )
		CHTTP( { failed = onFailure, succes = onSucces, method = "POST", url = webhook, body = body, type = "application/json" } )
	end

	function sendPost(sender, text)
		http.Fetch("http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key="..apiKey.."&steamids="..sender:SteamID64(), 
			function ( body, length, headers, code  )
			print("-------------\nGET successed\n-------------\n".."-------------\n"..code.."\n-------------")
			local user = util.JSONToTable(body)
			local json = util.TableToJSON( { username = sender:GetName(), content = text, avatar_url = user.response.players[1].avatarfull } )
			sendMsgToDiscord( json )
		end, function ( message )
			print("-------------\nGET failed\n-------------\n".."-------------\n"..message.."\n-------------")
			local json = util.TableToJSON( { username = sender:GetName(), content = text } )
			sendMsgToDiscord( json )
		end, { } )
		
		return text
	end

	function playerSpawnForTheFirstTime(ply, transit)
		local embed = {
			title = "Игрок " .. ply:GetName() .." (".. ply:SteamID() .. ") подключился к серверу",
			color = 4915018
		}

		local json = util.TableToJSON ({
				username = "Сервер",
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
				username = "Сервер",
				embeds = {embed}
			})
		sendMsgToDiscord( json )
	end

	hook.Add("PlayerInitialSpawn", "playerspawnedtobot", playerSpawnForTheFirstTime)
	hook.Add( "PlayerSay", "gg", sendPost)
	gameevent.Listen( "player_disconnect" )
	hook.Add("player_disconnect", "ondisconnect", playerDisconnected)
end