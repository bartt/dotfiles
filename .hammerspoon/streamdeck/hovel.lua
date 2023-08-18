-- The hovel, aka. my office.
require('alfred')
require('hue')
require('util')

local hovelScene = nil

function activateConference()
    hovelScene = 'conference'
    setBacklightState('on')
    setHueState(hovelScene)
    setDesklightState(hovelScene)
end

function activateScreentime()
    hovelScene = 'screentime'
    setBacklightState('on')
    setHueState(hovelScene)
    setDesklightState('off')
end

function lightsOff(holding)
    if holding then
        hovelScene = nil
        setBacklightState('off')
        setHueState('off')
        setDesklightState('off')
    end
end

screentimeButton = {
    ['name'] = 'screentime',
    ['stateProvider'] = function()
        return {
            ['scene'] = hovelScene,
            ['timestamp'] = os.date('*t')
        }
    end,
    ['imageProvider'] = function(context)
        local elements = {}
        elements[#elements + 1] = elementFromSvgFile('sun-dim')
        if context['state']['scene'] == 'screentime' then
            elements[#elements + 1] = {
                ['type'] = 'circle',
                ['radius'] = 22,
                ['fillColor'] = systemYellowColor
            }
        end
        return streamdeck_imageWithCanvasContents(elements)
    end,
    ['onClick'] = activateScreentime,
    ['onLongPress'] = lightsOff,
    ['updateInterval'] = 1
}

conferenceButton = {
    ['name'] = 'conference',
    ['stateProvider'] = function()
        return {
            ['scene'] = hovelScene,
            ['timestamp'] = os.date('*t')
        }
    end,
    ['imageProvider'] = function(context)
        local elements = {}
        elements[#elements + 1] = elementFromSvgFile('sun-bright')
        if context['state']['scene'] == 'conference' then
            elements[#elements + 1] = {
                ['type'] = 'circle',
                ['radius'] = 22,
                ['fillColor'] = systemYellowColor
            }
        end
        return streamdeck_imageWithCanvasContents(elements)
    end,
    ['onClick'] = activateConference,
    ['updateInterval'] = 1
}

hovelButton = {
    ['name'] = 'hovel',
    ['image'] = streamdeck_imageFromSvgFile('desk'),
    ['children'] = function()
        local children = {}
        children[#children + 1] = screentimeButton
        children[#children + 1] = conferenceButton
        return children
    end
}
