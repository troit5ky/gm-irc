util.AddNetworkString("SendMsg")

function poll()
	http.Fetch(
		GM_IRC.WebserverAdress .. '/getmsghistory',
		function(body, size, headers, code)
			local msgtble = util.JSONToTable(tostring(body))

			for i= 1, table.getn(msgtble) do 
				if msgtble[i].author != "BOT" then 

					if msgtble[i].timestamp+GM_IRC.GetmsgsDelay > os.time() then
						if IsValid( msgtble[i].isPrinted ) or !msgtble[i].isPrinted then
							print(GM_IRC.ChatPrefix .. " " .. msgtble[i].author .. ": " .. msgtble[i].content)

							net.Start("SendMsg")
							msgtble[i].pref = GM_IRC.ChatPrefix .. " "
							net.WriteTable(msgtble[i])
							net.Broadcast()

							msgtble[i].isPrinted = true
						end
					end
				end
			end

		end,
			
		function( err )
			print( err )
		end
	)
end
	
timer.Create("discordhttptimer", GM_IRC.GetmsgsDelay, 0, poll)