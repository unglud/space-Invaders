love.graphics.setDefaultFilter('nearest', 'nearest')

enemiesController = {}
enemiesController.enemies = {}
enemiesController.img = love.graphics.newImage('alien.png')
enemy = {}

function love.load()

	

	player = {}
	player.img = love.graphics.newImage('ship.png')
	player.x = 0
	player.y = 540
	player.bullets = {}
	player.cooldown = 20
	player.speed = 5
	player.fire = function (  )
		if player.cooldown <= 0 then
			player.cooldown = 20
			bullet = {}
			bullet.x = player.x + 23 
			bullet.y = player.y
			table.insert(player.bullets, bullet)
		end
	end



	enemiesController:spawnEnemy(20, 10)
	enemiesController:spawnEnemy(60, 10)
	
end

function enemiesController:spawnEnemy(x,y)
	enemy = {}
	enemy.x = x
	enemy.y = y
	enemy.bullets = {}
	enemy.cooldown = 20
	enemy.speed = 5
	table.insert(self.enemies, enemy)
end

function enemy:fire()
	if self.cooldown <= 0 then
		self.cooldown = 20
		bullet = {}
		bullet.x = self.x + 35 
		bullet.y = self.y
		table.insert(self.bullets, bullet)
	end
end

function love.update( dt )

	player.cooldown = player.cooldown -1

	if love.keyboard.isDown('right') then
		player.x = player.x+player.speed
	end
	if love.keyboard.isDown('left') then
		player.x = player.x-player.speed
	end

	if love.keyboard.isDown("space") then
		player.fire()
	end

	for i,bullet in ipairs(player.bullets) do
    	bullet.y = bullet.y - 5

    	if bullet.y < -10 then
    		table.remove(player.bullets, i)
    	end
    end

    for _,e in pairs(enemiesController.enemies) do
    	e.y = e.y + 1
    end
	 
end

function love.draw()
	love.graphics.setColor(255,255,255)
    love.graphics.draw(player.img, player.x, player.y, 0, .30)
    
    love.graphics.setColor(100,255,100)
    for _,e in pairs(enemiesController.enemies) do
    	love.graphics.draw(enemiesController.img, e.x, e.y, 0,3)
    end

    love.graphics.setColor(255,0,0)
    for _,bullet in pairs(player.bullets) do
    	love.graphics.rectangle("fill", bullet.x, bullet.y, 10,10, 5, 5)
    end
end