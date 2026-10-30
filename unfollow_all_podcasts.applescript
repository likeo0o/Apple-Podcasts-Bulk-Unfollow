-- Unfollow all shows in Podcasts.app
--
-- Verified against the live UI (macOS 26 / Darwin 25.5.0) using System Events
-- accessibility scripting. Podcasts.app exposes almost no standard container
-- roles (no scroll area/table/outline) -- everything is nested AXGroups, so
-- this walks the tree manually via `UI elements of X` rather than relying on
-- System Events' recursive `every <class> of <container>` (which does not
-- reliably descend through this app's structure).
--
-- HOW TO RUN: osascript unfollow_all_podcasts.applescript
-- Podcasts must already be running. You don't need to have it frontmost
-- first -- the script switches to its Space itself via the Dock icon, since
-- `tell application "Podcasts" to activate` alone does not reliably switch
-- macOS Spaces.
--
-- SAFETY: capped at maxIterations so a UI mismatch can't spin forever. Each
-- iteration re-fetches the first followed-show tile fresh (rather than
-- caching a list up front), since unfollowing a show removes it from the
-- grid and shifts the rest.

set maxIterations to 500
set unfollowedCount to 0
set unfollowedNames to {}

using terms from application "System Events"
	on findFirstMatch(e, roleWanted, descWanted, depth, maxDepth)
		if e is missing value then return missing value
		set roleStr to ""
		try
			set roleStr to role of e
		end try
		set descStr to ""
		try
			set descStr to description of e
		end try
		if roleStr is roleWanted and descStr is descWanted then
			return e
		end if
		if depth < maxDepth then
			try
				set kidList to UI elements of e
				repeat with k in kidList
					set found to my findFirstMatch(k, roleWanted, descWanted, depth + 1, maxDepth)
					if found is not missing value then
						return found
					end if
				end repeat
			end try
		end if
		return missing value
	end findFirstMatch

	on findFirstMatchByRole(e, roleWanted, depth, maxDepth)
		if e is missing value then return missing value
		set roleStr to ""
		try
			set roleStr to role of e
		end try
		if roleStr is roleWanted then
			return e
		end if
		if depth < maxDepth then
			try
				set kidList to UI elements of e
				repeat with k in kidList
					set found to my findFirstMatchByRole(k, roleWanted, depth + 1, maxDepth)
					if found is not missing value then
						return found
					end if
				end repeat
			end try
		end if
		return missing value
	end findFirstMatchByRole

	on findButtonContainingName(e, nameSubstr, depth, maxDepth)
		if e is missing value then return missing value
		set roleStr to ""
		try
			set roleStr to role of e
		end try
		if roleStr is "AXButton" then
			set nm to ""
			try
				set nm to name of e
			end try
			if nm contains nameSubstr then return e
		end if
		if depth < maxDepth then
			try
				set kidList to UI elements of e
				repeat with k in kidList
					set found to my findButtonContainingName(k, nameSubstr, depth + 1, maxDepth)
					if found is not missing value then
						return found
					end if
				end repeat
			end try
		end if
		return missing value
	end findButtonContainingName
end using terms from

