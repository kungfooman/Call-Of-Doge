ffi.cdef [[
	int curl_version();
	void *curl_easy_init();
	int curl_easy_setopt(void *curl, int option, ...);
	int curl_easy_perform(void *curl);
	void curl_easy_cleanup(void *curl);
	int curl_easy_getinfo(void *curl, int info, ...);
]]

function curl_callback(ptr, size, nmemb, userdata)
	-- print("Data callback! File-ID: ", userdata, "\n")
	local file = ffi.cast("fileHandle_t", userdata)
	return ffi.C.FS_Write(ptr, size*nmemb, file)
end

ffi_curl_callback = ffi.cast("size_t (*)(char *ptr, size_t size, size_t nmemb, void *userdata)", curl_callback)

CURLOPT_URL = 10002
CURLOPT_WRITEFUNCTION = 20011
CURLOPT_VERBOSE = 41
CURLOPT_PROGRESSDATA = 10057
CURLOPT_NOPROGRESS = 43
CURLOPT_WRITEDATA = 10001
CURLE_OK = 0

CURLINFO_RESPONSE_CODE = 2097154
CURLINFO_CONTENT_TYPE = 1048594

libcurl = ffi.load("libcurl-4.dll")

-- print("cURL Version: ", libcurl.curl_version(), "\n")