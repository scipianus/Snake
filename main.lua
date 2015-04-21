require "init"
require "draw"

function love.load()
	screen = "welcome"
	objects = {} -- table to hold all our physical objects
	radius = 25
	timecounterlimit = 0
	gfx = love.graphics
	key = love.keyboard
	phy = love.physics
	
	phy.setMeter(64) --the height of a meter our worlds will be 64px
	world = phy.newWorld(0, 0, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 0

	--initial graphics setup
	gfx.setBackgroundColor(255, 255, 153) --set the background color
	love.window.setMode(650, 650) --set the window dimensions to 650 by 650
	
	SIZE_X = gfx.getWidth()
	SIZE_Y = gfx.getHeight()
end



function love.update(dt)
	if screen == "playing" then
		timecounter = timecounter + 1
		world:update(dt) --this puts the world into motion
		if timecounter == timecounterlimit then
			timecounter = 0
			lastX = objects[#objects].body:getX()
			lastY = objects[#objects].body:getY()
			for i = #objects, 1, -1 do
				objects[i].body:setPosition(objects[i - 1].body:getX(), objects[i - 1].body:getY())
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
			if xnow == fruit.body:getX() and ynow == fruit.body:getY() then
				objects[snakesize] = {}
				objects[snakesize].body = phy.newBody(world, lastX, lastY, "static") 
				objects[snakesize].shape = phy.newCircleShape(radius) 
				objects[snakesize].fixture = phy.newFixture(objects[snakesize].body, objects[snakesize].shape, 0)
				snakesize = snakesize + 1
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
				screen = "welcome"
			end
		end
	elseif screen == "welcome" then
		if key.isDown("1") then 
			timecounterlimit = 9
			gameInit()
			newFruit()
		elseif key.isDown("2") then 
			timecounterlimit = 7
			gameInit()
			newFruit()
		elseif key.isDown("3") then
			timecounterlimit = 5
			gameInit()
			newFruit()
		end
	end
end