-- todo: save for each client individually which usermessage-id's are transmitted
usermessage_id_to_name = {}
client_usermessage_id_to_name = {}
usercommands_1 = {}
usercommands_2 = {}

function DataToClient(name, callback)
	Usermessage(name)
	Msg(name, callback)
end

function Usermessage(name)
	if isDefined(usermessage_id_to_name[name]) then
		--print("Usermessage is already transmitted!\n");
		return
	end
	usermessage_id_to_name[name] = count(usermessage_id_to_name)
	id = usermessage_id_to_name[name]
	--print(string.format("Cmd=%s ID=%d\n", name, id))
	
	table.insert(
		usercommands_1,
		function(msg)
			ffi.C.MSG_WriteByte(msg, ffi.C.svc_usermessage_1 )
			ffi.C.MSG_WriteLong(msg, id)
			ffi.C.MSG_WriteString(msg, name)
		end
	)
end

function Msg(name, callback)
	id = usermessage_id_to_name[name]
	if not isDefined(id) then
		--print(string.format("Usermessage Unknown ID for name=%s is not transmitted!\n", name))
		return
	end

	table.insert(
		usercommands_2,
		function(msg)
			ffi.C.MSG_WriteByte(msg, ffi.C.svc_usermessage_2 )
			ffi.C.MSG_WriteLong(msg, id)
			callback(msg)
		end
	)
end

function SV_SendUserMessagesToClient(client, msg)
	msg = ffi.cast("msg_t *", msg);
	
	for k,v in pairs(usercommands_1) do v(msg) end usercommands_1 = {}
	for k,v in pairs(usercommands_2) do v(msg) end usercommands_2 = {}
end

function CL_ParseUsermessage_1(msg)
	msg = ffi.cast("msg_t *", msg);
	usermessage_id = ffi.C.MSG_ReadLong(msg);
	usermessage_name = ffi.C.MSG_ReadString(msg);
	client_usermessage_id_to_name[usermessage_id] = ffi.string(usermessage_name)
	--print(string.format("usermessage[%d] = %s\n", usermessage_id, ffi.string(usermessage_name)))
end

function CL_ParseUsermessage_2(msg)
	msg = ffi.cast("msg_t *", msg)
	usermessage_id = ffi.C.MSG_ReadLong(msg)
	cmdname = client_usermessage_id_to_name[usermessage_id]
	if isDefined(cmdname) then
		print(string.format("Got message for: cmdname=%s id=%d\n", cmdname, usermessage_id))
		
		if isDefined(usermessage_Hook[cmdname]) then
			usermessage_Hook[cmdname](msg)
		else
			print("No hook found for ", cmdname, "\n")
		end
	else
		--print(string.format("Got message for: id=%d", usermessage_id))
	end
end
function CL_ParseUsermessage_3(msg) end
function CL_ParseUsermessage_4(msg) end
function CL_ParseUsermessage_5(msg) end