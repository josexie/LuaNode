-- Modified by Ignacio Burgue�o to just return the compiled code
-- No longer does what the description says

local description = [=[
Usage: lua bin2c.lua [+]filename [status]

Write a C source file to standard output.  When this C source file is
included in another C source file, it has the effect of loading and
running the specified file at that point in the program.

The file named by 'filename' contains either Lua byte code or Lua source.
Its contents are used to generate the C output.  If + is used, then the
contents of 'filename' are first compiled before being used to generate
the C output.  If given, 'status' names a C variable used to store the
return value of either luaL_loadbuffer() or lua_pcall().  Otherwise,
the return values of these functions will be unavailable.

This program is (overly) careful to generate output identical to the
output generated by bin2c5.1 from LuaBinaries.

http://lua-users.org/wiki/BinTwoCee

Original author: Mark Edgar
Licensed under the same terms as Lua (MIT license).
]=]

if not arg or not arg[1] then
  io.stderr:write(description)
  return
end

local compile, filename = arg[1]:match"^(+?)(.*)"
local status = arg[2]

local content = compile=="+"
  and string.dump(assert(loadfile(filename)))
  or assert(io.open(filename,"rb")):read"*a"


local dump do
  local numtab={}; for i=0,255 do numtab[string.char(i)]=("%3d,"):format(i) end
  function dump(str)
    return (str:gsub(".", numtab):gsub(("."):rep(80), "%0\n"))
  end
end

io.write(dump(content))
