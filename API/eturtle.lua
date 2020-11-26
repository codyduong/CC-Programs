--[[V0.1.0
an API which stands for enhanced turtle, just creates more sophisticated methods
--]]

--[[
Creation of a eturtle object, which passes itself as a param for some programs
Especially utilized for rednet passing, and network management of turtles
--]]
function Eturtle:new(o)
	direction --"north", "east", "south", "west"
	position --x (+east, -west); y (+up, -down); z (+south, -north)
	fuelLevel = turtle.getFuelLevel()
	fuelLimit = turtle.getFuelLimit()
	contents --{turtle.getItemDetail(1), turtle.getItemDetail(2), turtle.getItemDetail(3)...turtle.getItemDetail(16)}
	status = "" --just a string which is passed to the network, use this to set a status of a turtle (ie. mining, moving, etc)
end


--[[
Sets the direction of the Eturtle class to s
--params
s - string
--]]
function Eturtle:changeDirection(s)
	local accepted = {["north"] = true, ["east"] = true, ["south"] = true, ["west"] = true}
	if accepted[s] then self.Direction = s 
	else error("Eturtle:changeDirection param passed fail")
end


--[[
increments the direction of the turtle (i=1, north->east; i=-1, north->west)
--params
i - int, + indicates clockwise on compass, - counterclockwise
--]]
function Eturtle:incrementDirection(i) 
	j = i%4
	if self.direction == "north" then
		if j==1 then
			self:changeDirection("east")
		elseif j==2 then
			self:changeDirection("south")
		elseif j==3 then
			self:changeDirection("west")
		end
	elseif self.direction == "east" then
		if j==1 then
			self:changeDirection("south")
		elseif j==2 then
			self:changeDirection("west")
		elseif j==3 then
			self:changeDirection("north")
		end
	elseif self.direction == "south" then
		if j==1 then
			self:changeDirection("west")
		elseif j==2 then
			self:changeDirection("north")
		elseif j==3 then
			self:changeDirection("east")
		end
	elseif self.direction == "west" then
		if j==1 then
			self:changeDirection("north")
		elseif j==2 then
			self:changeDirection("east")
		elseif j==3 then
			self:changeDirection("south")
		end
	else
		error("Eturtle direction is nil")
	end
end


--[[
Just a cooler way to turn the turtles, makes turning 180 a lot easier.
--params
s1 - a string indicating where to turn to ("left", "right", "back") are the only accepted params
--]]
function Eturtle:turnTo(s)
	if s == "left" then
		if turtle.turnLeft() then 
			Eturtle:incrementDirection(-1)
		else
			error("eturtle turnTo ecode:0") 
		end
	elseif s == "back" then
		if turtle.turnLeft() then 
			turtle.turnLeft() 
			Eturtle:incrementDirection(-2)
		elseif turtle.turnRight() then 
			turtle.turnRight() 
			Eturtle:incrementDirection(2)
		else
			error("eturtle turnTo ecode:1") 
		end
	elseif s == "right" then
		if turtle.turnRight() then 
			Eturtle:incrementDirection(1)
		else
			error("eturtle turnTo ecode:2")
		end
	else 
		error("eturtle turnTo ecode:3")
	end
end


--[[
A way to manage turtles
--params
f - int of min fuel, ie, if turtle.getFuel() passes under this threshold, it will return false
--]]
function Eturtle:fuelCheck(f)
	self.fuelLevel = turtle.getFuelLevel()
	
end