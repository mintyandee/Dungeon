
function love.load()
	love.window.setMode(768, 576)
	oneBit = love.graphics.newImage("32x32.png")
	testx=15
	testy=415
	pieces = {}
	grid = {}
	for x = 0, 24, 1 do
		grid[x] = {}
		for y = 0, 18, 1 do
			grid[x][y] = 1
		end
	end
	
	pieces[0] = love.graphics.newImage("1.png")
	pieces[1] = love.graphics.newImage("2.png")
	pieces[2] = love.graphics.newImage("3.png")
	pieceC=1
	pieceCount=3;


	xSquare, ySquare = 0, 0
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

	if(not (love.keyboard.isDown('d', 'a'))) then 
		buttonHeld = 0
	end

	love.graphics.print("Choose your piece", testx, testy, 0, 2, 2)
	love.graphics.rectangle("line", 10, 400, 420, 160)
	love.graphics.setColor(255,255,255)
	love.graphics.draw(pieces[pieceC], 300,420)
	if(love.keyboard.isDown("d") and buttonHeld ==0) then
		if(pieceC+1 < pieceCount) then
			pieceC=pieceC+1
			buttonHeld=1
		end
	elseif(love.keyboard.isDown("a") and buttonHeld ==0) then
		if(pieceC-1 >= 0) then
			pieceC=pieceC-1
			buttonHeld=1
		end
	end	

end
