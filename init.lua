function gameInit(arg1, arg2)
	screen = "playing" -- current screen = new game
	snake = {} --snake's bodyparts
	snake[0] = {}
	head = snake[0] --the head
	obstacles = {} --the obstacles
	radius = 25 --radius of the snake's bodyparts and half of the obstacles' height and weight
	snakesize = 1 --snake's length
	dirx = 2 * radius --the OX velocity, initially the snake goes to the right
	diry = 0 --the OY velocity
	timecounter = 0 --used to adjust the speed
	fruit = {} --the fruit
	mat = {} --matrix where I represent the snake and the fruit
	score = 0 --the player's score
	fruitPoints = arg1 --how many points does a fruit give you
	nrObstacles = arg2 --how many obstacles do you have
	
	--initialize the matrix
	for i = radius, SIZE_X, 2 * radius do
		mat[i] = {}
		for j = radius, SIZE_Y, 2 * radius do
			mat[i][j] = 0
		end
	end
	
	--create the head
	head.body = phy.newBody(world, SIZE_X/2, SIZE_Y/2, "static") --place the head in the window's center
	head.shape = phy.newCircleShape(radius)
	head.fixture = phy.newFixture(head.body, head.shape, 0)
	mat[head.body:getX()][head.body:getY()] = 1
	
	--create another two bodyparts
	for i = 1, 2, 1 do
		snake[i] = {}
		snake[i].body = phy.newBody(world, SIZE_X/2 - 2 * i * radius, SIZE_Y/2, "static") 
		snake[i].shape = phy.newCircleShape(radius) 
		snake[i].fixture = phy.newFixture(snake[i].body, snake[i].shape, 0)
		mat[snake[i].body:getX()][snake[i].body:getY()] = 1
		snakesize = snakesize + 1
	end
	
	newFruit() --create a fruit
end