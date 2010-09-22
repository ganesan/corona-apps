-- This code demonstrates how to show a native activity indicator 
-- while connecting to a remote location and downloading a file.
 
--Add a button to the screen
local button = display.newGroup()
 
buttonBg = display.newRoundedRect(0, 0, 220, 40, 20)
buttonBg:setFillColor(255, 255, 255, 50)
button:insert(buttonBg)
 
buttonText = display.newText("Press to Update", 0, 0, native.systemFontBold, 14)
buttonText:setTextColor(255, 255, 255)
button:insert(buttonText)
buttonText.x = button.width*.5
buttonText.y = buttonBg.height*.5
 
button.x = display.stageWidth*.5 - button.width*.5
button.y = display.stageHeight - button.height*2
 
-- Set the url of the file to download
local url = "http://api.flickr.com/services/feeds/photos_public.gne?lang=en-us&format=rss_200&tags=night"
 
function updateXML()
        Runtime:removeEventListener("enterFrame", updateXML)                    
 
        local http = require("socket.http")
        local ltn12 = require("ltn12")
           
        --Check for a connection to the host
        r, c, h = http.request{
        method = "HEAD", 
        url = url
        }        
        local hostFound 
        if c == 200 then
        print("host found!")
        hostFound = true
        else 
                hostFound = false
        print("host not found")
        buttonText.text = "Unable to Connect to Host"
        end     
         
        --If a connection was found, save the content to a local file
        if hostFound then
                local path = system.pathForFile( "mos.content", system.DocumentsDirectory )
                local myFile = io.open( path, "w+b" )
        http.request{
                url = url,
                sink = ltn12.sink.file(myFile)
        --      sink = ltn12.sink.file(io.stdout)
        }
                                 
        --Open the file containing the content we received
        local file = io.open(path, "r")
        local content = file:read("*a")
        
        --Show the content in the terminal
        print(content)
 
                --Update the button text
                buttonText.text = "Update Complete!"
                print("Update Complete")
        end
 
        --Remove the activity indicator
        native.setActivityIndicator( false )
end
 
function buttonRelease(self, event)
        local phase = event.phase
        local t = event.target
 
        if "began" == phase then
 
                display.getCurrentStage():setFocus( t )
                t.isFocus = true
 
                -- Update the button text
                buttonText.text = "Updating"
 
        elseif t.isFocus then
                local bounds = self.stageBounds
                local x,y = event.x,event.y
                local isWithinBounds = 
                        bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y
 
                if phase == "ended" then
                
                        -- Only consider this a "click" if the user lifts their finger inside button's stageBounds
                        if isWithinBounds then
                                display.getCurrentStage():setFocus( nil )
                                t.isFocus = false
        
                                -- Start the activity indicator
                                native.setActivityIndicator( true )
                                                
                                -- Run the xml update in the next frame
                                Runtime:addEventListener("enterFrame", updateXML)                       
                        else
                                -- Update the button text
                                buttonText.text = "Press to Update"
                        end
 
                end
                
        end
 
        return true
end
 
button.touch = buttonRelease
button:addEventListener("touch", button)