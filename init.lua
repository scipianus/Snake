function gameInit()
	screen = "playing"
	objects = {} -- table to hold all our physical objects
	objects[0] = {}
	head = objects[0]
	snakesize = 1
	dirx = 2 * radius
	diry = 0
	timecounter = 0
	fruit = {}
	mat = {}
	
	--let's create a head
	head.body = phy.newBody(world, SIZE_X/2, SIZE_Y/2, "static") --place the body in the center of the world
	head.shape = phy.newCircleShape(radius) --the head's shape has a radius
	head.fixture = phy.newFixture(head.body, head.shape, 0) -- Attach fixture to body
	
	xfruit = (2 * math.random(SIZE_X/(2 * radius)) - 1) * radius
	yfruit = (2 * math.random(SIZE_Y/(2 * radius)) - 1) * radius
	fruit.body = phy.newBody(world, xfruit, yfruit, "static")
	fruit.shape = phy.newCircleShape(radius)
	fruit.fixture = phy.newFixture(fruit.body, fruit.shape, 0)
	
	for i = radius, SIZE_X, 2 * radius do
		mat[i] = {}
		for j = radius, SIZE_Y, 2 * radius do
			mat[i][j] = 0
		end
	end
	mat[head.body:getX()][head.body:getY()] = 1
	
	for i = 1, 2, 1 do
		objects[i] = {}
		objects[i].body = phy.newBody(world, 650/2 - 2 * i * radius, 650/2, "static") 
		objects[i].shape = phy.newCircleShape(radius) 
		objects[i].fixture = phy.newFixture(objects[i].body, objects[i].shape, 0)
		mat[objects[i].body:getX()][objects[i].body:getY()] = 1
		snakesize = snakesize + 1
	end
end

function newFruit()
	for i = radius, SIZE_X, 2 * radius do
		for j = radius, SIZE_Y, 2 * radius do
			if mat[i][j] == 1 then
				mat[i][j] = 0
			end
		end
	end
	for i = 1, #objects, 1 do
		mat[objects[i].body:getX()][objects[i].body:getY()] = 1
	end
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
	fruit.body:setPosition(xfruit, yfruit)
end