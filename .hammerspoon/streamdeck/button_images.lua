require "colors"

buttonWidth = 96
buttonHeight = 96

-- Shared cached canvas
local sharedCanvas = hs.canvas.new{ w = buttonWidth, h = buttonHeight }

-- Returns an image with the specified canvas contents
-- Canvas contents are a table of canvas commands
function streamdeck_imageWithCanvasContents(contents)
    sharedCanvas:replaceElements(contents)
    return sharedCanvas:imageFromCanvas()
end

-- Returns an image with the specified text, color, and background color
function streamdeck_imageFromText(text, options)
    local options = options or { }
    textColor = options['textColor'] or tintColor
    backgroundColor = options["backgroundColor"] or systemBackgroundColor
    font = options['font'] or ".AppleSystemUIFont"
    fontSize = options['fontSize'] or 70
    local lineHeight = buttonHeight
    local lines = 1
    for nl in string.gmatch(text, "%c") do
        lines = lines + 1
    end
    local offset = (lineHeight - fontSize) / 2        
    if (lines > 1) then
       offset = 0 
    end
    dbg(text .. ' ' .. lines .. ' ' .. fontSize)
    if (not options['fontSize']) then
        fontSize = fontSize / lines
    end
    lineHeight = lineHeight / lines
    dbg(buttonHeight .. ' ' .. lineHeight .. ' ' .. fontSize)
    local elements = { }
    table.insert(elements, {
        action = "fill",
        frame = { x = 0, y = 0, w = buttonWidth, h = buttonHeight },
        fillColor = backgroundColor,
        type = "rectangle",
    })
    table.insert(elements, {
        frame = { x = 0, y = 0, w = buttonWidth, h = buttonHeight },
        text = hs.styledtext.new(text, {
            font = { name = font, size = fontSize },
            paragraphStyle = { alignment = "center", minimumLineHeight = lineHeight },
            baselineOffset = offset,
            color = textColor,
        }),
        type = "text",
    })
    return streamdeck_imageWithCanvasContents(elements)
end
