--[[v0.3.16
an API which stands for enhanced turtle, just creates more sophisticated methods
--]]
os.loadAPI("api/json.lua")

--[[
Creation of a eturtle object, which passes itself as a param for some programs
Especially utilized for rednet passing, and network management of turtles
--]]
Eturtle = {}
function Eturtle:new()
	local o = {}
	setmetatable(o, self)
	self.__index = self
	self.position = vector.new(0,0,0) --x (+east, -west); y (+up, -down); z (+south, -north)
	self.direction = "north" --"north", "east", "south", "west"
	self.fuelLevel = turtle.getFuelLevel()
	self.fuelLimit = turtle.getFuelLimit()
	self.contents = {} --{turtle.getItemDetail(1), turtle.getItemDetail(2), turtle.getItemDetail(3)...turtle.getItemDetail(16)}
	for i=1, 16 do
		self.contents[i] = turtle.getItemDetail(i)
	end
	self.status = "" --just a string which is passed to the network, use this to set a status of a turtle (ie. mining, moving, etc)
	return o
end

--[[
todo documentation
-params
v = Vector.new(x,y,z)
--]]
function Eturtle:_setPosition(v)
	self.position = v
end


--[[
Sets the direction of the Eturtle class to s
NOTE: INTERNAL USE mostly
If you are trying to turn the turtle to the north, east, etc
use Eturtle:turnToAbsolute() instead.
--params
s = string
--]]
function Eturtle:_setDirection(s)
	local accepted = {["north"] = true, ["east"] = true, ["south"] = true, ["west"] = true}
	if accepted[s] then self.direction = s 
	else error("Eturtle:setDirection param passed fail") end
end


--[[
increments the direction of the turtle (i=1, north->east; i=-1, north->west), 
NOTE: mostly internal use, to dictate a direction of the turtle. Use Eturtle:turnTo(s) instead,
unless you really know what you're doing
SO IT DOES NOT TURN THE TURTLE
--params
i = int, + indicates clockwise on compass, - counterclockwise
--]]
function Eturtle:_incrementDirection(i) 
	j = i%4
	if self.direction == "north" then
		if j==1 then
			self:_setDirection("east")
		elseif j==2 then
			self:_setDirection("south")
		elseif j==3 then
			self:_setDirection("west")
		end
	elseif self.direction == "east" then
		if j==1 then
			self:_setDirection("south")
		elseif j==2 then
			self:_setDirection("west")
		elseif j==3 then
			self:_setDirection("north")
		end
	elseif self.direction == "south" then
		if j==1 then
			self:_setDirection("west")
		elseif j==2 then
			self:_setDirection("north")
		elseif j==3 then
			self:_setDirection("east")
		end
	elseif self.direction == "west" then
		if j==1 then
			self:_setDirection("north")
		elseif j==2 then
			self:_setDirection("east")
		elseif j==3 then
			self:_setDirection("south")
		end
	else
		error("Eturtle direction is nil")
	end
end


--[[
Used for turtle initialization for any values which cannot already be determined.
IE. set the turtles position/direction here,
otherwise it will use relative positioning.
(north = whichever way the turtle was facing, and not the actual world north)
(0,0,0 = where the turtle started, and not the actual world 0,0,0)
Recommended you use GPS for determining pos, orientation is set manually
--]]
function Eturtle:init(v, s)
	self:_setPosition(v)
	self:_setDirection(s)
end


--[[
A better way to turn turtles.
USE THIS FUNCTION OVER turtle.turnLeft() or turtle.turnRight()
if you want to transmit the Eturtles info accurately.
--params
s1 = a string indicating where to turn to ("left", "right", "back") are the only accepted params
--]]
function Eturtle:turnTo(s)
	local na = {["front"] = true, ["forward"] = true, ["top"] = true, ["bottom"] = true, ["up"] = true, ["down"] = true}
	if s == "left" then
		if turtle.turnLeft() then 
			self:_incrementDirection(-1)
		else
			error("eturtle turnTo ecode:0") 
		end
	elseif s == "back" then
		if turtle.turnLeft() then 
			turtle.turnLeft() 
			self:_incrementDirection(-2)
		elseif turtle.turnRight() then 
			turtle.turnRight() 
			self:_incrementDirection(2)
		else
			error("eturtle turnTo ecode:1") 
		end
	elseif s == "right" then
		if turtle.turnRight() then 
			self:_incrementDirection(1)
		else
			error("eturtle turnTo ecode:2")
		end
	--[[Errors keep getting thrown, idk why so I just removed it. It works now, just don't put anything funny in the params
	TODO fix, maybe... If I ever decide I need error throwing. But I don't... You might...
	elseif na[s] then
		print("bypass")
	elseif not na[s] then
		error("eturtle turnTo ecode:3")
	--]]
	end
end


