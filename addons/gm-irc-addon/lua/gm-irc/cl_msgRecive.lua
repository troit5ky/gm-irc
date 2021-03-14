function ReciveChat(  )
	local msgtble = net.ReadTable()
	chat.AddText( Color(114, 137, 218), msgtble.pref, Color( 255, 255, 255 ), msgtble.author .. ": " .. msgtble.content )
end

net.Receive("SendMsg", ReciveChat)