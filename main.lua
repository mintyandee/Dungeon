love.window.setMode(768, 576)
platform = {}
player = {}
grid = {}

function love.load()
	oneBit = love.graphics.newImage("32x32.png")
	player.img = love.graphics.newImage("blue.png")
	
	testx=15
	testy=415
	pieces = {}
	
	for x = 0, 24, 1 do
		grid[x] = {}
		for y = 0, 18, 1 do
			grid[x][y] = 1
		end
	end
	
	pieces[0] = love.graphics.newImage("1.png")
	pieces[1] = love.graphics.newImage("2.png")
	pieces[2] = love.graphics.newImage("3.png")
	pieceC = 1
	pieceCount = 3


	xSquare, ySquare = 0, 0
	
	player.speed = 200 --sets player speed
end

function love.update(dt)
	if love.mouse.isDown(1) then
		local xMouse, yMouse = love.mouse.getPosition()
		xSquare = math.floor(xMouse / 32)
		ySquare = math.floor(yMouse / 32)

		grid[xSquare][ySquare] = 0
	end

	-- When r is pressed, it resets the array to be 1s again
	if love.keyboard.isDown("r") then
		for x = 0, 24, 1 do
			grid[x] = {}
			for y = 0, 18, 1 do
				grid[x][y] = 1
			end
		end
	end

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

function love.draw()



	for x = 0, 24, 1 do
		for y = 0, 18, 1 do
			if grid[x][y] == 1 then
				love.graphics.draw(oneBit, x * 32, y * 32)
			elseif grid[x][y] == 0 then
				love.graphics.setColor(0, 0, 0)
				love.graphics.rectangle("fill", x * 32, y * 32, 32 , 32)
				-- Needed to change the color back after drawing
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
	love.graphics.draw(pieces[pieceC], 300, 420)
	if(love.keyboard.isDown("q") and buttonHeld == 0) then
		if(pieceC+1 < pieceCount) then
			pieceC = pieceC + 1
			buttonHeld = 1
		end
	elseif(love.keyboard.isDown("e") and buttonHeld == 0) then
		if(pieceC-1 >= 0) then
			pieceC = pieceC - 1
			buttonHeld = 1
		end
	end	

	--player for testing
	love.graphics.draw(player.img, player.x, player.y, 0, 1, 1, 0, 32)
	
end
