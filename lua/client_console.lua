function usermessageHud(msg)
	id = ffi.C.MSG_ReadLong(msg)
	x = ffi.C.MSG_ReadLong(msg)
	y = ffi.C.MSG_ReadLong(msg)
	width = ffi.C.MSG_ReadLong(msg)
	height = ffi.C.MSG_ReadLong(msg)
	alpha = ffi.C.MSG_ReadFloat(msg)
	str = ffi.string(ffi.C.MSG_ReadString(msg))
	if not isDefined(huds[id]) then
		huds[id] = {}
	end
	huds[id].x = x
	huds[id].y = y
	huds[id].width = width
	huds[id].height = height
	huds[id].alpha = alpha
	huds[id].str = str
	--print(string.format("Hud x=%d y=%d Usermessage HUD!\n", x, y))
end

usermessage_Hook = {
	hud = usermessageHud
}

huds = {}

function newHud(id, x, y, width, height, alpha, str)
	DataToClient("hud", function(msg)
			ffi.C.MSG_WriteLong(msg, id)
			ffi.C.MSG_WriteLong(msg, x)
			ffi.C.MSG_WriteLong(msg, y)
			ffi.C.MSG_WriteLong(msg, width)
			ffi.C.MSG_WriteLong(msg, height)
			ffi.C.MSG_WriteFloat(msg, alpha)
			ffi.C.MSG_WriteString(msg, str)
		end
	)
end

-- this function is not called when console is open
function Con_DrawNotify()
	--Com_Printf("Con_DrawNotify\n");
	ffi.C.SCR_DrawBigString(20, 20, "Hello From Luaaaaaaaaaaa!", 0.5, 1)
	ffi.C.SCR_DrawNamedPic(140, 140, 20,20, "console")
	
	ffi.C.SCR_FillRect(40, 40, 20,20, ffi.new("float[4]", {1,0,0,0.5}))
end

-- even draw when console is open, but is below console
function SCR_DrawScreenField(clc_state)
	for k,v in ipairs(huds) do
		hud = v
		ffi.C.SCR_FillRect(hud.x, hud.y, hud.width, hud.height, ffi.new("float[4]", {1,0,0,hud.alpha}))
		if hud.str ~= "" then
			ffi.C.SCR_DrawBigString(hud.x, hud.y, hud.str, hud.alpha, 1)
		end
	end
end