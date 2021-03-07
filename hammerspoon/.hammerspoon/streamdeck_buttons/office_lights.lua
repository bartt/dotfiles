require "streamdeck_buttons.button_images"
require("home_assistant")

local imageOptions = {
    ['textColor'] = hs.drawing.color.black,
    ['backgroundColor'] = hs.drawing.color.white
}

officeToggle = {
    ['name'] = 'Office Toggle',
    ['image'] = streamdeck_imageFromText("􀛮", imageOptions),
    ['onClick'] = function()
        homeAssistantRun('POST', 'services/homeassistant/toggle', { ['area_id'] = 'office' })
    end
}

