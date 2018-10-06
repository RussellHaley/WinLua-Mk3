local project_name = 'winlua'
BINARY_OR_TEXT_COMMAND_LINE = 'text'
ospath = require 'ospath'
filefind = require 'filefind'
local BIN = '../Deploy/x86/WinLua/'
local so_ext = '.dll'
local static_ext = '.lib'

local function call7Zip()
	
end

local function initLibreSSL()
	local bash = "C:\\msys64\\usr\\bin\\bash"
	 --~ C:\msys64\usr\bin\bash -lc "cd git/WinLua-Mk3/Sources/libressl && ./autogen.sh"
	--~ //chdir to libressl
	--~ check for dir build-vs2017
	--~ if not dir then mkdir 
	--~ chdir build-vs2017
	--~ cmake -DBUILD_SHARED_LIBS=ON -G"Visual Studio 15 2017" ..
	--~ run vs-shell.ps1 --> Will need ot include msbuild libressl to preserve environment
end

local function copyLibreSSL(dest)
--~ "C:\\Users\\russh\\git\\WinLua-Mk3\\Sources\\libressl\\build-vs2017\\apps\\openssl\\Debug\\openssl.exe"
--~ "C:\Users\russh\git\WinLua-Mk3\Sources\libressl\build-vs2017\crypto\Debug\crypto-44.dll"
--~ "C:\Users\russh\git\WinLua-Mk3\Sources\libressl\build-vs2017\ssl\Debug\ssl-46.dll"
--~ "C:\Users\russh\git\WinLua-Mk3\Sources\libressl\build-vs2017\tls\Debug\tls-18.dll"
--~ copy openssl.exe, crypto.dll, tls.dll, ssl.dll...?
end

local function buildLibreSSL(dest)
	initLibreSSL()
	copyLibreSSL()
end

local function downloadLuaRocks(uri,dest)

end

local function copyLuaRocks(dest)

end

local function genHppFile(var_name, filename, src_file)
	local hpp = io.open(filename, 'w')
	hpp:write(string.format('char * %s =  R"V0G0N(\r\n', var_name))
	local file = io.open(src_file, "r")

	for l in file:lines() do
		hpp:write(l..'\n')
	end
	file:close()
	hpp:write(')V0G0N";')
	hpp:close()
	print('hpp file written.')
end


local function makeVersion(version)
    if not version then 
        return nil,'Need a version number' 
    end
    
    local so = string.format('lua%s', version:gsub('%.',''))
    if so:len() > 5 then
		so = so:sub(1,5)
	end
	local so_full = string.format('lua%s%s', version:gsub('%.',''), so_ext)
    local path = string.format('lua-%s/src',version)
    local lua_build = {
        version = version,
        --~ sourcepath = path,
        source_path = jam_expand('@(' .. path .. ':T)')[1],
        so_target = so..'-shared',
        static_target = so..'-static',
        shared_object = so,
        static_object = so,
        shared_object_full = so_full,
        outpath = BIN..version:sub(1,3)
    }
    return lua_build
end

local function buildLFS(build)

	local target_name = 'lfs-'..build.shared_object
	local path = 'luafilesystem/src'
	--~ local lfs_path = jam_expand('@(' .. path .. ':T)')[1]
	--~ jam['C.Defines']( nil, '_WINDLL')
	--~ _CRT_SECURE_NO_WARNINGS;_WINDLL;
	jam['C.ActiveTarget'](target_name)
	jam['C.OutputPath'](nil, build.outpath)
	jam['C.OutputName'](nil, 'lfs')
	jam['C.IncludeDirectories'] (nil, build.source_path)
	jam['C.LinkLibraries']( nil, build.so_target)
	jam['C.Library'](nil, {path..'/*@=**.c@=**.h'}, 'shared')
	jam['Depends']('all', target_name)
end

local function buildLua(version_table)
	for i,v in pairs(version_table) do
		local build = makeVersion(v)
		--Target for intermediary files
		jam['C.ActiveTarget'](build.so_target)
		jam['C.OutputPath']( nil, build.outpath)
		jam['C.OutputName']( nil, build.shared_object)
		jam['C.Defines']( nil, 'LUA_BUILD_AS_DLL')
		jam['C.IncludeDirectories']( nil, build.source_path)
		jam['C.Library']( nil, {build.source_path..'/*@=**.c@=**.h'}, 'shared')
		
		--Static Library: Target for intermediary files
		jam['C.ActiveTarget']( build.static_target)
		jam['C.OutputPath']( nil, build.outpath..'/static')
		jam['C.OutputName']( nil, build.static_object)
		jam['C.IncludeDirectories']( nil, build.source_path)
		jam['C.Library']( nil, {build.source_path..'/*@=**.c@=**.h'}, 'static')
		jam['Depends']('all', build.static_target)
		--Target for Shared Object
		jam['C.ActiveTarget']( build.shared_object)
		jam['C.OutputPath'](nil,  build.outpath)
		--Why no target for the executable?
			jam['Depends']('all', build.so_target)
		buildLFS(build)
	end
end

local function buildWinLua()
	local hpp = "src\\getopt-lua.hpp"
	local getopt = "getopt.lua"
	genHppFile('get_opts', hpp, getopt)

	--~ hard coded for now. pretend this was returned from buildLua
	link_libs = {'lua53-shared'}
	buildLua({'5.1.5','5.2.4','5.3.5','5.4'})
	jam['C.ActiveTarget']( project_name)
	jam['C.OutputPath'](nil, BIN)
	jam['C.OutputName'](nil, project_name)
	jam['C.IncludeDirectories'](nil, {'lua-5.3.5/src','src/'})
	--~ jam['C.LinkLibraries'](nil, 'lua54 lua53 lua52 lua51')
	jam['C.LinkLibraries'](nil, link_libs)
	jam['C.Application'](nil, 'src/dtlua.cpp')
	jam['Depends']('all', project_name)
end


buildWinLua()
buildLibreSSL()
copyLuaRocks()
--~ buildInstaller()
