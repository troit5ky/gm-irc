function ReciveChat(  )
	local msgtble = net.ReadTable()
	chat.AddText( Color(114, 137, 218), GM_IRC.ChatPrefix .. " ", Color( 255, 255, 255 ), msgtble.author .. ": " .. msgtble.content )
end


net.Receive("SendMsg", ReciveChat)
