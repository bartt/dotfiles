require('util')

local ipAddress = '192.168.0.35'
local port = '3333'
local deviceId = 'n13BeQNO'
local socketUrl = 'ws://' .. ipAddress .. ':' .. port
dbg('websocket url = ' .. socketUrl)

local function socketCallback(state, message)
  dbg('websocker state = ' .. state .. ', message = ' .. message)
  -- Yields: 2023-08-18 17:02:36:               debug: table: 0x600000243740 "websocker state = fail, message = Invalid Sec-WebSocket-Accept response"
end

hs.websocket.new(socketUrl, socketCallback)