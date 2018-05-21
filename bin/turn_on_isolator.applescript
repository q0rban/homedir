#!/usr/bin/env osascript
tell application "Isolator"
	if not active
		tell application "System Events"
			key code 34 using {shift down, command down}
		end tell
		tell application "Isolator"
			set active to true
		end tell
	end if
end tell
