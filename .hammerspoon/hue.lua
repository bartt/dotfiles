-- Philips Hue
require('util')
local json = require("dkjson")

local bridgeIp = "192.168.0.216"
local apiKey = "wiRGVkmNAaiRFdY2-GPzGwJkQG5SVIFhIuCgm0Bs"
local lightId = "eacf6bff-cc7d-40ec-88c2-004ec0e26919"
local url = "https://" .. bridgeIp .. "/clip/v2/resource/light/" .. lightId

local function generateData(options)
    local data = {
        ['dimming'] = {
            ['brightness'] = options['brightness'] or 0,
            ['color'] = {
                ['xy'] = options['color'] or {
                    ['x'] = 0,
                    ['y'] = 0
                }
            }
        },
        ['on'] = {
            ['on'] = options['on'] or false
        }
    }
    return json.encode(data)
end

local function generateCommand(data)
    return "curl -k -H 'hue-application-key:" .. apiKey .. "' -X PUT -d '" .. data .. "' " .. url .. " &"
end

local function executeCommand(data)
    local command = generateCommand(generateData(data))
    dbg(command)
    hs.execute(command)
end

function setHueState(state)
    local data = {
        ['brightness'] = 0,
        ['on'] = false,
        ['color'] = {
            ['x'] = 0.3,
            ['y'] = 0.31
        }
    }
    if state == 'screentime' then
        data['brightness'] = 20.0
        data['on'] = true
    elseif state == 'conference' then
        data['brightness'] = 100.0
        data['on'] = true
    end
    executeCommand(data)
end
