require "streamdeck.audio_devices"
require "streamdeck.terminal"
require "streamdeck.peek"
require "streamdeck.url"
require "streamdeck.lock"
require "streamdeck.clock"
require "streamdeck.weather"
require "streamdeck.app_switcher"
require "streamdeck.window_switcher"
require "streamdeck.function_keys"
-- require "streamdeck.shortcuts"
require "streamdeck.soundboard"

initialButtonState = {
    ['name'] = 'Root',
    ['buttons'] = {
        weatherButton(),
        calendarPeekButton(),
        peekButtonFor('com.reederapp.rkit2.mac'),
        lockButton,
        clockButton,
        audioDeviceButton(false),
        audioDeviceButton(true),
        appSwitcher(),
        windowSwitcher(),
        functionKeys(),
        cpuButton,
        memoryButton,
        -- shortcuts(),
        -- soundboardButton(),
    }
}
