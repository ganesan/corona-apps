-- Zero Configuration Example
-- Here we are generating a new joystick by calling joystick = joystickClass.newJoystick{}
-- We are providing no pamams so the function will generate a joystick by creating 2 vector
-- circles and positioning them at the lower left corner of the screen.
-- The joystick we declared is global so any function can query its current calues
-- Directly querying the joystick is 1 of 2 different methods for obtaining readings

-- Setup Environment
display.setStatusBar( display.HiddenStatusBar )
system.activate( "multitouch" )

-- Load Joystick Class
local joystickClass = require( "joystick" )

-- Add New Joystick
joystick = joystickClass.newJoystick{}

-- Print Output To Terminal
local function printOutput()
	print( joystick.joyX , joystick.joyY , joystick.joyAngle , joystick.joyVector )
end
Runtime:addEventListener( "enterFrame" , printOutput )