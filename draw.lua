function love.draw()
	if screen == "playing" then
		if deadTime == 0 then --the obstacles are alive
			gfx.setColor(0, 0, 0)
		else -- or not
			gfx.setColor(192, 192, 192)
		end
		for i = 1, nrObstacles, 1 do --draw the obstacles
			gfx.circle("fill", obstacles[i].body:getX(), obstacles[i].body:getY(), obstacles[i].shape:getRadius())
		end
		
		gfx.setColor(255, 0, 0) --draw the fruit
		gfx.circle("fill", fruit.body:getX(), fruit.body:getY(), fruit.shape:getRadius())
		
		gfx.setColor(0, 51, 0) --draw the head
		gfx.circle("fill", head.body:getX(), head.body:getY(), head.shape:getRadius())
		
		gfx.setColor(0, 153, 0) --draw the bodyparts
		for i = 1, #snake, 1 do
			bodypart = snake[i]
			gfx.circle("fill", bodypart.body:getX(), bodypart.body:getY(), bodypart.shape:getRadius())
		end
		
		--draw the score
		gfx.setColor(0, 0, 0)
		gfx.setNewFont(20)
		gfx.printf("Score: "..score, 0, SIZE_Y - 30, SIZE_X, "center")
		
	elseif screen == "welcome" then --main screen
		gfx.setColor(0, 102, 0)
		gfx.setNewFont(20)
		gfx.printf("Choose the difficulty level:\n1 = easy\n2 = normal\n3 = hard", 0, SIZE_Y / 2 - 30, SIZE_X, "center")
	elseif screen == "lost" then --game over screen
		gfx.setColor(0, 102, 0)
		gfx.setNewFont(20)
		gfx.printf("GAME OVER\nScore: "..score.."\nPress Enter to restart", 0, SIZE_Y / 2 - 30, SIZE_X, "center")
	end
end