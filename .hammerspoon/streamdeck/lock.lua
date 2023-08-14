lockButton = {
    ['name'] = 'Lock',
    ['image'] = streamdeck_imageFromText('🔒'),
    ['onClick'] = function()
        hs.caffeinate.lockScreen()
    end
}
