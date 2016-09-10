function love.load()
	contents = love.filesystem.read("helloworld.txt")
	oneBit = love.graphics.newImage("32x32.png")
	-- twoBit = love.graphics.newImage("64x64.xcf")
	width = love.graphics.getWidth( )
	height = love.graphics.getHeight( )
end

function love.update(dt)

end

function love.draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", 0, 0, 500, 500)

	love.graphics.setColor(255, 255, 255)
	for x = 0, 24, 1 do
		for y = 0, 18, 1 do
			love.graphics.draw(oneBit, x * 32, y * 32)
		end
	end
end