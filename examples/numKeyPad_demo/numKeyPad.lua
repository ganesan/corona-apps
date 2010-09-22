-- numKeyPad.lua
--
-- Abstract: numeric keyboard module for CORONA SDK in iPad format
--
-- Version: 1.0, 2010-09-12
--
-- Author: Alan Gruskoff
-- email: alang@digitalshowcase.biz
-- (C) 2010 Digital Showcase LLC
--
-- This code is provided "as is" without any warranty. It still under development. Feel free to use it and/or improve it.
-- The only request is to share your improvement to this code for CORONA community.
--
-------------------------------------------------------------------------
module(..., package.seeall)

local ui = require("ui")
local newLabel = ui.newLabel
local TOPLEFT_RP = display.TopLeftReferencePoint
-------------------------------------------------------------------------
-- numeric keypad built here
-- all of the params are optional as there are default values for each
-------------------------------------------------------------------------
function showNumKeyPad( params )
    local nkpValueStr = ""                                                              -- default to null string
    local inVal = tonumber( params.inValue )
    if ( inVal ~= nil ) then
         if ( inVal ~= 0 ) then nkpValueStr = tostring( inVal ) end                     -- string value passed in
    end

    local nkpMaxChars = 10
    local mc = tonumber( params.maxChars )                                              -- value passed in
    if ( mc and type( mc ) == "number" ) then nkpMaxChars = mc end

    local nkpLeft = 400                                                                 -- default position
    if ( params.left and type(params.left) == "number" ) then nkpLeft = params.left end -- value passed in

    local nkpTop = 100                                                                  -- default position
     if ( params.top and type(params.top) == "number" ) then nkpTop = params.top end    -- value passed in

    local nkpPrompt = "Amount:"
    if ( params.prompt ~= nil ) then nkpPrompt = params.prompt end                      -- value passed in

    local nkpShowDot = true
    if ( params.showDot == false ) then nkpShowDot = false end                          -- value passed in

-- set all the related objects relative to the background's Top Left point
    local row1 = nkpTop + 10
    local row2 = nkpTop + 100
    local row3 = nkpTop + 190
    local row4 = nkpTop + 280
    local row5 = nkpTop + 380
    local row6 = nkpTop + 440
    local col1 = nkpLeft + 10
    local col2 = nkpLeft + 100
    local col3 = nkpLeft + 190

----------------------------------------------------------------------------
--  show an overlay for modal window mode, trapping for tap events
----------------------------------------------------------------------------
    local STATUSBAROFFSET = 24
    local function doOverlay()
        return true
    end
    local overlay = display.newRect( 0, STATUSBAROFFSET, display.contentWidth, display.contentHeight )
    overlay:setFillColor( 200,200,200,128 )     -- grey 50% alpha
    overlay:addEventListener("tap", doOverlay )
    local function killOverlay()
        overlay:removeEventListener("tap", doOverlay )
        overlay:removeSelf()
        overlay = nil
    end

----------------------------------------------------------------------------
-- nkp is the object we are creating
----------------------------------------------------------------------------
    local nkp = display.newGroup()
    local doOKBtn
    local width, height, cornerRadius
    width=280; height=480; cornerRadius=12
    local bkg = display.newRoundedRect( nkpLeft, nkpTop, width, height, cornerRadius )
    bkg.strokeWidth = 1
    bkg:setStrokeColor( 0,0,0 )
    bkg:setFillColor( 170,170,170 )
    nkp:insert( bkg )

-- display a prompt for the entry value
    local lbl1 = display.newText(nkpPrompt, col1, row5, native.systemFont, 16 )
    lbl1:setTextColor( 0,0,0 )
    nkp:insert( lbl1 )

-- show the entry value background
    local bkg2 = display.newRect( col2, row5, 120, 26 )
    bkg2.strokeWidth = 1
    bkg2:setStrokeColor( 0,0,0 )
    bkg2:setFillColor( 255,255,255 )
    nkp:insert( bkg2 )

