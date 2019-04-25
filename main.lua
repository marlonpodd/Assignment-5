-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
math.randomseed( os.time() )
--physics
local physics = require( "physics" )

physics.start()
physics.setGravity( 0, 0 ) -- ( x, y )
--physics.setDrawMode( "hybrid" )   -- Shows collision engine outlines only

local lasershot = {}

local aliensound = audio.loadStream( "./assets/alien.wav" )
local alienChannel = audio.play( aliensound )

-- backround
local background = display.newImageRect( "./assets/backround.jpg", 1000, 700  )
background.x = display.contentCenterX
background.y = display.contentCenterY
background.id = " background "

--walls
local leftWall = display.newRect( 0, display.contentHeight / 0, 0, display.contentHeight )
-- myRectangle.strokeWidth = 3
-- myRectangle:setFillColor( 0.5 )
-- myRectangle:setStrokeColor( 1, 0, 0 )
leftWall.alpha = 0.0
leftWall.id = "leftwall"
physics.addBody( leftWall, "static", { 
    friction = 0.5, 
    bounce = 0 
    } )

local rightWall = display.newRect( 400, 0, display.contentHeight / 5 , display.contentHeight + 400 )
-- myRectangle.strokeWidth = 3
-- myRectangle:setFillColor( 0.5 )
-- myRectangle:setStrokeColor( 1, 0, 0 )
rightWall.alpha = 0.0
rightWall.id = "rightwall"
physics.addBody( rightWall, "static", { 
    friction = 0.5, 
    bounce = 0 
    } )

--the ship(player)
local ship = display.newImageRect( "./assets/ship.png", 75, 75 )
ship.x = 160
ship.y = 380
ship.id = " ship thing "
ship.alpha = 0
physics.addBody( ship, "dynamic", { 
    density = 3.0, 
    friction = 0, 
    bounce = 0 
    } )

--enemy ships
local enemyscroll = 1
local fastscroll = 1.5

local enemy = display.newImageRect( "./assets/enemy.png", 75, 75)
enemy.x = math.random(1, 320)
enemy.y = -200
enemy.id = "enemy"
enemy.alpha = 0
physics.addBody( enemy, "static", {
	density = 0.0,
	friction = 0,
	bounce = 0
	} )

local fastenemy = display.newImageRect( "./assets/slowenemy.png", 50, 50)
fastenemy.x = math.random(1, 315)
fastenemy.y = -1000
fastenemy.id = "fastenemy"
fastenemy.alpha = 0
physics.addBody( fastenemy, "dynamic", {
	density = 3,
	friction = 0,
	bounce = 0
	} )


--fire button
local fire = display.newImageRect( "./assets/fire.png", 150, 100 )
fire.x = 240
fire.y = 470
fire.id = " fire button "
fire.alpha = 0

--point counter text
local pointcounter = display.newText( "Points: ", 60, 480, native.systemFont, 33 )
pointcounter:setFillColor( 0/255, 0/255, 0/255 )

points = 0

local screentext = display.newText( points , 135, 480, native.systemFont, 35 )
screentext:setFillColor( 0/255, 0/255, 0/255 )

--start text
local start = display.newText( "START", 160, 280, native.systemFont, 30 )
start:setFillColor( 0/255, 255/255, 0/255 )
start.alpha = 1

local title = display.newText( "Shoot down the enemies!" , 160, 80, native.systemFont, 27 )
title:setFillColor( 255/255, 50/255, 50/255 )

local title2 = display.newText( "Use the 'Fire' button to" , 160, 130, native.systemFont, 25 )
title2:setFillColor( 0/255, 150/255, 150/255 )

local title3 = display.newText( "shoot a laser, but don't" , 160, 160, native.systemFont, 25 )
title3:setFillColor( 0/255, 150/255, 150/255 )

local title4 = display.newText( "let the enemies touch you!" , 160, 190, native.systemFont, 25 )
title4:setFillColor( 0/255, 150/255, 150/255 )

--enemy scroll function
function pressStart (event)
	start:removeSelf()
	title:removeSelf()
	title2:removeSelf()
	title3:removeSelf()
	title4:removeSelf()

	enemy.alpha = 1
	fire.alpha = 1
	ship.alpha = 1
	fastenemy.alpha = 1

	function moveEnemy (event)
		enemy.y = enemy.y + enemyscroll

		fastenemy.y = fastenemy.y + fastscroll
	end

	Runtime:addEventListener("enterFrame", moveEnemy )
end
-------ship moving function---------
local function theShiptouch ( event )
	local theShiptouched = event.target

        if (event.phase == "began") then
        	display.getCurrentStage():setFocus( theShiptouched )

        	theShiptouched.startMoveX = theShiptouched.x

        elseif (event.phase == "moved") then
        		 theShiptouched.x = (event.x - event.xStart) + theShiptouched.startMoveX
 
        elseif event.phase == "ended" or event.phase == "cancelled"  then
        		display.getCurrentStage():setFocus( nil )
        		theShiptouched.x = ship.x
             
        end
                return true
