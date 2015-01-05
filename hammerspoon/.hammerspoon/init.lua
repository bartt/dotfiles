-- peterhajas's Hammerspoon config file
-- Originally written Jan 4, 2015

-- This is defined in my Karabiner config

local hyper = {"ctrl", "alt", "shift"}

-- Because I define Ctrl-H/J/K/L to left/down/up/right, we need to do this
-- Grumble grumble

local hyperVimMovement = {"alt", "shift"}

-- Window Manipulation

function adjustForegroundWindowToUnitSize (x,y,w,h)
    local win = hs.window.focusedWindow()
    local windowScreen = win:screen()
    local screenFrame = windowScreen:frame()
    local frame = win:frame()

    frame.x = screenFrame.x + screenFrame.w * x
    frame.y = screenFrame.y + screenFrame.h * y
    frame.w = screenFrame.w * w
    frame.h = screenFrame.h * h

    win:setFrame(frame)
end

-- 50% manipulation

-- Bind hyper-H to move window to the left half of its current screen
hs.hotkey.bind(hyperVimMovement, "Left", function()
    adjustForegroundWindowToUnitSize(0,0,0.5,1)
end)

-- Bind hyper-L to move window to the right half of its current screen

hs.hotkey.bind(hyperVimMovement, "Right", function()
    adjustForegroundWindowToUnitSize(0.5,0.0,0.5,1)
end)

-- Bind hyper-K to move window to the top half of its current screen

hs.hotkey.bind(hyperVimMovement, "Up", function()
    adjustForegroundWindowToUnitSize(0,0,1,0.5)
end)

-- Bind hyper-L to move window to the bottom half of its current screen

hs.hotkey.bind(hyperVimMovement, "Down", function()
    adjustForegroundWindowToUnitSize(0,0.5,1,0.5)
end)

-- Bind hyper-: to move 75% sized window to the center

hs.hotkey.bind(hyper, ";", function()
    adjustForegroundWindowToUnitSize(0.125,0.125,0.75,0.7)
end)

-- 70% manipulation

-- Bind hyper-Y to move window to the left 70% of its current screen

hs.hotkey.bind(hyper, "Y", function()
    adjustForegroundWindowToUnitSize(0,0,0.7,1)
end)

-- Bind hyper-O to move window to the right 70% of its current screen

hs.hotkey.bind(hyper, "O", function()
    adjustForegroundWindowToUnitSize(0.3,0.0,0.7,1)
end)

-- Bind hyper-I to move window to the top 70% of its current screen

hs.hotkey.bind(hyper, "I", function()
    adjustForegroundWindowToUnitSize(0,0,1,0.7)
end)

-- Bind hyper-U to move window to the bottom 70% of its current screen

hs.hotkey.bind(hyper, "U", function()
    adjustForegroundWindowToUnitSize(0,0.3,1,0.7)
end)

-- Bind hyper-P to move 100% sized window to the center

hs.hotkey.bind(hyper, "P", function()
    adjustForegroundWindowToUnitSize(0,0,1,1)
end)

-- 30% manipulation

-- Bind hyper-N to move window to the left 30% of its current screen

hs.hotkey.bind(hyper, "N", function()
    adjustForegroundWindowToUnitSize(0,0,0.3,1)
end)

-- Bind hyper-. to move window to the right 30% of its current screen

hs.hotkey.bind(hyper, ".", function()
    adjustForegroundWindowToUnitSize(0.7,0.0,0.3,1)
end)

-- Bind hyper-, to move window to the top 30% of its current screen

hs.hotkey.bind(hyper, ",", function()
    adjustForegroundWindowToUnitSize(0,0,1,0.3)
end)

-- Bind hyper-M to move window to the bottom 30% of its current screen

hs.hotkey.bind(hyper, "M", function()
    adjustForegroundWindowToUnitSize(0,0.7,1,0.3)
end)

-- Bind hyper-/ to move 50% sized window to the center

hs.hotkey.bind(hyper, "/", function()
    adjustForegroundWindowToUnitSize(0.25,0.25,.5,.5)
end)

-- Bind hyper-T to move window to the "next" screen

hs.hotkey.bind(hyper, "T", function()
    local win = hs.window.focusedWindow()
    local windowScreen = win:screen()
    
    local newWindowScreen = windowScreen:next()
    win:moveToScreen(newWindowScreen)
end)

-- Misc.

-- I can reload the config when this file changes. From:
-- http://www.hammerspoon.org/go/#fancyreload
function reload_config(files)
    hs.reload()
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()
hs.alert.show("Config loaded")
