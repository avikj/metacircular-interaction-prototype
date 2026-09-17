# UCM recovery ledger

See [RECOVERY.md](RECOVERY.md) for the complete recovery chapter. This pointer is intentionally separate so parallel agents can append UCM-specific recovery entries without overwriting other integration notes.

## UCM checkpoint rule

Commit each recovered source batch immediately. Run the UCM smoke suite after every overlay group and record the command, binary path, and result in the shared ledger.
