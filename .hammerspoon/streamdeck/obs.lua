require "util"

obs = hs.loadSpoon("OBS")

local obsScenes = {}
local obsCurrentSceneName = nil
local obsIsConnected = false
local obsIsVirtualCamOn = false
local obsIsStudioEnabled = false
local isMicrophoneOn = true

local function updateScreenshots()
    if obsIsConnected then
        obs:request('GetSceneList')
        local sceneCount = 0
        for k,v in pairs(obsScenes) do
            sceneCount = sceneCount + 1
        end
        if sceneCount > 0 then
            getScreenshots(obsScenes)
        end
    end
end

obsCallback = function(eventType, eventIntent, eventData)
    print(eventType)
    print(eventIntent)
    if not (eventType == 'SpoonBatchRequestResponse') then
        -- dbg(eventData)
    end

    if eventType == 'SpoonOBSConnected' then
        obsIsConnected = true
        updateScreenshots()
    end

    if eventType == 'SpoonOBSDisconnected' then
        obsIsConnected = false
        obsIsVirtualCamOn = false
        obsCurrentSceneName = nil
        obsScenes = {}
        isMicrophoneOn = true
    end

    if eventType == 'VirtualcamStateChanged' then
        obsIsVirtualCamOn = eventData['outputActive']
    end

    if eventType == 'CurrentProgramSceneChanged' then
        obsCurrentSceneName = eventData['sceneName']
    end

    if eventType == 'StudioModeStateChanged' then 
        dbg(eventData)
        obsIsStudioEnabled = eventData['studioModeEnabled']
    end

    if eventType == 'SpoonRequestResponse' then
        dbg(eventData)
        -- Do we have a successful request response?
        if eventData['responseData'] then
            local responseData = eventData['responseData']
            if eventData['requestType'] == 'GetSceneList' then
                obsCurrentSceneName = responseData['currentProgramSceneName'] or obsCurrentSceneName
                obsScenes = getScenes(responseData['scenes']) or obsScenes
                -- dbg(obsScenes)
            end

            if eventData['requestType'] == 'GetVirtualCamStatus' then
              obsIsVirtualCamOn = responseData['outputActive']
            end
        end
    end

    if eventType == 'SpoonBatchRequestResponse' then
        for i, eventData in pairs(eventData['results']) do
            -- dbg(eventData)
            if eventData['requestType'] == 'GetSourceScreenshot' then
                local imageData = eventData['responseData'] and eventData['responseData']['imageData']
                -- The request was made with the sceneName as the requestId. 
                local sceneName = eventData['requestId']
                obsScenes[sceneName] = imageData or obsScenes[sceneName]
            end
        end
    end
end

obsBundleId = 'com.obsproject.obs-studio'

obs:init(obsCallback, "192.168.0.118", 4455, "6ucP8jTMqTj6r.GFWsfY",
    obs.eventSubscriptionValues.Outputs | obs.eventSubscriptionValues.Scenes)

