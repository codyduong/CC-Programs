--[[v0.0.2
Runs lua files in directory named "startdir" available at
the root of files. Typically will be installed by
eturtle_installer, or another installer, if not
already present.
--]]

if not fs.exists("startdir") then
	fs.makeDir("startdir")
end
local list = fs.list("startdir")
for x, i in pairs(list) do
	shell.run("startdir/"..i)
end