-- Apple Podcasts Bulk Unfollow — guarded, experimental distribution version.
-- MIT License. Copyright (c) 2026 likeo0o.
-- Read README.md before running. This changes your Podcasts library.
-- English UI only: exact accessibility labels "Shows" and "Unfollow".
-- Default: at most ONE request; optional CLI argument: integer 1..500.
-- Never confirms download-removal dialogs. Stops on dialogs or UI mismatch.
-- Compiling this source does not run it. Runtime has NOT been release-tested.

property searchNodes : 0
property searchNodeLimit : 2500
property searchDepthLimit : 20

on run argv
	set maxIterations to 1
	if (count of argv) > 1 then error "Usage: osascript unfollow_all_podcasts.applescript [1..500]"
	if (count of argv) = 1 then
		set rawLimit to item 1 of argv
		try
			set maxIterations to rawLimit as integer
		on error
			error "The limit must be a whole number from 1 to 500."
		end try
		if (maxIterations as text) is not rawLimit or maxIterations < 1 or maxIterations > 500 then error "The limit must be a whole number from 1 to 500."
	end if

	try
		display dialog "Send up to " & maxIterations & " Unfollow request(s) in Apple Podcasts?" & return & return & "Prepare Library > Shows with followed shows first, using the English app interface. Stay with the app while it runs." & return & return & "This changes your library and may sync to other devices. Save a list of shows first. Any download-removal dialog stops the script for you to handle manually." buttons {"Cancel", "Continue"} default button "Cancel" cancel button "Cancel" with title "Apple Podcasts Bulk Unfollow" with icon caution
	on error number -128
		return "Cancelled; no requests sent."
	end try

	set requestCount to 0
	set requestedNames to {}
	set stopReason to "Reached the requested limit. Check the library to confirm the result."
	try
		tell application "System Events"
			if not (exists process "Podcasts") then error "Open Podcasts and its Library > Shows view first."
		end tell
		tell application "Podcasts" to activate
		delay 0.5
		tell application "System Events" to tell process "Podcasts" to set frontmost to true

		repeat with i from 1 to maxIterations
			my assertReady()
			set firstShow to my currentFirstShow()
			if firstShow is missing value then
				set stopReason to "No show tile was found in the current view. This does not prove all shows were unfollowed."
				exit repeat
			end if
			set showName to my tileLabel(firstShow)
			if showName is "" then error "The first show has no readable label; refusing to guess."
			if requestedNames contains showName then error "A previously processed label is still first (or duplicated). Refusing to repeat the action."

			my assertReady()
			tell application "System Events" to perform action "AXShowMenu" of firstShow
			set theMenu to missing value
			repeat with attempt from 1 to 10
				my assertReady()
				set theMenu to my currentMenu()
				if theMenu is not missing value then exit repeat
				delay 0.2
			end repeat
			if theMenu is missing value then error "The show context menu did not open."

			set unfollowItem to missing value
			tell application "System Events"
				repeat with mItem in (menu items of theMenu)
					if (name of mItem) is "Unfollow" then
						if unfollowItem is not missing value then error "Multiple Unfollow items found."
						set unfollowItem to mItem
					end if
				end repeat
				if unfollowItem is missing value then error "No exact English Unfollow item. Check the language and followed-shows view."
				if not (enabled of unfollowItem) then error "Unfollow is disabled."
			end tell
			my assertReady()
			-- This is the only press action in this distribution version.
			tell application "System Events" to perform action "AXPress" of unfollowItem
			set requestCount to requestCount + 1
			set end of requestedNames to showName
			log ("Unfollow request sent for: " & showName)

			-- Wait for a changed first tile, without clicking any dialog buttons.
			-- Require two matching observations; a UI change is not server proof.
			set changedView to false
			set previousLabel to missing value
			repeat with attempt from 1 to 30
				delay 0.2
				my assertReady()
				set nextShow to my currentFirstShow()
				set nextLabel to ""
				if nextShow is not missing value then set nextLabel to my tileLabel(nextShow)
				if nextLabel is not showName and nextLabel is previousLabel then
					set changedView to true
					exit repeat
				end if
				set previousLabel to nextLabel
			end repeat
			if not changedView then error "The first tile did not change within the wait period. Inspect Podcasts before retrying."
		end repeat
	on error errMsg number errNum
		-- Do not send Escape, Return, or any other key into an unknown dialog.
		set stopReason to "Stopped (" & errNum & "): " & errMsg & " The last request may already have taken effect. Inspect Podcasts before restarting."
	end try
	set summaryText to "Unfollow requests sent: " & requestCount & ". " & stopReason
	log summaryText
	return summaryText
end run

using terms from application "System Events"
	on assertReady()
		tell application "System Events"
			if not (exists process "Podcasts") then error "Podcasts is no longer running."
			tell process "Podcasts"
				if not frontmost then error "Podcasts lost focus."
				if (count of windows) is not 1 then error "Expected exactly one Podcasts window. Close extra windows or dialogs."
				set w to window 1
				if (count of sheets of w) > 0 then error "A Podcasts sheet is open. Handle it manually; no button was pressed by this script."
				if (subrole of w) is "AXDialog" then error "A Podcasts dialog is open. Handle it manually."
			end tell
		end tell
	end assertReady

	on currentFirstShow()
		set searchNodes to 0
		tell application "System Events" to tell process "Podcasts" to set w to window 1
		set showsGroup to my findMatch(w, "AXGroup", "Shows", 0)
		if showsGroup is missing value then error "No exact English Shows group. Open Library > Shows. This app version or language may be unsupported."
		tell application "System Events"
			repeat with k in (UI elements of showsGroup)
				if (role of k) is "AXButton" then return contents of k
			end repeat
		end tell
		return missing value
	end currentFirstShow

	on tileLabel(theTile)
		tell application "System Events"
			set labelText to description of theTile
			if labelText is missing value then return ""
			return labelText as text
		end tell
	end tileLabel

	on currentMenu()
		tell application "System Events" to tell process "Podcasts" to set w to window 1
		-- Keep the original shallow menu lookup, refreshing its parent each time.
		tell application "System Events"
			set topChildren to UI elements of w
			if (count of topChildren) > 0 then
				repeat with k in (UI elements of item 1 of topChildren)
					if (role of k) is "AXMenu" then return contents of k
				end repeat
			end if
		end tell
		set searchNodes to 0
		return my findMatch(w, "AXMenu", missing value, 0)
	end currentMenu

	on findMatch(e, roleWanted, descWanted, depth)
		set searchNodes to searchNodes + 1
		if searchNodes > searchNodeLimit then error "Accessibility search budget exceeded; stopping."
		set roleText to ""
		set descText to ""
		tell application "System Events"
			try
				set roleText to role of e
			end try
			if descWanted is not missing value then
				try
					set descText to description of e
				end try
			end if
		end tell
		if roleText is roleWanted then
			if descWanted is missing value then return e
			if descText is descWanted then return e
		end if
		if depth >= searchDepthLimit then return missing value
		set childrenList to {}
		tell application "System Events"
			try
				set childrenList to UI elements of e
			end try
		end tell
		repeat with k in childrenList
			set found to my findMatch(contents of k, roleWanted, descWanted, depth + 1)
			if found is not missing value then return found
		end repeat
		return missing value
	end findMatch
end using terms from
