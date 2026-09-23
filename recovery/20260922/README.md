# Workspace recovery — 22 September 2026

The working branch is `integration/main-bend-20260922`, based on `origin/main`
at `51a67c10ed`. Main now includes both `collab/bend2-interactive-cubical/`
and `collab/bend2-official-cubical/`. The old `collab/bend2-cubical` path is a
compatibility symlink, not a third compiler.

## Preservation

- Full verified filesystem backup: `/Users/avikjain/repo-backups/recovery-20260922/workspace`.
  All 511,057 entries matched; 61,823,223,529 regular-file bytes were checked.
  Ignored files, untracked files, local toolchains and nested repositories are included.
- Git bundle: `all-refs.bundle` in the same recovery directory, verified by Git.
- Original branch tip: `recovery/pre-integration-20260922` (`40f2e1f2e5`).
- Saved local changes: `recovery/paused-work-20260922` (`407d3fdada`).
  Downloaded toolchains, large local datasets and nested repositories stay in the full
  filesystem backup and working copy rather than being imported as root-repo source.
- The original working directory is retained as `original-before-cutover` alongside
  the backup when the integrated copy is put at the usual workspace path.
- The backup directory also contains staged/unstaged patches, initial refs/status,
  the per-file SHA-256 manifest, test logs and the rebase transcript.

## Integration decisions

The six committed Rubik/fibre changes were replayed onto current main. Unique local
work was committed: Unison provenance/admission changes, additional Bend and Agda
programs, research artifacts, UI data and the organized benchmark campaign.

The local workspace also contained an unfinished bulk substring-renaming pass.
433 modified files matched that pass exactly; related partial substitutions, stale
include paths and duplicate deletions were reviewed separately. It changed paths
without renaming their targets and produced identifiers such as `sanorderna`.
The integrated tree retains main's repaired versions for that work. Nothing is lost:
the original bytes and deletions remain on the recovery branch and in the full backup.
`resolution-ledger.json` lists 643 path-level decisions. Four final conflicts were
three Bend additions carried into the renamed port directory and an unchanged
American-spelling duplicate whose upstream deletion was retained.

The old checkout had stale rebase metadata from September 17. It was cleared with
`git rebase --quit` only in the integration copy; it remains in the original backup.

Main tracked distinct `Kernel/` and `kernel/` copies of three Agda modules. Those
collide on this case-insensitive filesystem. The flat module directory is now
`formal/cubical/kernel-flat/`; the namespaced modules stay under `Kernel/`.
Agda include paths were updated. Both variants remain available and were checked.

Local build caches, large `.h5ad` datasets and the three nested UI/Unison checkouts
are ignored at the root-repo level and preserved on disk. No nested repository was
converted into an unconfigured gitlink. Existing tracked build artifacts were not
silently removed. No remote branch was rewritten or pushed.

## Validation

- Full filesystem backup and complete-history Git bundle verified.
- Namespaced and flat `ControlledGrammar` and `GenerativeKernel`: all four typecheck.
- Recovered `research/sat_fibre/InteractionLedger.agda`: typechecks.
- Cubical `SchematicOperation.bend`: 82 successful checks, no rejections.
- Repaired one invalid UTF-8 sequence in a recovered `FibreElement.bend` comment;
  the declaration bodies are unchanged and original bytes remain in the backup.
- Official public cubical fork matches the fetched main tree exactly.
- Official benchmark `doctor` passes; the original benchmark artifacts retain their hashes.
- See `test-staged-bend.json` for the Rubik checks with their import dependencies staged.
  Argmin, RubiksFamily and Cube3ReadoutFull still have 5, 3 and 8 rejected definitions
  respectively. The same definitions are rejected in the original workspace after
  removing invalid comment bytes in an isolated staging copy; see
  `test-bend-baseline-comparison.json`. Their unfinished implementations are preserved.

The Unison canonical smoke test fails identically in the untouched original and the
integrated copy. Its installed Bend package lacks `doParseBookWithSpans` although
the working source contains it, and vector's package metadata points to the missing
`/private/tmp/biology-substrate/cabal-store`. This is a pre-existing toolchain/build
problem, not a resolved or passing check. Rebuilding/relocating that toolchain is
separate from this Git recovery. Agda validation used installed 2.8.0.1 with cubical
v0.9 through an explicit local library file; no global configuration was changed.

This is an integration recovery, not a claim that every repository experiment or
every unfinished local feature now passes its full test suite.
