function love.draw()
	if screen == "playing" then
		gfx.setColor(255, 0, 0) --set the drawing color for the fruit
		gfx.circle("fill", fruit.body:getX(), fruit.body:getY(), fruit.shape:getRadius())
		gfx.setColor(0, 102, 0) --set the drawing color for the head
		gfx.circle("fill", head.body:getX(), head.body:getY(), head.shape:getRadius())
		gfx.setColor(0, 153, 0) --set the drawing color for the rest of the bodyparts
		for i = 1, #objects, 1 do
			bodypart = objects[i]
			gfx.circle("fill", bodypart.body:getX(), bodypart.body:getY(), bodypart.shape:getRadius())
		end
	elseif screen == "welcome" then
		gfx.setColor(0, 102, 0)
		gfx.setNewFont(20)
		gfx.printf("Choose the difficulty level:\n1 = easy\n2 = normal\n3 = hard", 0, SIZE_Y / 2 - 30, SIZE_X, "center")
	end
end