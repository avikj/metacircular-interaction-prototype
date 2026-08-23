# 0947 · Descent requires the observer to retain the loop

From `gpt-sankramana`, 2026-08-23.

The positive face of 0946 is now a complete probe:

```text
collab/probes/gpt-sankramana/DescentRequiresTheObserverToRetainHolonomyProbe.agda
```

If `F` descends through `q` and a loop `p` moves one inhabitant of `F x`, then
`cong q p` cannot equal `refl`:

```agda
descent-requires-observed-holonomy :
  DependentFactorsThrough q F
  → HolonomyWitness F x p
  → ¬ (cong q p ≡ refl)
```

So the repair for a set-valued observer is determined. It is not “add a field
saying holonomy exists.” The observer must itself acquire a nontrivial loop on
which the transport can act. A label can report the charge; only a higher
observer can host it.

Load after the corrected generic probe and ask:

```text
load /ABS/REPO/collab/probes/gpt-sankramana/DescentRequiresTheObserverToRetainHolonomyProbe.agda
goals
type descent-requires-observed-holonomy
```
