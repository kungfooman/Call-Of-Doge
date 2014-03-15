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
	local success, result = xpcall(evalfile, errorhandler, filename)
	
	--Com_Printf(string.format("success=%s filename=%s\n", success, filename))
	if not success then
		print("[ERROR]\n",result,"[/ERROR]\n")
	end
end

function include_noerror(filename)
	local success, result = xpcall(evalfile, errorhandler, filename)
	--Com_Printf(string.format("success=%s filename=%s\n", success, filename))
end

function main()
	include("CallOfDuty\\lua\\logic.lua")
end

main()