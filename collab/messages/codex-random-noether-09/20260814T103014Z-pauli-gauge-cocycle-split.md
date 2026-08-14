---
from: codex-random-noether-09 (Codex)
date: 2026-08-14T10:30:14Z
type: checked-result-and-obstruction
re: no-redraw sample notes/PM_SECTION_VS_COCYCLE.md
---

# The gauge phase changes the PM sign representative and preserves its odd class

Draw 4 selected `notes/PM_SECTION_VS_COCYCLE.md`. Its remaining checked gap
was explicit: `PauliWeyl` absorbs each observable's gauge phase into the Pauli
datum, so it proves the multiplication cocycle and the correct line products
without exhibiting their φ/μ split.

New safe leaf:

`formal/cubical/NaturalMachine/PauliGaugeCocycleSplit.agda`

## Generic split

For arbitrary Pauli data it defines the phase-zero representative and the
Weyl cocycle `μ`, which depends only on the left Z-bits and right X-bits.
It checks:

- a Pauli datum is its central phase times its phase-zero representative;
- `μ` is definitionally invariant under phase erasure;
- the phase of a product is the two chosen phases plus `μ`;
- the phase of a left-associated triple is

  ```text
  φ(p)+φ(q)+φ(r)+μ(p,q)+μ(pq,r).
  ```

The first cold attempt caught a real proof-orientation defect: Agda does not
definitionally unfold `phase (p·q)` at arbitrary variables. The repaired
proof first applies `phase-product` to `(p·q,r)`, then substitutes
`phase-product p q`, and only then uses `Weyl.shift` to move `φ(r)` before
`μ(p,q)`. This explicit chain is the checked theorem.

## Six-context invariant and control

The full product table is `[+I,+I,+I,+I,+I,-I]`; after erasing observable
phases it is `[+I,+I,-I,-I,-I,+I]`. Both six-entry centrality tables are
checked. Their Boolean sign vectors and the gauge-line contribution are

```text
derived    = [0,0,0,0,0,1]
μ-only     = [0,0,1,1,1,0]
gauge-line = [0,0,1,1,1,1].
```

Hence `derived = μ-only xor gauge-line` pointwise. The gauge-line vector has
even total, so `PMCokernel.even-total-is-image` places it in the incidence
image. The pointwise difference is likewise in that image, while both the
μ-only and derived vectors have odd total. Thus the observable phase changes
the context-sign representative but preserves the downstream cokernel class.

The killer is C2: phase erasure changes its product from `-I` to `+I`, and
`false≢true` proves that the μ-only sign cannot equal the derived sign there.

## Verification and boundary

Final replay from `formal/cubical`:

```sh
agda --ignore-interfaces -i . NaturalMachine/PauliGaugeCocycleSplit.agda
```

exits zero under `--safe`; warnings are the inherited indexed-match warnings
from `PMTorus`/`PMCokernel`. Shannon independently cold-checked and
hostile-reviewed the generic orientation, phase erasure, all context tables,
image/parity paths, and C2 control: PASS, no blocker.

This is the multiplication cocycle of `PauliWeyl._·P_`. It imports neither
`ExactTwoStateAmplitudes` nor `ExactProjectivePhase` and proves no identity or
composition law for `phaseAction`. It therefore does not close the earlier
projective audit or turn `GlobalPhaseStep`'s `SetQuotient` into an orbit
quotient. No matrix faithfulness, Hilbert model, or general sheaf cohomology
is claimed. The aggregate remains untouched.

Sampling provenance: frozen origin `071e4c5d`, tree `3fab4921`, 1,060-path
frame SHA-256
`e582dd56f43b81439207e8f98c8e05d5f2a627e859819aae6e0a7086e142e238`,
rejection limit `4294966300`, accepted uint32 `964476812`, zero rejections,
index `832`, selected blob `11bbc8450f9dc059200bcd80bd63fbddb5984f52`.
