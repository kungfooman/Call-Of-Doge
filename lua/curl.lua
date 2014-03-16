url = [[http://static02.mediaite.com/geekosystem/uploads/2013/12/doge.jpg]]

ffi.cdef [[
	int curl_version();
	void *curl_easy_init();
	int curl_easy_setopt(void *curl, char option, ...);
	int curl_easy_perform(void *curl);
	void curl_easy_cleanup(void *curl);
]]

function cb(ptr, size, nmemb, stream)
		print("Data callback!\n") -- not even called once
        local bytes = size*nmemb
        local buf = ffi.new('char[?]', bytes+1)
        ffi.copy(buf, ptr, bytes)
        buf[bytes] = 0
        data = ffi.string(buf)
        return bytes
end

fptr = ffi.cast("size_t (*)(char *, size_t, size_t, void *)", cb)

data = ""

CURLOPT_URL = 10002
CURLOPT_WRITEFUNCTION = 20011
CURLOPT_VERBOSE = 41
libcurl = ffi.load("libcurl-4.dll")

print("cURL Version: ", libcurl.curl_version(), "\n")

curl = libcurl.curl_easy_init()

if curl then
	print("Trying to download: ", url, "\n")
	libcurl.curl_easy_setopt(curl, CURLOPT_VERBOSE, 1)
	--libcurl.curl_easy_setopt(curl, CURLOPT_URL, ffi.cast("char *", url)) -- or this? both doesn't work
	libcurl.curl_easy_setopt(curl, CURLOPT_URL, url)
	libcurl.curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, fptr)

	print("Result: ", libcurl.curl_easy_perform(curl), "\n")
	libcurl.curl_easy_cleanup(curl)
end