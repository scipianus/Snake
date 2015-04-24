require "init"
require "draw"

function love.load()
	screen = "welcome"
	snake = {} -- table to hold all our physical snake
	radius = 25
	timecounterlimit = 0
	gfx = love.graphics
	key = love.keyboard
	phy = love.physics
	
	phy.setMeter(64) --the height of a meter our worlds will be 64px
	world = phy.newWorld(0, 0, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 0

	--initial graphics setup
	gfx.setBackgroundColor(255, 255, 153) --set the background color
	love.window.setMode(1050, 650) --set the window dimensions
	
	SIZE_X = gfx.getWidth()
	SIZE_Y = gfx.getHeight()
end

function Collision(x, y)
	if mat[x][y] == 1 then
		return true
	end
	if deadTime > 0 then
		return false
	end
	for i = 1, nrObstacles, 1 do
		if x == obstacles[i].body:getX() and y == obstacles[i].body:getY() then
			return true
		end
	end
	return false
end

function love.update(dt)
	if screen == "playing" then
		timecounter = timecounter + 1
		world:update(dt) --this puts the world into motion
		if timecounter == timecounterlimit then
			timecounter = 0
			if deadTime > 0 then
				deadTime = deadTime - 1
			end
			lastX = snake[#snake].body:getX()
			lastY = snake[#snake].body:getY()
			for i = #snake, 1, -1 do
				snake[i].body:setPosition(snake[i - 1].body:getX(), snake[i - 1].body:getY())
			end
			--move the head
			xnow = head.body:getX() + dirx
			ynow = head.body:getY() + diry
			if xnow > SIZE_X then
				xnow = xnow % SIZE_X
			end
			if xnow < 0 then
				xnow = xnow + SIZE_X
			end
			if ynow > SIZE_Y then
				ynow = ynow % SIZE_Y
			end
			if ynow < 0 then
				ynow = ynow + SIZE_Y
			end
			head.body:setPosition(xnow, ynow)
			updateMatrix()
			if Collision(xnow, ynow) then
				screen = "lost"
				return
			end
			if xnow == fruit.body:getX() and ynow == fruit.body:getY() then
				snake[snakesize] = {}
				snake[snakesize].body = phy.newBody(world, lastX, lastY, "static") 
				snake[snakesize].shape = phy.newCircleShape(radius) 
				snake[snakesize].fixture = phy.newFixture(snake[snakesize].body, snake[snakesize].shape, 0)
				snakesize = snakesize + 1
				score = score + fruitPoints
				newFruit()
			end	
			--here we are going to create some keyboard events
			if key.isDown("right") and dirx ~= -2 * radius then
				dirx = 2 * radius
				diry = 0
			elseif key.isDown("left") and dirx ~= 2 * radius then
				dirx = -2 * radius
				diry = 0
			elseif key.isDown("up") and diry ~= 2 * radius then
				dirx = 0
				diry = -2 * radius
			elseif key.isDown("down") and diry ~= -2 * radius then
				dirx = 0
				diry = 2 * radius
			elseif key.isDown("escape") then
				screen = "lost"
			end
		end
	elseif screen == "welcome" then
		if key.isDown("1") then 
			gameInit(1, 8)
			timecounterlimit = 9
		elseif key.isDown("2") then 
			gameInit(2, 9)
			timecounterlimit = 7
		elseif key.isDown("3") then
			gameInit(3, 10)
			timecounterlimit = 5
		end
	elseif screen == "lost" then
		if key.isDown("return") then
			screen = "welcome"
		end
	end
end