function readScores()
        local path = system.pathForFile( "scores.txt", system.DocumentsDirectory )
        -- io.open opens a file at path. returns nil if no file found 
        local file = io.open( path, "r" )
        
        if file then
                -- read all contents of file into a string 
                local contents = file:read( "*a" ) 
                scoresList = Json.Decode(contents);
                
                io.close( file )
 
        end
end
 
function saveScores()
 
        local path = system.pathForFile( "scores.txt", system.DocumentsDirectory )
        
        -- create file b/c it doesn't exist yet 
        local file = io.open( path, "w" ) 
 
        if file then
                file:write( Json.Encode(scoresList) ) 
                io.close( file )
        end
                
end