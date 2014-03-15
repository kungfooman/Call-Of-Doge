function loadLibs()
	ffi = require "ffi"

	include_noerror("lua\\header_scr.lua")
	include_noerror("lua\\header_MSG.lua")
	include_noerror("lua\\header_cvar.lua")
	include("lua\\php.lua")
	include("lua\\codscript.lua")
	include("lua\\usermessage.lua")
	include("lua\\client_console.lua")
end

function evalfile(filename, env)
	local f = assert(loadfile(filename))
	return f()
end

function eval(text)
	local f = assert(load(text))
	return f()
end

function errorhandler(err)
	return debug.traceback(err)
end

function include(filename)
	local filename = Cvar_VariableString("fs_game") .. "\\" .. filename
	local success, result = xpcall(evalfile, errorhandler, filename)

	--Com_Printf(string.format("success=%s filename=%s\n", success, filename))
	if not success then
		print("[ERROR]\n",result,"[/ERROR]\n")
	end
	return result
end

function include_noerror(filename)
	local filename = Cvar_VariableString("fs_game") .. "\\" .. filename
	local success, result = xpcall(evalfile, errorhandler, filename)
	--Com_Printf(string.format("success=%s filename=%s\n", success, filename))
end

function refresh()
	include("CallOfDuty\\lua\\main.lua")
end

function main()
	loadLibs()
	include("lua\\logic.lua")
end

main()