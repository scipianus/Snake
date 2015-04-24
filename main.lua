require "init"
require "draw"

function love.load()
	screen = "welcome" --current screen = main screen
	gfx = love.graphics
	key = love.keyboard
	phy = love.physics
	
	phy.setMeter(64) --the height of a meter will be 64px
	world = phy.newWorld(0, 0, true) --create a world for the bodies to exist in with horizontal and vertical gravity of 0

	gfx.setBackgroundColor(255, 255, 153) --set the background color
	love.window.setMode(1050, 650) --set the window dimensions
	
	SIZE_X = gfx.getWidth()
	SIZE_Y = gfx.getHeight()
end

function updateMatrix() --update the matrix with the snake's new position
	for i = radius, SIZE_X, 2 * radius do
		for j = radius, SIZE_Y, 2 * radius do
			if mat[i][j] == 1 then
				mat[i][j] = 0
			end
		end
	end
	mat[head.body:getX()][head.body:getY()] = 2
	for i = 1, #snake, 1 do
		mat[snake[i].body:getX()][snake[i].body:getY()] = 1
	end
end

function newFruit()
	updateMatrix()
	freespots = {} --freespots in the matrix, where I don't have bodyparts
	nrspots = 0
	for i = radius, SIZE_X, 2 * radius do
		for j = radius, SIZE_Y, 2 * radius do
			if mat[i][j] == 0 then
				nrspots = nrspots + 1
				freespots[nrspots] = {}
				freespots[nrspots][0] = i
				freespots[nrspots][1] = j
			end
		end
	end
	ind = math.random(nrspots) --randomly generate the fruit's position
	xfruit = freespots[ind][0]
	yfruit = freespots[ind][1]
	fruit.body = phy.newBody(world, xfruit, yfruit, "static") --and create it
	fruit.shape = phy.newCircleShape(radius)
	fruit.fixture = phy.newFixture(fruit.body, fruit.shape, 0)
	mat[xfruit][yfruit] = 3
	generateObstacles() --create the new set of obstacles
end

function generateObstacles()
	updateMatrix()
	freespots = {} --freespots in the matrix, where I don't have bodyparts or fruit
	nrspots = 0
	imaginaryTime = 5 --the number of moves while the obstacles are "imaginary"
	for i = radius, SIZE_X, 2 * radius do
		for j = radius, SIZE_Y, 2 * radius do
			if mat[i][j] == 0 then
				nrspots = nrspots + 1
				freespots[nrspots] = {}
				freespots[nrspots][0] = i
				freespots[nrspots][1] = j
			end
		end
	end
	if nrObstacles == nrspots then --the table will be full with the snake, the fruit and the obstacles
		screen = "lost"
		return
	end
	for i = 1, nrObstacles, 1 do
		ind = math.random(1, nrspots) --randomly generate the obstacle's position
		obstacles[i] = {}
		obstacles[i].body = phy.newBody(world, freespots[ind][0], freespots[ind][1], "static") --and create it
		obstacles[i].shape = phy.newRectangleShape(2 * radius, 2 * radius)
		obstacles[i].fixture = phy.newFixture(obstacles[i].body, obstacles[i].shape, 0)
		freespots[ind] = freespots[nrspots] --removing this spot from freespots for the next random pick
		nrspots = nrspots - 1
	end
end

function Collision(x, y) --detect if (x,y) is a bodypart (other than head) or an obstacle
	if mat[x][y] == 1 then --collision with a bodypart
		return true
	end
	if imaginaryTime > 0 then --obstacles are still "imaginary"
		return false
	end
	for i = 1, nrObstacles, 1 do
		if x == obstacles[i].body:getX() and y == obstacles[i].body:getY() then --collision with an obstacle
			return true
		end
	end
	return false
end

function love.update(dt)
	if screen == "playing" then
		timecounter = timecounter + 1 
		world:update(dt) --this puts the world into motion
		if timecounter == timecounterlimit then --need to make a new move update
			timecounter = 0
			if imaginaryTime > 0 then --imaginaryTime 0 when the obstacles become real
				imaginaryTime = imaginaryTime - 1
			end
			--we save the position of the last bodypart in case we eat the fruit
			lastX = snake[#snake].body:getX() 
			lastY = snake[#snake].body:getY()
			--move the snake with one position
			for i = #snake, 1, -1 do 
				snake[i].body:setPosition(snake[i - 1].body:getX(), snake[i - 1].body:getY())
			end
			--move the head with one position
			xnow = head.body:getX() + dirx
			ynow = head.body:getY() + diry
			if xnow > SIZE_X then
				xnow = radius
			elseif xnow < 0 then
				xnow = SIZE_X - radius
			end
			if ynow > SIZE_Y then
				ynow = radius
			elseif ynow < 0 then
				ynow = SIZE_Y - radius
			end
			head.body:setPosition(xnow, ynow)
			updateMatrix() --update the matrix with the snake's new position
			if Collision(xnow, ynow) then --check collision
				screen = "lost"
				return
			end
			if xnow == fruit.body:getX() and ynow == fruit.body:getY() then --you eat the fruit
				--add another bodypart to the end of the snake
				snake[snakesize] = {}
				snake[snakesize].body = phy.newBody(world, lastX, lastY, "static")
				snake[snakesize].shape = phy.newCircleShape(radius) 
				snake[snakesize].fixture = phy.newFixture(snake[snakesize].body, snake[snakesize].shape, 0)
				snakesize = snakesize + 1
				score = score + fruitPoints --increase the score
				newFruit() --generate another fruit
			end	
			--keyboard events
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
		--select the game mode and the difficulty level
		if key.isDown("1") then 
			gameInit(1, 0)
			timecounterlimit = 7
		elseif key.isDown("2") then 
			gameInit(1, 0)
			timecounterlimit = 5
		elseif key.isDown("3") then
			gameInit(1, 8)
			timecounterlimit = 9
		elseif key.isDown("4") then
			gameInit(2, 9)
			timecounterlimit = 7
		elseif key.isDown("5") then
			gameInit(3, 10)
			timecounterlimit = 5
		end
	elseif screen == "lost" then
		--game over and you can play a new game
		if key.isDown("return") then
			screen = "welcome"
		end
	end
end