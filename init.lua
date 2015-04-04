function gameInit()
	screen = "playing"
	objects = {} -- table to hold all our physical objects
	objects[0] = {}
	head = objects[0]
	dirx = 2 * radius
	diry = 0
	timecounter = 0
	
	--let's create a head
	head.body = phy.newBody(world, SIZE_X/2, SIZE_Y/2, "static") --place the body in the center of the world
	head.shape = phy.newCircleShape(radius) --the head's shape has a radius
	head.fixture = phy.newFixture(head.body, head.shape, 0) -- Attach fixture to body
	
	for i = 1, 2, 1 do
		objects[i] = {}
		objects[i].body = phy.newBody(world, 650/2 - 2 * i * radius, 650/2, "static") 
		objects[i].shape = phy.newCircleShape(radius) 
		objects[i].fixture = phy.newFixture(objects[i].body, objects[i].shape, 0)
	end

end