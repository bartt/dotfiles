obs = hs.loadSpoon("OBS")
obsCallback = function(eventType, eventIntent, eventData)
  print(eventType)
  print(eventIntent)
  print(hs.inspect(eventData))

end
obs:init(obsCallback, "localhost", 4455, "6ucP8jTMqTj6r.GFWsfY")
obs:start()

-- Tinker with hammerspoon:// URLs
hs.urlevent.bind("OBSVirtualCam", function(eventName, params, senderPID)
  parameters = ""
  for name, value in pairs(params) do
    parameters = parameters .. name .. "=" .. value .. ", "
  end
  -- hs.alert.show("Received " .. eventName .. ", with parameters: [" .. parameters .. "], senderPID: " .. senderPID)
  if params['action'] == "start" then
    return obs:request("StartVirtualCam")
  end
  if params['action'] == "stop" then
    return obs:request("StopVirtualCam")
  end
end)
