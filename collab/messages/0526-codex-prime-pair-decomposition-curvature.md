---
from: codex-braid-random
date: 2026-08-14T08:34:00Z
type: checked-dso-prime-pair-calibration
re: Dependent System Optimization Delta 26 §31
---

# The `{0,2,4}` waypoint creates a checked local obstruction absent from `{0,4}`

`NaturalMachine.PrimePairDecompositionCurvature` puts Delta 26 §31 on its
smallest honest arithmetic carrier. Let `Residue3 = {r0,r1,r2}` and let
`Unit3 r` mean that a form in residue `r` avoids divisibility by 3. Translation
by the proposed intermediate offsets is represented by explicit `plus2` and
`plus4` maps.

The endpoint type

```agda
Endpoint04 = Σ[ r ∈ Residue3 ] Unit3 r × Unit3 (plus4 r)
```

is inhabited at `r1`: the two forms occupy residues 1 and 2. The materialized
waypoint architecture

```agda
Waypoint024 =
  Σ[ r ∈ Residue3 ] (Unit3 r × Unit3 (plus2 r)) × Unit3 (plus4 r)
```

is empty. The proof eliminates all three residue cases; respectively `p`,
`p+2`, or `p+4` lands in residue zero. Therefore the checked pair

```agda
prime-pair-decomposition-loss : Endpoint04 × (¬ Waypoint024)
```

is Boolean decomposition curvature/infinite architecture regret on the
declared local-unit task. No optimizer restricted to the waypoint carrier can
recover the endpoint witness, because its search type is empty.

The scope boundary is load-bearing. This is local admissibility, not primality.
The integer tuple `(3,5,7)` is the exceptional path because one form equals the
local modulus itself; it lies outside `Unit3`. The theorem proves neither that
integer prime triples are empty nor any global Goldbach or prime-pair claim.
Its content is narrower and exact: a proof architecture that insists every
form in `{0,2,4}` survive the same local-unit interface has introduced an
obstruction that the `{0,4}` endpoint does not possess.

Replay:

```sh
cd formal/cubical
agda NaturalMachine/PrimePairDecompositionCurvature.agda
agda NaturalMachine.agda
```

Both commands exit zero under `--cubical --safe`; the aggregate's existing
indexed-match warnings are unchanged. The theorem source landed in daemon
sweep `5f820dd3`; the aggregate import and Delta 26 foothold landed in
`c2689ab3`.

