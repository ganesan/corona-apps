-- score.lua 
-- Author Michael Hartlef
-- Version 1.0
-- License: MIT
 
module(..., package.seeall)
Json = require("Json")
 
 
--****************************************************************
function newList(hsnum)
--****************************************************************
        scoreList = {}
        scoreList.entrycount = hsnum
        scoreList.list = {}
        local i = 0
        for i = hsnum,1,-1 do
                local ts = {}
                ts.name = "---"
                ts.points = 0
                table.insert(scoreList.list, ts)
        end
        
        
        --****************************************************************
        function scoreList:Load(fn)
        --****************************************************************
                local path = system.pathForFile( fn, system.DocumentsDirectory )
                -- io.open opens a file at path. returns nil if no file found
                local file = io.open( path, "r" )
                if file then
                        -- read all contents of file into a string
                        local contents = file:read( "*a" )
                        scoreList.list = Json.Decode(contents);
                        scoreList.entrycount = #scoreList.list
                        io.close( file )
                end
        end
        
        --****************************************************************
        function scoreList:Save(fn)
        --****************************************************************
                local path = system.pathForFile( fn, system.DocumentsDirectory )
                local file = io.open( path, "w" )
                if file then
                        local contents = Json.Encode(scoreList.list)
                        file:write( contents )
                        io.close( file )
                end
        end
        
        
        --****************************************************************
        function scoreList:CheckScore(p)
        --****************************************************************
                print ("#scoreList.list:"..#scoreList.list)
                local i = 0
                for i = 1,#scoreList.list,1 do
                        local ts = scoreList.list[i]
                        if ts.points < p then
                                return i
                        end
                end
                return 0
        end
        
        --****************************************************************
        function scoreList:StoreEntry(index,points,name)
        --****************************************************************
                local ts = {}
                ts.name = name
                ts.points = points
                table.insert(scoreList.list, index, ts)
                table.remove(scoreList.list,(scoreList.entrycount+1))
        end
        
        --****************************************************************
        function scoreList:Count()
        --****************************************************************
                return scoreList.entrycount
        end
        
        --****************************************************************
        function scoreList:GetName(i)
        --****************************************************************
                local ts = scoreList.list[i]
                return ts.name
        end
        
        --****************************************************************
        function scoreList:GetPoints(i)
        --****************************************************************
                local ts = scoreList.list[i]
                return ts.points
        end
        
        return scoreList
end