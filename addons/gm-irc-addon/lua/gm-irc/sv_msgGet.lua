util.AddNetworkString("SendMsg")

local printed = {}

function poll()
	http.Fetch(
		GM_IRC.WebserverAdress .. '/getmsghistory',
		function(body, size, headers, code)
			local msgtble = util.JSONToTable(tostring(body))
			
			if body == "null" then print("[relay] DISCORD API ERROR")  return end

			--msgtble = table.Reverse(msgtble)

			for i, msg in ipairs(msgtble) do
				if not msg.isbot then
					if ( os.time() > msg.timestamp+GM_IRC.GetmsgsDelay+30 ) then return end
					if ( printed[msg.content] ) then return end
					
					print(GM_IRC.ChatPrefix .. " " .. msg.author .. ": " .. msg.content)

					net.Start("SendMsg")
					msg.pref = GM_IRC.ChatPrefix .. " "
					net.WriteTable(msg)
					net.Broadcast()

					if ( table.getn(printed) ) >= 10 then table.remove(printed, 1) end
					printed[msg.content] = true
				end
			end
		end,
			
		function( err )
			print( "FAILED GET: " .. err )
		end
	)
end
	
timer.Create("discordhttptimer", GM_IRC.GetmsgsDelay, 0, poll)
