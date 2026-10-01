-- Interface to Alfred
function setBacklightState(state)
    hs.urlevent.openURL("alfred://runtrigger/biz.thecodemill.backlight/toggle/?argument=" .. state)
end

function setCoffeeState(state)
    hs.urlevent.openURL("alfred://runtrigger/biz.thecodemill.coffee/toggle/?argument=" .. state)
end

function setDesklightState(state)
  hs.urlevent.openURL("alfred://runtrigger/biz.thecodemill.dlight/set/?argument=" .. state)
end