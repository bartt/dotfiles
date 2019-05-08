require "hyper"

hs.window.animationDuration = 0

screenWidthPerGridUnit = 3840 / 10
screenHeightPerGridUnit = 2160 / 4

function updateGridForScreen(screen)
    -- The largest comfortable size to use for the keyboards I type on
    size = hs.geometry.size(10, 4)

    hs.grid.setGrid(size, screen)
end

function updateGridsForScreens()
    screens = hs.screen.allScreens()
    for i, screen in ipairs(screens) do
        updateGridForScreen(screen)
    end
end

updateGridsForScreens()

local margins = hs.geometry.size(0, 0)

hs.grid.setMargins(margins)
hs.grid.ui.showExtraKeys = false

hs.hotkey.bind(hyper, "space", function()
    hs.grid.toggleShow()
end)

