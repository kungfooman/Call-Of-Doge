function usermessageHud(msg)
	id = ffi.C.MSG_ReadLong(msg)
	x = ffi.C.MSG_ReadLong(msg)
	y = ffi.C.MSG_ReadLong(msg)
	if not isDefined(huds[id]) then
		huds[id] = {}
	end
	huds[id].x = x
	huds[id].y = y
	print(string.format("Hud x=%d y=%d Usermessage HUD!", x, y))
end

usermessage_Hook = {
	hud = usermessageHud
}

huds = {}

function newHud(id, x, y)
	DataToClient("hud", function(msg)
			ffi.C.MSG_WriteLong(msg, id)
			ffi.C.MSG_WriteLong(msg, x)
			ffi.C.MSG_WriteLong(msg, y)
		end
	)
end

function Con_DrawNotify()
	--Com_Printf("Con_DrawNotify\n");
	ffi.C.SCR_DrawBigString(20, 20, "Hello From Luaaaaaaaaaaa!", 0.5, 1)
	ffi.C.SCR_DrawNamedPic(140, 140, 20,20, "console")
	
	ffi.C.SCR_FillRect(40, 40, 20,20, ffi.new("float[4]", {1,0,0,0.5}))
	
	for k,v in ipairs(huds) do
		hud = v
		ffi.C.SCR_FillRect(hud.x, hud.y, 20, 20, ffi.new("float[4]", {1,0,0,0.5}))
	end
end