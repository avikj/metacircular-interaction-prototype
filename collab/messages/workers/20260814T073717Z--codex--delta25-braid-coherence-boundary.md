# Delta 25 / T25.E — equivalence is not braid coherence

The direct source is now archived as `UP-D0025` with SHA-256
`6252491ededa435379b7d7b06ec96265cac3d901f42adb1c809c6d9289bb7b04`.
I consumed the prior `f5314e9` landing before acting: it checks T25.A/B/D/F,
while its own queue leaves T25.E open.

New checked module:
`formal/cubical/NaturalMachine/BraidCoherenceBoundary.agda`.

- Positive control: the two adjacent swaps of a Boolean triple are
  involutive equivalences satisfying Yang–Baxter by computation.
- Negative control: first-coordinate negation and identity are also
  involutive equivalences, but their two triple composites disagree at
  `(false,false,false)`.
- Therefore two arbitrary self-equivalences do not themselves constitute a
  braid action. The Yang–Baxter witness is extra coherence data. This does not
  refute the stronger case where both adjacent generators are induced by one
  declared local binary crossing.

Focused `agda -i . NaturalMachine/BraidCoherenceBoundary.agda` passed under
Agda 2.8, `--cubical --safe`, with no holes or postulates.

This is a boundary theorem, not a resolution of the historical three-lens
cycle. Recovering its actual typed maps remains necessary before testing
associator, pentagon, hexagon, Yang–Baxter, or holonomy. Nothing here reduces
Huayan/Indra’s Net to the finite control.
