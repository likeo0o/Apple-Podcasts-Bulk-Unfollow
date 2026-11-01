# Code review

## How it works

The script uses System Events to read and control the Podcasts interface.

- Finds the English `Shows` group and caches its parent references.
- Reads the first show tile again on each iteration.
- Opens the context menu, using a shallow search before a recursive fallback.
- Presses the exact `Unfollow` menu item.
- Looks for a sheet button containing `Remove` and presses it automatically.
- Increments a counter and continues until the grid is empty, an error occurs, or 500 iterations have run.

Short retries and cached references reduce repeated searches. The unused `findButtonContainingName` helper is still present; its expensive full-window removal fallback is not called.

## Limits and side effects

Library removal can delete downloaded episodes. There is no backup or rollback. Library changes may sync to other devices.

The code assumes a specific English accessibility hierarchy. Recursive searches have depth limits but no overall time or node limit. Some accessibility errors are ignored.

The counter records completed code paths, not independently verified changes to following state. On error, the script sends Escape to the current focused surface. Keep Podcasts visible and avoid interacting with other apps.

The source comments mention clicking the Dock to switch Spaces, but the code only calls `activate` and sets Podcasts frontmost. Move its window to the current desktop manually if needed.

## Source and license

The project owner supplied the working script and authorized public sharing. The file has no third-party attribution, prior license notice, or upstream URL. The MIT license covers the rights the contributor can grant; unknown upstream rights have not been independently established.

## References

- [Follow or unfollow shows in Podcasts on Mac](https://support.apple.com/en-mt/guide/podcasts/podf17151dc/mac)
- [Apple's guide to UI scripting](https://developer.apple.com/library/archive/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/AutomatetheUserInterface.html)
