--[[v0.0.12
self-referencial pastebin here: rPpJjEFx
Installs the necessary components for eturtle in one package
also planned to update files if necessary
Currently contains:
startup.lua (V0.0.2) [If not already installed]

eturtle.lua (V0.3.19)
eturtle_startup.lua (V0.0.7)
--params
arg1 = boolean stating whether to update (optional parameter)

EX: 
eturtle.installer true --> will replace old files with new ones
eturtle.installer --> will only install files that are missing
--]]
local arg1, extra = ...

if not fs.exists("api") then fs.makeDir("api") end
if not fs.exists("startdir") then fs.makeDir("startdir") end
if not arg1 then --If not asking for a reinstall, do a clean install: does not overwrite any files.
	if not fs.exists("startup.lua") then shell.run("pastebin get 7EtT3zBn startup.lua") end
	if not fs.exists("api/eturtle.lua") then
		shell.run("pastebin get 5emHRrcV eturtle.lua")
		shell.run("move eturtle.lua api/")
	end
	if not fs.exists("startdir/eturtle_startup.lua") then
		shell.run("pastebin get mNVUrxpn eturtle_startup.lua")
		shell.run("move eturtle_startup.lua startdir/")
	end
	print("Installed and rebooting")
	os.sleep(3) --just so the user can read the prompt
	os.reboot()
else 
	if fs.exists("startup.lua") then 
		fs.delete("startup.lua")
	end
	if fs.exists("api/eturtle.lua") then
		fs.delete("api/eturtle.lua")
	end
	if fs.exists("startdir/eturtle_startup.lua") then
		fs.delete("startdir/eturtle_startup.lua")
	end
	shell.run("pastebin get 7EtT3zBn startup.lua") 
	shell.run("pastebin get 5emHRrcV eturtle.lua")
	shell.run("move eturtle.lua api/")
	shell.run("pastebin get mNVUrxpn eturtle_startup.lua")
	shell.run("move eturtle_startup.lua startdir/")
	print("Updated and rebooting")
	os.sleep(3) --just so the user can read the prompt
	os.reboot()
end

