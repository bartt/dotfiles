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
-- require "streamdeck.shortcuts"
require "streamdeck.soundboard"
require ".streamdeck.nonce"

initialButtonState = {
    ['name'] = 'Root',
    ['buttons'] = {
        weatherButton(),
        calendarPeekButton(),
        clockButton,
        cpuButton,
        memoryButton,

        audioDeviceButton(false),
        audioDeviceButton(true),
        peekButtonFor('com.reederapp.rkit2.mac'),
        obsButton,
        nonceButton(),

        lockButton,
        appSwitcher(),
        windowSwitcher(),
        functionKeys(),
        -- soundboardButton(),
    }
}