-- Plane - plane.lua
-- Version 1.0
module(..., package.seeall)
------------------------------------------------------------------------------------------------------------------------
-- Load Plane
plane = movieclip.newAnim{ 
	"plane_000.png" ,
	"plane_001.png" ,
	"plane_002.png" ,
	"plane_003.png" ,
	"plane_004.png" ,
	"plane_005.png" ,
	"plane_006.png" ,
	"plane_007.png" ,
	"plane_008.png" ,
	"plane_009.png" ,
	"plane_010.png" ,
	"plane_011.png" ,
	"plane_012.png" ,
	"plane_013.png" ,
	"plane_014.png" ,
	"plane_015.png" ,
	"plane_016.png" ,
	"plane_017.png" ,
	"plane_018.png"
}
plane.x = 160
plane.y = 240
plane:stopAtFrame( 10 )

------------------------------------------------------------------------------------------------------------------------

-- Animate Plane
local function animatePlane( xStrength )

	-- Pick Correct Sprite
	if xStrength == false or xStrength == 0 then
		plane:stopAtFrame( 10 )
	elseif xStrength <= -0.9 then
		plane:stopAtFrame( 1 )
	elseif xStrength <= -0.8 and xStrength > -0.9 then
		plane:stopAtFrame( 2 )
	elseif xStrength <= -0.7 and xStrength > -0.8 then
		plane:stopAtFrame( 3 )
	elseif xStrength <= -0.6 and xStrength > -0.7 then
		plane:stopAtFrame( 4 )
	elseif xStrength <= -0.5 and xStrength > -0.6 then
		plane:stopAtFrame( 5 )
	elseif xStrength <= -0.4 and xStrength > -0.5 then
		plane:stopAtFrame( 6 )
	elseif xStrength <= -0.3 and xStrength > -0.4 then
		plane:stopAtFrame( 7 )
	elseif xStrength <= -0.2 and xStrength > -0.3 then
		plane:stopAtFrame( 8 )
	elseif xStrength <= -0.1 and xStrength > -0.2 then
		plane:stopAtFrame( 9 )
	elseif xStrength >= 0.1 and xStrength < 0.2 then
		plane:stopAtFrame( 11 )
	elseif xStrength >= 0.2 and xStrength < 0.3 then
		plane:stopAtFrame( 12 )
	elseif xStrength >= 0.3 and xStrength < 0.4 then
		plane:stopAtFrame( 13 )
	elseif xStrength >= 0.4 and xStrength < 0.5 then
		plane:stopAtFrame( 14 )
	elseif xStrength >= 0.5 and xStrength < 0.6 then
		plane:stopAtFrame( 15 )
	elseif xStrength >= 0.6 and xStrength < 0.7 then
		plane:stopAtFrame( 16 )
	elseif xStrength >= 0.7 and xStrength < 0.8 then
		plane:stopAtFrame( 17 )
	elseif xStrength >= 0.8 and xStrength < 0.9 then
		plane:stopAtFrame( 18 )
	elseif xStrength >= 0.9 then
		plane:stopAtFrame( 19 )
	end
end

------------------------------------------------------------------------------------------------------------------------

-- Move Plane
local function movePlane( xStrength , yStrength )

	-- Set Plane Speed Mutliplyer
	local speed = 7
	
	-- Move X
	if xStrength ~= false then
		plane.x = math.floor( plane.x + ( xStrength * speed ) )
	end
	
	-- Move Y
	if yStrength ~= false then
		plane.y = math.floor( plane.y + ( yStrength * speed ) )
	end
	
	-- Boundries
	if plane.x < 85 then
		plane.x = 85
	elseif plane.x > 235 then
		plane.x = 235
	end
	if plane.y < 95 then
		plane.y = 95
	elseif plane.y > 265 then
		plane.y = 265
	end
	
end

------------------------------------------------------------------------------------------------------------------------
-- Plane Loop
function planeControl( event )
	local joyX = event.joyX
	local joyY = event.joyY
	animatePlane( joyX )
	movePlane( joyX , joyY )
end