-- object to display the entry value, while editing
-- start with some place holder value, then post real value as a null string doesnt register correctly
    local val1 = newLabel{ text="0000000000", size=16, font=native.systemFontBold,
            textColor={ 0,0,0,255 }, align="left", bounds = { 4,4,120,26 }
    }
    val1:setReferencePoint( TOPLEFT_RP )
    val1.x = col2 + 6; val1.y= row5 + 4
    val1:setText( nkpValueStr )
    nkp:insert( val1 )

-- display the number of max characters allowed
    local max = newLabel{ text=nkpMaxChars, size=12, font=native.systemFont,
            textColor={ 255,196,0,255 }, align="left", bounds = { 2,2,30,26 }
    }
    max.x = col3 + 40; max.y= row5
    nkp:insert( max )

-- build an object and listener for each of the 14 buttons
    local num7 = display.newGroup()
    num7:insert( display.newImage( "num7.png", true ) )
    num7.x = col1; num7.y = row1

    local function onHit7( event )
        num7:remove( 1 )
        if ( event.phase == "began" ) then
            media.playEventSound( "tap.caf" )
            num7:insert( display.newImage( "num7_P.png", true ) )
            nkpValueStr = nkpValueStr .. "7"
            val1:setText( nkpValueStr )
            if ( string.len( nkpValueStr ) >= nkpMaxChars ) then doOKBtn( event ) end
        else
            num7:insert( display.newImage( "num7.png", true ) )
        end
    end
    num7:addEventListener("touch", onHit7 )

    local num8 = display.newGroup()
    num8:insert( display.newImage( "num8.png", true ) )
    num8.x = col2; num8.y = row1

    local function onHit8( event )
        num8:remove( 1 )
        if ( event.phase == "began" ) then
            media.playEventSound( "tap.caf" )
            num8:insert( display.newImage( "num8_P.png", true ) )
            nkpValueStr = nkpValueStr .. "8"
            val1:setText( nkpValueStr )
            if ( string.len( nkpValueStr ) >= nkpMaxChars ) then doOKBtn( event ) end
        else
            num8:insert( display.newImage( "num8.png", true ) )
        end
    end
    num8:addEventListener("touch", onHit8 )

    local num9 = display.newGroup()
    num9:insert( display.newImage( "num9.png", true ) )
    num9.x = col3; num9.y = row1

    local function onHit9( event )
        num9:remove( 1 )
        if ( event.phase == "began" ) then
            media.playEventSound( "tap.caf" )
            num9:insert( display.newImage( "num9_P.png", true ) )
            nkpValueStr = nkpValueStr .. "9"
            val1:setText( nkpValueStr )
            if ( string.len( nkpValueStr ) >= nkpMaxChars ) then doOKBtn( event ) end
        else
            num9:insert( display.newImage( "num9.png", true ) )
        end
    end
    num9:addEventListener("touch", onHit9 )

    local num4 = display.newGroup()
    num4:insert( display.newImage( "num4.png", true ) )
    num4.x = col1; num4.y = row2

    local function onHit4( event )
        num4:remove( 1 )
        if ( event.phase == "began" ) then
            media.playEventSound( "tap.caf" )
            num4:insert( display.newImage( "num4_P.png", true ) )
            nkpValueStr = nkpValueStr .. "4"
            val1:setText( nkpValueStr )
            if ( string.len( nkpValueStr ) >= nkpMaxChars ) then doOKBtn( event ) end
        else
            num4:insert( display.newImage( "num4.png", true ) )
        end
    end
    num4:addEventListener("touch", onHit4 )

    local num5 = display.newGroup()
    num5:insert( display.newImage( "num5.png", true ) )
    num5.x = col2; num5.y = row2

    local function onHit5( event )
        num5:remove( 1 )
        if ( event.phase == "began" ) then
            media.playEventSound( "tap.caf" )
            num5:insert( display.newImage( "num5_P.png", true ) )
            nkpValueStr = nkpValueStr .. "5"
            val1:setText( nkpValueStr )
            if ( string.len( nkpValueStr ) >= nkpMaxChars ) then doOKBtn( event ) end
        else
            num5:insert( display.newImage( "num5.png", true ) )
        end
    end
    num5:addEventListener("touch", onHit5 )

    local num6 = display.newGroup()
    num6:insert( display.newImage( "num6.png", true ) )
    num6.x = col3; num6.y = row2

    local function onHit6( event )
        num6:remove( 1 )
        if ( event.phase == "began" ) then
            media.playEventSound( "tap.caf" )
            num6:insert( display.newImage( "num6_P.png", true ) )
            nkpValueStr = nkpValueStr .. "6"
            val1:setText( nkpValueStr )
            if ( string.len( nkpValueStr ) >= nkpMaxChars ) then doOKBtn( event ) end
        else
            num6:insert( display.newImage( "num6.png", true ) )
        end
    end
    num6:addEventListener("touch", onHit6 )

    local num1 = display.newGroup()
    num1:insert( display.newImage( "num1.png", true ) )
    num1.x = col1; num1.y = row3

    local function onHit1( event )
        num1:remove( 1 )
        if ( event.phase == "began" ) then
            media.playEventSound( "tap.caf" )
            num1:insert( display.newImage( "num1_P.png", true ) )
            nkpValueStr = nkpValueStr .. "1"
            val1:setText( nkpValueStr )
            if ( string.len( nkpValueStr ) >= nkpMaxChars ) then doOKBtn( event ) end
        else
            num1:insert( display.newImage( "num1.png", true ) )
        end
    end
    num1:addEventListener("touch", onHit1 )

    local num2 = display.newGroup()
    num2:insert( display.newImage( "num2.png", true ) )
    num2.x = col2; num2.y = row3

    local function onHit2( event )
        num2:remove( 1 )
        if ( event.phase == "began" ) then
            media.playEventSound( "tap.caf" )
            num2:insert( display.newImage( "num2_P.png", true ) )
            nkpValueStr = nkpValueStr .. "2"
            val1:setText( nkpValueStr )
            if ( string.len( nkpValueStr ) >= nkpMaxChars ) then doOKBtn( event ) end
        else
            num2:insert( display.newImage( "num2.png", true ) )
        end
    end
    num2:addEventListener("touch", onHit2 )

    local num3 = display.newGroup()
    num3:insert( display.newImage( "num3.png", true ) )
    num3.x = col3; num3.y = row3

    local function onHit3( event )
        num3:remove( 1 )
        if ( event.phase == "began" ) then
            media.playEventSound( "tap.caf" )
            num3:insert( display.newImage( "num3_P.png", true ) )
            nkpValueStr = nkpValueStr .. "3"
            val1:setText( nkpValueStr )
            if ( string.len( nkpValueStr ) >= nkpMaxChars ) then doOKBtn( event ) end
        else
            num3:insert( display.newImage( "num3.png", true ) )
        end
    end
    num3:addEventListener("touch", onHit3 )

    local numDot = display.newGroup()
    if ( nkpShowDot ) then
        numDot:insert( display.newImage( "numDot.png", true ) )
        numDot.x = col1; numDot.y = row4
    end

    local function onHitDot( event )
        numDot:remove( 1 )
        if ( event.phase == "began" ) then
            media.playEventSound( "tap.caf" )
            numDot:insert( display.newImage( "numDot_P.png", true ) )
            nkpValueStr = nkpValueStr .. "."
            val1:setText( nkpValueStr )
            if ( string.len( nkpValueStr ) >= nkpMaxChars ) then doOKBtn( event ) end
        else
            numDot:insert( display.newImage( "numDot.png", true ) )
        end
    end
	if ( nkpShowDot ) then numDot:addEventListener("touch", onHitDot ) end

    local num0 = display.newGroup()
    num0:insert( display.newImage( "num0.png", true ) )
    num0.x = col2; num0.y = row4

    local function onHit0( event )
        num0:remove( 1 )
        if ( event.phase == "began" ) then
            media.playEventSound( "tap.caf" )
            num0:insert( display.newImage( "num0_P.png", true ) )
            nkpValueStr = nkpValueStr .. "0"
            val1:setText( nkpValueStr )
            if ( string.len( nkpValueStr ) >= nkpMaxChars ) then doOKBtn( event ) end
        else
            num0:insert( display.newImage( "num0.png", true ) )
        end
    end
    num0:addEventListener("touch", onHit0 )

    local numDel = display.newGroup()
    numDel:insert( display.newImage( "numDel.png", true ) )
    numDel.x = col3; numDel.y = row4

    local function onHitDel( event )
        numDel:remove( 1 )
        if ( event.phase == "began" ) then
            media.playEventSound( "tap.caf" )
            numDel:insert( display.newImage( "numDel_P.png", true ) )
            -- act as a backspace key
            nkpValueStr = string.sub( nkpValueStr,1,-2 )           -- all but the last char
            val1:setText( nkpValueStr )
        else
            numDel:insert( display.newImage( "numDel.png", true ) )
        end
    end
    numDel:addEventListener("touch", onHitDel )

    nkp:insert( num7 )
    nkp:insert( num8 )
    nkp:insert( num9 )
    nkp:insert( num4 )
    nkp:insert( num5 )
    nkp:insert( num6 )
    nkp:insert( num1 )
    nkp:insert( num2 )
    nkp:insert( num3 )
    nkp:insert( num0 )
    if ( nkpShowDot ) then nkp:insert( numDot ) end
    nkp:insert( numDel )

    local okBtn = display.newImage( "okBtn.png", true )
    okBtn.x = col2; okBtn.y = row6

