require "streamdeck.audio_devices"
require "streamdeck.terminal"
require "streamdeck.peek"
require "streamdeck.url"
require "streamdeck.lock"
require "streamdeck.clock"
require "streamdeck.weather"
require "streamdeck.obs"
require "streamdeck.app_switcher"
require "streamdeck.window_switcher"
require "streamdeck.function_keys"
require "streamdeck.shortcuts"
require "streamdeck.soundboard"
require "streamdeck.nonce"
require "streamdeck.hovel"
require "streamdeck.favorite_apps"
require "streamdeck.printer_lights"

initialButtonState = {
    ['name'] = 'Root',
    ['buttons'] = {
        weatherButton(),
        -- calendarPeekButton(),
        -- clockButton,
        appSwitcher(),
        windowSwitcher(),
        favoriteAppsButton,
        obsButton,

        audioDeviceButton(false),
        audioDeviceButton(true),
        cpuButton,
        memoryButton, 
        lockButton,

        functionKeys(),
        pinterLightKeys(),
        hovelButton,
        screentimeButton,
        conferenceButton,
        
        -- peekButtonFor('com.reederapp.rkit2.mac'),
        -- soundboardButton(),
    }
}
