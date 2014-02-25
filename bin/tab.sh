#!/usr/bin/env bash
osascript -e "
tell application \"iTerm\"
  tell the first terminal
    launch session \"Default Session\"
    tell the last session
      write text \"cd $(pwd)\"
    end tell
  end tell
end tell"
