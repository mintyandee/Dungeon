love.window.setMode(832, 640)
map_width = 384
map_height = 128
platform = {}
player = {}
grid = {}
local debug = false
lastMouseClickX, lastMouseClickY = 0, 0

function love.load()
	oneBit = love.graphics.newImage("32x32.png")
	player.img = love.graphics.newImage("blue.png")
	rooms = love.graphics.newImage("map.png")
	
	testx=15
	testy=415
	pieces = {}
	testMapPieces = {}
	lroom = {}
	
	for x = 0, 24, 1 do
		grid[x] = {}
		for y = 0, 18, 1 do
			grid[x][y] = 0
		end
	end
	
	pieces[0] = love.graphics.newImage("1.png")
	pieces[1] = love.graphics.newImage("2.png")
	pieces[2] = love.graphics.newImage("3.png")

	testMapPieces[0] = love.graphics.newQuad(0, 0, 96, 64, rooms:getDimensions())
	testMapPieces[1] = love.graphics.newQuad(96, 0, 96, 64, rooms:getDimensions())
	testMapPieces[2] = love.graphics.newQuad(192, 0, 64, 64, rooms:getDimensions())
	testMapPieces[3] = love.graphics.newQuad(256, 0, 32, 128, rooms:getDimensions())
	testMapPieces[4] = love.graphics.newQuad(288, 0, 96, 64, rooms:getDimensions())

	lroom[0] = love.graphics.newQuad(0, 0, 32, 32, rooms:getDimensions())
	lroom[1] = love.graphics.newQuad(0, 32, 32, 32, rooms:getDimensions())
	lroom[2] = love.graphics.newQuad(32, 32, 32, 32, rooms:getDimensions())
	lroom[3] = love.graphics.newQuad(64, 32, 32, 32, rooms:getDimensions())

	lnum = table.getn(lroom)


	tmpC = 0
	tmpCount = 5

	pieceC = 1
	pieceCount = 3

	player.speed = 200 --sets player speed
end

function getRoomNumber() 
	local roomNum
	if tmpC == 0 then roomNum = 2
	elseif tmpC == 1 then roomNum = 3
	elseif tmpC == 2 then roomNum = 4
	elseif tmpC == 3 then roomNum = 5
	elseif tmpC == 4 then roomNum = 6	
	end
	return roomNum
end

function getMousePos() 
	local x, y
	if love.mouse.isDown(1) then
		x, y = love.mouse.getPosition()
		x = math.floor(x / 32)
		y = math.floor(y / 32)
		lastMouseClickX, lastMouseClickY = x, y
	end

	if debug then
		if x then
			love.graphics.print("We clicked at "..x.." "..y, 160, 15)
		end
	end
	return x, y
end

function canDrawRoom(room, x, y) 
	if room == 2 then
		print("grid at ("..x..","..y..")", 0, 60)
		if not isEdge(room, x, y) and (grid[x][y] == 0 and grid[x][y + 1] == 0 and grid[x + 1][y + 1] == 0 and grid[x + 2][y + 1] == 0) then
				return true
		end
	end
	return false
end

function isEdge(room, x, y)
	if room == 2 then
		if (x + 2) > 24  or (y + 1) > 18 then
			return true
		end 
	end

	return false
end

function updateTable(room)
	local x, y = getMousePos()
	if not x and not y then
		return
	end
	if room == 2 then
		if canDrawRoom(room, x, y) then
			grid[x][y] = {room = 1, tile = 0} 
			grid[x][y + 1] = {room = 1, tile = 1}
			grid[x + 1][y + 1] = {room = 1, tile = 2}
			grid[x + 2][y + 1] = {room = 1, tile = 3}
		end
	end
end

function love.update(dt)
	local room = getRoomNumber()

	updateTable(room)

	--player for testing
	if love.keyboard.isDown("p") then
		player.x = love.graphics.getHeight() / 2
		player.y = love.graphics.getHeight() / 2
	end	

	if love.keyboard.isDown('a') then
		if grid[(math.floor(player.x / 32))][(math.floor(player.y / 32)) - 1] ==  1 then
			player.x = player.x - (player.speed * dt)
		end

	elseif love.keyboard.isDown('d') then
		if grid[(math.floor(player.x / 32) + 1)][(math.floor(player.y / 32)) - 1] ==  1 then
			player.x = player.x + (player.speed * dt)
		end

	elseif love.keyboard.isDown('w') then
		if grid[(math.floor(player.x / 32))][(math.floor(player.y / 32)) - 1] == 1 then
			player.y = player.y - (player.speed * dt)
		end

	elseif love.keyboard.isDown('s') then
		if grid[(math.floor(player.x / 32))][(math.floor(player.y / 32))] == 1 then
			player.y = player.y + (player.speed * dt)
		end
	end
end

function love.keypressed(key)
	if key == "f3" then
		debug = not debug
	elseif key =="r" then -- When r is pressed, it resets the array to be 1s again
		for x = 0, 24, 1 do
			grid[x] = {}
			for y = 0, 18, 1 do
				grid[x][y] = 0
			end
		end
	end 
end

function love.draw()
	for x = 0, 24, 1 do
		for y = 0, 18, 1 do
			if grid[x][y] == 0 then
				love.graphics.draw(oneBit, x * 32, y * 32)
			elseif grid[x][y].room == 1 then
				love.graphics.draw(rooms, lroom[grid[x][y].tile], x * 32, y * 32)
				love.graphics.setColor(255, 255, 255)
			end
		end
	end

	if(not (love.keyboard.isDown('q', 'e'))) then 
		buttonHeld = 0
	end

	love.graphics.print("Use 'q' and 'e' to choose your piece", testx, testy, 0, 2, 2)
	love.graphics.rectangle("line", 10, 400, 420, 160)
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(rooms, testMapPieces[tmpC], 300, 420)
	if(love.keyboard.isDown("e") and buttonHeld == 0) then
		if(tmpC+1 < tmpCount) then
			tmpC = tmpC + 1
			buttonHeld = 1
		else
			tmpC = 0
			buttonHeld = 1
		end

	elseif(love.keyboard.isDown("q") and buttonHeld == 0) then
		if(tmpC-1 >= 0) then
			tmpC = tmpC - 1
			buttonHeld = 1
		else
			tmpC = 4
			buttonHeld = 1
		end
	end

	debugPrint()

	--player for testing
	love.graphics.draw(player.img, player.x, player.y, 0, 1, 1, 0, 32)
	
end

function debugPrint()
	if debug then
		local x, y = lastMouseClickX, lastMouseClickY
		local room = getRoomNumber()
		love.graphics.setColor(255, 255, 255)
		print("-- Debug Info --", 0, 0)
		print("Mouse Position At X: "..x, 0, 15)
		print("Mouse Position At Y: "..y, 0, 30)
		print("Room Number: "..room, 0, 45)
	end	
end

function print(...)
	love.graphics.print(...)
end