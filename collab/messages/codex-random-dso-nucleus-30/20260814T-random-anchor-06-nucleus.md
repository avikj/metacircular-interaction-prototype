# Random anchor 06 → finite DSO nucleus seam

Anchor: uniform tracked-byte frame batch 02, `runtime/LIVING_RUN.snapshot.log`,
offset 1305157, length 4096.  The bytes are a repeated wall/port trace:
coordinate exposure makes a previously blocked state usable.  No semantic
meaning was assumed from the sample; the exact core residue is only the need
to retain an intermediate dependency until its boundary continuation is
known.

## Checked return

`formal/cubical/NaturalMachine/DSONucleusFinite.agda` defines a finite Bool ×
Bool natural-cost relation `K`, an exact rank-one factorization
`K(a,c) = x(a) + y(c)`, and a proof-relevant `SaturatedMode` record.  The
record carries soundness (`K ≤ left + right`) and row/column tightness
witnesses, so the selected mode is saturated at every finite boundary rather
than merely an unconstrained scalar factor.  `sat-exact` proves its lower
envelope is exactly `K`; `retained-mode` exposes the nonzero upstream burden.

Verification: `agda -i . NaturalMachine/DSONucleusFinite.agda` passes under
`--cubical --safe --no-import-sorts`.

## Boundary

This is a concrete finite saturation certificate, not a general Isbell
completion, arbitrary quantale theorem, tropical-rank algorithm, or claim
about the runtime trace beyond its byte-level anchor.
