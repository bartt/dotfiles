lockButton = {
    ['name'] = 'Lock',
    ['image'] = streamdeck_imageFromSvgFile('lock'),
    ['onClick'] = function()
        hs.caffeinate.lockScreen()
    end
}
