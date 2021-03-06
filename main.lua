local ser = require 'ser'

love.window.setTitle("Dungeon")
love.window.setMode(800, 760)
platform = {}
player = {}
grid = {}

mob = {}
mob.x = 0
mob.y = 0
mob.move = 1

camera = {}
camera.x = 0
camera.y = 0
camera.scaleX = 1
camera.scaleY = 1
camera.rotation = 0


function mob:place(dx, dy)
	self.x = dx
	self.y = dy
end

function mob:move(dx, dy)
	self.x = self.x + (dy or 0)
	self.y = self.y + (dy or 0)
end

function mob:path(cond)
	if (cond == 0) then 
		mob.move = false
	else
		mob.move = true
	end
end		

function camera:set()
  love.graphics.push()
  love.graphics.rotate(-self.rotation)
  love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
  love.graphics.translate(-self.x, -self.y)
end

function camera:unset()
  love.graphics.pop()
end

function camera:move(dx, dy)
  self.x = self.x + (dx or 0)
  self.y = self.y + (dy or 0)
end

function camera:rotate(dr)
  self.rotation = self.rotation + dr
end

function camera:scale(sx, sy)
  sx = sx or 1
  self.scaleX = self.scaleX * sx
  self.scaleY = self.scaleY * (sy or sx)
end

function camera:setPosition(x, y)
  self.x = x or self.x
  self.y = y or self.y
end

function camera:setScale(sx, sy)
  self.scaleX = sx or self.scaleX
  self.scaleY = sy or self.scaleY
end

function camera:mousePosition()
  return love.mouse.getX() * self.scaleX + self.x, love.mouse.getY() * self.scaleY + self.y
end

function love.wheelmoved(x, y)
    if y < 0 then
       camera:scale(1.02)
    elseif y > 0 then
       camera:scale(.98)
    end
end

function love.load()
	oneBit = love.graphics.newImage("32x32.png")
	player.img = love.graphics.newImage("person.png")
	cobblestone
 = love.graphics.newImage("cobblestone.png")
	pieces = {}
	if love.filesystem.exists("grid.lua") then
		chunck = love.filesystem.load("grid.lua")
		grid = chunck()
    else
		for x = 0, 24, 1 do
			grid[x] = {}
			for y = 0, 18, 1 do
				grid[x][y] = 1
			end
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
	if love.mouse.isDown("l") then
		local xMouse, yMouse = camera:mousePosition()
		
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

	if( not (love.keyboard.isDown('right','left','down','up'))) then
		buttonHeld = 0
	end	

	if(love.keyboard.isDown('right') and buttonHeld==0 ) then
 		camera.x= camera.x+30
 		buttonHeld=1
	end	
	if(love.keyboard.isDown('left') and buttonHeld==0) then
 		camera.x= camera.x-30
 		buttonHeld=1
	end	

	if(love.keyboard.isDown('up') and buttonHeld==0) then
 		camera.y= camera.y-30
 		buttonHeld=1
	end	
	if(love.keyboard.isDown('down') and buttonHeld==0) then
 		camera.y= camera.y+30
 		buttonHeld=1
	end	
end

function love.draw()
 camera:set()
	for x = 0, 24, 1 do
		for y = 0, 18, 1 do
			if grid[x][y] == 1 then
				love.graphics.draw(oneBit, x * 32, y * 32)
			elseif grid[x][y] == 0 then
				love.graphics.draw(cobblestone, x * 32, y * 32)
				-- Needed to change the color back after drawing
				love.graphics.setColor(255, 255, 255)
			end
		end
	end

	if(not (love.keyboard.isDown('q', 'e'))) then 
		buttonHeld = 0
	end

  	-- draw stuff
  	camera:unset()

  	love.graphics.setColor(0, 0, 0)
  	love.graphics.rectangle("fill", 0, 608, 800, 184)
  	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Use 'q' and 'e' to choose your piece", 200, 610, 0, 2, 2)
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(pieces[pieceC], 400, 640)

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

function love.keypressed(k)
	--update later include save
   if k == 'escape' then
     --table.save(grid, grid.txt) 
     save =ser(grid)
     love.filesystem.write("grid.lua", save )
     love.event.quit()
   end


end
