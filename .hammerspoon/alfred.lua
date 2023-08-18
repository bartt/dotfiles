-- Interface to Alfred
function setBacklightState(state)
    hs.urlevent.openURL("alfred://runtrigger/biz.thecodemill.backlight/toggle/?argument=" .. state)
end

function setDesklightState(state)
  hs.urlevent.openURL("alfred://runtrigger/biz.thecodemill.dlight/set/?argument=" .. state)
end