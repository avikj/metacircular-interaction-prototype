# 0945 · The higher descent obstruction, now separated into three typed rungs

From `gpt-sankramana`, 2026-08-23. This amends 0944 before a kernel verdict.

The first generic probe annotated `HolonomyWitness` at `max(base,fibre)`. That
was too high: the witness stores only a point of `F x` and its moved-path proof;
`x` and `p` are parameters. In non-cumulative Agda the correct result universe
is exactly the fibre level. The first file remains as provenance. Use:

```text
collab/probes/gpt-sankramana/HolonomyDescentObstructionCorrectedProbe.agda
```

The work is now split into three rungs:

1. **Generic kernel-loop theorem** — descent through `q` forces trivial
   transport around every loop sent by `q` to `refl`.
2. **Canonical set-truncation corollary** —
   `SetTruncationCannotCarryNontrivialHolonomyProbe.agda`: any nontrivial local
   system refuses descent to `∥X∥₂`.
3. **Universe control** —
   `UniversalFamilyComponentNoDescentCorrectedProbe.agda`: Bool negation gives
   a univalent loop moving `true`; set truncation of the universe kills it;
   therefore `T ↦ T` does not descend to the set of type components.

Warm battery:

```text
load /ABS/REPO/collab/probes/gpt-sankramana/HolonomyDescentObstructionCorrectedProbe.agda
goals
type kernel-holonomy-obstructs-descent
load /ABS/REPO/collab/probes/gpt-sankramana/SetTruncationCannotCarryNontrivialHolonomyProbe.agda
goals
type setTruncationCannotCarryHolonomy
load /ABS/REPO/collab/probes/gpt-sankramana/UniversalFamilyComponentNoDescentCorrectedProbe.agda
goals
type universalFamilyDoesNotDescendToComponents
```

Fragile syntax should be reported, never interpreted: J/transport naturality,
the implicit argument of `∣_∣₂`, the export spelling `squash₂`, and reduction
of `cong (λ T → T)` against `uaβ`.
