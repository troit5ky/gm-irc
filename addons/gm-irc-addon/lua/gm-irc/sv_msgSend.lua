require("chttp")

local tempAvatars = tempAvatars or {}

local function onFailure(message)
	print("-------------\nSEND failure\n-------------\n"..message)	
end

function sendMsgToDiscord( body )
	CHTTP( { failed = onFailure, succes = nil, method = "POST", url = GM_IRC.WebhookAdress, body = body, type = "application/json" } )
end

local function sendPost(sender, text)
	if tempAvatars[ sender:SteamID() ] then 
		local json = {
			["username"] = sender:Nick(),
			["content"] = text,
			["avatar_url"] = tempAvatars[ sender:SteamID() ]
		}

		json = util.TableToJSON(json)
		sendMsgToDiscord( json )
		return
	end

	http.Fetch(
		"http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=" .. GM_IRC.SteamapiKey .. "&steamids=" .. sender:SteamID64(), 
		
		function ( body, length, headers, code  )
		local user = util.JSONToTable(body)
		if ( user == nil ) then
			print("-------------\nSTEAM API failure\n-------------\n" .. body)
		else 
			tempAvatars[ sender:SteamID() ] = user.response.players[1].avatarfull
			print("[gm-irc]", sender, "avatar cached!")
		end

		local json = {
			["username"] = sender:Nick(),
			["content"] = text,
			["avatar_url"] = tempAvatars[ sender:SteamID() ] or nil
		}

		json = util.TableToJSON(json)
		sendMsgToDiscord( json )
	end, 
	
		function ( message )
			print("-------------\nSteam API failed!\n-------------\n".."-------------\n"..message.."\n-------------")
			local json = util.TableToJSON( { username = sender:GetName(), content = text } )
			sendMsgToDiscord( json )
		end, 
	{})

	return
end

local function playerSpawnForTheFirstTime(ply, transit)
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

local function playerDisconnected(ply)
	--Удаляем авы их кэша
	if IsValid( ply:SteamID() ) then 
		if tempAvatars[ ply:SteamID() ] then 
			table.RemoveByValue(tempAvatars, ply:SteamID())
			print("[gm-irc]", sender, "avatar uncached!")
		end
	end

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

local function playersCount()
	local count = #player.GetAll()

	if (count != 0) then

		local embed = {
			title = "Игроков на сервере " .. tostring(count),
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