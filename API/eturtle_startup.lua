--[[v0.0.7
A startup for turtle initialization.
Put the following code in the startup.lua:
local eturtlestartup = multishell.launch({}, "startup/eturtlestartup")
--]]

et = require("/api/eturtle")
local t = et:new()

function askForPosition()
	print('Input space-seperated position of the turtle (x y z)')
	local s = read()
	fs = {}
	for substring in s:gmatch("%S+") do
	   table.insert(fs, substring)
	end
	local x, y, z = fs[1], fs[2], fs[3]
	if x and y and z then
		t:_setPosition(x, y, z)
	else print("invalid position")
		return askForPosition()
	end
end

function askForDirection()
	local accepted = {["north"]=true,["east"]=true,["south"]=true,["west"]=true}
	print('Input direction turtle is facing ("north", "east", "south", "west")')
	local s = read()
	if accepted[s] then
		t:_setDirection(s)
	else print("invalid direction")
		return askForDirection()
	end
end

if not fs.exists("/turtle") then
	local x, y, z = gps.locate(5)
	if x and y and z then
		v = vector.new(x, y, z)
		t:_setPosition(v)
	else
		askForPosition()
	end
	askForDirection()
	t:writeToFile("/turtle")
end
