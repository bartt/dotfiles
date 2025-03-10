require "color_support"
require "terminal"

local function terminalButton(button)
    local bundleID = 'com.apple.ActivityMonitor'
    local out = button
    out['onClick'] = function()
        peekAtApp(bundleID)
    end
    out['onLongPress'] = function(holding)
        peekAtApp(bundleID)
    end
    return out
end

cpuButton = terminalButton({
    ['imageProvider'] = function()
        local value = math.floor(hs.execute('~/bin/cpu_usage.sh', true))
        local text = value .. "%"
        local color = severityColorForFraction(value / 100.0)
        local elements = {}
        elements[#elements + 1] = {
            action = "fill",
            frame = {
                x = 0,
                y = 0,
                w = buttonWidth,
                h = buttonHeight
            },
            fillColor = color,
            type = "rectangle"
        }
        elements[#elements + 1] = {
            type = 'image',
            image = gifImageFromSvgFile("chip"),
            frame = {
                x = 25,
                y = 3,
                w = 45,
                h = 45
            }
        }
        elements[#elements + 1] = {
            frame = {
                x = 0,
                y = 48,
                w = 96,
                h = 45
            },
            text = hs.styledtext.new(text, {
                font = {
                    name = font,
                    size = 40
                },
                paragraphStyle = {
                    alignment = "center",
                    minimumLineHeight = 45
                },
                baselineOffset = 2,
                color = textColor
            }),
            type = "text"
        }
        return streamdeck_imageWithCanvasContents(elements)
    end,
    ['updateInterval'] = 10
})

memoryButton = terminalButton({
    ['imageProvider'] = function()
        local value = math.floor(hs.execute('~/bin/mem_usage.sh', true))
        local text = value .. "%"
        local color = severityColorForFraction(value / 100.0)
        local elements = {}
        elements[#elements + 1] = {
            action = "fill",
            frame = {
                x = 0,
                y = 0,
                w = buttonWidth,
                h = buttonHeight
            },
            fillColor = color,
            type = "rectangle"
        }
        elements[#elements + 1] = {
            type = 'image',
            image = gifImageFromSvgFile("ram"),
            frame = {
                x = 25,
                y = 3,
                w = 45,
                h = 45
            }
        }
        elements[#elements + 1] = {
            frame = {
                x = 0,
                y = 48,
                w = 96,
                h = 45
            },
            text = hs.styledtext.new(text, {
                font = {
                    name = font,
                    size = 40
                },
                paragraphStyle = {
                    alignment = "center",
                    minimumLineHeight = 45
                },
                baselineOffset = 2,
                color = textColor
            }),
            type = "text"
        }
        return streamdeck_imageWithCanvasContents(elements)
    end,
    ['updateInterval'] = 10
})

