require "colors"

buttonWidth = 96
buttonHeight = 96

-- Shared cached canvas
local sharedCanvas = hs.canvas.new {
    w = buttonWidth,
    h = buttonHeight
}

-- Returns an image with the specified canvas contents
-- Canvas contents are a table of canvas commands
function streamdeck_imageWithCanvasContents(contents)
    sharedCanvas:replaceElements(contents)
    return sharedCanvas:imageFromCanvas()
end

-- Returns an image with the specified text, controlColor
function streamdeck_imageFromText(text, options)
    local options = options or {}
    textColor = options['textColor'] or whiteColor
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
    if (not options['fontSize']) then
        fontSize = fontSize / lines
    end
    lineHeight = lineHeight / lines
    local elements = {}
    table.insert(elements, {
        frame = {
            x = 0,
            y = 0,
            w = buttonWidth,
            h = buttonHeight
        },
        text = hs.styledtext.new(text, {
            font = {
                name = font,
                size = fontSize
            },
            paragraphStyle = {
                alignment = "center",
                minimumLineHeight = lineHeight
            },
            baselineOffset = offset,
            color = textColor
        }),
        type = "text"
    })
    return streamdeck_imageWithCanvasContents(elements)
end

function streamdeck_imageFromSvgFile(imageName)
    local elements = {}
    elements[#elements + 1] = elementFromSvgFile(imageName)
    return streamdeck_imageWithCanvasContents(elements)
end

function elementFromSvgFile(imageName)
    return {
        type = 'image',
        image = gifImageFromSvgFile(imageName),
        imageScaling = 'shrinkToFit',
        frame = {
            x = 5,
            y = 5,
            h = buttonWidth - 10,
            w = buttonHeight - 10
        }
    }
end

function elementBackground(color)
    return {
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
end

function gifImageFromSvgFile(imageName)
    return hs.image.imageFromPath("svg/" .. imageName .. ".svg")
end
