#!/usr/bin/env osascript
tell application "HazeOver"
	if enabled
		tell application "System Events"
			key code 34 using {shift down, command down}
		end tell
	end if
end tell
