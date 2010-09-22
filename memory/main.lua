

local ui = require("ui")
local multiline_text = require("multiline_text")

-- Determine if running on Corona Simulator
--
local isSimulator = "simulator" == system.getInfo("environment")

-- Determine the platform type
-- "iPhoneOS" or "Android" or "Mac OS X"
--
local isAndroid = "Android" == system.getInfo("platformName")

--[[
local safeopenfeint = require("safeopenfeint")

if not isSimulator then
	require "openfeint"
	openfeint.init( "61Zp4vDFB48z1xl2WAdeA", "Uoq3349w5qomVzFaCP39WsXS6ckUWbAaZVJUCir8Y", "Memory" )
end
]]

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

local audio = {}
if isAndroid then
	audio.beep = media.newEventSound( "beep_mp3.mp3" )
	audio.bomb = media.newEventSound( "bomb_mp3.mp3" )
	audio.count = media.newEventSound( "short_low_high.mp3" )
else
	audio.beep = media.newEventSound( "beep_caf.caf" )
	audio.bomb = media.newEventSound( "bomb_caf.caf" )
	audio.count = media.newEventSound( "short_low_high.caf" )
end

audio.playBeep = function()
	media.playEventSound( audio.beep )
end
audio.playBomb = function()
	media.playEventSound( audio.bomb )
end
audio.playCount = function()
	media.playEventSound( audio.count )
end

local gui = {}

local config = {}
local game = {}

config.circleSize = 20

local countDown --- countdown function
local clearCurrentIteration
local drawNewIteration  --- draws a new iteration
local countDownCount = 3 --- counter
local showNumbers --- show all of the current numbers
local circleColor = 255,110,110

local resetGame = function()
	game.curCount = 3
	game.lastCount = nil
	game.score = 0
	game.bestScore = 0
	game.curLocations = {}
	game.nextIndex = nil
end

clearCurrentIteration = function()
	for i=1,#game.curLocations do
		o = game.curLocations[i]
		if (o ~= nil) then
			o:removeSelf()
		end
	end
	game.curLocations = {}
end

local scoreTable = {}
scoreTable[1] = 92
scoreTable[2] = 65
scoreTable[3] = 50
scoreTable[4] = 40
scoreTable[5] = 32
scoreTable[6] = 25
scoreTable[7] = 23
scoreTable[8] = 20
scoreTable[9] = 19
scoreTable[10] = 18

local calculateScore = function()
	gui.age_desc = ui.newLabel{
		bounds = { 10, 100, 300, 40 },
		text = "Your approximate age is...",
		font = "Helvetica",
		textColor = { 200,200,200, 255 },
		size = 20,
		align = "center"
	}
	gui.age = display.newText( "0", 115, 105, "ArialRoundedMTBold", 160 )
	gui.age:setTextColor( 200, 200, 200 )
	function gui.age:timer( event )
		local count = event.count
		self.text = count
		if count == scoreTable[game.curCount] then
			gui.playAgainButton.isVisible = true
		end
	end
	
	-- Register to call t's timer method 50 times
	timer.performWithDelay( 50, gui.age, scoreTable[game.curCount] )
end

local startNewIteration = function(newCount)
	if newCount == game.bestScore then
		timer.performWithDelay(1000, clearCurrentIteration)
		calculateScore()
		return
	end
	game.bestScore = math.max(game.bestScore,game.curCount)
	game.lastCount = game.curCount
	game.curCount = newCount
	local delayedStart = function(event)
		countDownCount = 3
		countDown()
	end
	timer.performWithDelay(1000, clearCurrentIteration)
	timer.performWithDelay(2000, delayedStart)
end

local circleTouchedListener = function( event )
	if "ended" == event.phase then
		local g = event.target
		local text = g[1]
		local circle = g[2]
		circle.isVisible = false
		text.isVisible = true
		if g.num == game.curLocations[game.nextIndex].num then
			audio.playBeep()
			circle:setStrokeColor(50,200,60)
			text:setTextColor( 50,200,60 )
			game.nextIndex = game.nextIndex + 1
			if game.nextIndex > #game.curLocations then
				startNewIteration(game.curCount+1)	
			end
		else
			audio.playBomb()
			circle:setStrokeColor(200,50,40)
			text:setTextColor( 200,50,40 )
			showNumbers()
			startNewIteration(game.curCount-1)
		end
	end
end

showNumbers = function(event)
	for i=1,#game.curLocations do
		local g = game.curLocations[i]
		local text = g[1]
		local circle = g[2]
		circle.isVisible = false
		text.isVisible = true
	end
end

local hideNumbers = function(event)
	for i=1,#game.curLocations do
		local g = game.curLocations[i]
		if (g ~= nil) then
			local text = g[1]
			local circle = g[2]
			circle.isVisible = true
			text.isVisible = false
			game.nextIndex = 1
			g:addEventListener( "touch", circleTouchedListener )
		end
	end
