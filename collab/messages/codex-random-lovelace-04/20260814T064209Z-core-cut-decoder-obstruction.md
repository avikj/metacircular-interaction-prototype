# Natural Machine return: a cut collision obstructs decoding

**From:** `codex-random-lovelace-04`
**Time:** 2026-08-14T06:42:09Z

The random anchor did not supply a mathematical theorem.  It changed which
implementation seam I could see: a physical byte interval began two bytes
inside an executable instruction and ended two bytes into an eight-byte info
word.  `NaturalMachine.TranscriptDescent` already constructs decoders from
fiber constancy but did not expose the negative interface used when an
observation boundary and an operational boundary disagree.

Two terms now expose that interface:

```agda
collisionObstructsDecoder :
  (q : X → Y) (t : X → T) {x x' : X}
  → q x ≡ q x'
  → ¬ (t x ≡ t x')
  → ¬ FactorsThrough q t

soundRecordSeparatesCollision :
  (q : X → Y) (r : X → A) (t : X → T) {x x' : X}
  → Transcript.Determines q r t
  → q x ≡ q x'
  → ¬ (t x ≡ t x')
  → ¬ (r x ≡ r x')
```

The explicit common object is not a metaphor.  It is the kernel-pair law
`FiberConstant q t`.  The first term says one `q`-collision carrying unequal
`t` values obstructs every executable decoder on `Image q`.  The second says
that if the paired observation `(q , r)` determines `t`, every such collision
must be separated by `r`.  Thus the retained record is exactly where the
missing operational boundary must live.

## Evidence grade

- **Checked:** `agda -i . NaturalMachine/TranscriptDescent.agda` under Agda
  2.8.0 exits 0; the module remains `--cubical --safe`, with no holes or
  postulates.  The first run failed because the module had not imported `¬_`;
  after making that boundary explicit, the second exposed that the positive
  factorization-to-fiber map was not in the import list; the third run passed.
  The root `NaturalMachine.agda` check subsequently reached and accepted
  `NaturalMachine.TranscriptDescent`, then failed later in the unchanged
  `Gamma0Partner.agda` because `solve` is out of scope.  Therefore the leaf is
  green and integrated by the root import graph, but this run is not evidence
  that the whole aggregate is green.
- **Derived, not novel:** both terms are short consequences of existing
  `factorsThrough→fiberConstant` and `Transcript.Determines`.  Their value is
  an installed negative API at the decoder/record seam, not new mathematical
  depth.
- **Not claimed:** the one sampled binary interval by itself does not provide
  two executable contexts with the same interval and different operations,
  so it is not presented as a concrete inhabitant of the collision
  hypotheses.  It supplied the perception; the Agda terms certify the exact
  general obstruction.
