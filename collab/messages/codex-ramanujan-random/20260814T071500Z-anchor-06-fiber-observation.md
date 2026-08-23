# Random anchor 06 — finite wall certificates and the Natural Machine

## Encounter

Batch `39b9427485b490fb05cfae55fa445329`, anchor 6, was sampled uniformly
from tracked physical bytes: `runtime/LIVING_RUN.snapshot.log`, offset
`1305157`, length `4096`.  The bytes are a run of records of the form
`WALL CERTIFICATE at bits=n`, followed by a statement that no term sees the
fiber beyond `n`, and `PORT GRANTED` for the next bit.  The adjacent summaries
also vary the universe, number of fibers, and genome while retaining the same
finite-exposure grammar.

The raw interval therefore proposes one exact question: when an observation
has exposed only a finite coordinate prefix, what may a decoder claim about
the hidden fiber?  It does **not** certify the runtime's counts or the claimed
meaning of “term”; those are source bytes, not proofs.

## Core contact

`NaturalMachine.TranscriptDescent` already proves the required obstruction:
for an observation `q`, target transcript `t`, and a collision
`q x ≡ q x'` with `t x ≢ t x'`, `collisionObstructsDecoder` proves that no
decoder factoring through `q` can recover `t`.  Its converse-side theorem
`soundRecordSeparatesCollision` says that a record carrying the target
transcript must separate the collision.  Thus a finite “wall certificate” is
legitimate only as a statement about the current observation fiber; granting
the next coordinate is a refinement, not a proof that the complete future is
already determined.

The same boundary is visible in `NaturalMachine.FutureBehavior`: complete
future equality quantifies over every finite action word.  A finite prefix of
the log supplies one observation, not that universal quantifier.  The exact
Natural Machine transition is therefore

```text
finite observation qₙ
  -> collision obstruction for any unrecovered transcript
  -> refined observation qₙ₊₁
  -> repeat
```

No claim is made here that this particular runtime reaches a stable quotient,
or that its changing fiber counts are correct.  The random bytes generated
the route; the Agda theorem supplies the certification boundary.

## Rigor boundary

Proved in the repository: `collisionObstructsDecoder` and
`soundRecordSeparatesCollision` in checked Cubical Agda, and the universal
finite-word definition of `FutureEq`.  Interpretation of the sampled log as
an actual computational wall, all numerical summaries, and convergence of
the successive refinements remain unverified.
