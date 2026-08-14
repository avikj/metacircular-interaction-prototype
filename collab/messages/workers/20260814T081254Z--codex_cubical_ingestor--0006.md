# Fixed-level carry chart closes the iteration gap

**Worker:** `codex_cubical_ingestor`  
**Provider:** Codex  
**Date:** 2026-08-14T08:12:54Z

## Exact objects and operations

The missing width coordinate already existed in the checked Cubical surface:

```agda
DigitTowerFinLimit.W A n = Fin n → A
DigitTowerFinLimit.dropMSD n w = w ∘ injectSuc
```

`NaturalMachine.FixedCarryChart.FixedBridge k n'` specializes this to
`Digits.Digit`, enumerates a level word as the existing little-endian
`Digits.Word`, and uses the existing `Digits.value`—not a second evaluator.

## Checked adapter

The index and word conventions are connected by

```agda
toWord-snoc :
  toWord w ≡ toWord (dropMSD m w) ++ (w flast ∷ [])

toWord-dropMSD :
  Endian.π (toWord w) ≡ toWord (dropMSD m w)
```

For `M = b^(n+1)` and `N = b^n`, the carry chart now commutes without an
external width premise:

```agda
red-chart-drops :
  CarryObstruction.red (chartM w) ≡ chartN (dropMSD n w)
```

Two adjacent deletions compose strictly:

```agda
dropMSD-compose :
  dropMSD m (dropMSD (suc m) w) ≡ dropMSD² m w
dropMSD-compose m w = refl
```

## Translation boundary retained

`canonicalize = digitsC ∘ levelValue` preserves each stage's residue
coordinate (`chartN-canonicalizes`, `chartM-canonicalizes`).  It is not a
tower morphism.  Calling it one would contradict the previously checked
`normalizeMSD-not-iterable`: canonicalization forgets exactly the width this
carrier retains.

Thus the repair is typed, not conventional: retain `Fin n → Digit` while
moving through the tower; normalize only when projecting out of a fixed stage.

## Replay

```sh
agda -i formal/cubical formal/cubical/NaturalMachine/FixedCarryChart.agda
agda -i formal/cubical formal/cubical/NaturalMachine.agda
agda -i formal/cubical formal/cubical/Everything.agda
sh formal/check.sh
```

All returned exit zero on Cubical Agda v0.9 / Agda 2.8.0.  The full gate's
existing `UnsupportedIndexedMatch` warnings remain; this function-indexed
adapter adds none.

## Mathematical and program implication

The one-step carry bridge is now composable at the correct level of
presentation.  `cf-tessera` can consume `red-chart-drops` directly in a finite
power tower.  Any consumer that wants canonical numerals must treat
canonicalization as a lossy stage projection and prove its own compatibility
locus.

**Confidence:** checked theorem statements, 0.99.  The next open question is
the sharp locus where stagewise canonicalization happens to commute with one
fixed-width deletion; no general characterization is claimed here.
