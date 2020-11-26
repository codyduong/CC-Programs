--[[V0.1.0
A program which scrapes the surface of the world, 16x16 area at a time,
digs 3 blocks deeper than the deepest layer of the dirt, intented to collect
various surface ores
--]]

os.loadAPI(api/echest.lua) --directory to the echest API, change as needed (default api/echest.lua)
os.loadAPI(api/eturtle.lua) --directory to the cturt API, change as needed (default api/cturt.lua)

local cTCX, cTCY, Q = ...
if not cTCX or not cTCY or not Q then error("surfacescraper ecode:0") end

