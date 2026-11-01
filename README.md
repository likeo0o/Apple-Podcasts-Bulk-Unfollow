# Apple Podcasts Bulk Unfollow

Unfollow Apple Podcasts shows in bulk on macOS.

**The script starts immediately and runs for up to 500 iterations. It also confirms library removal prompts, which can delete downloaded episodes. Back up anything you want to keep before running it.**

## Setup

1. Download and unzip the repository.
2. Open Podcasts and go to **Library > Shows**, with followed shows in the grid. Keep the main window visible and close any dialogs.
3. Use the English app interface. The script looks for the labels `Shows` and `Unfollow`.
4. Give Terminal or Script Editor the required accessibility and automation permissions in **System Settings > Privacy & Security**. See [Apple's accessibility guide](https://support.apple.com/guide/mac-help/allow-accessibility-apps-to-access-your-mac-mh43185/mac).

No extra software is needed.

## Run

Open Terminal in the project folder, then run:

```sh
osascript ./unfollow_all_podcasts.applescript
```

You can also open the file in Script Editor and click Run.

To process fewer shows, change `set maxIterations to 500` near the top of the script to a smaller positive number. The script does not accept a batch-size argument.

Watch Podcasts while it runs and avoid changing windows or views. Press **Control-C** in Terminal, or Stop in Script Editor, to stop further actions. Completed changes are not undone.

## Notes

The project owner has successfully used this script. Other macOS versions and Podcasts layouts may behave differently.

- Unfollowing does not cancel paid subscriptions.
- If it cannot find `Shows` or `Unfollow`, check the app language and current view.
- Check your library afterward. The displayed count does not verify that every show was unfollowed.

[Code review](docs/CODE_REVIEW.md) · [Validation](docs/VALIDATION.md) · [MIT License](LICENSE)
