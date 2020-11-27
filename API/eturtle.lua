--[[V0.2.0
an API which stands for enhanced turtle, just creates more sophisticated methods
--]]

--[[
Creation of a eturtle object, which passes itself as a param for some programs
Especially utilized for rednet passing, and network management of turtles
--]]
function Eturtle:new()
	Eturtle = {}
	setmetatable(Eturtle, self)
	self.__index = self
	self.position = {} --x (+east, -west); y (+up, -down); z (+south, -north)
	self.direction = "nil" --"north", "east", "south", "west"
	self.fuelLevel = turtle.getFuel()
	self.fuelLimit = turtle.getFuelLimit()
	self.contents = {} --{turtle.getItemDetail(1), turtle.getItemDetail(2), turtle.getItemDetail(3)...turtle.getItemDetail(16)}
	for i=1, 16 do
		contents[i] = turtle.getItemDetail(i)
	end
	self.status = "" --just a string which is passed to the network, use this to set a status of a turtle (ie. mining, moving, etc)
	return Eturtle
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
NOTE: INTERNAL USE only
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
Just a cooler way to turn the turtles, makes turning 180 a lot easier.
--params
s1 = a string indicating where to turn to ("left", "right", "back") are the only accepted params
--]]
function Eturtle:turnTo(s)
	if s == "left" then
		if turtle.turnLeft() then 
			Eturtle:_incrementDirection(-1)
		else
			error("eturtle turnTo ecode:0") 
		end
	elseif s == "back" then
		if turtle.turnLeft() then 
			turtle.turnLeft() 
			Eturtle:_incrementDirection(-2)
		elseif turtle.turnRight() then 
			turtle.turnRight() 
			Eturtle:_incrementDirection(2)
		else
			error("eturtle turnTo ecode:1") 
		end
	elseif s == "right" then
		if turtle.turnRight() then 
			Eturtle:_incrementDirection(1)
		else
			error("eturtle turnTo ecode:2")
		end
	else 
		error("eturtle turnTo ecode:3")
	end
end


--[[
Turns to an absolute position given
--params
s = string ("north", "east", "south", "west")
--]]
function Eturtle:turnToAbsolute(s)
	keyLeft = 
		{["northnorth"] = 0, ["northeast"] = 3, ["northsouth"] = 2, ["northwest"] = 1
		["eastnorth"] = 1, ["easteast"] = 0, ["eastsouth"] = 3, ["eastwest"] = 2
		["southnorth"] = 2, ["southeast"] = 1, ["southsouth"] = 0, ["southwest"] = 3
		["westnorth"] = 3, ["westeast"] = 2, ["westsouth"] = 1, ["westwest"] = 0
		}
	keyRight =
		{["northnorth"] = 0, ["northeast"] = 1, ["northsouth"] = 2, ["northwest"] = 3
		["eastnorth"] = 3, ["easteast"] = 0, ["eastsouth"] = 1, ["eastwest"] = 2
		["southnorth"] = 2, ["southeast"] = 3, ["southsouth"] = 0, ["southwest"] = 1
		["westnorth"] = 1, ["westeast"] = 2, ["westsouth"] = 3, ["westwest"] = 0
		}
	leftTurnCount = keyLeft[(self.direction)..s]
	rightTurnCount = keyRight[(self.direction)..s]
	if leftTurnCount <= rightTurnCount then
		for i=1, leftTurnCount()
			turtle.turnLeft()
			Eturtle:_incrementDirection(-1)
		end
	else
		for i=1, rightTurnCount then
			turtle.turnRight()
			Eturtle:_incrementDirection(1)
		end
	end
end


--[[temp disabled (has no use, and is confusing rn)
--[[
A way to manage turtles
--params
f - int of min fuel, ie, if turtle.getFuel() passes under this threshold, it will return false
--]]
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
Writes itself to a file
--params
d = directory
--]]
function Eturtle:writeSelfToFile(d)
	
end


--[[If you need to read from file using Eturtle, you're doing something wrong. I think...? Anyways I manage to do without this method, and the Eturtleless API is intended for this purpose.
--[[
Meant to return a Eturtle object after reading it from a file.
--]]
function readFile(d)

end
--]]