-- 
-- Abstract: Fishies sample app
-- 
-- Version: 1.0
-- 
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.


-- Seed randomizer
local seed = os.time();
math.randomseed( seed )

display.setStatusBar( display.HiddenStatusBar )

-- Background
local halfW = display.viewableContentWidth / 2
local halfH = display.viewableContentHeight / 2

--local backgroundPortrait = display.newImage( "aquariumbackgroundIPhone.jpg", 0, 0 )
--local backgroundLandscape = display.newImage( "aquariumbackgroundIPhoneLandscape.jpg", -80, 80 )
--backgroundLandscape.isVisible = false
--local background = backgroundPortrait

-- Handle changes in orientation for the background images
local backgroundOrientation = function( event )
	-- TODO: This requires some setup, i.e. the landscape needs to be centered
	-- Need to add a centering operation.  For now, the position is hard coded
	local delta = event.delta
	if ( delta ~= 0 ) then
		local rotateParams = { rotation=-delta, time=500, delta=true }

		if ( delta == 90 or delta == -90 ) then
			local src = background

			-- toggle background to refer to correct dst
			--background = ( backgroundLandscape == background and backgroundPortrait ) or backgroundLandscape
			--background.rotation = src.rotation
			transition.dissolve( src, background )
			transition.to( src, rotateParams )
		else
			assert( 180 == delta or -180 == delta )
		end

		--transition.to( background, rotateParams )

		media.playEventSound( "bubble_strong.caf" )
	end
end

-- Add a global listener
Runtime:addEventListener( "orientation", backgroundOrientation )

-- Fishies
local numFish = 10
local file1 = "fish.small.red.png"
local file2 = "fish.small.blue.png"

-- Define touch listener for fish so that fish can behave like buttons.
-- The listener will receive an 'event' argument containing a "target" property
-- corresponding to the object that was the target of the interaction.
-- This eliminates closure overhead (i.e. the need to reference non-local variables )
local buttonListener = function( event )
	if "ended" == event.phase then
		local group = event.target

		-- tap only triggers change from original to different color
		local topObject = group[1]

		if ( topObject.isVisible ) then
			local bottomObject = group[2]

			-- Dissolve to bottomObject (different color)
			transition.dissolve( topObject, bottomObject, 500 )

			-- Restore after some random delay
			transition.dissolve( bottomObject, topObject, 500, math.random( 3000, 10000 ) )
		end

		-- we handled it so return true to stop propagation
		return true
	end
end


-- Create a table to store all the fish and register this table as the 
-- "enterFrame" listener to animate all the fish.
local bounceAnimation = {
	container = display.newRect( 0, 0, display.viewableContentWidth, display.viewableContentHeight ),
	reflectX = true,
}

local circleSize = 20
local curCount = 3
local curLocations = {}
local nextIndex = nil
local circleColor = 255,110,110

local circleTouchedListener = function( event )
	if "ended" == event.phase then
		local g = event.target
		local text = g[1]
		local circle = g[2]
		circle.isVisible = false
		text.isVisible = true
		if g.num == curLocations[nextIndex].num then
			circle:setStrokeColor(50,200,60)
			text:setTextColor( 50,200,60 )
			nextIndex = nextIndex + 1
		else
			circle:setStrokeColor(200,50,40)
			text:setTextColor( 200,50,40 )
		end
		
		print(g.num)
	end
end

local hideNumbers = function(event)
	for i=1,#curLocations do
		local g = curLocations[i]
		if (g ~= nil) then
			local text = g[1]
			local circle = g[2]
			circle.isVisible = true
			text.isVisible = false
			nextIndex = 1
			g:addEventListener( "touch", circleTouchedListener )
		end
	end
end

local drawNewIteration = function( event )
	local xpad = display.viewableContentWidth*0.05
	local ypad = display.viewableContentHeight*0.05
	local w = display.viewableContentWidth - 2*xpad
	local h = display.viewableContentHeight - 2*ypad
	for i=1,#curLocations do
		o = curLocations[i]
		if (o ~= nil) then
			o:removeSelf()
		end
	end
	curLocations = {}
	
	local spaceIsFree = function(x,y)
		for _,v in pairs(curLocations) do
			if ((x > (v.x - 25)) and (x < (v.x + 25))) or ((y > (v.y-25)) and (y < (v.y + 25))) then
				return false
			end
		end
		return true
	end
	
	i = 1
	repeat
		local x = math.random() * w + xpad
		local y = math.random() * h + ypad
		if spaceIsFree(x,y) then
			local num = math.random(10)
			local group = display.newGroup()
			group.x = x
			group.y = y
			group.num = num
			local t = display.newText( num, x, y, native.systemFont, 30 )
			group:insert( t, true )
			local c = display.newCircle(x, y, circleSize)
			group:insert( c, true )  -- accessed in buttonListener as group[1]
			c.strokeWidth = 3
			c:setStrokeColor(255,110,110)
			c:setFillColor(0,0,0)
			c.isVisible = false
			
			curLocations[i] = group
			t:setTextColor( 255,110,110 )
			i = i + 1
		end
	until i > curCount
	curCount = curCount + 1
	table.sort(curLocations, function (a,b) return (a.num < b.num) end)
	timer.performWithDelay(1000, hideNumbers)
