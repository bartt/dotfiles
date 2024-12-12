local printerLightsSize = 'full'
local printerLights = {}
local printerColors = {}
printerColors["master"] = hs.drawing.color.ansiTerminalColors.fgBlack
printerColors["red"] = hs.drawing.color.ansiTerminalColors.fgRed
printerColors["green"] = hs.drawing.color.ansiTerminalColors.fgGreen
printerColors["blue"] = hs.drawing.color.ansiTerminalColors.fgBlue
printerColors["cyan"] = hs.drawing.color.ansiTerminalColors.fgCyan
printerColors["magenta"] = hs.drawing.color.ansiTerminalColors.fgMagenta
printerColors["yellow"] = hs.drawing.color.ansiTerminalColors.fgYello9w

local function createPrinterSize(size)
  return {
    ['name'] = 'printerLightSize_'..size,
    ['stateProvider'] = function()
      return {
        ['enabled'] = printerLightsSize == size,
        ['timestamp'] = os.date('*t')
      }
    end,
    ['imageProvider'] = function(context)
      local elements = {}
      local fileName = size
      if context['state']['enabled'] then 
        fileName = fileName..'-selected'
      end
      elements[#elements + 1] = {
        type = 'image',
        image = gifImageFromSvgFile(fileName),
        frame = {
          x = 25,
          y = 25,
          w = 50,
          h = 50
        },
      }
      return streamdeck_imageWithCanvasContents(elements)
    end,
    ['onClick'] = function()
      printerLightsSize = size
    end,
    ['updateInterval'] = 1
  }
end

local function createPrinterLight(color, direction, key)
  return {
    ['name'] = color..'\n'..direction,
    ['stateProvider'] = function()
      return {
        ['timestamp'] = os.date('*t')
      }
    end,
    ['imageProvider'] =  function(context)
      local elements = {}
      local fileName = printerLightsSize..'-'..((direction == "+") and "plus" or "minus")
      elements[#elements + 1] = elementBackground(printerColors[color])
      elements[#elements + 1] = {
        type = 'image',
        image = gifImageFromSvgFile(fileName),
      }  
      return streamdeck_imageWithCanvasContents(elements)
    end,
    ['onClick'] = function()
      -- dbg('pad'..key)
      local keyCode = hs.keycodes.map['pad'..key]
      -- dbg(keyCode)
      -- dbg(printerLightsSize)
      -- hs.eventtap.keyStroke() doesn't work with Davinci Resolve. ¯\_(ツ)_/¯  
      if printerLightsSize == 'half' then
        -- 2x quarter printer light key press as half don't have keys assigned.
        hs.eventtap.event.newKeyEvent(hs.keycodes.map.cmd, true):post()  
        hs.eventtap.event.newKeyEvent(keyCode, true):post()
        hs.eventtap.event.newKeyEvent(keyCode, true):post()
        hs.eventtap.event.newKeyEvent(hs.keycodes.map.cmd, false):post()  
      elseif printerLightsSize == 'quarter' then
          -- Quarter printer lights keys are the same as the full keys plus CMD. 
        hs.eventtap.event.newKeyEvent(hs.keycodes.map.cmd, true):post()  
        hs.eventtap.event.newKeyEvent(keyCode, true):post()
        hs.eventtap.event.newKeyEvent(hs.keycodes.map.cmd, false):post()  
      else
        hs.eventtap.event.newKeyEvent(keyCode, true):post()          
      end
    end,
    ['updateInterval'] = 1
  }
end

-- first row, starts with a return button
table.insert(printerLights, createPrinterLight("master", '+', '+'))
table.insert(printerLights, createPrinterLight("red", "+", "7"))
table.insert(printerLights, createPrinterLight("green", "+", "8"))
table.insert(printerLights, createPrinterLight("blue", "+", "9"))

-- Blank dummy button.
table.insert(printerLights, {['image'] = streamdeck_imageFromText('')})
table.insert(printerLights, createPrinterLight("master", "-", "enter"))
table.insert(printerLights, createPrinterLight("red", "-", "4"))
table.insert(printerLights, createPrinterLight("green", "-", "5"))
table.insert(printerLights, createPrinterLight("blue", "-", "6"))

-- Blank dummy buttons.
table.insert(printerLights, {['image'] = streamdeck_imageFromText('')})
table.insert(printerLights, {['image'] = streamdeck_imageFromText('')})
table.insert(printerLights, createPrinterSize("full"))
table.insert(printerLights, createPrinterSize("half"))
table.insert(printerLights, createPrinterSize("quarter"))

-- table.insert(printerLights, createPrinterLight("cyan", "+", "1"))
-- table.insert(printerLights, createPrinterLight("cyan", "-", "-"))
-- table.insert(printerLights, createPrinterLight("magenta", "+", "2"))
-- table.insert(printerLights, createPrinterLight("magenta", "-", "0"))
-- table.insert(printerLights, createPrinterLight("yellow", "+", "3"))
-- table.insert(printerLights, createPrinterLight("yellow", "-", "."))

-- dbg(printerLights)

function printerLightKeys()
  return {
    ['name'] = "Printer Light Keys",
    ['image'] = streamdeck_imageFromSvgFile("colors"),
    ['children'] = function()
      local children = {}
      for i,printerLight in ipairs(printerLights) do
        dbg(i)
        table.insert(children, printerLight)
      end
      return children
    end
  }
end