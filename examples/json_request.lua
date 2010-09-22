http = require("socket.http")
crypto = require("crypto")
ltn12 = require("ltn12")
url = require("socket.url")
require("Json")
 
local commands_json = 
{
        {
                ["command"] = "search"
        }
}
 
local json = {}
json.api_key = "6_192116334"
json.ver = 1
json.commands_json = Json.Encode(commands_json)
json.commands_hash = crypto.digest(crypto.md5, json.commands_json .. 'hkjhkjhkjh')
 
local post = "api=" .. url.escape(Json.Encode(json))
local response = {}
 
local r, c, h = http.request {
    url = "http://127.0.0.1/?page=api",
    method = "POST",
    headers = {
        ["content-length"] = #post,
        ["Content-Type"] =  "application/x-www-form-urlencoded"
    },
    source = ltn12.source.string(post),
    sink = ltn12.sink.table(response)
}
 
local path = system.pathForFile("r.txt", system.DocumentsDirectory)
local file = io.open (path, "w")
file:write (Json.Encode(json) .. "\n")
file:write (post .. "\n")
file:write (response[1] .. "\n")
io.close (file)
 
json = Json.Decode(table.concat(response,''))
native.showAlert("hey", json.commands[1].tot_nbr_rows)