--[[
Turns to an absolute position given
--params
s = string ("north", "east", "south", "west")
--]]
function Eturtle:turnToAbsolute(s)
	local keyLeft = 
		{["northnorth"] = 0, ["northeast"] = 3, ["northsouth"] = 2, ["northwest"] = 1,
		["eastnorth"] = 1, ["easteast"] = 0, ["eastsouth"] = 3, ["eastwest"] = 2,
		["southnorth"] = 2, ["southeast"] = 1, ["southsouth"] = 0, ["southwest"] = 3,
		["westnorth"] = 3, ["westeast"] = 2, ["westsouth"] = 1, ["westwest"] = 0
		}
	local keyRight =
		{["northnorth"] = 0, ["northeast"] = 1, ["northsouth"] = 2, ["northwest"] = 3,
		["eastnorth"] = 3, ["easteast"] = 0, ["eastsouth"] = 1, ["eastwest"] = 2,
		["southnorth"] = 2, ["southeast"] = 3, ["southsouth"] = 0, ["southwest"] = 1,
		["westnorth"] = 1, ["westeast"] = 2, ["westsouth"] = 3, ["westwest"] = 0
		}
	local leftTurnCount = keyLeft[(self.direction)..s]
	local rightTurnCount = keyRight[(self.direction)..s]
	if leftTurnCount <= rightTurnCount then
		for i=1, leftTurnCount do
			turtle.turnLeft()
			self:_incrementDirection(-1)
		end
	else
		for i=1, rightTurnCount do
			turtle.turnRight()
			self:_incrementDirection(1)
		end
	end
end


--[[
A better way to move turtles, it will only
turn if absolutely necessary
USE THIS FUNCTION over turtle.forward, et cetera
if you want to transmit Eturtles info accurately.
--params
s = direction (string: "front", "back",
"left", "right", "top", "bottom")
n = amount to move that direction
e = end direction (will end up facing same way if no input) ("left", "right", "back")
--]]
function Eturtle:moveDirection(s, n, e)
	a = 1
	if n then
		a = n
	end
	--starting direction --> ending direction
	local keyRelative = 
		--[[
		{["leftleft"] = "forward",["leftright"] = "back",["leftback"] = "left",
		["rightleft"] = "back",["rightright"] = "forward",["rightback"] = "right",
		["backleft"] = "left",["backright"] = "right",["backback"] = "back"
		}--]]
		{["leftright"] = "back",["leftback"] = "left",
		["rightleft"] = "back",["rightback"] = "right",
		}
	--creates a vector which chooses the appropriate direction
	local positionKey =
		{["north"] = vector.new(0,0,-1),
		["east"] = vector.new(1,0,0),
		["south"] = vector.new(0,0,1),
		["west"] = vector.new(-1,0,0)
		}
	if s == "left" then
		self:turnTo("left")
		for i=1, a do
			if not turtle.forward() then break end
			self:_setPosition(self.position + positionKey[self.direction])
		end
	elseif s == "right" then
		self:turnTo("right")
		for i=1, a do
			if not turtle.forward() then break end
			self:_setPosition(self.position + positionKey[self.direction])
		end
	elseif s == "front" or s == "forward" then
		for i=1, a do
			if not turtle.forward() then break end
			self:_setPosition(self.position + positionKey[self.direction])
		end
	elseif s == "back" then
		for i=1, a do
			if not turtle.back() then break end
			self:_setPosition(self.position + (positionKey[self.direction]) * -1 ) --it multiplies by -1 since it goes backwards from the direction it's facing
		end
	elseif s == "up" then
		for i=1, a do
			if not turtle.up() then break end
			self:_setPosition(self.position + vector.new(0,1,0))
		end
	elseif s == "down" then
		for i=1, a do
			if not turtle.down() then break end
			self:_setPosition(self.position + vector.new(0,-1,0))
		end
	end
	if e ~= nil then
		if (s == "left") or (s == "right") then
			self:turnTo(keyRelative[s..e])
		else
			self:turnTo(e)
		end
	else
		if s == "left" then
			self:turnTo("right")
		elseif s == "right" then
			self:turnTo("left")
		end
	end
end


--[[
A way to manage turtles
--params
f - int of min fuel, ie, if turtle.getFuelLevel() passes under this threshold, it will return false

function Eturtle:fuelCheck(f)
	self.fuelLevel = turtle.getFuelLevel()
	if not self.fuelLevel >= f then
		return false
	else
		return true
	end
end
--]]


--[[
reads data from file directory, and uses that as reference for Eturtle metadata
--params
d = directory
--]]
function Eturtle:readFromFile(d)
	if fs.exists(d) then
		local turtle = json.decodeFromFile(d)
		self = turtle
	else return false end
end


--[[
writes data to the file directory, for use in other programs or etc.
--]]
function Eturtle:writeToFile()
	local file = assert(fs.open("turtle", "w"))
	file.write(json.encode(self))
	file.close()
end

return Eturtle