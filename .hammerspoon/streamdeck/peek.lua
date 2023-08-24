function peekAtApp(appString)
    local app = hs.application.get(appString)
    if app == nil then
        hs.application.open(appString)
        return
    end
    if app:isRunning() then
        if app:isFrontmost() then
            app:hide()
        else
            hs.application.open(appString)
            app:activate()
        end
    else
        hs.application.open(app)
    end
end

function peekButtonFor(bundleID, showRunning)
    local showRunning = showRunning or false
    return {
        ['name'] = "Peek " .. bundleID,
        ['stateProvider'] = function()
            local app = hs.application.get(bundleID)
            return {
                ['isRunning'] = app and app:isRunning() or false
            }
        end,
        ['imageProvider'] = function(context)
            local elements = {}
            elements[#elements + 1] = {
                ['type'] = 'image',
                ['image'] = hs.image.imageFromAppBundle(bundleID),
                ['imageScaling'] = 'scaleProportionally'
            }
            if showRunning and context['state']['isRunning'] then
                elements[#elements + 1] = {
                    ['type'] = 'circle',
                    ['radius'] = 10,
                    ['center'] = {
                        x = 80,
                        y = 80
                    },
                    ['fillColor'] = systemGreenColor
                }
            end
            return streamdeck_imageWithCanvasContents(elements)
        end,
        ['onClick'] = function()
            peekAtApp(bundleID)
        end,
        ['onLongPress'] = function(holding)
            peekAtApp(bundleID)
        end,
        ['updateInterval'] = 1
    }
end

local calendarButtonDimension = 76

function calendarPeekButton()
    local button = peekButtonFor('com.apple.iCal')

    local x = (buttonWidth - calendarButtonDimension)/2
    local y = (buttonHeight - calendarButtonDimension)/2

    local radius = 16
    local headerHeight = 24

    local headerFontSize = 16
    local bodyFontSize = 42

    local headerText = os.date("%b")
    -- +0 to strip leading 0
    local bodyText = os.date("%d") + 0

    button['image'] = nil
    button['stateProvider'] = function()
        return os.date("%d") + 0
    end
    button['imageProvider'] = function(state)
        local elements = {}

        -- White background
        table.insert(elements, {
            action = "fill",
            frame = { x = x, y = y, w = calendarButtonDimension, h = calendarButtonDimension },
            fillColor = hs.drawing.color.white,
            type = "rectangle",
        })

        -- Red header
        table.insert(elements, {
            action = "fill",
            frame = { x = x, y = y, w = calendarButtonDimension, h = headerHeight },
            fillColor = { red = 249.0/255.0, green = 86.0/255.0, blue = 78.0/255.0, alpha = 1.0},
            type = "rectangle"
        })

        -- Header text
        table.insert(elements, {
            frame = { x = x, y = y, w = calendarButtonDimension, h = headerHeight },
            text = hs.styledtext.new(headerText, {
                font = { name = ".AppleSystemUIFont", size = headerFontSize },
                paragraphStyle = { alignment = "center" },
                color = hs.drawing.color.white,
            }),
            type = "text"
        })

        -- Body text
        table.insert(elements, {
            frame = { x = x, y = y + headerHeight, w = calendarButtonDimension, h = calendarButtonDimension - headerHeight },
            text = hs.styledtext.new(bodyText, {
                font = { name = ".AppleSystemUIFont", size = bodyFontSize },
                paragraphStyle = { alignment = "center" },
                color = hs.drawing.color.black,
            }),
            type = "text"
        })

        -- Clip
        -- This doesn't work, and I don't know why
        table.insert(elements, {
            action = "clip",
            frame = { x = x, y = y, w = calendarButtonDimension, h = calendarButtonDimension },
            roundedRectRadii = { xRadius = radius, yRadius = radius },
            type = "rectangle",
        })

        return streamdeck_imageWithCanvasContents(elements)
    end
    button['updateInterval'] = 10
    return button
end

