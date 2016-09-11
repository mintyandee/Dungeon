love.window.setMode(768, 576)
function love.load()
	oneBit = love.graphics.newImage("32x32.png")

	grid = {}
	for x = 0, 24, 1 do
		grid[x] = {}
		for y = 0, 18, 1 do
			grid[x][y] = 1
		end
	end
	
	xSquare, ySquare = 0, 0
end

function love.update(dt)
	if love.mouse.isDown(1) then
		local xMouse, yMouse = love.mouse.getPosition()
		xSquare = math.floor(xMouse / 32)
		ySquare = math.floor(yMouse / 32)

		grid[xSquare][ySquare] = 0
	end
end

function love.draw()
	-- love.graphics.setColor(255, 255, 255)
	-- for x = 0, 24, 1 do
	-- 	for y = 0, 18, 1 do
	-- 		love.graphics.draw(oneBit, x * 32, y * 32)
	-- 	end
	-- end

	for x = 0, 24, 1 do
		for y = 0, 18, 1 do
			if grid[x][y] == 1 then
				love.graphics.draw(oneBit, x * 32, y * 32)
			elseif grid[x][y] == 0 then
				love.graphics.setColor(0, 0, 0)
				love.graphics.rectangle("fill", x * 32, y * 32, 32 , 32)
			end
		end
	end


	love.graphics.setColor(255, 255, 255)
	love.graphics.print(xSquare, 50, 50)
	love.graphics.print(ySquare, 50, 60)
end
