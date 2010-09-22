-- numeric keyboard for iPad usage demo
-- Version 1.0, 2010-09-12
-- Alan Gruskoff - Digital Showcase LLC
--
-- A demonstration of how to use the numKeyPad module to 
-- edit a numeric value on an iPad size screen.
----------------------------------------------------------
local ui = require("ui")
local newLabel = ui.newLabel
local STATUSBAROFFSET = 24
local numKeyPad = require("numKeyPad")
local showNumKeyPad = numKeyPad.showNumKeyPad
local background = display.newGroup()
local bkg0 = display.newRect( 0, STATUSBAROFFSET, display.contentWidth, display.contentHeight ) 
bkg0:setFillColor( 128,128,0 )
background:insert( bkg0 )
local txt0 = display.newText( "Tap this number to edit ->", 60, 646, native.systemFontBold, 16)
txt0:setTextColor( 0,0,0 )
background:insert( txt0 )

-- value entry label for testing
local amt1Lbl = display.newGroup()
amt1Lbl.x = 300
amt1Lbl.y = 640
local bkg1 = display.newRect( 0, 0, 120, 36 ) 
bkg1.strokeWidth = 1
bkg1:setStrokeColor( 0,0,0 )
bkg1:setFillColor( 255,255,255 )
amt1Lbl:insert( bkg1 )

local amount = 123          -- the initial value
local txt1 = newLabel{ text=tostring( amount ), size=15, textColor={ 0,0,0,255 }, align="left", bounds = { 3,8,120,26 } }
amt1Lbl:insert( txt1 )

--------------------------------------------------------------------------------------
-- The following lines demonstrate usage of the numKeyPad module
--------------------------------------------------------------------------------------
local nkp = nil                        -- the object that holds the numeric key pad

local function getNKPValue( event )
    if ( event.value == nil ) then
--      the Cancel key hit sent back an event with a nil value to say just skip it.
    else
--      do this when the numKeyPad module sends out a "nkpCompleted" event on OK hit.
        amount = tonumber( event.value )        -- hold on to the numeric value
        txt1:setText( event.value )             -- display the value passed back
    end
    Runtime:removeEventListener( "nkpCompleted", getNKPValue )
    nkp = nil
end

local hitAmt1 = function( event )
    if ( nkp ~= nil ) then return end  -- dont make another object if we already have one
    
    media.playEventSound( "tap.caf" )
     
--      note that none of these module arguments are required, all have reasonable defaults
    nkp = showNumKeyPad{
        inValue = tostring( amount ),  -- pass in the initial value as a string
        maxChars = 10,                   -- pass in the maximum number of characters allowed
        left = 260,                    -- display position in pixels
        top = 100,                     -- display position in pixels
        prompt = "Amount:",            -- the prompt shown to the left of the value
        showDot = true                 -- boolean value as to whether to display the decimal point or not  
     }
     
     Runtime:addEventListener( "nkpCompleted", getNKPValue )
     return true
end
amt1Lbl:addEventListener("tap", hitAmt1 )
