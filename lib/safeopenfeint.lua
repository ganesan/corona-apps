--[[
 
Name: safeopenfeint.lua
Author: Stuart Carnie, Manomio
Description: Safely wraps the openfeint module, which currently does not work on Corona Sim, Android and iPhone Simulator, preventing crashes or hanging apps
Change log:
  20100815 - Initial release
 
--]]
 
module(..., package.seeall)
 
local isiPhoneSim = system.getInfo("name") == "iPhone Simulator"
local isiOS = system.getInfo("platformName") == "iPhone OS"
local isCorona = system.getInfo("environment") == "simulator"
 
local isOFSupported = not isiPhoneSim and isiOS and not isCorona
 
if isOFSupported then
        local openfeint = require "openfeint"
end
 
function isSupported()
        return isOFSupported
end
 
function init(productKey, productSecret, displayName)
        if not isOFSupported then return end
        
        openfeint.init(productKey, productSecret, displayName)
end
 
function launchDashboard()
        if not isOFSupported then return end
        
        openfeint.launchDashboard()
end
 
function launchDashboardWithListLeaderboardsPage()
        if not isOFSupported then return end
        
        openfeint.launchDashboardWithListLeaderboardsPage()
end
 
function setHighScore( leaderboardId, score )
        if not isOFSupported then return end
        
        openfeint.setHighScore(leaderboardId, score)
end