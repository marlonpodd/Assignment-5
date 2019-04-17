-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

--physics
local physics = require( "physics" )

physics.start()
physics.setGravity( 0, 0 ) -- ( x, y )
--physics.setDrawMode( "hybrid" )   -- Shows collision engine outlines only

-- backround
local background = display.newImageRect( "./assets/backround.jpg", 1000, 700  )
background.x = display.contentCenterX
background.y = display.contentCenterY
background.id = " background "

--walls
local leftWall = display.newRect( 0, display.contentHeight / 2, 1, display.contentHeight )
-- myRectangle.strokeWidth = 3
-- myRectangle:setFillColor( 0.5 )
-- myRectangle:setStrokeColor( 1, 0, 0 )
leftWall.alpha = 0.0
physics.addBody( leftWall, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local rightWall = display.newRect( 400, 0, display.contentHeight / 3 , display.contentHeight + 400 )
-- myRectangle.strokeWidth = 3
-- myRectangle:setFillColor( 0.5 )
-- myRectangle:setStrokeColor( 1, 0, 0 )
rightWall.alpha = 0.0
physics.addBody( rightWall, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

--fire button
local fire = display.newImageRect( "./assets/fire.png", 150, 100 )
fire.x = 240
fire.y = 470
fire.id = " fire button "

--the ship(player)
local ship = display.newImageRect( "./assets/ship.png", 75, 75 )
ship.x = 160
ship.y = 380
ship.id = " ship thing "
physics.addBody( ship, "dynamic", { 
    density = 3.0, 
    friction = 0.5, 
    bounce = 0.3 
    } )



--point counter text
local pointcounter = display.newText( "Points: ", 60, 480, native.systemFont, 33 )
pointcounter:setFillColor( 0/255, 0/255, 0/255 )

points = 0

local screentext = display.newText( points, 135, 480, native.systemFont, 35 )
screentext:setFillColor( 0/255, 0/255, 0/255 )


-------ship moving function---------
function theShiptouch ( event )
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
 
function fire:touch( event )
    if ( event.phase == "ended" ) then
        
        local laser = display.newImageRect( "./assets/laser.png", 25, 35 )
		laser.x = ship.x
		laser.y = 350
		laser.id = " laser button "
        
        transition.moveBy( laser, { 
        	x = 0, -- move 0 in the x direction 
        	y = -480, -- move up 50 pixels
        	time = 0550 -- move in a 1/10 of a second
        	} )
    end

    return true
end

function checkCharacterPosition( event )
    -- check every frame to see if character has fallen
    if ship.x > 340 or ship.x < -20 then
        ship.x = display.contentCenterX
        ship.y = 380
    end
end

ship:addEventListener("touch", theShiptouch )
fire:addEventListener("touch", fire )
Runtime:addEventListener( "enterFrame", checkCharacterPosition )
