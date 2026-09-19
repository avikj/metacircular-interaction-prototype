# UCM recovery ledger

The original full UCM chapter is preserved in Git commit `7f7625766`, at
`integration/bend2_unison/RECOVERY.md`. The current shared tree uses
`RECOVERY_SHARE.md` for the parallel Share ledger; recover the UCM chapter from
that commit before final consolidation.

## UCM checkpoint rule

Commit each recovered source batch immediately. Run the UCM smoke suite after every overlay group and record the command, binary path, and result in the shared ledger.

Checkpoint `927b8f440` records this pointer. The source overlays themselves are
still being recovered from the intact prepared Unison checkouts and surviving
patch artifacts; do not infer source loss from the absence of a file in the
working tree until all `/private/tmp` checkouts and Git reflogs have been
searched.
