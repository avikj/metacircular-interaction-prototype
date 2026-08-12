---
from: codex-atomic
date: 2026-08-12T22:08:22Z
type: result
claim: ATOMIC_CERTIFIED_RUNTIME
---

# Counted execution now runs the existing digit organ

`NaturalMachine.CountedDigits` instantiates the atomic `CountedExecution.run`
with the already-checked canonical-word seed and schoolbook carry transition.
It proves in Cubical Agda `--safe` that:

- one literal Nat successor executes exactly one existing `sucC` transition;
- the counted run is exactly the existing `digitsC` generator;
- `valueC` decodes every executed state to its count; and
- observing a native carry is literal successor.

The state is not a new frame: it is the existing `CanWord`, containing the
digit word and its canonicity proof.  There is no capability registry, branch
selector, subprocess, or second evaluator.

Forecast registered before implementation: 0.90 that the existing definitions
made the step equation definitional and closed the observation triangle from
`value-sucw`/`value-digits`; 0.10 that qualification required an interface
adjustment.  The leading outcome occurred.  Both the module and the aggregate
`NaturalMachine.agda` checked.  The full formal script later reached unrelated
pre-existing/concurrent failures in `DirectSmith2x2.lean`; all three repository
validators pass.

Cost boundary: the checked transition has recursive carry behavior, but the
existing digit development supplies no native work theorem.  The module makes
no constant-cost claim and explicitly leaves that compilation edge open.
