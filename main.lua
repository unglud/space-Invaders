love.graphics.setDefaultFilter('nearest', 'nearest')

enemiesController = {}
enemiesController.enemies = {}
enemiesController.img = love.graphics.newImage('alien.png')
enemiesController.exp =love.audio.newSource('explosion.wav')
enemiesController.scale = 3
enemy = {}

function love.load()

	music = love.audio.newSource('Penitent Existence.mp3')
	love.audio.play(music)
	love.audio.setVolume(0)

	backgroundImage = love.graphics.newImage('bg.jpg')
	gg = love.graphics.newImage('gg.png')

	halfOfWgg = gg:getWidth()/2 
	halfOfHgg = gg:getHeight()/2 + 50
	screenCenter = {}
	screenCenter.x = love.graphics.getWidth()/2
	screenCenter.y = love.graphics.getHeight()/2

	gameOver = false

	player = {}
	player.img = love.graphics.newImage('ship.png')
	player.sound = {}
	player.sound.fire = love.audio.newSource('fire.wav')
	player.sound.empty = love.audio.newSource('empty.wav')
	player.x = 0
	player.y = 540
	player.bullets = {}
	player.cooldown = 20
	player.speed = 5
	player.fire = function (  )
		if player.cooldown <= 0 then
			love.audio.play(player.sound.fire)
			player.cooldown = 20
			bullet = {}
			bullet.x = player.x + 23 
			bullet.y = player.y
			table.insert(player.bullets, bullet)
		else 
			love.audio.play(player.sound.empty)
		end
	end


	for i=1, 11 do
		enemiesController:spawnEnemy(i*40, 10)
	end
	
	
	
end

function enemiesController:spawnEnemy(x,y)
	enemy = {}
	enemy.x = x
	enemy.y = y
	enemy.height = enemiesController.img:getHeight() * enemiesController.scale
	enemy.width = enemiesController.img:getWidth() * enemiesController.scale
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

function checkCollisions(enemies, bullets)
	for i,e in ipairs(enemies) do
		for j,b in ipairs(bullets) do
			if b.y <= e.y + e.height and b.x > e.x and b.x < e.x + e.width then
				table.remove(enemies,i)
				table.remove(bullets,j)
				love.audio.play(enemiesController.exp)
				particleSystem:spawn(e.x,e.y)
			end 
		end
	end
end

particleSystem = {}
particleSystem.list = {}
particleSystem.img = love.graphics.newImage('particle.png')

function particleSystem:spawn(x,y)
	local ps = {}
	ps.x = x
	ps.y = y
	ps.ps = love.graphics.newParticleSystem(particleSystem.img, 32)
	ps.ps:setParticleLifetime(2, 4)
	ps.ps:setEmissionRate(5)
	ps.ps:setSizeVariation(1)
	ps.ps:setLinearAcceleration(-20,-20,20,20)
	ps.ps:setColors(100,255,100,255,0,255,0,255)
	table.insert(particleSystem.list,ps)
end

function particleSystem:draw()
	for _,v in pairs(particleSystem.list) do
		love.graphics.draw(v.ps, v.x, v.y)
	end
end

function particleSystem:update(dt)
	for _,v in pairs(particleSystem.list) do
		v.ps:update(dt)
	end
end

function particleSystem:cleanup()
	-- for _,v in pairs(particleSystem.list) do
	-- 	v.ps:update(dt)
	-- end
end

function love.update( dt )

	player.cooldown = player.cooldown -1

	volume = love.audio.getVolume()
	if volume < 1 then
		volume = volume + .005
		love.audio.setVolume(volume)
	end

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

    	if e.y+e.height >= love.graphics.getHeight() then
    		gameOver = true
    	end
    end

    checkCollisions(enemiesController.enemies, player.bullets)

end

function love.draw()
	
	love.graphics.setColor(150,150,150)
	love.graphics.draw(backgroundImage)

	love.graphics.setColor(255,255,255)
    love.graphics.draw(player.img, player.x, player.y, 0, .30)
    
    
    for _,e in pairs(enemiesController.enemies) do
    	love.graphics.draw(enemiesController.img, e.x, e.y, 0, enemiesController.scale)
    end

    love.graphics.setColor(255,0,0)
    for _,bullet in pairs(player.bullets) do
    	love.graphics.rectangle("fill", bullet.x, bullet.y, 10,10, 5, 5)
    end

    if gameOver then
    	love.graphics.setColor(255,255,255,150)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(),love.graphics.getHeight())
		love.graphics.setColor(255,255,255)
		love.graphics.draw(gg, screenCenter.x - halfOfWgg, screenCenter.y - halfOfHgg)
    end


    

end