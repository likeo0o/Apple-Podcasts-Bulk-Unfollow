# Code review and risk record

Review date: 2026-10-30. All 292 lines of the uploaded source were read. No version of the cancellation script was executed during preparation.

## Exact source

- Original attachment: `unfollow_all_podcasts.applescript`.
- Preserved copy: `original/unfollow_all_podcasts.applescript.txt`.
- Size: 9,440 bytes, 292 lines.
- SHA-256: `d42c4321f64aeb62b6f23ea926ce3bf7b301e7039e171c226fdbb7d1c04963ea`.
- The attachment and the user's Desktop copy had identical hashes at review time. No personal absolute paths, account identifiers, credentials, network endpoints, shell commands, or third-party attribution were found in the source.

Line references below refer to the preserved original, not the distribution version.

## Complete control-flow review

| Original lines | Behavior and assessment |
| --- | --- |
| 1–19 | Comments claim historical live testing on macOS 26 / Darwin 25.5.0. This is an unverified source comment, not release-test evidence. Comments about switching Spaces through the Dock do not match the actual implementation. |
| 21–23 | Up to 500 iterations; no initial confirmation or preview. Keeps names only in memory. |
| 25–101 | Three recursive accessibility search helpers. Depth limits bound depth but not node count or total elapsed time. Errors are often swallowed. `findButtonContainingName` is now unused. |
| 104–117 | Requires Podcasts already running, activates it and accesses window 1 without checking windows or existing dialogs. No Dock click is present. |
| 119–135 | Looks for an exact English `AXGroup` description `Shows`; caches grid and top-level parent references. Strongly depends on one version's accessibility layout. |
| 137–184 | Selects the first direct `AXButton` as a show and retries an empty grid briefly. It does not prove the button is followed or that an empty view means the entire library is clear. Refreshes the grid only after one kind of stale-reference error. |
| 186–238 | Reads the tile description; retries `AXShowMenu`, searches for an `AXMenu`, and requires the exact English menu name `Unfollow`. This exact match is preferable to a fuzzy destructive-command match, but the surrounding UI can still differ. |
| 240 | Sends a real `AXPress` to Unfollow. A successful Apple event does not prove server-side or library completion. |
| 242–276 | Searches a sheet for the first button whose name contains `Remove` and automatically presses it. The original comment claims a prior user choice; that comment does not authorize deletion for new users. The download/library-removal risk is material. The slow full-window fallback mentioned in the old conversation is already absent from the uploaded file. |
| 278–279 | Increments a success-sounding counter without checking that the UI or following state actually changed. |
| 280–292 | On error, sends a global Escape key, shows a dialog, then may still report an Unfollowed count. This can affect an unexpected focused surface and overstate success. No structured rollback exists. |

## Changes in the distribution version

1. Default limit is 1, with an optional strict integer limit 1–500 and a confirmation whose default is Cancel. It remains a real operation, not a preview.
2. The only press action targets an enabled menu item named exactly `Unfollow`. There is no auto-press handler for removal, keep, generic confirmation, or default buttons, and no keyboard-event cleanup.
3. Before each action and while waiting, check that Podcasts is frontmost, has one window, and has no recognized sheet or dialog. On mismatch, stop and leave the UI for manual inspection. Custom overlays not exposed as sheets or dialogs may evade this guard.
4. Refresh window, grid, and parent references; preserve shallow menu lookup with a bounded recursive fallback (20 levels, 2,500 visited nodes per search). These are traversal bounds, not a strict wall-clock timeout.
5. Stop on repeated or unreadable labels and on lack of observable first-tile progress. Duplicate titles and unfiltered libraries may cause early stops. These checks intentionally favor stopping over repeated actions.
6. Report requests sent, never a verified successful-unfollow total. If an Apple event or UI read fails, the last action may already have occurred. Terminal logs can expose show labels locally.

No safeguards here are a guarantee against UI races. A user could change the selected view between reads. Accessibility metadata can be stale or misleading. A library mutation may sync elsewhere. The script cannot restore previous following state, validate download preservation, or cancel paid subscriptions.

## Compatibility

- AppleScript and System Events are macOS technologies; this script operates the desktop Apple Podcasts UI. It does not call a documented bulk-unfollow API.
- Supported labels in code are exactly English `Shows` and `Unfollow`. The current Apple user guide describes an Unfollow Show action, but that guide does not establish the accessibility menu name or hierarchy used by any specific app version.
- Historical macOS 26 / Darwin 25.5.0 source comments and the user's earlier reported use are not reproducible release validation. Preparation used macOS 27.2 for compile-only checks; no Podcasts runtime-version compatibility was established.
- Assumes one main window and a grid with direct show buttons. List layouts, localization, mini-player windows, Spaces behavior, custom dialogs, slow responses, saved/downloaded shows, or UI changes can cause early stops.
- Terminal or Script Editor needs the appropriate accessibility and automation permissions. No additional runtime package, network service, root permission, or direct access to the Podcasts database is used by this source. Apple's app itself may communicate and sync as usual.

## 来源与许可

The user supplied this AI-assisted script and explicitly requested public sharing from their GitHub account. The uploaded file has no named third-party author, license notice, or upstream URL. No independently verified upstream provenance is available; absence of a notice does not prove the absence of third-party rights.

The project is distributed under MIT as the contributor's chosen license for the code and documentation they are entitled to license. This is not a legal clearance of unknown upstream rights. If an upstream origin is identified later, preserve applicable notices and resolve any conflicting terms before further redistribution. Apple trademarks and bundled applications are not licensed by this project.

## Primary references

- [Apple: Follow or unfollow shows in Podcasts on Mac](https://support.apple.com/en-mt/guide/podcasts/podf17151dc/mac): unfollowing, paid subscriptions remaining active, and the choice to keep or remove downloads.
- [Apple: Allow accessibility apps to access your Mac](https://support.apple.com/guide/mac-help/allow-accessibility-apps-to-access-your-mac-mh43185/mac): permission settings for accessibility control.
- [Apple: Automating the User Interface](https://developer.apple.com/library/archive/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/AutomatetheUserInterface.html): System Events UI scripting and its accessibility requirements.
- The local `osacompile(1)` manual: compilation produces compiled script data; it is distinct from running with `osascript`.

These documents explain product behavior and UI scripting. They do not certify that this script works with the current Podcasts accessibility tree.
