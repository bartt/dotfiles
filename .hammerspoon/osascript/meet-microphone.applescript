tell application "Google Chrome"
  activate
  repeat with theWindow in windows
    set i to 0
    repeat with theTab in tabs of theWindow
      set i to i + 1
      if URL of theTab starts with "https://meet.google.com" then
        set index of theWindow to 1
        set active tab index of theWindow to i
          tell application "System Events" to keystroke "d" using command down
        return
      end if
    end repeat
  end repeat
end tell