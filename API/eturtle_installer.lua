--[[v0.0.2
self-referencial pastebin here: rPpJjEFx
Installs the necessary components for eturtle in one package
Currently contains:
startup.lua (V0.0.1) [If not already installed]
eturtle.lua (V0.3.11)
eturtle_startup.lua (V0.0.1)
json.lua
--]]

if not fs.exists("api") then fs.makeDir("api") end
if not fs.exists("startdir") then fs.makeDir("startdir") end
if not fs.exists("startup") then shell.run("pastebin get 7EtT3zBn startup.lua") end
if not fs.exists("api/eturtle.lua") then
	shell.run("pastebin get 5emHRrcV eturtle.lua")
	fs.move("eturtle.lua", "api")
end
if not fs.exists("api/json.lua") then
shell.run("pastebin get mNVUrxpn eturtle_startup.lua")
fs.move("json.lua", "api")
end
if not fs.exists("startdir/json.lua") then
shell.run("pastebin get 4nRg9CHU json.lua")
fs.move("eturtle_startup.lua", "startdir")
end

print("Installed and rebooting")
os.sleep(1)
os.reboot()