end

	

-- Add fish to the screen
numFish = 0
for i=1,numFish do
	-- create group which will represent our fish, storing both images (file1 and file2)
	local group = display.newGroup()

	local fishOriginal = display.newImage( file1 )
	group:insert( fishOriginal, true )  -- accessed in buttonListener as group[1]

	local fishDifferent = display.newImage( file2 )
	group:insert( fishDifferent, true ) -- accessed in buttonListener as group[2]
	fishDifferent.isVisible = false -- make file2 invisible

	-- move to random position in a 200x200 region in the middle of the screen
	group:translate( halfW + math.random( -100, 100 ), halfH + math.random( -100, 100 ) )

	-- connect buttonListener. touching the fish will cause it to change to file2's image
	group:addEventListener( "touch", buttonListener )

	-- assign each fish a random velocity
	group.vx = math.random( 1, 5 )
	group.vy = math.random( -2, 2 )

	-- add fish to animation group so that it will bounce
	bounceAnimation[ #bounceAnimation + 1 ] = group
end

drawNewIteration()

--timer.performWithDelay(5000, drawNewIteration, 5 )

--local myText = display.newText( "Hello, World!", 40, 90, "MarkerFelt-Thin", 48 )
--myText:setTextColor( 255,110,110 )

-- Function to animate all the fish
function bounceAnimation:enterFrame( event )
	local container = self.container
	local containerBounds = container.stageBounds
	local xMin = containerBounds.xMin
	local xMax = containerBounds.xMax
	local yMin = containerBounds.yMin
	local yMax = containerBounds.yMax

	local orientation = self.currentOrientation
	local isLandscape = "landscapeLeft" == orientation or "landscapeRight" == orientation

	local reflectX = nil ~= self.reflectX
	local reflectY = nil ~= self.reflectY

	-- the fish groups are stored in integer arrays, so iterate through all the 
	-- integer arrays
	for i,v in ipairs( self ) do
		local object = v  -- the display object to animate, e.g. the fish group
		local vx = object.vx
		local vy = object.vy

		if ( isLandscape ) then
			if ( "landscapeLeft" == orientation ) then
				local vxOld = vx
				vx = -vy
				vy = -vxOld
			elseif ( "landscapeRight" == orientation ) then
				local vxOld = vx
				vx = vy
				vy = vxOld
			end
		elseif ( "portraitUpsideDown" == orientation ) then
			vx = -vx
			vy = -vy
		end

		-- TODO: for now, time is measured in frames instead of seconds...
		local dx = vx
		local dy = vy

		local bounds = object.stageBounds

		local flipX = false
		local flipY = false

		if (bounds.xMax + dx) > xMax then
			flipX = true
			dx = xMax - bounds.xMax
		elseif (bounds.xMin + dx) < xMin then
			flipX = true
			dx = xMin - bounds.xMin
		end

		if (bounds.yMax + dy) > yMax then
			flipY = true
			dy = yMax - bounds.yMax
		elseif (bounds.yMin + dy) < yMin then
			flipY = true
			dy = yMin - bounds.yMin
		end

		if ( isLandscape ) then flipX,flipY = flipY,flipX end
		if ( flipX ) then
			object.vx = -object.vx
			if ( reflectX ) then object:scale( -1, 1 ) end
		end
		if ( flipY ) then
			object.vy = -object.vy
			if ( reflectY ) then object:scale( 1, -1 ) end
		end

		object:translate( dx, dy )
	end
end

-- Handle orientation of the fish
function bounceAnimation:orientation( event )
	print( "bounceAnimation" )
	for k,v in pairs( event ) do
		print( "   " .. tostring( k ) .. "(" .. tostring( v ) .. ")" )
	end

	if ( event.delta ~= 0 ) then
		local rotateParameters = { rotation = -event.delta, time=500, delta=true }

		Runtime:removeEventListener( "enterFrame", self )
		self.currentOrientation = event.type

		for i,object in ipairs( self ) do
			transition.to( object, rotateParameters )
		end

		local function resume(event)
			Runtime:addEventListener( "enterFrame", self )
		end

		timer.performWithDelay( 500, resume )
	end
end

--Runtime:addEventListener( "enterFrame", bounceAnimation );
Runtime:addEventListener( "orientation", bounceAnimation )

