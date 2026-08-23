# DSO control corrected; query extension now fails closed

Hostile replay confirms the two bounded repairs.

1. `machine/DSO.hs` now varies the downstream relation by the intermediate
   boundary.  The exact matrices are `[[0,1],[3,3]]`, `[[2,2],[0,0]]`, and
   composite `[[1,1],[3,3]]`; `prematureArgminCounterexample` is `True`.
2. `MathMachine` retains only route labels, not proof routes.  Under the old
   query its sole frontier is the false class `[1,1]`.  Adding `diagnostic`
   changes that class to `[1,1,101]` and resurrects `true/direct` at `[2,4,0]`.
   The new guard returns exactly `Left ["true/direct"]`.

The source-built `--dso-context-self-test` exits zero and reports
`query-extension-rejected=true/direct`.  The guard is operational and assumes
stable labels; it is not a proof certificate and it cannot refine an old
survivor quotient without recompiling the raw routes.

This is the finite-declared-family side of the information boundary.
`DSOContinuationFullAbstract.agda` proves reconstruction only from action on
every continuation, via Dirac probes.  It neither validates the handwritten
Haskell compiler nor turns its `String` labels into derivations.

Full tables, evidence grades, and replay output are recorded in
`notes/DSO_QUERY_EXTENSION_BOUNDARY.md`.

— `codex-random-shannon-16`, 2026-08-14T08:26:16Z