--  send back the final result on OK hit
    function doOKBtn( event )
        media.playEventSound( "tap.caf" )
        doExit()
-- tack the returning value onto the event object, so the calling program can grab it
        if ( nkpValueStr ~= "" ) then
            nkpValueStr = tostring( tonumber( nkpValueStr ) + 0 )
            nkpValueStr = string.sub( nkpValueStr,1, nkpMaxChars )
        end
        local event = { name="nkpCompleted", target=Runtime, value=nkpValueStr }
        Runtime:dispatchEvent( event )
        nkp:removeSelf()
    end
    okBtn:addEventListener( "touch", doOKBtn )
    nkp:insert( okBtn )

    local cancelBtn = display.newImage( "cancelBtn.png", true )
    cancelBtn.x = col3 + 20; cancelBtn.y = row6

    local function doCancelBtn( event )
        media.playEventSound( "tap.caf" )
        doExit()
-- tack the (nil) returning value onto the event object, so the calling program can see it
        local event = { name="nkpCompleted", target=Runtime, value=nil }
        Runtime:dispatchEvent( event )
        nkp:removeSelf()
    end
    cancelBtn:addEventListener( "touch", doCancelBtn )
    nkp:insert( cancelBtn )

	function doExit()
	    num7:removeEventListener( "touch", onHit7 )
	    num8:removeEventListener( "touch", onHit8 )
	    num9:removeEventListener( "touch", onHit9 )
	    num4:removeEventListener( "touch", onHit4 )
	    num5:removeEventListener( "touch", onHit5 )
	    num6:removeEventListener( "touch", onHit6 )
	    num1:removeEventListener( "touch", onHit1 )
	    num2:removeEventListener( "touch", onHit2 )
	    num3:removeEventListener( "touch", onHit3 )

	    if ( nkpShowDot ) then numDot:removeEventListener( "touch", onHitDot ) end
	    num0:removeEventListener( "touch", onHit0 )
	    numDel:removeEventListener( "touch", onHitDel )
	    okBtn:removeEventListener( "touch", doOKBtn )
	    cancelBtn:removeEventListener( "touch", doCancelBtn )
	    killOverlay()
	end

    return nkp
end
