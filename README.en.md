# Apple Podcasts Bulk Unfollow

[中文说明](README.md) · [Code review](docs/CODE_REVIEW.md) · [MIT License](LICENSE)

An experimental AppleScript that sends bounded Unfollow requests to Apple Podcasts using macOS accessibility UI scripting. The distribution version defaults to **one request**, asks for confirmation, and never automatically presses a download-removal button.

**The distribution version has not been tested by unfollowing real shows.** Compilation and static review do not demonstrate runtime compatibility. It expects exact English accessibility labels `Shows` and `Unfollow` and a particular show-grid structure.

## Before running

- Record show names or links yourself. There is no backup, undo, or automated restore. Changes may sync through Apple's library sync to other devices.
- Podcasts may ask whether to keep or remove downloaded episodes. This version stops on recognized dialogs and leaves every dialog button for you to choose manually. The last Unfollow request may already have taken effect when the script stops.
- Unfollowing does not cancel a paid subscription. See [Apple's Mac guide](https://support.apple.com/en-mt/guide/podcasts/podf17151dc/mac), which also describes the download-removal choice.
- Keep watching the app. UI automation remains fallible; the guards do not guarantee preservation of content.

## Setup

1. Choose **Code → Download ZIP** on this repository and extract it, or clone the repository. No additional software dependencies are required.
2. Read the source. Open Podcasts manually in **Library → Shows**, with followed shows selected if that filter is available. Close other Podcasts windows, its mini-player, and any dialogs; leave one main window.
3. Use the English app interface. Other languages are unsupported. If needed, set English for Podcasts specifically in macOS Language & Region app settings, then reopen it.
4. Grant accessibility permission to the actual runner, such as Terminal or Script Editor, in **System Settings → Privacy & Security → Accessibility**. If prompted, allow that runner to automate System Events / Podcasts. See [Apple's permission guide](https://support.apple.com/guide/mac-help/allow-accessibility-apps-to-access-your-mac-mh43185/mac). Labels may vary by OS version. Administrator commands, Full Disk Access, and disabling system protections are not required.

## Run one request first

In Terminal, type `cd `, drag the extracted project folder into the window, and press Return. Then:

```sh
osascript ./unfollow_all_podcasts.applescript
```

**This performs a real library-changing operation after you choose Continue. It is not a preview.** Cancel is the default button. Opening the distribution script in Script Editor and choosing Run also uses the one-request default.

After manually checking that result, an optional integer argument sets a larger limit:

```sh
osascript ./unfollow_all_podcasts.applescript 10
```

Only integers `1` through `500` are accepted; confirmation is required on every run. The limit is a cap on requests, not a promise to unfollow every show.

Do not interact with or navigate Podcasts while it runs. To stop, press **Control-C** in its Terminal or Stop in Script Editor. Already-sent requests cannot be recalled. Inspect and handle any menu or dialog left open after stopping.

## Output and limitations

The script reports **requests sent**, not verified successful unfollows. It logs show labels locally to Terminal, so review logs before sharing them.

It stops on missing English labels, recognized sheets/dialogs, lost focus, unexpected window counts, inaccessible UI elements, duplicate processed labels, exhausted search budgets, or failure of the first tile to change. A changing tile is only a UI observation. Empty views are not evidence that the entire account is clear. Unfollowed shows may remain in an unfiltered library, in which case a followed-shows filter or manual intervention is needed.

If a dialog appears, read it and decide manually whether to keep downloads. Inspect the show's state before restarting. Do not work around missing labels by matching `Remove` or pressing default dialog buttons.

The original file's header claims historical testing on macOS 26 / Darwin 25.5.0; that claim was not independently reverified. The current preparation environment was macOS 27.2. Only compilation and static checks were performed. No real unfollows, download prompts, or cross-device synchronization were tested. iOS, iPadOS, Windows, and the web app cannot run this script.

## Original source and license

`original/unfollow_all_podcasts.applescript.txt` preserves the user-supplied original byte for byte. It defaults to **500** iterations and automatically presses a button whose name contains `Remove`; this can remove library/downloaded content. It is reference material, not the recommended entry point. The `.txt` extension is a label, not a sandbox: an interpreter can still explicitly run it.

See [the code review](docs/CODE_REVIEW.md), [validation record](docs/VALIDATION.md), and [changelog](CHANGELOG.md). MIT licensed; preserve the license when redistributing. The supplied script was AI-assisted, contains no upstream attribution or prior license, and its upstream provenance has not been independently established. The license grants rights the contributor can grant. This project is unaffiliated with Apple.

For bug reports, include macOS version, Podcasts version, app language, and error text. Omit account details and private show lists. Distinguish compile-only checks, synthetic checks, and real-account testing.
