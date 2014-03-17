function print(...)
	args = {...}
	for k,v in ipairs(args) do
		Com_Printf(v)
	end
end

function getCvar(name)
	return trap_Cvar_VariableStringBuffer(name)
end


print("=== Init Lua For GAME ===\n")
print("fs_game: ", getCvar("fs_game"), "\n")