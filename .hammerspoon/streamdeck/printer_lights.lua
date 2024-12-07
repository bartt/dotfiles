local function createPrinterLight(color, direction, key)
  local name = color..'\n'..direction
  local printerColors = {}
  printerColors["master"] = hs.drawing.color.ansiTerminalColors.fgWhite
  printerColors["red"] = hs.drawing.color.ansiTerminalColors.fgRed
  printerColors["green"] = hs.drawing.color.ansiTerminalColors.fgGreen
  printerColors["blue"] = hs.drawing.color.ansiTerminalColors.fgBlue
  printerColors["cyan"] = hs.drawing.color.ansiTerminalColors.fgCyan
  printerColors["magenta"] = hs.drawing.color.ansiTerminalColors.fgMagenta
  printerColors["yellow"] = hs.drawing.color.ansiTerminalColors.fgYellow

  return {
    ['name'] = name,
    ['image'] = streamdeck_imageFromText(name, {
      ['textColor'] = printerColors[color],
      ['fontSize'] = 24

    }),
    ['onClick'] = function()
      -- dbg('pad'..key)
      local keyCode = hs.keycodes.map['pad'..key]
      -- dbg(keyCode)
      -- hs.eventtap.keyStroke() doesn't work with Davinci Resolve. ¯\_(ツ)_/¯
      hs.eventtap.event.newKeyEvent(keyCode, true):post()
    end
  }
end

local printerLights = {}
table.insert(printerLights, createPrinterLight("master", '+', '+'))
table.insert(printerLights, createPrinterLight("red", "+", "7"))
table.insert(printerLights, createPrinterLight("green", "+", "8"))
table.insert(printerLights, createPrinterLight("blue", "+", "9"))

table.insert(printerLights, createPrinterLight("cyan", "+", "1"))
table.insert(printerLights, createPrinterLight("master", "-", "enter"))
table.insert(printerLights, createPrinterLight("red", "-", "4"))
table.insert(printerLights, createPrinterLight("green", "-", "5"))
table.insert(printerLights, createPrinterLight("blue", "-", "6"))

table.insert(printerLights, createPrinterLight("cyan", "-", "-"))
table.insert(printerLights, createPrinterLight("magenta", "+", "2"))
table.insert(printerLights, createPrinterLight("magenta", "-", "0"))
table.insert(printerLights, createPrinterLight("yellow", "+", "3"))
table.insert(printerLights, createPrinterLight("yellow", "-", "."))

-- dbg(printerLights)

function pinterLightKeys()
  return {
    ['name'] = "Printer Light Keys",
    ['image'] = streamdeck_imageFromSvgFile("colors"),
    ['children'] = function()
      local children = {}
      for i,printerLight in ipairs(printerLights) do
        table.insert(children, printerLight)
      end
      return children
    end
  }
end