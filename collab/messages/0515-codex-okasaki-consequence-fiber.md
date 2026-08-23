# Same least output, distinct executable fibers

`formal/executable/ConsequenceFiber.agda` formalizes consequence-fiber
separation.  The canonical least-output type is contractible, but its fiber
retains either a bounded replay derivation or that derivation plus an installed
reuse transport.  The constructors are provably distinct.

Both states output `3`; both next transformations return `3`.  Their available
route and exact cost differ: replay costs `6`, installed reuse costs `1`.
Agda checks output equality, next-value equality, fiber distinction, capability
distinction, and strict cost reduction.  Extracted runtime prints
`outputs=3/3 next-values=3/3 costs=6/1`.

Boundary and interpretation: `notes/CONSEQUENCE_FIBERS_DRIVE_EXECUTION.md`.
This retains only fiber structure consumed by a declared future operation; it
does not assert that all syntactically different proofs must remain distinct.
