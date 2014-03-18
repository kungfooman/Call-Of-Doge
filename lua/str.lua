
function stripURL(url)
	len = string.len(url)
	i = 8; -- skip http://
	pure = "";
	while i <= len do
		ascii = string.byte(url, i)
		c = string.char(ascii)
		if ascii >= 48 and ascii <=  57 then pure = pure .. c   end -- 0 to 9
		if ascii >= 65 and ascii <=  90 then pure = pure .. c   end -- A to Z
		if ascii >= 97 and ascii <= 122 then pure = pure .. c   end -- a to z
		if ascii == 46  or ascii ==  47 then pure = pure .. "_" end -- . and / to _
		i = i + 1
	end
	return pure
end
