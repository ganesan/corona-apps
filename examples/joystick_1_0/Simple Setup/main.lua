-- Simple Setup Example
-- This is probably the most simple setup for a joystick that could be used in
-- you application. You provide an outer and inner image, set their alphas, the 
-- position of the joystick and the name of the function the joystick should
-- call. In this case onMove = printOutput is called and it recieves the joystick's
-- current values through the "event" table

-- Setup Environment
display.setStatusBar( display.HiddenStatusBar )
system.activate( "multitouch" )

-- Load Joystick Class
local joystickClass = require( "joystick" )

-- Print Output To Terminal
local function printOutput( event )
	print( event.joyX , event.joyY , event.joyAngle , event.joyVector )
end

-- Add A New Joystick
joystick = joystickClass.newJoystick{
	outerImage = "joystickOuter.png",		-- Outer Image - Circular - Leave Empty For Default Vector
	outerAlpha = 0.8,						-- Outer Alpha ( 0 - 1 )
	innerImage = "joystickInner.png",		-- Inner Image - Circular - Leave Empty For Default Vector
	innerAlpha = 0.8,						-- Inner Alpha ( 0 - 1 )
	position_x = 25,						-- X Position Top - From Left Of Screen - Positions Outer Image
	position_y = 335,						-- Y Position - From Left Of Screen - Positions Outer Image
	onMove = printOutput					-- Move Event
}