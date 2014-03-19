url = [[http://static02.mediaite.com/geekosystem/uploads/2013/12/doge.jpg]]

function downloadFile(url, customFolder)
	if not isDefined(customFolder) then customFolder = "downloads" end
	
	local curl = libcurl.curl_easy_init()

	if not curl then return nil end
	
	-- strangely FS_SV_FOpenFileWrite doesn't writes into file, though it creates the file
	local filename = customFolder .. "/" .. stripURL(url)
	local file = ffi.C.FS_FOpenFileWrite(filename)

	libcurl.curl_easy_setopt(curl, CURLOPT_VERBOSE, ffi.new("int", 1))
	libcurl.curl_easy_setopt(curl, CURLOPT_URL, url)
	libcurl.curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, ffi_curl_callback)
	--libcurl.curl_easy_setopt(curl, CURLOPT_NOPROGRESS, 1)
	--libcurl.curl_easy_setopt(curl, CURLOPT_PROGRESSDATA, 123)
	libcurl.curl_easy_setopt(curl, CURLOPT_WRITEDATA, ffi.cast("void *", file))
	
	if libcurl.curl_easy_perform(curl) ~= CURLE_OK then
		print("Error! Result: ", result, "\n")
		ffi.C.FS_FCloseFile(file)
		libcurl.curl_easy_cleanup(curl)
		return nil;
	end
	
	ffi_response_code = ffi.new("int[1]")
	ffi_content_type = ffi.new("char*[1]")
	libcurl.curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, ffi_response_code)
	libcurl.curl_easy_getinfo(curl, CURLINFO_CONTENT_TYPE, ffi_content_type)
	response_code = tonumber(ffi_response_code[0])
	content_type = ffi.string(ffi_content_type[0])
	--print("RESPONSE CODE: '", response_code, "'\n")
	--print("CONTENT TYPE::::'", content_type, "'\n")

	ffi.C.FS_FCloseFile(file)
	libcurl.curl_easy_cleanup(curl)

	local filename_new = filename
	if content_type == "image/jpeg" then filename_new = filename_new .. ".jpg" end
	
	ffi.C.FS_HomeRemove(filename_new) -- delete in case it exists
	ffi.C.FS_Rename(filename, filename_new)
	
	return filename_new
end