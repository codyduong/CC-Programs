--[[V0.0.1
Installs the necessary components for eturtle in one package
Currently contains:
startup.lua (V0.0.1) [If not already installed]
eturtle.lua (V0.3.11)
eturtle_startup.lua (V0.0.1)
--]]

if not fs.exists("api") then
	fs.makeDir("api")
end
if not fs.exists("startdir") then
	fs.makeDir("startdir")
end
if not fs.exists("startup") then
	--install startup
end
pastebin get --CODE eturtle.lua
fs.move("eturtle.lua", "api")
pastebin get --CODE eturtle_startup.lua
fs.move("eturtle_startup.lua", "startdir")
print("Installed and rebooting")
os.sleep(1)
os.reboot()