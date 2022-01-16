util.AddNetworkString("SendMsg")

local printed = printed or {}

function poll()
	http.Fetch(GM_IRC.WebserverAdress .. '/getmsghistory',

	function(body, size, headers, code)
		local msgtble = util.JSONToTable(tostring(body))

		if body == "null" then print("[relay]", "DISCORD API ERROR")  return end

		msgtble = table.Reverse(msgtble)

		for _, msg in ipairs(msgtble) do
			if not msg.isbot and os.time() < msg.timestamp+GM_IRC.GetmsgsDelay+10 and not printed[msg.content] then
				print(GM_IRC.ChatPrefix .. " " .. msg.author .. ": " .. msg.content)

				net.Start("SendMsg")
				msg.pref = GM_IRC.ChatPrefix .. " "
				net.WriteTable(msg)
				net.Broadcast()

				printed[msg.content] = true
				timer.Simple(GM_IRC.GetmsgsDelay+10, function () 
					printed[msg.content] = nil
				end)
			end
		end
	end,
			
	function( err )
		print( "FAILED GET: " .. err )
	end)
end
	
timer.Create("discordhttptimer", GM_IRC.GetmsgsDelay, 0, poll)
