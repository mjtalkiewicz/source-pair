#!/usr/bin/env lua
--[[
MIT License
Copyright (C) 2017 Micah Talkiewicz.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

function main()
	assert(#arg) -- We need at least one file name argument

	local header_text = load_header_text(".project_standard_header")

	for k = 1, #arg do
		local name = arg[k]
		write_header_file(name, header_text)
		write_source_file(name, header_text)
	end

end

function load_header_text(path)
	local year = os.date("%Y", os.time())
	local f = assert(io.open(path, "r")) -- Project Header File
	local header_text = f:read("a")
	f:close()

	return string.gsub(header_text, "<REPLACE_WITH_YEAR>", year)
end

function write_header_file(name, text)
	local f = assert(io.open(name .. ".h", "w")) -- C header file
	local include_name = name:upper() .. "_H"

	f:write(text)

	f:write("\n#ifndef " .. include_name)
	f:write("\n#define " .. include_name)
	f:write("\n\n\n")
	f:write("\n#endif")

	f:write("\n")
	f:flush()
	f:close()
end

function write_source_file(name, text)
	local f = assert(io.open(name .. ".c", "w")) -- C header file
	local include_name = name .. ".h"

	f:write(text)
	f:write("\n#include \"" .. include_name .. "\"")
	f:write("\n#include <assert.h>") -- Good programers know

	f:write("\n\n\n")
	f:flush()
	f:close()
end

main()
