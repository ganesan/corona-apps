-- Advanced Setup Example
-- Here we are adding a background and fade effect to our joystick
-- You will notice we are not using an outer image this time, the background contains
-- the full joystick design. Instead to form the outer boundary we are generating a 
-- vector circle using outerRadius = 60 and setting the outerAlpha = 0 so it cannot
-- be seen.
--
-- To add the fade effect we first need to set the joystickAlpha value to < 1
-- then by setting joystickFade = true and defining a value for joystickFadeDelay you will
-- have a joystick that is ghosted until the user interacts with it. After the user has
-- finished it will fade back to its original alpha. Setting joystickFadeDelay = 0 will make
-- the joystick fade immediately after the interaction has finished.

-- Setup Environment
display.setStatusBar( display.HiddenStatusBar )
system.activate( "multitouch" )
local movieclip = require("movieclip")

-- Load Tile Engine
local tileEngine = require( "tileEngine" )

-- Generate Background
local background = tileEngine.newSurface( "background.png" , 2 , 2 , 1 , 1 , 0 )

-- Generate Clouds
local clouds1 = tileEngine.newSurface( "clouds1.png" , 2 , 3 , 1 , 1 , 0 )

-- Load Plane
local plane = require( "plane" )

-- Generate More Clouds
local clouds2 = tileEngine.newSurface( "clouds2.png" , 2 , 5 , 1 , 0.8 , 0 )

-- Load Joystick Class
local joystickClass = require( "joystick" )

-- Add A New Joystick
joystick = joystickClass.newJoystick{
	outerImage = "",						-- Outer Image - Circular - Leave Empty For Default Vector
	outerRadius = 60,						-- Outer Radius - Size Of Outer Joystick Element - The Limit
	outerAlpha = 0,							-- Outer Alpha ( 0 - 1 )
	innerImage = "joystickInner.png",		-- Inner Image - Circular - Leave Empty For Default Vector
	innerRadius = "",						-- Inner Radius - Size Of Touchable Joystick Element
	innerAlpha = 1,							-- Inner Alpha ( 0 - 1 )
	backgroundImage = "joystickDial.png",	-- Background Image
	background_x = 0,						-- Background X Offset
	background_y = 0,						-- Background Y Offset
	backgroundAlpha = 1,					-- Background Alpha ( 0 - 1 )
	position_x = 25,						-- X Position Top - From Left Of Screen - Positions Outer Image
	position_y = 335,						-- Y Position - From Left Of Screen - Positions Outer Image
	ghost = 155,							-- Set Alpha Of Touch Ghost ( 0 - 255 )
	joystickAlpha = 0.4,					-- Joystick Alpha - ( 0 - 1 ) - Sets Alpha Of Entire Joystick Group
	joystickFade = true,					-- Fade Effect ( true / false )
	joystickFadeDelay = 2000,				-- Fade Effect Delay ( In MilliSeconds )
	onMove = plane.planeControl				-- Move Event
}