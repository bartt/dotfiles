require('util')

local showRunning = true

favoriteAppsButton = {
  ['name'] = 'favorite apps',
  ['image'] = streamdeck_imageFromSvgFile('favorite-app'),
  ['children'] = function()
    local children = {}
    children[#children + 1] = peekButtonFor('com.blackmagic-design.DaVinciResolve', showRunning)
    children[#children + 1] = peekButtonFor('com.captureone.captureone16', showRunning)
    children[#children + 1] = peekButtonFor('com.ononesoftware.ON1PhotoRAW2023.premium', showRunning)
    children[#children + 1] = peekButtonFor('com.microsoft.VSCode', showRunning)
    children[#children + 1] = peekButtonFor('org.mozilla.firefox', showRunning)
    children[#children + 1] = peekButtonFor('com.binarynights.ForkLift', showRunning)
    children[#children + 1] = peekButtonFor('com.reederapp.rkit2.mac', showRunning)
    children[#children + 1] = peekButtonFor('net.kovidgoyal.calibre', showRunning)
    children[#children + 1] = peekButtonFor('com.hamrick.vuescan', showRunning)
    return children
  end
}