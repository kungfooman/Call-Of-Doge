function isDefined(value)
	return type(value) ~= "nil"
end

function getCvar(name)
	return ffi.string(ffi.C.Cvar_VariableString(name))
end