end

drawNewIteration = function( event )
	local xpad = display.viewableContentWidth*0.07
	local ypad = display.viewableContentHeight*0.07
	local w = display.viewableContentWidth - 2*xpad
	local h = display.viewableContentHeight - 2*ypad
	clearCurrentIteration()
	
	local spaceIsFree = function(num,x,y)
		for _,v in pairs(game.curLocations) do
			if v.num == num then
				return false
			end
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
		local num = math.random(10)
		if spaceIsFree(num,x,y) then
			local group = display.newGroup()
			group.x = x
			group.y = y
			group.num = num
			local t = display.newText( num, x, y, native.systemFont, 30 )
			group:insert( t, true )
			local c = display.newCircle(x, y, config.circleSize)
			group:insert( c, true )  -- accessed in buttonListener as group[1]
			c.strokeWidth = 3
			c:setStrokeColor(255,110,110)
			c:setFillColor(0,0,0)
			c.isVisible = false
			
			game.curLocations[i] = group
			t:setTextColor( 255,110,110 )
			i = i + 1
		end
	until i > game.curCount
	table.sort(game.curLocations, function (a,b) return (a.num < b.num) end)
	timer.performWithDelay(1000, hideNumbers)
end

--local roundedRect = display.newRoundedRect( 10, 50, 300, 40, 8 )
--roundedRect:setFillColor( 0, 0, 0, 170 )

local countDownText = ui.newLabel{
	bounds = { 10, 100, 300, 40 },
	text = "",
	font = "AmericanTypewriter",
	textColor = { 255, 204, 102, 255 },
	size = 60,
	align = "center"
}

countDown = function( event )
	countDownText:setText(tostring(countDownCount))
	countDownText.isVisible = true
	audio.playCount()
	countDownCount = countDownCount - 1
	if countDownCount >= 0 then
		timer.performWithDelay(1000, countDown)
	else
		drawNewIteration()
		countDownText.isVisible = false
	end
end

local startButtonRelease = function( event )
	--gui.startButton:removeSelf()
	--gui.gameText:removeSelf()
	resetGame()
	for _,v in pairs(gui) do
		v.isVisible = false
	end
	--gui.startButton.isVisible = false
	--gui.gameText.isVisible = false
	--gui.playAgainButton.isVisible = false
	countDownCount = 3	
	countDown()
end

-- openfeint stuff

local dashboardButtonRelease = function( event )
	openfeint.launchDashboard()
end

local leaderBoardButtonRelease = function( event )
	openfeint.launchDashboardWithListLeaderboardsPage()
end

local font = "MarkerFelt-Thin"
local font_size = 28

gui.dashboardButton = ui.newButton{
	default = "buttonRed.png",
	over = "buttonRedOver.png",
	onRelease = dashboardButtonRelease,
	id = "launchDashboard",
	text = "Launch Dashboard",
	font = font,
	size = font_size,
	emboss = true
}

gui.leaderBoardButton = ui.newButton{
	default = "buttonRed.png",
	over = "buttonRedOver.png",
	onRelease = leaderBoardButtonRelease,
	id = "launchDashboardWithListLeaderboardsPage",
	text = "List Leaderboards",
	font = font,
	size = font_size,
	emboss = true
}

gui.startButton = ui.newButton{
	default = "buttonGreen.png",
	over = "buttonGreenOver.png",
	--onPress = startButtonPress,
	onRelease = startButtonRelease,
	text = "I'm Ready...  Start!",
	font = font,
	size = font_size,
	emboss = true
}

gui.playAgainButton = ui.newButton{
	default = "buttonGreen.png",
	over = "buttonGreenOver.png",
	--onPress = startButtonPress,
	onRelease = startButtonRelease,
	text = "Play Again",
	font = font,
	size = font_size,
	emboss = true
}

gui.gameText = multiline_text.autoWrappedText(
	"You will have a second to view and memorize the locations of the numbers.\n \nTouch the locations in ascending order.", 
	"Helvetica", 20, { 200,200,200, 255 }, 300)

gui.gameText.x = 160
gui.gameText.y = 150

--button1.x = 160
--button1.y = -50
--button2.x = 160
--button2.y = -100

gui.startButton.x = 160; gui.startButton.y = 350
gui.playAgainButton.x = 160; gui.playAgainButton.y = 350

countDownText.isVisible = false
gui.playAgainButton.isVisible = false
gui.dashboardButton.isVisible = false
gui.leaderBoardButton.isVisible = false




--timer.performWithDelay(5000, drawNewIteration, 5 )

--local myText = display.newText( "Hello, World!", 40, 90, "MarkerFelt-Thin", 48 )
--myText:setTextColor( 255,110,110 )

