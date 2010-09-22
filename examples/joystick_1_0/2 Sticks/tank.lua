-- Tank - tank.lua
-- Version 1.0
module(..., package.seeall)
------------------------------------------------------------------------------------------------------------------------
-- Load Tank
local tank = display.newImage( "tank.png" )
tank.x = 160
tank.y = 240-40
-- Load Turret
turret = movieclip.newAnim{ 
	"turret000.png" ,
	"turret001.png" ,
	"turret002.png" ,
	"turret003.png" ,
	"turret004.png" ,
	"turret005.png" ,
	"turret006.png" ,
	"turret007.png" ,
	"turret008.png" ,
	"turret009.png" ,
	"turret010.png" ,
	"turret011.png" ,
	"turret012.png" ,
	"turret013.png" ,
	"turret014.png" ,
	"turret015.png" ,
	"turret016.png" ,
	"turret017.png" ,
	"turret018.png" ,
	"turret019.png" ,
	"turret020.png" ,
	"turret021.png" ,
	"turret022.png" ,
	"turret023.png" ,
	"turret024.png" ,
}
turret.x = 160
turret.y = 171
turret.yReference = 28
turret.alpha = 1
turret:stopAtFrame( 1 )
turret.frame = 1
------------------------------------------------------------------------------------------------------------------------
-- Rotate Turret
local function rotateTurret( joyX )
	if joyX and joyX ~= false then
		turret.rotation = turret.rotation + ( joyX * 2 )
	end
end
------------------------------------------------------------------------------------------------------------------------
-- Raise Turret
local function raiseTurret( joyY )
	if joyY and joyY ~= false then
		if joyY > 0.7 and turret.frame < turret.numChildren then
			turret.frame = turret.frame + 1
			turret:stopAtFrame( turret.frame )
		elseif joyY < -0.7 and turret.frame > 1 then
			turret.frame = turret.frame - 1
			turret:stopAtFrame( turret.frame )
		end
		
	end
end
------------------------------------------------------------------------------------------------------------------------
-- Turret Controller
function turretControl( event )
	local joyX = event.joyX
	local joyY = event.joyY
	rotateTurret( joyX )
	raiseTurret( joyY )
end