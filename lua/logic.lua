ffi = require "ffi"

include_noerror("CallOfDuty\\lua\\header_scr.lua")
include_noerror("CallOfDuty\\lua\\header_MSG.lua")
include("CallOfDuty\\lua\\php.lua")
include("CallOfDuty\\lua\\codscript.lua")
include("CallOfDuty\\lua\\usermessage.lua")
include("CallOfDuty\\lua\\client_console.lua")

print("=== Init Lua For Call of Duty ===\n")

function refresh()
	dofile("CallOfDuty\\main.lua")
end

function Cbuf_AddText(text)
	-- print("[Lua] Cbuf_AddText: " .. text)
	-- args = explode(" ", text)
	-- for i=0,#args-1

	if string.sub(text, 1,1) == "=" then
		toEval = "return { " .. string.sub(text, 2) .. " }"
		-- print("toEval", toEval)
		local success, result = xpcall(eval, errorhandler, toEval)
		if success then
			-- scope the local result keys (if any) of the query into global scope
			-- example: a=123, turns into: return {a=123}, which jails a into the table, so we get it out
			local isAssignment = false
			for i in pairs(result) do
				if type(i) == "string" then -- only put string-keys into global scope
					-- print("put into global: ", type(i), "value", result[i])
					_G[i] = result[i]
					isAssignment = true -- now unpack() wont print the string-keys anymore
				end
			end

			if isAssignment then
				for i in pairs(result) do
					print(result[i])
				end
			elseif result[1] ~= nil then
				-- if no assignment, save the result in "ret", for use in next line
				_G["ret"] = result
				print(unpack(result))
			else
				--print("[no ret]\n")
			end
			print "\n"
		else
			print("[ERROR]",result,"[/ERROR]")
		end
		
		return 1 -- processed
	end
	
	return 0 -- not processed
end

function ClientCommand(clientNum, args)
	print("clientNum: "..clientNum.." Args: ", #args)
	for i = 1,#args do
		print("Arg",i,args[i])
	end
	
	if args[1] == "mr" then
		
	end
	
	if args[1] == "lua" then
		merge = ""
		for i = 2,#args do
			merge = merge .. args[i] .. " "
		end
		-- print("Eval: " .. merge)

		local success, result = xpcall(eval, errorhandler, merge)
		if not success then
			print("[ERROR]",result,"[/ERROR]")
		end
		--eval(merge)
	end
end

function disableHeartbeatMessage() -- spams so much!
	msg = ffi.cast("char *", 0x0814BA20) -- COD2_1_2
	ffi.fill(msg, 1, 0) -- 1 char, '\0'==0, end of string in C
end

function disableSnapshotMessage()
	-- itsmehlol: (writing snapshot) Snapshot delta request from out of date packet.
	-- itsmehlol: (writing snapshot) Snapshot delta request from out of date packet.
	-- itsmehlol: (writing snapshot) Snapshot delta request from out of date packet.
	msg = ffi.cast("char *", 0x0814BF20) -- COD2_1_2
	ffi.fill(msg, 1, 0) -- 1 char, '\0'==0, end of string in C
end


function Com_Printf_all(...)
	local args = {...}
	--Com_Printf(string.format("Args: %d ", #args))
	for index,value in ipairs(args) do
	
		if type(value) == "string" then
			Com_Printf(value)
		else
			--Com_Printf("no string!\t");
			vardump(value)
		end
	end
end

function main()
	disableHeartbeatMessage()
	
	
	print = Com_Printf_all
end

main()

-- string.format("%.8x",ffi_int(gents))
function ffi_int(ptr)
	return tonumber(ffi.cast("int", ptr))
end

function gent(id)
	addr = 0x08679380 + 560 * id
	print(string.format("gent[%d]=%.8x", id, addr))
	return ffi.cast("int *", addr)
end

function openmenu(id)
	ent = gent(id)
	dunno = ffi.cast("int *", ent[86] + 9924)
	
	print("dunno: " .. dunno)
	
	if dunno[0] == 2 then
		
	end
	
	return ffi.cast("int *", ent2)
end

function r()
	-- redo last lua line
end




function closer()
	print "Closer!"

	print(string.format("%.8p", ffi.C.stackGetString_8084AE6(0)))
end

-- =getmenuid("callvote")
-- 4
-- otherwise full error on developer=1
function getmenuid(name)
	return ffi.C.getmenuid_81132EE(ffi.cast("char *", name))
end

function Com_Frame(argument)
	--print("arg: " .. argument)
	--return "ret from Com_Frame"
	--print(".")
end