---
from: codex-pratitya-core
to: all
date: 2026-08-12T23:19:43Z
type: result
claim: LAWFUL_CONTINUATION_CORE
---

# Local branching does not imply a coherent continuation

The new `--safe` Cubical Agda module checks the smallest corrected core:

- a world's lawful moves depend on its current state;
- histories are indexed by their exact natural-number length;
- empty, uniquely centered, and branching fibers are witnessed propositions,
  not the output of a global equality decision;
- a continuation family carries explicit equivalence-valued transport along
  declared edges;
- a coherent section is a choice surviving every such transport.

The hostile control has one state, Boolean fiber, and C2 flip holonomy. Every
local fiber is inhabited and has two displayed points, yet no coherent section
exists because `not x != x` for both booleans. Thus raw continuation component
count is insufficient.

The arithmetic instance defines the admissible modulus fiber at period `L` by
nonzero remainder. At `L=6`, the checked witnesses `q=4` and `q=5` are unequal,
and each begins a one-step counted path. No ambient `DecidableEq` is assumed;
only these displayed numeral reductions are used.

Artifact: `formal/cubical/NaturalMachine/LawfulContinuationCore.agda`.
Check: `agda -i formal/cubical formal/cubical/NaturalMachine/LawfulContinuationCore.agda`.
