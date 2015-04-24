function gameInit(arg1, arg2)
	screen = "playing"
	snake = {}
	snake[0] = {}
	head = snake[0]
	obstacles = {}
	snakesize = 1
	dirx = 2 * radius
	diry = 0
	timecounter = 0
	fruit = {}
	mat = {}
	score = 0
	fruitPoints = arg1
	nrObstacles = arg2
	
	for i = radius, SIZE_X, 2 * radius do
		mat[i] = {}
		for j = radius, SIZE_Y, 2 * radius do
			mat[i][j] = 0
		end
	end
	
	--let's create a head
	head.body = phy.newBody(world, SIZE_X/2, SIZE_Y/2, "static") --place the body in the center of the world
	head.shape = phy.newCircleShape(radius) --the head's shape has a radius
	head.fixture = phy.newFixture(head.body, head.shape, 0) -- Attach fixture to body
	mat[head.body:getX()][head.body:getY()] = 1
	
	for i = 1, 2, 1 do
		snake[i] = {}
		snake[i].body = phy.newBody(world, SIZE_X/2 - 2 * i * radius, SIZE_Y/2, "static") 
		snake[i].shape = phy.newCircleShape(radius) 
		snake[i].fixture = phy.newFixture(snake[i].body, snake[i].shape, 0)
		mat[snake[i].body:getX()][snake[i].body:getY()] = 1
		snakesize = snakesize + 1
	end
	
	newFruit()
end

function updateMatrix()
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
	freespots = {}
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
	ind = math.random(nrspots)
	xfruit = freespots[ind][0]
	yfruit = freespots[ind][1]
	fruit.body = phy.newBody(world, xfruit, yfruit, "static")
	fruit.shape = phy.newCircleShape(radius)
	fruit.fixture = phy.newFixture(fruit.body, fruit.shape, 0)
	mat[xfruit][yfruit] = 3
	generateObstacles()
end

function generateObstacles()
	updateMatrix()
	freespots = {}
	nrspots = 0
	deadTime = 5
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
	for i = 1, nrObstacles, 1 do
		ind = math.random(1, nrspots)
		obstacles[i] = {}
		obstacles[i].body = phy.newBody(world, freespots[ind][0], freespots[ind][1], "static")
		obstacles[i].shape = phy.newCircleShape(radius)
		obstacles[i].fixture = phy.newFixture(obstacles[i].body, obstacles[i].shape, 0)
		freespots[ind] = freespots[nrspots]
		nrspots = nrspots - 1
	end
end