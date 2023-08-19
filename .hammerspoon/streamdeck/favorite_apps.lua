require('util')

favoriteAppsButton = {
  ['name'] = 'favorite apps',
  ['image'] = streamdeck_imageFromSvgFile('favorite-app'),
  ['children'] = function()
    local children = {}
    children[#children + 1] = peekButtonFor('com.blackmagic-design.DaVinciResolve')
    children[#children + 1] = peekButtonFor('com.captureone.captureone16')
    children[#children + 1] = peekButtonFor('com.ononesoftware.ON1PhotoRAW2023.premium')
    children[#children + 1] = peekButtonFor('com.microsoft.VSCode')
    children[#children + 1] = peekButtonFor('com.reederapp.rkit2.mac')
    return children
  end
}