obsButton = {
    ['name'] = 'OBS',
    ['stateProvider'] = function()
        return {
            ['connected'] = obsIsConnected,
            ['virtualCamOn'] = obsIsVirtualCamOn
        }
    end,
    ['imageProvider'] = function(context)
        local elements = {}
        if context['state']['virtualCamOn'] then
            elements[#elements + 1] = elementBackground(systemRedColor)
        end
        elements[#elements + 1] = {
            type = 'image',
            image = hs.image.imageFromAppBundle(obsBundleId)
        }
        local obsState = 'inactive'
        if (context['state']['connected']) then
            obsState = 'active'
        end
        elements[#elements + 1] = {
            type = 'image',
            image = gifImageFromSvgFile(obsState),
            frame = {
                x = 61,
                y = 61,
                w = 30,
                h = 30
            }
        }
        return streamdeck_imageWithCanvasContents(elements)
    end,
    ['onClick'] = function()
        activateConference()
        if (hs.application.get(obsBundleId) == nil) then
            hs.execute('rm -f "$HOME/Library/Application Support/obs-studio/safe_mode"')
            hs.application.open(obsBundleId, 0, true)
            obs:start()
        else
            if (not obsIsConnected) then
                obs:start()
            end
        end
        updateScreenshots()
    end,
    ['onLongPress'] = function(holding)
        if holding then
            if obsIsVirtualCamOn then
                obs:request('ToggleVirtualCam')
            end
            hs.timer.waitWhile(function()
                return obsIsVirtualCamOn
            end, function() 
                obs:stop()                
            end)
            hs.timer.waitWhile(function()
                return obsIsConnected
            end, function()
                activateScreentime()
                local obsApp = hs.application.get(obsBundleId)
                if obsApp then
                    obsApp:kill9()
                end
            end)
        end
    end,
    ['children'] = function()
        local out = {}
        out[#out + 1] = webcamButton
        out[#out + 1] = microphoneButton
        out[#out + 1] = screentimeButton
        out[#out + 1] = conferenceButton
        -- out[#out + 1] = studioButton
        for sceneName, sceneImage in pairs(obsScenes) do
            out[#out + 1] = sceneButton(sceneName)
        end
        return out
    end,
    ['updateInterval'] = 1
}

webcamButton = {
    ['stateProvider'] = function()
        return {
            ['connected'] = obsIsConnected,
            ['virtualCamOn'] = obsIsVirtualCamOn
        }
    end,
    ['imageProvider'] = function(context)
        local elements = {}
        if context['state']['virtualCamOn'] then
            elements[#elements + 1] = elementBackground(systemRedColor)
        end
        elements[#elements + 1] = elementFromSvgFile('webcam')
        return streamdeck_imageWithCanvasContents(elements)
    end,
    ['onClick'] = function()
        obs:request('ToggleVirtualCam')
    end,
    ['updateInterval'] = 1
}

microphoneButton = {
    ['stateProvider'] = function()
        return {
            ['microphoneOn'] = isMicrophoneOn
        }
    end,
    ['imageProvider'] = function(context)
        local elements = {}
        local microphoneSvg = 'microphone-off'
        if context['state']['microphoneOn'] then
            elements[#elements + 1] = elementBackground(systemRedColor)
            microphoneSvg = 'microphone-on'
        end
        elements[#elements + 1] = elementFromSvgFile(microphoneSvg)
        return streamdeck_imageWithCanvasContents(elements)
    end,
    ['onClick'] = function()
        local success = hs.osascript.applescriptFromFile('osascript/meet-microphone.applescript')
        if (success) then 
            isMicrophoneOn = not isMicrophoneOn
        else 
            print("Failed to toggle Meet microphone")
        end
    end,
    ['updateInterval'] = 1
}

studioButton = {
    ['stateProvider'] = function() 
        return {
            ['enabled'] = obsIsStudioEnabled
        }
    end,
    ['imageProvider'] = function(context)
        dbg(context)
        local elements = {}
        local studioSvg = 'obs-studio'
        if context['state']['enabled'] then
            elements[#elements + 1] = elementBackground(systemRedColor)
        end
        elements[#elements + 1] = elementFromSvgFile(studioSvg)
        return streamdeck_imageWithCanvasContents(elements)
    end,
    ['onClick'] = function()
        local properties = {
            ['studioModeEnabled'] = not obsIsStudioEnabled
        }
        dbg(properties)
        obs:request('SetStudioModeEnabled', properties)
    end,
    ['updateInterval'] = 1
}

function sceneButton(sceneName)
    local sceneName = sceneName
    return {
        ['stateProvider'] = function()
            return {
                ['name'] = sceneName,
                ['active'] = sceneName == obsCurrentSceneName,
                ['timestamp'] = os.date('*t')
            }
        end,
        ['imageProvider'] = function(context)
            local elements = {}
            elements[#elements + 1] = {
                type = 'image',
                image = hs.image.imageFromURL(obsScenes[sceneName]),
                imageScaling = 'shrinkToFit'
            }
            elements[#elements + 1] = {
                type = 'image',
                image = hs.image.imageFromAppBundle(obsBundleId),
                frame = {
                    x = 5,
                    y = 5,
                    w = 30,
                    h = 30
                }
            }
            if context['state']['active'] then
                elements[#elements + 1] = {
                    type = 'image',
                    image = gifImageFromSvgFile("webcam"),
                    frame = {
                        x = 61,
                        y = 61,
                        w = 30,
                        h = 30
                    }
                }
            end
            return streamdeck_imageWithCanvasContents(elements)
        end,
        ['onClick'] = function(context)
            obs:request('SetCurrentProgramScene', {
                ['sceneName'] = sceneName
            })
        end,
        ['name'] = sceneName,
        ['updateInterval'] = 1
    }
end

function getScenes(scenesData)
    if scenesData == nil then
        return nil
    end
    local scenes = {}
    for i, scene in pairs(scenesData) do
        scenes[scene.sceneName] = ""
    end
    getScreenshots(scenes)
    return scenes
end

function getScreenshots(scenes)
    local requests = {}
    for sceneName, imageData in pairs(scenes) do
        table.insert(requests, {
            requestType = "SetCurrentProgramScene",
            requestData = {
                ["sceneName"] = sceneName
            }
        })
        -- Add a delay to ensure the scene can be rendered before taking a screenshot.
        table.insert(requests, {
            requestType = "Sleep",
            requestData = {
                ["sleepMillis"] = 100
            }
        })
        -- Use the sceneName as the requestId so that the response event handler can store the screenshot with the right scene.
        table.insert(requests, {
            requestType = "GetSourceScreenshot",
            requestData = {
                sourceName = sceneName,
                imageHeight = buttonHeight,
                imageFormat = "png"
            },
            requestId = sceneName
        })
    end
    -- Return to the original scene
    table.insert(requests, {
        requestType = "SetCurrentProgramScene",
        requestData = {
            ["sceneName"] = obsCurrentSceneName
        }
    })
    -- dbg(requests)
    obs:requestBatch(requests)
end

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

if hs.application.get(obsBundleId) ~= nil and not obsIsConnected then
    obs:start()
end