tell application "System Events"
	if not (exists process "Podcasts") then
		display dialog "Podcasts isn't running. Open it first." buttons {"OK"} default button 1
		return
	end if

	-- Switch to whatever Space Podcasts' window lives on. `activate` alone
	-- does not reliably do this; clicking the Dock icon does.
        tell application "Podcasts" to activate
	delay 0.3

	tell process "Podcasts"
		set frontmost to true
		set w to window 1

		-- Resolve these once, up front: the deep recursive searches are the
		-- real cost, not the small `delay`s. showsGroup and mainGroup are
		-- stable AXUIElement references that stay valid as show tiles come
		-- and go underneath them, so there's no need to re-search the whole
		-- window tree on every single iteration -- only refresh them (via
		-- the try/on error fallback below) if a reference ever goes stale.
		set showsGroup to my findFirstMatch(w, "AXGroup", "Shows", 0, 20)
		if showsGroup is missing value then
			display dialog "Stopped: couldn't find the Shows grid." buttons {"OK"} default button 1
			return
		end if
		-- The open context menu always shows up as a shallow sibling of the
		-- big content subtree (2 levels under the window), so instead of a
		-- full recursive search for it each time (which would have to walk
		-- the entire show grid first), just check the direct children of
		-- this top-level group.
		set mainGroup to item 1 of (UI elements of w)

		repeat with i from 1 to maxIterations
			try
				set kids to UI elements of showsGroup
			on error
				set showsGroup to my findFirstMatch(w, "AXGroup", "Shows", 0, 20)
				if showsGroup is missing value then
					display dialog "Stopped after unfollowing " & unfollowedCount & " show(s): couldn't find the Shows grid." buttons {"OK"} default button 1
					exit repeat
				end if
				set kids to UI elements of showsGroup
			end try
			set firstShow to missing value
			repeat with k in kids
				set r to ""
				try
					set r to role of k
				end try
				if r is "AXButton" then
					set firstShow to k
					exit repeat
				end if
			end repeat

			if firstShow is missing value then
				-- Grid may be mid-reflow right after a previous unfollow;
				-- retry briefly before concluding we're actually done. Check
				-- immediately first, then only pay small delays between
				-- retries -- for as long as it takes to settle, not a fixed
				-- wait every time.
				set retryFound to false
				repeat with attempt from 1 to 6
					set kids to UI elements of showsGroup
					repeat with k in kids
						set r to ""
						try
							set r to role of k
						end try
						if r is "AXButton" then
							set firstShow to k
							set retryFound to true
							exit repeat
						end if
					end repeat
					if retryFound then exit repeat
					if attempt < 6 then delay 0.05
				end repeat
				if not retryFound then exit repeat -- no more followed shows
			end if

			set showName to ""
			try
				set showName to description of firstShow
			end try

			try
				-- The app can still be mid-animation from the previous
				-- removal, and AXShowMenu fired into that seems to get
				-- silently dropped rather than queued -- waiting longer
				-- doesn't help, but re-firing the action does. So retry the
				-- action itself, polling cheaply (shallow children of
				-- mainGroup, not a full tree walk) in between. Exits the
				-- moment the menu shows up; only pays the ~2s budget on the
				-- rare attempt that's genuinely slow.
				set theMenu to missing value
				repeat with attempt from 1 to 14
					perform action "AXShowMenu" of firstShow
					delay 0.1
					try
						repeat with k in (UI elements of mainGroup)
							set r to ""
							try
								set r to role of k
							end try
							if r is "AXMenu" then
								set theMenu to k
								exit repeat
							end if
						end repeat
					end try
					if theMenu is not missing value then exit repeat
				end repeat
				if theMenu is missing value then
					-- Last resort: the expensive full-tree search, in case
					-- the menu isn't where we expect it to be.
					set theMenu to my findFirstMatchByRole(w, "AXMenu", 0, 20)
				end if
				if theMenu is missing value then error "context menu did not open"

				set unfollowItem to missing value
				set mi to menu items of theMenu
				repeat with mItem in mi
					set inm to ""
					try
						set inm to name of mItem
					end try
					if inm is "Unfollow" then
						set unfollowItem to mItem
						exit repeat
					end if
				end repeat

				if unfollowItem is missing value then error "no \"Unfollow\" item in menu"

				perform action "AXPress" of unfollowItem

				-- Some shows prompt to remove/keep downloaded episodes
				-- ("Remove all episodes of ... from your Library?" with
				-- buttons "Remove From Library" / "Keep All Episodes").
				-- Auto-confirm removal, per explicit user choice. This
				-- dialog is rare (only shows with actual downloads trigger
				-- it) and its appearance isn't instant, so check right away
				-- with no delay, then only pay small delays between retries
				-- -- and only for as long as it takes to show up, not a
				-- fixed wait every single time.
				set removeBtn to missing value
				repeat with attempt from 1 to 5
					try
						set sheetCount to count of sheets of w
						if sheetCount > 0 then
							set theSheet to sheet 1 of w
							set sheetBtns to buttons of theSheet
							repeat with aBtn in sheetBtns
								set bn to ""
								try
									set bn to name of aBtn
								end try
								if bn contains "Remove" then
									set removeBtn to aBtn
									exit repeat
								end if
							end repeat
						end if
					end try

					if removeBtn is not missing value then exit repeat
					if attempt < 5 then delay 0.06
				end repeat
				if removeBtn is not missing value then
					perform action "AXPress" of removeBtn
				end if

				set unfollowedCount to unfollowedCount + 1
				set end of unfollowedNames to showName
			on error errMsg
				try
					key code 53 -- Escape, in case a menu got left open
				end try
				display dialog "Stopped after unfollowing " & unfollowedCount & " show(s). Error on \"" & showName & "\": " & errMsg buttons {"OK"} default button 1
				exit repeat
			end try
		end repeat
	end tell
end tell

display notification ("Unfollowed " & unfollowedCount & " show(s).") with title "Podcasts Cleanup"
return unfollowedNames
