util.AddNetworkString("SendMsg")

local printed = {}

function poll()
	http.Fetch(
		GM_IRC.WebserverAdress .. '/getmsghistory',
		function(body, size, headers, code)
			local msgtble = util.JSONToTable(tostring(body))

			for i, msg in ipairs(msgtble) do
				if ( msg.author != "BOT" ) then 
					if (os.time()-10 < msg.timestamp+GM_IRC.GetmsgsDelay+30) then
						for i,k in ipairs(printed) do
							if ( msg.content == k.content ) then return end
						end
						print(GM_IRC.ChatPrefix .. " " .. msg.author .. ": " .. msg.content)

						net.Start("SendMsg")
						msg.pref = GM_IRC.ChatPrefix .. " "
						net.WriteTable(msg)
						net.Broadcast()

						if ( table.getn(printed) ) == 10 then table.remove(printed, 1) end
						table.insert(printed, msg)
					end
				end
			end

		end,
			
		function( err )
			print( "FAILED GET: " .. err )
		end
	)
end
	
timer.Create("discordhttptimer", GM_IRC.GetmsgsDelay, 0, poll)