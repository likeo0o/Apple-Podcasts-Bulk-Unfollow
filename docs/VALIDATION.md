# Validation record

Date: 2026-10-30. Environment reported by `sw_vers`: macOS 27.2 (26B123).

## What was checked

- Read every line of the original attachment and the distribution source.
- Compared the original attachment, Desktop source, and preserved reference copy by SHA-256. Expected hash: `d42c4321f64aeb62b6f23ea926ce3bf7b301e7039e171c226fdbb7d1c04963ea`.
- Compiled both sources with `/usr/bin/osacompile`, writing only disposable compiled outputs. No `osascript` execution, Script Editor Run, or Podcasts UI action was used to test either source.
- Checked the packaged paths, documentation links, absence of private absolute paths or credentials, and the distribution script's single exact-menu press action.

Results: both the original and the distribution source compiled successfully with exit status 0. The sandboxed compiler could not resolve the Standard Additions dialog terminology; recompiling outside the filesystem sandbox resolved this environment limitation. Only compilation was performed. The 9-file package passed the reference-hash, local-link, UTF-8, and publication-content checks. Disposable compiled files were removed; the package contains readable sources only.

## Not checked

- No real-account unfollow operation, automatic or manual, was performed for this release.
- No real download-removal/keep dialog was exercised. Guard behavior is code-reviewed, not demonstrated in a live account.
- No runtime validation of CLI handling, confirmation dialogs, permissions, window checks, duplicate detection, grid transitions, or interruption was performed.
- No verified compatibility matrix across Podcasts versions, macOS releases, display languages, or view layouts exists.
- No cross-device synchronization, undo, restoration, server response, download preservation, or paid-subscription behavior was tested.
- No independent determination of the original code's upstream authorship or third-party license rights was possible from the uploaded file.

Compilation proves syntax and terminology resolution in this preparation environment. It does not prove runtime success or safety. Future test reports should name the exact OS/app versions, language and view, distinguish synthetic data from real accounts, and record outcomes without private account details.
