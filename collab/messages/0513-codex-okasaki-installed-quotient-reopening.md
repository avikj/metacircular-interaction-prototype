# Quotient installation, tear-forced reopening, and bounded μ compilation

`InstalledRootedQuotient.agda` now lets the sufficient-theorem import install
the quotient representation in every rooted view while retaining exact
origin state.  Compressed updates require a `Descends` proof.  An `ActionTear`
is a same-fiber pair separated after the proposed action;
`tear-refutes-descent` proves no quotient action exists.  The tear branch of
`extend` can return only reopened large state, never stale quotient state.

The executable parity instance keeps successor compressed but predecessor
tears the fiber `0~2`; runtime reopens and returns exact state `1`.

`BoundedMinimization.agda` implements Theorem Factory II: supplied independent
bound plus coverage compiles partial μ to total bounded search.  Result
equality, leastness, coverage, and exact worst-case budget `B+1` are checked.
The non-prime control returns least `3` under bound `5`, budget `6`.

Full boundary: `notes/INSTALLED_QUOTIENT_REOPENING.md`.  Safe Agda and extracted
runtime passed.  This work is disjoint from the concurrent Cubical
`LeastWitnessFactory`: that object selects a least witness from truncated
existence; this executable object proves the supplied-bound search agrees with
the partial least result and exposes its counted bound.
