-- peterhajas's Hammerspoon config file
-- Originally written Jan 4, 2015

-- Clear the console
hs.console.clearConsole()

-- Start profiling
require("profile")

hs.alert.show("hs...")

profileStart('imports')
profileStart('configTotal')

require("hs.ipc")
hs.ipc.cliInstall()

require "emoji"
require "hyper"
require "preferred_screen"
require "brightness_control"
require "grid"
require "darkmode"
require "audio_output"
require "choose"
require "streamdeck"
require "link_replace"

profileStop('imports')
profileStart('globals')
-- Global 'doc' variable that I can use inside of the Hammerspoon {{{

doc = hs.doc

-- }}}
-- Global 'inspectThing' function for inspecting objects {{{

function inspectThing(thing)
    return hs.inspect.inspect(thing)
end

-- }}}
-- Global variables {{{
hs.window.animationDuration = 0.0
caffeinateWatcher = nil
pasteboardWatcher = nil
-- }}}
profileStop('globals')
-- Finding all running GUI apps {{{

function allRunningApps()
    local allApps = hs.application.runningApplications()
    local allRunningApps = {}

    for idx,app in pairs(allApps) do
        -- Ignore Hammerspoon
        if app:mainWindow() ~= nil and app:title() ~= "Hammerspoon" then
            table.insert(allRunningApps, app)
        end
    end

    return allRunningApps
end

-- }}}
-- Notifying {{{

function notifySoftly(notificationString)
    hs.alert.show(notificationString)
end

function notify(notificationString)
    local notification = hs.notify.new()
    notification:title(notificationString)
    notification:send()
end

hs.urlevent.bind("notifySoftly", function(eventName, params)
    local text = params["text"]
    if text then
        notifySoftly(text)
    end
end)

hs.urlevent.bind("notify", function(eventName, params)
    local text = params["text"]
    if text then
        notify(text)
    end
end)

-- }}}
-- Other Shortcuts {{{

-- Hyper-escape to toggle the Hammerspoon console

hs.hotkey.bind(hyper, "escape", function()
    hs.toggleConsole()
end)

-- }}}

profileStart('noises')
-- Noises {{{
-- Just playing for now with this config:
-- https://github.com/trishume/dotfiles/blob/master/hammerspoon/hammerspoon.symlink/init.lua
-- This stuff is wild, and it works!
listener = nil
popclickListening = false
local scrollDownTimer = nil
function popclickHandler(evNum)
  if evNum == 1 then
    scrollDownTimer = hs.timer.doEvery(0.02, function()
      hs.eventtap.scrollWheel({0,-10},{}, "pixel")
      end)
  elseif evNum == 2 then
    if scrollDownTimer then
      scrollDownTimer:stop()
      scrollDownTimer = nil
    end
  elseif evNum == 3 then
    hs.eventtap.scrollWheel({0,250},{}, "pixel")
  end
end

function popclickPlayPause()
  if not popclickListening then
    listener:start()
    hs.alert.show("listening")
  else
    listener:stop()
    hs.alert.show("stopped listening")
  end
  popclickListening = not popclickListening
end
popclickListening = false
local fn = popclickHandler
listener = hs.noises.new(fn)
-- }}}
profileStop('noises')
profileStart('screenChanges')
-- {{{ Screen Changes
--- Watch screen change notifications, and reload certain components when the
--screen configuration changes

function handleScreenEvent()
    updateGridsForScreens()
end

screenWatcher = hs.screen.watcher.new(handleScreenEvent)
screenWatcher:start()

-- }}}
profileStop('screenChanges')
profileStart('caffeinate')
-- {{{ Caffeinate

function caffeinateCallback(eventType)
    if (eventType == hs.caffeinate.watcher.screensDidSleep) then
    elseif (eventType == hs.caffeinate.watcher.screensDidWake) then
        -- Do nothing
    elseif (eventType == hs.caffeinate.watcher.screensDidLock) then
        -- streamdeck_sleep()
    elseif (eventType == hs.caffeinate.watcher.screensDidUnlock) then
        streamdeck_wake()
    end
end

caffeinateWatcher = hs.caffeinate.watcher.new(caffeinateCallback)
caffeinateWatcher:start()
-- }}}
profileStop('caffeinate')
profileStart('pasteboard')
-- {{{ Pasteboard
pasteboardWatcher = hs.pasteboard.watcher.new(function(contents)
    replacePasteboardLinkIfNecessary(contents)
end)
-- }}}
profileStop('pasteboard')
profileStart('reloading')
-- Reloading {{{
-- I can reload the config when this file changes. From:
-- http://www.hammerspoon.org/go/#fancyreload
function reload_config(files)
    hs.reload()
end

hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()

-- }}}
profileStop('reloading')
-- AXBrowse {{{
-- local axbrowse = require("axbrowse")
-- local lastApp
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "b", function()
--  local currentApp = hs.axuielement.applicationElement(hs.application.frontmostApplication())
--  if currentApp == lastApp then
--      axbrowse.browse() -- try to continue from where we left off
--  else
--      lastApp = currentApp
--      axbrowse.browse(currentApp) -- new app, so start over
--  end
-- end)
-- }}}

-- {{ Bootstrapping


hs.alert.show("hs ready!")

profileStop('configTotal')

