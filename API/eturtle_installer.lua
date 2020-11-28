--[[v0.0.8
self-referencial pastebin here: rPpJjEFx
Installs the necessary components for eturtle in one package
Currently contains:
startup.lua (V0.0.2) [If not already installed]

eturtle.lua (V0.3.16)
json.lua --stored constantly at 4nRg9CHU (hopefully)
eturtle_startup.lua (V0.0.7)
--]]

if not fs.exists("api") then fs.makeDir("api") end
if not fs.exists("startdir") then fs.makeDir("startdir") end
if not fs.exists("startup") then shell.run("pastebin get 7EtT3zBn startup.lua") end
if not fs.exists("api/eturtle.lua") then
	shell.run("pastebin get 5emHRrcV eturtle.lua")
	shell.run("move eturtle.lua api/")
end
if not fs.exists("api/json.lua") then
	shell.run("pastebin get 4nRg9CHU json.lua")
	shell.run("move json.lua api/")
end
if not fs.exists("startdir/eturtle_startup.lua") then
	shell.run("pastebin get mNVUrxpn eturtle_startup.lua")
	shell.run("move eturtle_startup.lua startdir/")
end

print("Installed and rebooting")
os.sleep(3)
os.reboot()