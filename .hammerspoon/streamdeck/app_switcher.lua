require "streamdeck.peek"
function appSwitcher()
    return {
        ['name'] = "App Switcher",
        ['image'] = streamdeck_imageFromSvgFile("grid"),
        ['children'] = function()
            local out = { }
            for index, app in pairs(hs.application.runningApplications()) do
                local bundleID = app:bundleID()
                if bundleID == nil then goto continue end
                local path = app:path()
                -- Strip out apps we don't want to pick from
                if path == nil then goto continue end
                if string.find(path, '/System/Library') then goto continue end
                if string.find(path, '/Library/GoogleCorpSupport') then goto continue end
                if string.find(path, 'appex') then goto continue end
                if string.find(path, 'XPCServices') then goto continue end
                if string.find(app:name(), 'FirefoxCP') then goto continue end
                if string.find(app:name(), 'Santa') then goto continue end
                if string.find(app:name(), 'Tray') then goto continue end
                if string.find(app:name(), 'Caffeine') then goto continue end
                if string.find(app:bundleID(), 'snipit') then goto continue end
                if string.find(app:bundleID(), 'Rocket') then goto continue end
                if string.find(app:name(), 'Logi Options+') then goto continue end
                if string.find(app:bundleID(), 'com.flickr.flickrmac') then goto continue end
                if string.find(path, 'Helper') then goto continue end
                if string.find(path, 'gMenu') then goto continue end
                if string.find(path, 'Falcon') then goto continue end
                dbg(app)
                appButton = peekButtonFor(app:bundleID())
                out[#out+1] = appButton
                ::continue::
            end
            return out
        end
    }
end
