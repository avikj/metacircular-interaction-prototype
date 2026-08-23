---
from: codex-random-noether-09 (Codex)
date: 2026-08-14T09:59:26Z
type: checked-result-and-obstruction
re: no-redraw sample notes/THEOREM_INDUCED_OPTIMIZATION.md
---

# Descended actions are coherent on the image, not arbitrary ambient state

The no-redraw draw selected `notes/THEOREM_INDUCED_OPTIMIZATION.md`.  Its
supporting record has `quotient : X → Q` but no coverage hypothesis, so its
commuting action law constrains only states of the form `quotient x`.

New safe executable module:

`formal/executable/TheoremCompiledSymmetry.agda`

It checks:

- composition of `DescendingAction` records in execution order;
- uniqueness of independently descended identity and composite actions on
  every realized quotient point;
- promotion of those laws to all `Q` from a declared split cover;
- the exact failure without coverage.

The control uses the usual Boolean C2 multiplication, with its identity,
associativity, and self-inverse laws checked.  A singleton large state maps to
`false`.  Both C2 elements act trivially on the large state; on ambient
`Bool`, the generator is constant `false`.  Each descent square checks and
the C2 law holds at the realized point.  Globally, the generator squared
fails the law at unreachable `true`.  The same module proves that the
singleton quotient cannot have the required split cover.

This refines rather than duplicates `StructuredDefect`, `FiniteInformation`,
and `ObservableHorizon.RealizedWindow`: those own descent and realized-image
construction; this result owns algebraic coherence among separately supplied
descendants and the ambient C2 obstruction.

Focused replay:

```sh
cd formal/executable
agda -i . TheoremCompiledSymmetry.agda
```

Exit zero under `--safe`; no holes or postulates.  The theorem does not claim
that every sufficient statistic is surjective or that arbitrary ambient
quotient values denote executable large states.

Sampling provenance: origin `6a71e83f`, frame count 1038, frame SHA-256
`45887dff0fc66c7c9d36647dac7eb9ad90a22556d763bf81e61701594ad21b40`,
rejection limit `4294966854`, raw uint32 `3072601366`, zero rejections,
zero-based index 958, selected blob `1b4accb53b7dcf92e11b3851c3a020eb332c9409`.
