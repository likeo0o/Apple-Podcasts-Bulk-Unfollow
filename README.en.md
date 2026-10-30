# Apple Podcasts Bulk Unfollow

[中文说明](README.md) · [Code review](docs/CODE_REVIEW.md) · [Usage evidence](docs/VALIDATION.md) · [MIT License](LICENSE)

**This is the GPT-assisted fast unfollow script that the user confirms they successfully ran on their own Mac.** The published `unfollow_all_podcasts.applescript` is byte-for-byte identical to the supplied working file. Its behavior has not been rewritten for publication.

An earlier packaging mistake put a separate guarded rewrite at the main entry point. That mistake has been corrected: the current repository contains only the user-tested fast script, with documentation matching its actual behavior.

## Read before running

**Running starts real operations immediately, without a startup confirmation, for up to 500 iterations. The script also automatically confirms library removal, which can delete downloaded episodes.** These behaviors are preserved from the working fast script.

- After Unfollow, it inspects a Podcasts sheet and presses a button whose name contains `Remove`. This is not a preserve-downloads tool and has no preview mode.
- Record show names or links and back up downloads you need. There is no automated undo or restore; library changes may sync to other devices.
- Unfollowing does not cancel a paid subscription. See [Apple's Mac guide](https://support.apple.com/en-mt/guide/podcasts/podf17151dc/mac) for the distinction and download choices.
- Successful use on one Mac does not establish compatibility with every OS, app version, language, or UI layout.

## Existing speed improvements

The code caches the show grid and parent references, prefers a shallow menu search, and polls briefly rather than paying fixed long delays. The uploaded file already omits the expensive full-window `Remove From Library` fallback. Sheet-level removal confirmation remains present. There is no reproducible benchmark or claimed speed multiplier.

## Setup and run

1. Choose **Code → Download ZIP** and extract it, or clone the repository. No extra runtime package is needed.
2. Read the source and risks. Open Apple Podcasts manually in **Library → Shows**, displaying followed shows in its grid. Close existing dialogs and keep the main window visible. The script does not navigate to this view for you.
3. The code matches exact English accessibility labels `Shows` and `Unfollow`; other languages have not been adapted. If needed, set English specifically for Podcasts in macOS app language settings, then reopen it.
4. Grant the actual runner, such as Terminal or Script Editor, the necessary accessibility and automation permissions. See [Apple's permission guide](https://support.apple.com/guide/mac-help/allow-accessibility-apps-to-access-your-mac-mh43185/mac). Setting names can vary with macOS.

In Terminal, type `cd `, drag the extracted project folder into the window, and press Return. Only run the following once you accept the automatic unfollow and removal behavior:

```sh
osascript ./unfollow_all_podcasts.applescript
```

You can also open the source in Script Editor and choose Run. **Both methods start immediately, with a 500-iteration cap.** The script does not parse a batch-size CLI argument; adding `10` to the command does not change the limit.

To try a smaller batch, edit line 21, changing `set maxIterations to 500` to a smaller positive integer, and save. Your edited copy will then differ from the byte-preserved published file.

Watch Podcasts while it runs and do not change its view or interact with other windows. To stop further actions, use **Control-C** in its Terminal or Stop in Script Editor. Already-applied changes are not automatically reversed.

## Results and limitations

The script returns show descriptions and displays an `Unfollowed` count, but does not independently verify the final following state after each click. Inspect the library yourself. The iteration cap is not a guarantee that the entire account will be clear.

For missing `Shows` or `Unfollow`, check English labels, the show grid, and following state. UI hierarchies can differ across versions. Check permissions if automation fails. Bring Podcasts onto the current desktop manually if Spaces causes trouble: the source's Dock-switching comments are stale; the implementation uses `activate` and sets the process frontmost.

## Usage evidence

- The user explicitly confirms successful real use of this GPT-optimized fast script.
- The repository file matches the uploaded file and the user's Desktop copy by SHA-256.
- AppleScript compilation passed during preparation. No cancellation script was re-executed during publication; this does not negate the user's earlier successful use.
- A complete OS/app version and language record for that successful run was not separately captured. Source comments mention historical macOS 26 / Darwin 25.5.0, which does not identify the user's actual successful environment.
- No cross-version compatibility matrix exists. This macOS AppleScript cannot run on iOS, iPadOS, Windows, or the web app.

The script has 292 lines and 9,440 bytes. SHA-256:

```text
d42c4321f64aeb62b6f23ea926ce3bf7b301e7039e171c226fdbb7d1c04963ea
```

## License and feedback

MIT licensed. The user states that GPT helped modify this script and explicitly authorized public sharing. The file has no upstream attribution, prior license, or upstream URL; unknown third-party rights have not been independently cleared. See [the provenance record](docs/CODE_REVIEW.md#来源与许可). This project is unaffiliated with Apple.

Bug reports should include macOS/Podcasts versions, interface language, and error text. Omit private show lists and account details.
