--[[V1.1.1
an API for handling enderchest storage
--]]

--[[
A shared internal API function
--params
n1 - eChest slot (int)
s1 - eChest location (string: "front", "back",
"left", "right", "top", "bottom")
n2 - array or slot to deposit ({int, int} or int)
n3 - an amount to withdraw/deposit (int)
s2 - drop/suck (string: "drop", "suck")
--]]
function _shared(n1, s1, n2, n3, s2)
	a = {}
	if type(n2) == "number" then
		a = {n2}
	elseif type(n2) == "table" then
		a = n2
	else
		error("echest ecode:0")
	end
	function _doWork() --turtle.suck/drop depending on s2
		if s2 == "drop" then
			turtle.drop(n3)
		elseif s2 == "suck" then
			turtle.suck(n3)
		else
			error("echest ecode:1")
		end
	end
	function _turnLeft(n)
		for i=1, n do
			turtle.turnLeft()
		end
	end
	function _turnRight(n)
		for i=1, n do
			turtle.turnRight()
		end
	end
	function _simpDo()
		for i, n in ipairs(a) do
			turtle.select(n)
			_doWork()
		end
		turtle.select(n1)
	end
	turtle.select(n1)
	if s1 == "front" then
		if not turtle.place() then return false end
		_simpDo()
		turtle.dig()
	elseif s1 == "left" then
		_turnLeft(1)
		if not turtle.place() then return false end
		_simpDo()
		turtle.dig()
		_turnRight(1)
	elseif s1 == "back" then
		_turnLeft(2)
		if not turtle.place() then return false end
		_simpDo()
		turtle.dig()
		_turnRight(2)
	elseif s1 == "right" then
		_turnRight(1)
		if not turtle.place() then return false end
		_simpDo()
		turtle.dig()
		_turnLeft(1)
	elseif s1 == "top" then
		if not turtle.placeUp() then return false
		if s2 == "suck" then
			for i, n in ipairs(a) do
				turtle.select(n)
				turtle.suckUp(n3)
			end
		end
		elseif s2 == "drop" then
			for i, n in ipairs(a) do
				turtle.select(n)
				turtle.dropUp(n3)
			end
		else
			error("echest ecode:3")
		end
		turtle.select(n1)
		turtle.digUp()
	elseif s1 == "bottom" then
		if not turtle.placeDown() then return false
		if s2 == "suck" then
			for i, n in ipairs(a) do
				turtle.select(n)
				turtle.suckDown(n3)
			end
		end
		elseif s2 == "drop" then
			for i, n in ipairs(a) do
				turtle.select(n)
				turtle.dropDown(n3)
			end
		else
			error("echest ecode:3")
		end
		turtle.select(n1)
		turtle.digDown()
	else return false end
end

--[[
Used for depositing objects into an eChest
--params
n1 - eChest slot (int)
s1 - eChest location (string)
n2 - array or slot to deposit ({int, int} or int)
n3 - an amount to withdraw/deposit (int) 
--]]
function deposit(n1, s1, n2, n3)
	local opt = 64
	if n3 then opt = n3 end 
	_shared(n1, s1, n2, opt, "drop")
end

--[[
Used for withdrawing objects from an eChest
--params
n1 - eChest slot (int)
s1 - eChest location (string)
n2 - array or slot to deposit ({int, int} or int)
n3 - an amount to withdraw/deposit (int)
--]]
function withdraw(n1, s1, n2, n3)
	local opt = 64
	if n3 then opt = n3 end 
	_shared(n1, s1, n2, opt, "suck")
end
	