require "color_support"

-- from https://stackoverflow.com/questions/59561776/how-do-i-insert-a-string-into-another-string-in-lua
function string.insert(str1, str2, pos)
    return str1:sub(1,pos)..str2..str1:sub(pos+1)
end

local function weatherButtonForLocation(location)
    return {
        ['name'] = 'Weather',
        ['imageProvider'] = function()
            local url = "wttr.in?m&format=1"
            if location ~= nil then
                url = "wttr.in/" .. location .. "?m&format=1"
            end
            local command = 'curl --max-time 0.5 --silent "' .. url
            command = command .. '" | sed "s/+//" | sed "s/C//" | grep -v "Unknow" | tr -d "\\n" | tr -s "[:blank:]" "\\n"'
            local output = hs.execute(command)
            local fontSize = 40
            if location ~= nil then
                output = location .. '\n' .. output
                fontSize = 24
            end
            local options = {
                ['fontSize'] = fontSize,
                ['textColor'] = systemTextColor
            }
            return streamdeck_imageFromText(output, options)
        end,
        ['updateInterval'] = 1800,
    }
end

function weatherButton()
    local button = weatherButtonForLocation(nil)
    button['children'] = function()
        return {
            weatherButtonForLocation('SJC'),
            weatherButtonForLocation('KTVL'),
            weatherButtonForLocation('NYC'),
            weatherButtonForLocation('Emmen'),
            weatherButtonForLocation('Malmö'),
        }
    end
    return button
end

