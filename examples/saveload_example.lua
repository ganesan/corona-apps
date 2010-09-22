local myBox = display.newRect(0, 0, 40, 40)
myBox:setFillColor(255, 255, 0)
 
local function moveBox( event )
        myBox.x = event.x 
        myBox.y = event.y 
end
 
local function resumeStart()
                -- restore previous state
                local path = system.pathForFile( "data.txt", system.DocumentsDirectory )                
                local file = io.open( path, "r" )
                
                if file then
                        print("loading previous state variables...")
                        local contents = file:read( "*a" )
                
                        -- separate the variables into a table using a helper function
                        local prevState = explode(", ", contents)
                        
                        myBox.x = prevState[1]
                        myBox.y = prevState[2]
                                                                                
                        io.close( file )
                else 
                        myBox.x = display.stageWidth/2
                        myBox.y = display.stageHeight/2
                end
end
 
local function onSystemEvent( event )
        if( event.type == "applicationExit" ) then              
                -- create a file to save current state
                local path = system.pathForFile( "data.txt", system.DocumentsDirectory )                
                local file = io.open( path, "w+b" )
                
                -- save current state variables in comma separated list
                file:write( myBox.x ..", ".. myBox.y )          
                io.close( file )
        end
end
 
-- explode helper function
function explode(div,str)
  if (div=='') then return false end
  local pos,arr = 0,{}
  -- for each divider found
  for st,sp in function() return string.find(str,div,pos,true) end do
    table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
    pos = sp + 1 -- Jump past current divider
  end
  table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
  return arr
end
 
local function init()
        -- start and resume from previous state, if any
        resumeStart()   
        
        myBox:addEventListener("touch", moveBox)
 
        Runtime:addEventListener( "system", onSystemEvent )     
end
 
 
--start the program
init()