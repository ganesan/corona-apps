-- tileEngine - tileEngine.lua
-- Version 1.0
-- Demo, not designed for production

module(..., package.seeall)
------------------------------------------------------------------------------------------------------------------------

function loadSurface( textureMap , steps , alpha , yoffset )
	
	-- Setup Groups
	local masterGroup = display.newGroup()
	local backgroundGroup = display.newGroup()
	masterGroup:insert( backgroundGroup )
	masterGroup.backgroundGroup = backgroundGroup
	masterGroup.xReference = 160
	masterGroup.yReference = 240 - yoffset
	masterGroup.xScale = 1
	masterGroup.yScale = 1
	masterGroup.alpha = alpha

	-- Work Out Steps
	x_steps = steps * 320
	y_steps = steps * 480
	
	-- Build Grid
	local backgroundArray = {}
	for width = -x_steps , x_steps , 320 do
		for height = -y_steps , y_steps , 480 do
			table.insert( backgroundArray , width )
			table.insert( backgroundArray , height )
		end
	end
	
	-- Load Images
	local background
	for i=1 , ( #backgroundArray ) , 2 do
		local background = display.newImage( textureMap , backgroundArray[i] , backgroundArray[i+1] )
		backgroundGroup:insert( background )
	end
	
	-- Return Background
	return masterGroup

end

------------------------------------------------------------------------------------------------------------------------

-- Animate Background
local function animateSurface( event )

	-- Setup
	local pi = math.pi
	local sin = math.sin
	local cos = math.cos
	
	-- Get Groups To Animate
	local masterGroup = event
	local backgroundGroup = event.backgroundGroup
	
	-- Get Joystick Values
	local xStrength = joystick.joyX
	local yStrength = joystick.joyY
	
	if yStrength == false or not yStrength then
		yStrength = 0
	end
	
	-- Animate
	if xStrength ~= false and xStrength then
		masterGroup.rotation = masterGroup.rotation - xStrength
	end
	local angle = masterGroup.rotation
	local xFinal = ( sin( angle * pi / 180 ) * ( masterGroup.speed - ( yStrength * masterGroup.speedMultiplyer ) ) )
	local yFinal = ( cos( angle * pi / 180 ) * ( masterGroup.speed - ( yStrength * masterGroup.speedMultiplyer ) ) )
	
	backgroundGroup.x = backgroundGroup.x + xFinal
	backgroundGroup.y = backgroundGroup.y + yFinal
	
	-- Reset Pattern If Moved Past Boundaries
	if backgroundGroup.y > 480 then backgroundGroup.y = backgroundGroup.y - 480 end
	if backgroundGroup.y < -480 then backgroundGroup.y = backgroundGroup.y + 480 end
	if backgroundGroup.x > 320 then backgroundGroup.x = backgroundGroup.x - 320 end
	if backgroundGroup.x < -320 then backgroundGroup.x = backgroundGroup.x + 320 end
	
end

------------------------------------------------------------------------------------------------------------------------

function newSurface( textureMap , steps , speed , speedMultiplyer , alpha , yoffset )
	surface = loadSurface( textureMap , steps , alpha , yoffset )
	surface.speed = speed
	surface.speedMultiplyer = speedMultiplyer
	surface.enterFrame = animateSurface
	Runtime:addEventListener( "enterFrame" , surface )
	return surface
end