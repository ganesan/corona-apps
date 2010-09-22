-- 2 Joystick Example
-- Here we are generating 2 seperate joysticks - joystick and joystickTurret
-- The tileEngine watches for a joystick called "joystick" and responds to
-- the values that joystick generates. This works because we declared that
-- joystick globally. The other joystick, joystickTurret uses the other method
-- of interacting with the joystick, the param onMove = tank.turretControl binds
-- a function in tank.lua to the joystick and the joystick then calls that function
-- every frame sending it the current values through the function turretControl( event )

-- Setup Environment
display.setStatusBar( display.HiddenStatusBar )
system.activate( "multitouch" )
local movieclip = require("movieclip")

-- Load Tile Engine
local tileEngine = require( "tileEngine" )

-- Generate Background With The Tile Engine
background = tileEngine.newSurface( "background.png" , 2 , 0 , 6 , 1 , 40 )

-- Load Tank
local tank = require( "tank" )

-- Generate Smoke With The Tile Engine
smoke = tileEngine.newSurface( "smoke.png" , 2 , 0.5 , 6 , 0.3 , 40 )

-- Load Joystick Class
local joystickClass = require( "joystick" )

-- Add A Joystick To Control The Background
joystick = joystickClass.newJoystick{
	outerImage = "joystickOuter.png",		-- Outer Image - Circular - Leave Empty For Default Vector
	outerRadius = "",						-- Outer Radius - Size Of Outer Joystick Element - The Limit
	outerAlpha = 0.5,						-- Outer Alpha ( 0 - 1 )
	innerImage = "joystickInner.png",		-- Inner Image - Circular - Leave Empty For Default Vector
	innerRadius = "",						-- Inner Radius - Size Of Touchable Joystick Element
	innerAlpha = 0.5,						-- Inner Alpha ( 0 - 1 )
	backgroundImage = "",					-- Background Image
	background_x = 0,						-- Background X Offset
	background_y = 0,						-- Background Y Offset
	backgroundAlpha = 1,					-- Background Alpha ( 0 - 1 )
	position_x = 15,						-- X Position Top - From Left Of Screen - Positions Outer Image
	position_y = 345,						-- Y Position - From Left Of Screen - Positions Outer Image
	ghost = 0,								-- Set Alpha Of Touch Ghost ( 0 - 255 )
	joystickAlpha = 0.5,					-- Joystick Alpha - ( 0 - 1 ) - Sets Alpha Of Entire Joystick Group
	joystickFade = true,					-- Fade Effect ( true / false )
	joystickFadeDelay = 2000,				-- Fade Effect Delay ( In MilliSeconds )
	onMove = ""								-- Move Event
}

-- Add A Joystick To Control The Tank Turret
local joystickTurret = joystickClass.newJoystick{
	outerImage = "joystickOuter.png",		-- Outer Image - Circular - Leave Empty For Default Vector
	outerRadius = "",						-- Outer Radius - Size Of Outer Joystick Element - The Limit
	outerAlpha = 0.5,						-- Outer Alpha ( 0 - 1 )
	innerImage = "joystickInner.png",		-- Inner Image - Circular - Leave Empty For Default Vector
	innerRadius = "",						-- Inner Radius - Size Of Touchable Joystick Element
	innerAlpha = 0.5,						-- Inner Alpha ( 0 - 1 )
	backgroundImage = "",					-- Background Image
	background_x = 0,						-- Background X Offset
	background_y = 0,						-- Background Y Offset
	backgroundAlpha = 1,					-- Background Alpha ( 0 - 1 )
	position_x = 185,						-- X Position Top - From Left Of Screen - Positions Outer Image
	position_y = 345,						-- Y Position - From Left Of Screen - Positions Outer Image
	ghost = 0,								-- Set Alpha Of Touch Ghost ( 0 - 255 )
	joystickAlpha = 0.5,					-- Joystick Alpha - ( 0 - 1 ) - Sets Alpha Of Entire Joystick Group
	joystickFade = true,					-- Fade Effect ( true / false )
	joystickFadeDelay = 2000,				-- Fade Effect Delay ( In MilliSeconds )
	onMove = tank.turretControl				-- Move Event
}