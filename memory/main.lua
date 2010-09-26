

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

local backgroundPortrait = display.newImage( "backgroundPortrait.png", 0, 0 )
--local backgroundLandscape = display.newImage( "aquariumbackgroundIPhoneLandscape.jpg", -80, 80 )
--backgroundLandscape.isVisible = 
local background = backgroundPortrait

local audio = {}
if isAndroid then
	audio.beep = media.newEventSound( "beep_mp3.mp3" )
	audio.bomb = media.newEventSound( "bomb_mp3.mp3" )
	audio.count = media.newEventSound( "short_low_high.mp3" )
else
	audio.beep = media.newEventSound( "beep_caf.caf" )
	audio.bomb = media.newEventSound( "bomb_caf.caf" )
	audio.count = media.newEventSound( "short_low_high.caf" )
	audio.three = media.newEventSound("Mamacita_Three.caf")
	audio.two = media.newEventSound("Mamacita_Two.caf")
	audio.one = media.newEventSound("Mamacita_One.caf")
end

audio.playBeep = function()
	media.playEventSound( audio.beep )
end
audio.playBomb = function()
	media.playEventSound( audio.bomb )
end
audio.playCountBeep = function()
	media.playEventSound( audio.count )
end
audio.playCount = function(num)
	if num == 3 then
		media.playEventSound(audio.three)
	elseif num == 2 then
		media.playEventSound(audio.two)
	elseif num == 1 then
		media.playEventSound(audio.one)
	end
end

local gui = {}

local config = {
	circleSize = 20,
	countDownTextColor = {255, 204, 102, 255},
	countDownTextSize = 80,
	correctTextColor = {200,255,200,255},
	incorrectTextColor = { 200,50,40, 255},
	--numberTextColor = {255, 204, 102, 255}, -- 255,110,110
	--numberTextColor = {255,110,110,255},
	numberTextColor = {250,250,250,255},
	scoreTextColor = {250,250,250,255}
}
local game = {}

local countDown --- countdown function
local clearCurrentIteration
local drawNewIteration  --- draws a new iteration
local countDownCount = 3 --- counter
local showNumbers --- show all of the current numbers
local circleColor = 255,110,110

local resetGame = function()
	game.curCount = 3
	game.points = 0
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

local pointsTable = {1,5,10,20,30,40,50,60,70,80}
local scoreTable = {92,65,50,40,32,25,23,19,18}
local gemTable = {"darkDiamond.png", "gemGreen.png", "whiteRuby.png", "redTriangle.png", "purpleSaphire.png", 
	"gemPurple.png", "greenDiamond.png", "redSaphire.png", "greenRuby.png", "greenSaphire.png", "whiteGem.png"}

local displayScore = function()
	local tc = config.scoreTextColor
	gui.score_desc = ui.newLabel{
		bounds = { 10, 100, 300, 40 },
		text = "Your final score is...",
		font = "Helvetica",
		textColor = tc,
		size = 20,
		align = "center"
	}
	gui.score = display.newText( "0", 115, 105, "ArialRoundedMTBold", 140 )
	gui.score:setTextColor( tc[1], tc[2], tc[3] )
	function gui.score:timer( event )
		local score = event.count * 10
		self.text = score
		if score >= game.points then
			self.text = game.points
			gui.playAgainButton.isVisible = true
		end
	end
	
	-- Register to call t's timer method 50 times
	timer.performWithDelay( 50, gui.score, game.points / 10 )
end

local calculateAndDisplayAge = function()
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
		displayScore()
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

local toggleNumber = function(g)
	local text = g[1]
	local circle = g[2]
	local scale = 1.0
	if circle.isVisible then
		circle.isVisible = false
		text.isVisible = true
	else
		if circle.width < 100 then
			scale = 1.0
		else
			scale = 0.5
		end
		circle.isVisible = true
		text.isVisible = false
	end
	g.xScale = scale
	g.yScale = scale
end

local circleTouchedListener = function( event )
	if "ended" == event.phase then
		local g = event.target
		toggleNumber(g)
		local text = g[1]
		local circle = g[2]
		if g.num == game.curLocations[game.nextIndex].num then
			audio.playBeep()
			local c = config.correctTextColor
			text:setTextColor( c[1],c[2],c[3] )
			game.nextIndex = game.nextIndex + 1
			
			-- add the points
			local points = display.newText( pointsTable[game.curCount], g.x-20, g.y-30, native.systemFont, 30 )
			game.points = game.points + pointsTable[game.curCount]
			points:setTextColor(255,255,255)

			transition.to(points, {time=500, alpha=0, y=g.y-150, onComplete=function(event) points:removeSelf() end})
			
			if game.nextIndex > #game.curLocations then
				startNewIteration(game.curCount+1)	
			end 
			
		else
			audio.playBomb()
			local c = config.incorrectTextColor
			text:setTextColor(c[2],c[2],c[3] )
			showNumbers()
			startNewIteration(game.curCount-1)
		end
	end
end

showNumbers = function(event)
	for i=1,#game.curLocations do
		toggleNumber(game.curLocations[i])
	end
end

local hideNumbers = function(event)
	for i=1,#game.curLocations do
		local g = game.curLocations[i]
		if (g ~= nil) then
			toggleNumber(g)
			local gem = g[2]
			game.nextIndex = 1
			g:addEventListener( "touch", circleTouchedListener )
			if gem.width < 100 then
				scale = 1.0
			else
				scale = 0.5
			end
			g.xScale = scale
			g.yScale = scale
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
		local num = math.random(math.max(10, game.curCount*2))
		if spaceIsFree(num,x,y) then
			local group = display.newGroup()
			group.x = x
			group.y = y
			group.num = num
			local t = display.newText( num, x, y, native.systemFont, 30 )
			group:insert( t, true )
			local c = display.newImage(gemTable[game.curCount], x, y)
			group:insert( c, true )  -- accessed in buttonListener as group[1]
			c.isVisible = false
			
			game.curLocations[i] = group
			local clr = config.numberTextColor
			t:setTextColor( clr[1], clr[2], clr[3] )
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
	textColor = config.countDownTextColor,
	size = config.countDownTextSize,
	align = "center"
}

countDown = function( event )
	countDownText:setText(tostring(countDownCount))
	countDownText.isVisible = true
	audio.playCount(countDownCount)
	countDownCount = countDownCount - 1
	if countDownCount >= 0 then
		timer.performWithDelay(1000, countDown)
	else
		drawNewIteration()
		countDownText.isVisible = false
	end
end

local startButtonRelease = function( event )
	resetGame()
	for _,v in pairs(gui) do
		v.isVisible = false
	end
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
	"Helvetica", 20, config.scoreTextColor, 300)

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

