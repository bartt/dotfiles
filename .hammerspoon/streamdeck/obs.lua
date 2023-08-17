require "util"

obs = hs.loadSpoon("OBS")

obsScenes = {}
obsCurrentSceneName = nil
obsIsConnected = false
obsIsVirtualCamOn = false

obsCallback = function(eventType, eventIntent, eventData)
    print(eventType)
    print(eventIntent)
    if not (eventType == 'SpoonBatchRequestResponse') then
        dbg(eventData)
    end

    if eventType == 'SpoonOBSConnected' then
        obsIsConnected = true
        obs:request('GetSceneList')
        obs:request('GetVirtualCamStatus')
    end

    if eventType == 'SpoonOBSDisconnected' then
        obsIsConnected = false
        obsIsVirtualCamOn = false
        obsCurrentSceneName = nil
        obsScenes = {}
    end

    if eventType == 'VirtualcamStateChanged' then
        obsIsVirtualCamOn = eventData['outputActive']
    end

    if eventType == 'CurrentProgramSceneChanged' then
        obsCurrentSceneName = eventData['sceneName']
    end

    if eventType == 'SpoonRequestResponse' then
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
            dbg(eventData)
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

obs:init(obsCallback, "localhost", 4455, "6ucP8jTMqTj6r.GFWsfY",
    obs.eventSubscriptionValues.Outputs | obs.eventSubscriptionValues.Scenes)

obsButton = {
    ['name'] = 'OBS',
    ['stateProvider'] = function()
        return {
            connected = obsIsConnected,
            virtualCamOn = obsIsVirtualCamOn
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
        if (hs.application.get(obsBundleId) == nil) then
            hs.application.open(obsBundleId, 0, true)
            obs:start()
        else
            if (not obsIsConnected) then
                obs:start()
            end
        end
        if obsIsConnected and #obsScenes > 0 then
            getScreenshots(obsScenes)
        end
    end,
    ['onLongPress'] = function()
        if obsIsVirtualCamOn then
            obs:request('ToggleVirtualCam')
        end
        hs.timer.waitWhile(function()
            return obsIsVirtualCamOn
        end, function()
            local obsApp = hs.application.get(obsBundleId)
            if obsApp then
                obsApp:kill()
            end
        end)
    end,
    ['children'] = function()
        local out = {}
        out[#out + 1] = {
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
        for sceneName, sceneImage in pairs(obsScenes) do
            out[#out + 1] = sceneButton(sceneName)
        end
        return out
    end,
    ['updateInterval'] = 1
}

function sceneButton(sceneName)
    local sceneName = sceneName
    return {
        ['stateProvider'] = function()
            return {
                name = sceneName,
                active = sceneName == obsCurrentSceneName
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
