# Changelog

## 0.1.1 — 2026-10-30

- Correct the published entry point to the GPT-optimized fast script that the user explicitly confirms they successfully ran.
- Preserve the supplied file byte for byte: 292 lines, 9,440 bytes, SHA-256 `d42c4321f64aeb62b6f23ea926ce3bf7b301e7039e171c226fdbb7d1c04963ea`.
- Remove the separately written guarded script and redundant `original/` copy from the current tree. They remain available through Git history.
- Rewrite both READMEs and review/validation records around the actual 500-iteration fast script, including its automatic library-removal behavior and lack of a batch-size CLI argument.
- Record user-reported successful real use separately from publisher compile/static checks. No cancellation script was re-executed during this correction.

## 0.1.0 — 2026-10-30

- Initial packaging mistakenly made a separate, untested guarded rewrite the main script while putting the user-tested fast script under `original/` as a text reference.
- That package did not match the requested working-version entry point. Version 0.1.1 corrects the entry point and documentation; it does not introduce a new runtime rewrite.