end

--laser function/ fire button 
function fire:touch( event )
    if ( event.phase == "began" ) then
        local lasersound = audio.loadStream( "./assets/laserwave.wav" )
        local laserChannel = audio.play( lasersound )

        -- make a bullet appear
        laser = display.newImageRect( "./assets/laser.png", 25, 35 )
        laser.x = ship.x
        laser.y = ship.y - 10
        physics.addBody( laser, 'dynamic' )
        -- Make the object a "bullet" type object
        laser.isBullet = true
        laser.isFixedRotation = true
        laser.gravityScale = 0
        laser.id = "laser"
        laser:setLinearVelocity(  0 , -1500 )

        table.insert(lasershot,laser)
        print("# of bullet: " .. tostring(#lasershot))
    end

    return true
end


--collisions
local function laserCollision( self, event )

    if ( event.phase == "began" ) then
        print( self.id .. ": collision began with " .. event.other.id )
        if event.other.id == "laser" then
        	
        	points = points + 1
        	screentext.text = points

        	laser:removeSelf()

        	timer.performWithDelay(1, function()

        	enemy.x = math.random(1, 320)
        	enemy.y = -100
        	
        end
        )
    elseif ( event.phase == "ended" ) then
        
    end
end
end

local function fastCollision( self, event )

    if ( event.phase == "began" ) then
        print( self.id .. ": collision began with " .. event.other.id )
        if event.other.id == "laser" then
        	
        	points = points + 1
        	screentext.text = points

        	laser:removeSelf()

        	timer.performWithDelay(1, function()

        	fastenemy.x = math.random(1, 320)
        	fastenemy.y = -1000
        	
        end
        )
    elseif ( event.phase == "ended" ) then
        
    end
end
end

local function levelIncrease( event )
	if points > 25 then
		local youwin = display.newImageRect( "./assets/youwin.png", 320, 250)
		youwin.x = 160
		youwin.y = 200
		youwin.id = "youwin"

		screentext.text = ""
		pointcounter.text = ""

		enemy.alpha = 0
		fastenemy.alpha = 0
		ship.alpha = 0
		fire.alpha = 0
	elseif points > 20 then
		enemyscroll = enemyscroll + 0.0027
		fastscroll = fastscroll + 0.00027
	elseif points > 12 then
		enemyscroll = enemyscroll + 0.00025
		fastscroll = fastscroll + 0.000025
	elseif points > 5 then
		enemyscroll = enemyscroll + 0.002
		fastscroll = fastscroll + 0.002
	else
		enemyscroll = 1
		fastscroll = 1.5
	end
end

local function shipCollision( self, event )

    if ( event.phase == "began" ) then
        print( self.id .. ": collision began with " .. event.other.id )
        if event.other.id == "enemy" then
        	
        	local explosionsound = audio.loadStream( "./assets/explosion.wav" )
            local explosionChannel = audio.play( explosionsound )

        	pointcounter.text = " "
        	screentext.text = " "
        	
        	local gameover = display.newImageRect( "./assets/gameover.png", 275, 250)
			gameover.x = 160
			gameover.y = 200
			gameover.id = "gameover"

        	timer.performWithDelay(1, function()
        	
        	ship:removeSelf()
        	fire:removeSelf()

        	for fade = 1, 150 do
        		enemy.alpha = enemy.alpha - 0.0005
        		fastenemy.alpha = fastenemy.alpha - 0.0005
        	end

        end
        )
    elseif ( event.phase == "ended" ) then
        
    end
end
end


local function enemyWin (event)
	if enemy.y > 500 or fastenemy.y > 500 then
		enemy.y = -100
		enemy.x = math.random(1, 320)

		fastenemy.y = -250
		fastenemy.x = math.random(1, 320)

		points = points - 5
		screentext.text = points
    end
end

local function pointsGame( event )
	if points < 0 then
		local gameover = display.newImageRect( "./assets/gameover.png", 275, 250)
		gameover.x = 160
		gameover.y = 200
		gameover.id = "gameover"

		screentext.text = ""
		pointcounter.text = ""

		enemy.alpha = 0
		fastenemy.alpha = 0
		ship.alpha = 0
		fire.alpha = 0
	end
end
ship:addEventListener("touch", theShiptouch )
fire:addEventListener("touch", fire )
Runtime:addEventListener("enterFrame", enemyWin )
Runtime:addEventListener("enterFrame", pointsGame )
start:addEventListener("touch", pressStart )
Runtime:addEventListener("enterFrame", levelIncrease )

enemy.collision = laserCollision
enemy:addEventListener( "collision" )

fastenemy.collision = fastCollision
fastenemy:addEventListener( "collision" )

ship.collision = shipCollision
ship:addEventListener( "collision" )




--just in case

--local gameover = display.newText( "GAME OVER!", 160, 100, native.systemFont, 45)
--gameover:setFillColor( 255/255, 0/255, 0/255 )