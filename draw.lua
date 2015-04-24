function love.draw()
	if screen == "playing" then --playing a game
		if imaginaryTime == 0 then --the obstacles are alive
			gfx.setColor(0, 0, 0)
		else -- or not
			gfx.setColor(192, 192, 192)
		end
		for i = 1, nrObstacles, 1 do --draw the obstacles
			gfx.rectangle("fill", obstacles[i].body:getX() - radius, obstacles[i].body:getY() - radius, 2 * radius, 2 * radius)
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
		gfx.printf("Choose the game mode and the difficulty level:\n1 = Zen normal\n2 = Zen hard\n3 = Arcade easy\n4 = Arcade normal\n5 = Arcade hard", 0, SIZE_Y / 2 - 30, SIZE_X, "center")
	elseif screen == "lost" then --game over screen
		gfx.setColor(0, 102, 0)
		gfx.setNewFont(20)
		gfx.printf("GAME OVER\nScore: "..score.."\nPress ENTER for a new game", 0, SIZE_Y / 2 - 50, SIZE_X, "center")
	end
end