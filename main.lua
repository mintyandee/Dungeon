local ser = require 'ser'

love.window.setTitle( "Dungeon")
love.window.setMode(800, 600)
grid = {}
function love.load()
	oneBit = love.graphics.newImage("32x32.png")
 	if love.filesystem.exists( 'grid.lua' ) then
        chunk = love.filesystem.load( 'grid.lua' )
        grid = chunk()

    else
		for x = 0, 24, 1 do
			grid[x] = {}
			for y = 0, 18, 1 do
				grid[x][y] = 1
			end
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
end

function love.keypressed(k)
	--update later include save
   if k == 'escape' then
     --table.save(grid, grid.txt) 

     save =ser(grid)
     love.filesystem.write( 'grid.lua', save )

      love.event.quit()
   end
end
