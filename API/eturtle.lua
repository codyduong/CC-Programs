--[[v0.4.4
an API which stands for enhanced turtle, just creates more sophisticated methods
TODO: fix so when eturtle.new is called it checks for existing files first.
--]]

--[[
Creation of a eturtle object, which passes itself as a param for some programs
Especially utilized for rednet passing, and network management of turtles
--]]
Eturtle = {}
function Eturtle:new(o)
	local et = o or {}
	setmetatable(et, self)
	self.__index = self
	if not o then --instantiates some default stuff
		et.position = vector.new(0,0,0) --x (+east, -west); y (+up, -down); z (+south, -north)
		et.direction = "north" --"north", "east", "south", "west"
		et.fuelLevel = turtle.getFuelLevel()
		et.fuelLimit = turtle.getFuelLimit()
		et.contents =
		{turtle.getItemDetail(1), turtle.getItemDetail(2), turtle.getItemDetail(3), turtle.getItemDetail(4), 
		turtle.getItemDetail(5), turtle.getItemDetail(6), turtle.getItemDetail(7), turtle.getItemDetail(8), 
		turtle.getItemDetail(9), turtle.getItemDetail(10), turtle.getItemDetail(11), turtle.getItemDetail(12), 
		turtle.getItemDetail(13), turtle.getItemDetail(14), turtle.getItemDetail(15), turtle.getItemDetail(16)
		}
		--[[this for loop for instantiating the elements with indice i, won't work due to contents nil(ing) itself as soon as it starts? maybe there is a better fix...
		{turtle.getItemDetail(1), turtle.getItemDetail(2), turtle.getItemDetail(3)...turtle.getItemDetail(16)}
		for i=1, 16 do
			self.contents[i] = turtle.getItemDetail(i)
		end
		--]]
		et.status = "" --just a string which is passed to the network, use this to set a status of a turtle (ie. mining, moving, etc)
	end
	return et
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
	self:writeToFile()
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
s = direction (string: "forward", "back",
"left", "right", "top", "bottom")
n = amount to move that direction
e = end direction (will end up facing same way if no input) ("left", "right", "back")
--]]
function Eturtle:moveDirection(s, n, e)
	s_def = s or "forward"
	n_def = n or 1
	e_def = e or "forward"
	--starting direction --> ending direction
	local keyRelative = 
		{["leftright"] = "back",["leftback"] = "left",
		["rightleft"] = "back",["rightback"] = "right",
		["leftforward"] = "right", ["leftfront"] = "right", 
		["rightforward"] = "left", ["rightfront"] = "left", 
		}
	--creates a vector which chooses the appropriate direction
	local positionKey =
		{["north"] = vector.new(0,0,-1),
		["east"] = vector.new(1,0,0),
		["south"] = vector.new(0,0,1),
		["west"] = vector.new(-1,0,0)
		}
	if s_def == "left" then
		self:turnTo("left")
		for i=1, n_def do
			if not turtle.forward() then break end
			self:_setPosition(self.position + positionKey[self.direction])
			self:writeToFile()
		end
	elseif s_def == "right" then
		self:turnTo("right")
		for i=1, n_def do
			if not turtle.forward() then break end
			self:_setPosition(self.position + positionKey[self.direction])
			self:writeToFile()
		end
	elseif s_def == "front" or s == "forward" then
		for i=1, n_def do
			if not turtle.forward() then break end
			self:_setPosition(self.position + positionKey[self.direction])
			self:writeToFile()
		end
	elseif s_def == "back" then
		for i=1, n_def do
			if not turtle.back() then break end
			self:_setPosition(self.position + (positionKey[self.direction]) * -1 ) --it multiplies by -1 since it goes backwards from the direction it's facing
			self:writeToFile()
		end
	elseif s_def == "up" then
		for i=1, n_def do
			if not turtle.up() then break end
			self:_setPosition(self.position + vector.new(0,1,0))
			self:writeToFile()
		end
	elseif s_def == "down" then
		for i=1, n_def do
			if not turtle.down() then break end
			self:_setPosition(self.position + vector.new(0,-1,0))
			self:writeToFile()
		end
	end
	if (s_def == "left") or (s_def == "right") then
		if keyRelative[s_def..e_def] then self:turnTo(keyRelative[s_def..e_def]) end
	else
		self:turnTo(e_def)
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
function Eturtle.readFromFile(d)
	d_default = d or "turtle"
	if fs.exists(d_default) then
		file = fs.open(d_default, "r")
		local turtle = textutils.unserialize(file.readAll())
		file.close()
		return turtle
	else 
		error("Failed to read file")
		--return false 
	end
end


--[[
writes data to the file directory, for use in other programs or etc.
--params
d = directory
--]]
function Eturtle:writeToFile(d)
	d_default = d or "turtle"
	local file = assert(fs.open(d_default, "w"))
	file.write(textutils.serialize(self))
	file.close()
end


--[[
writes a status to the turtle (ie. moving, mining, executing a command)
--params
s = string
--]]
function Eturtle:setStatus(s)
	self.status = s
end

return Eturtle