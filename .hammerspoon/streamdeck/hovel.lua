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
  ['stateProvider'] = function()
    return {
      ['scene'] = hovelScene
    }
  end,
  ['image'] = streamdeck_imageFromSvgFile('sun-dim'),
  ['onClick'] = activateScreentime,
  ['onLongPress'] = lightsOff
}

conferenceButton = {
  ['stateProvider'] = function()
    return {
      ['scene'] = hovelScene
    }
  end,
  ['image'] = streamdeck_imageFromSvgFile('sun-bright'),
  ['onClick'] = activateConference,
  ['onLongPress'] = lightsOff
}
