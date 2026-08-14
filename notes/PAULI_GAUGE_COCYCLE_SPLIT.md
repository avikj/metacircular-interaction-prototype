# The Pauli gauge phase changes the representative and preserves the obstruction

## Exact result

`formal/cubical/NaturalMachine/PauliGaugeCocycleSplit.agda` exposes the split
left implicit by `PauliWeyl`. For arbitrary Pauli data, `phase-product` and
`phase-triple` separate the chosen central phases from the Weyl multiplication
cocycle `μ`. Every Pauli datum is reconstructed as its central phase times its
phase-zero representative (`central-times-erased`).

For the repository's six Peres--Mermin contexts, `μOnlySign` computes the
sign after erasing the observable phases and `gaugeLineSign` computes the
line contribution of those phases. The checked pointwise law is

```text
derived-s(c) = μOnlySign(c) xor gaugeLineSign(c).
```

The correction is locally load-bearing: after phase erasure the C2 product is
`+I`, whereas the full C2 product is `-I`. Thus the multiplication cocycle
alone gives the wrong C2 sign.

At the same time, the correction has even context parity. By
`PMCokernel.even-total-is-image` it lies in the incidence image. Hence the
μ-only and full sign vectors have the same odd cokernel parity even though
they disagree as representatives. This is the structural distinction the
sampled `PM_SECTION_VS_COCYCLE.md` was pointing toward: the gauge phase is
essential for the physical context signs while the downstream obstruction is
conserved under its incidence-boundary change.

## Existing modules and novelty boundary

- `PauliWeyl` already defines the symplectic multiplication, proves its
  associativity/cocycle law, and derives the actual six signs, but explicitly
  absorbs rather than exhibits the gauge/cocycle split.
- `PMCokernel` proves exactness of the incidence map and parity evaluator.
- `PMGaugeCohomology` constructs a different, downstream edge-sign quotient
  by context gauge. This result does not identify the observable Z4 phase
  with that quotient's Boolean vertex gauge; it uses only the checked fact
  that the resulting context correction lies in the incidence image.

No matrix representation, Hilbert-space model, or general sheaf-cohomology
theorem is claimed.

## Projective-action boundary

This module is about `PauliWeyl._·P_`. It does **not** prove that
`ExactTwoStateAmplitudes.phaseAction` satisfies identity or composition, and
it does not turn `ExactProjectivePhase.GlobalPhaseStep` into a checked Z4
action or identify its `SetQuotient` as an orbit quotient. Those were the
precise gaps in the projective-phase audit and remain open.

## Provenance

Literal no-redraw Draw 4 froze origin snapshot `071e4c5d`, tree `3fab4921`,
and selected `notes/PM_SECTION_VS_COCYCLE.md` (blob `11bbc845`) from a
1,060-path semantic frame. Frame SHA-256 was
`e582dd56f43b81439207e8f98c8e05d5f2a627e859819aae6e0a7086e142e238`;
rejection limit `4294966300`, accepted uint32 `964476812`, zero rejections,
zero-based index `832`. The three earlier sampled objects were excluded.
